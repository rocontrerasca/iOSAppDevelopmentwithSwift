//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    var originalImage = UIImage(named: "testing.jpg")
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    
    @IBOutlet weak var btnCompare: UIButton!
    var filterSelected = ""
    var aCIImage = CIImage();
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    var context = CIContext();
    
    @IBOutlet weak var scrollView: UIScrollView!
    var filtersList = ["CIPhotoEffectChrome","CISepiaTone","CIPhotoEffectTransfer","CIPhotoEffectTonal","CIPhotoEffectProcess","CIPhotoEffectNoir", "CIPhotoEffectInstant","CIPhotoEffectFade"]
    
    enum  HueLevel: UInt8 {
        case low = 0
        case medium = 128
        case high = 255
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        btnCompare.enabled = false
        let tapRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(ViewController.toggleImage(_:)))
        //Add the recognizer to your view.
        imageView.addGestureRecognizer(tapRecognizer)
        setThumbnails()
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func setThumbnails(){
        let aUIImage = imageView.image;
        let aCGImage = aUIImage?.CGImage;
        aCIImage = CIImage(CGImage: aCGImage!)
        context = CIContext(options: nil);
        contrastFilter = CIFilter(name: "CIColorControls");
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        
        let thumbNailWidth : CGFloat = 80
        let thumbNailHeight : CGFloat = 80
        let padding: CGFloat = 10
        let contentSizeWidth:CGFloat = (thumbNailWidth + padding) * (CGFloat(filtersList.count))
        let contentSize = CGSize(width: contentSizeWidth ,height: thumbNailHeight)
        
        scrollView.contentSize = contentSize
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        for index in 0..<filtersList.count {
            
            //calculate x for uibutton
            let xButton = CGFloat(padding * (CGFloat(index) + 1) + (CGFloat(index) * thumbNailWidth))
            
            let button:UIButton = UIButton(frame: CGRectMake(xButton,padding, thumbNailWidth, thumbNailHeight)
            )
            //tag for show image
            button.tag = index
            button.setTitle(filtersList[index], forState: .Normal)
            
            button.setImage(customFilter(filtersList [index], image: imageView.image!), forState: .Normal)
            //selector when touch in side of button
            button.addTarget(self, action: #selector(ViewController.changeFilter(_:)), forControlEvents: .TouchUpInside)
            
            scrollView.addSubview(button)
        }
        self.secondaryMenu.addSubview(scrollView)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //self.scrollView.removeFromSuperview()
            imageView.image = image
            filterSelected = ""
            btnCompare.enabled = false
            originalImage = image
            setThumbnails()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(80)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
  
    @IBAction func compareImage(sender: UIButton) {
        if sender.selected {
            imageView.image = customFilter(filterSelected, image: originalImage!)
            sender.selected = false
        }
        else {
            imageView.image = originalImage
            sender.selected = true
        }
    }
    
    func changeFilter(sender: UIButton) {
        imageView.image = sender.currentImage
        filterSelected = sender.currentTitle!
        btnCompare.enabled = true
        let aUIImage = imageView.image;
        let aCGImage = aUIImage?.CGImage;
        aCIImage = CIImage(CGImage: aCGImage!)
        context = CIContext(options: nil);
        contrastFilter = CIFilter(name: "CIColorControls");
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
    
    func toggleImage(sender: UILongPressGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view!
        
        if sender.state == .Ended{
            UIView.animateWithDuration(0.5, animations: {
                self.imageView.alpha = 0.1
            })
            
            imageView.image = customFilter(filterSelected, image: originalImage!)
            
            UIView.animateWithDuration(0.5, animations: {
                self.imageView.alpha = 1
            })
        }
        else if sender.state == .Began{
            UIView.animateWithDuration(0.5, animations: {
                self.imageView.alpha = 0.1
            })
            imageView.image  =  self.originalImage
            UIView.animateWithDuration(0.5, animations: {
                self.imageView.alpha = 1
            })
        }
    }
    
    @IBAction func sliderContrastChanged(sender: UISlider) {
        contrastFilter.setValue(NSNumber(float: sender.value), forKey: "inputContrast")
        let outputImage = contrastFilter.outputImage;
        let cgimg = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
        let newUIImage = UIImage(CGImage: cgimg)
        imageView.image = newUIImage;
    }
    
    @IBAction func sliderBrightnessChanged(sender: UISlider) {
        brightnessFilter.setValue(NSNumber(float: sender.value), forKey: "inputBrightness");
        let outputImage = brightnessFilter.outputImage;
        let imageRef = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
        let newUIImage = UIImage(CGImage: imageRef)
        imageView.image = newUIImage;
    }
}