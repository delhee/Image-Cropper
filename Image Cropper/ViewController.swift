//
//  ViewController.swift
//  Image Cropper
//
//  Created by Max Haii  on 13/01/2016.
//  Copyright © 2016 maxhaii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK : Constant declaration
    let TITLE_BAR_HEIGHT: CGFloat = 70
    let CROP_WINDOW_HEIGHT: CGFloat = 300
    let CROP_WINDOW_WIDTH: CGFloat = 300
    let CROP_WINDOW_Y_POSITION: CGFloat = 50
    let CROP_MASK_COLOR: UIColor = UIColor(red: 0, green: 90, blue: 90, alpha: 0.7)
    var imageToCrop: UIImage? = UIImage (named: "nature.jpeg")
    var processedImage: UIImage = UIImage()
    
    
    // MARK : View (or View Related) variables
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let titleBar: UIView = UIView()
    let btnCropAndSave: UIButton = UIButton()
    var scrollView: UIScrollView = UIScrollView()
    var imageView: UIImageView = UIImageView()
    var cropWindowPieceTop: UIView = UIView()
    var cropWindowPieceLeft: UIView = UIView()
    var cropWindowPieceRight: UIView = UIView()
    var cropWindowPieceBottom: UIView = UIView()
    var resultMsgLable: UILabel = UILabel()
    
    
    // MARK : Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make custom view
        initialize()
        makeView()
        putDataIntoView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK : Delegates
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    // MARK : custom methods
    func initialize () {
        if imageToCrop != nil {
            var w = imageToCrop!.size.width
            var h = imageToCrop!.size.height
            if  w < CROP_WINDOW_WIDTH || h < CROP_WINDOW_HEIGHT {
                if w < h {
                    h = h * CROP_WINDOW_WIDTH / w
                    w = CROP_WINDOW_WIDTH
                } else {
                    w = w * CROP_WINDOW_HEIGHT / h
                    h = CROP_WINDOW_HEIGHT
                }
                
                UIGraphicsBeginImageContext(CGSize(width: w, height: h))
                imageToCrop!.drawInRect(CGRect(x: 0, y: 0, width: w, height: h))
                processedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            } else {
                processedImage = imageToCrop!
            }
            
            imageToCrop = nil
        }
    }
    
    func makeView() {
        // View structure:
        // 1. Title bar
        //   1.1 save button
        // 2. UIScrollView
        //   2.1 UImageView
        // 3. Crop window
        
        // Important params:
        let screenWidth = self.screenSize.width
        let screenHeight = self.screenSize.height
        // Code:
        // 1. Title bar
        titleBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: TITLE_BAR_HEIGHT)
        titleBar.backgroundColor = UIColor.greenColor()
        self.view.addSubview(titleBar)
        
        // 1.1 save button on the title bar
        btnCropAndSave.frame = CGRect(x: 0, y: 0, width: 200, height: TITLE_BAR_HEIGHT)
        btnCropAndSave.setTitle("Crop and Save", forState: .Normal)
        btnCropAndSave.backgroundColor = UIColor.blueColor()
        btnCropAndSave.addTarget(self, action: "btnCropAndSaveClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        titleBar.addSubview(btnCropAndSave)
        
        // 2. UIScrollView
        scrollView.frame = CGRect(x: 0, y: TITLE_BAR_HEIGHT, width: screenWidth, height: (screenHeight - TITLE_BAR_HEIGHT))
        scrollView.backgroundColor = UIColor.brownColor()
        self.view.addSubview(scrollView)
        
        // 2.1 UIImageView
        /*imageView.frame = CGRect(x: (screenWidth - CROP_WINDOW_WIDTH) / 2, y: CROP_WINDOW_Y_POSITION, width: CROP_WINDOW_WIDTH, height: CROP_WINDOW_HEIGHT)*/
        imageView.frame = CGRect(x: 0, y: 0, width: processedImage.size.width, height: processedImage.size.height)
        imageView.backgroundColor = UIColor.yellowColor()
        scrollView.addSubview(imageView)
        
        // 3. Crop window
        cropWindowPieceTop.frame = CGRect(x: 0, y: TITLE_BAR_HEIGHT, width: screenWidth, height: CROP_WINDOW_Y_POSITION)
        cropWindowPieceTop.backgroundColor = CROP_MASK_COLOR
        self.view.addSubview(cropWindowPieceTop)
        
        cropWindowPieceLeft.frame = CGRect(
            x: 0,
            y: TITLE_BAR_HEIGHT + CROP_WINDOW_Y_POSITION,
            width: (screenWidth - CROP_WINDOW_WIDTH)/2,
            height: screenHeight - TITLE_BAR_HEIGHT-CROP_WINDOW_Y_POSITION)
        cropWindowPieceLeft.backgroundColor = CROP_MASK_COLOR
        self.view.addSubview(cropWindowPieceLeft)
        
        cropWindowPieceRight.frame = CGRect(
            x: (CROP_WINDOW_WIDTH + screenWidth)/2,
            y: TITLE_BAR_HEIGHT + CROP_WINDOW_Y_POSITION,
            width: (screenWidth - CROP_WINDOW_WIDTH)/2,
            height: screenHeight - TITLE_BAR_HEIGHT-CROP_WINDOW_Y_POSITION)
        cropWindowPieceRight.backgroundColor = CROP_MASK_COLOR
        self.view.addSubview(cropWindowPieceRight)
        
        cropWindowPieceBottom.frame = CGRect(
            x: (screenWidth - CROP_WINDOW_WIDTH)/2,
            y: TITLE_BAR_HEIGHT + CROP_WINDOW_Y_POSITION + CROP_WINDOW_HEIGHT,
            width: CROP_WINDOW_WIDTH,
            height: screenHeight - (TITLE_BAR_HEIGHT + CROP_WINDOW_Y_POSITION + CROP_WINDOW_HEIGHT))
        cropWindowPieceBottom.backgroundColor = CROP_MASK_COLOR
        self.view.addSubview(cropWindowPieceBottom)
    }
    
    func putDataIntoView() {
        imageView.image = processedImage
        
        // setting the scrollView.minimumZoomScale
        let w = processedImage.size.width
        let h = processedImage.size.height
        if  w < h {
            scrollView.minimumZoomScale = CROP_WINDOW_WIDTH / w
        } else {
            scrollView.minimumZoomScale = CROP_WINDOW_HEIGHT / h
        }
        
        scrollView.maximumZoomScale = 10
        scrollView.contentSize = processedImage.size
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(
            top: CROP_WINDOW_Y_POSITION,
            left: (screenSize.width - CROP_WINDOW_WIDTH)/2,
            bottom: scrollView.frame.height - CROP_WINDOW_Y_POSITION - CROP_WINDOW_HEIGHT,
            right: (screenSize.width - CROP_WINDOW_WIDTH)/2)
        
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        cropWindowPieceTop.userInteractionEnabled = false
        cropWindowPieceLeft.userInteractionEnabled = false
        cropWindowPieceRight.userInteractionEnabled = false
        cropWindowPieceBottom.userInteractionEnabled = false
    }
    
    func btnCropAndSaveClicked(sender: UIButton!) {
        print("save btn clicked")
        
        let scale = 1 / scrollView.zoomScale
        
        let visibleRect = CGRect(
            x: (scrollView.contentOffset.x + scrollView.contentInset.left) * scale,
            y: (scrollView.contentOffset.y + scrollView.contentInset.top) * scale,
            width: CROP_WINDOW_WIDTH * scale,
            height: CROP_WINDOW_HEIGHT * scale)
        
        let imageRef: CGImageRef? = CGImageCreateWithImageInRect(processedImage.CGImage, visibleRect)!
        
        let croppedImage:UIImage = UIImage(CGImage: imageRef!)
        
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
        showResultMessage()
    }
    
    func showResultMessage() {
        resultMsgLable.frame = CGRect(x: (screenSize.width - 200)/2, y: (screenSize.height - 30 - 50), width: 200, height: 30)
        resultMsgLable.backgroundColor = UIColor.blackColor()
        resultMsgLable.textColor = UIColor.whiteColor()
        resultMsgLable.text = "cropped and saved"
        self.view.addSubview(resultMsgLable)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "dismissResultMessage", userInfo: nil, repeats: false)
    }
    
    func dismissResultMessage() {
        resultMsgLable.removeFromSuperview()
    }
}

