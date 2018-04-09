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
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        btnCompare.isEnabled = false
        let tapRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(ViewController.toggleImage(_:)))
        //Add the recognizer to your view.
        imageView.addGestureRecognizer(tapRecognizer)
        setThumbnails()
    }

    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    func setThumbnails(){
        let aUIImage = imageView.image;
        let aCGImage = aUIImage?.cgImage;
        aCIImage = CIImage(cgImage: aCGImage!)
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
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        for index in 0..<filtersList.count {
            
            //calculate x for uibutton
            let xButton = CGFloat(padding * (CGFloat(index) + 1) + (CGFloat(index) * thumbNailWidth))
            
            let button:UIButton = UIButton(frame: CGRect(x: xButton,y: padding, width: thumbNailWidth, height: thumbNailHeight)
            )
            //tag for show image
            button.tag = index
            button.setTitle(filtersList[index], for: UIControlState())
            
            button.setImage(customFilter(filtersList [index], image: imageView.image!), for: UIControlState())
            //selector when touch in side of button
            button.addTarget(self, action: #selector(ViewController.changeFilter(_:)), for: .touchUpInside)
            
            scrollView.addSubview(button)
        }
        self.secondaryMenu.addSubview(scrollView)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //self.scrollView.removeFromSuperview()
            imageView.image = image
            filterSelected = ""
            btnCompare.isEnabled = false
            originalImage = image
            setThumbnails()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 80)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 1.0
        }) 
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }) 
    }
    
  
    @IBAction func compareImage(_ sender: UIButton) {
        if sender.isSelected {
            imageView.image = customFilter(filterSelected, image: originalImage!)
            sender.isSelected = false
        }
        else {
            imageView.image = originalImage
            sender.isSelected = true
        }
    }
    
    func changeFilter(_ sender: UIButton) {
        imageView.image = sender.currentImage
        filterSelected = sender.currentTitle!
        btnCompare.isEnabled = true
        let aUIImage = imageView.image;
        let aCGImage = aUIImage?.cgImage;
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil);
        contrastFilter = CIFilter(name: "CIColorControls");
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
    
    func toggleImage(_ sender: UILongPressGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view!
        
        if sender.state == .ended{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 0.1
            })
            
            imageView.image = customFilter(filterSelected, image: originalImage!)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 1
            })
        }
        else if sender.state == .began{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 0.1
            })
            imageView.image  =  self.originalImage
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 1
            })
        }
    }
    
    @IBAction func sliderContrastChanged(_ sender: UISlider) {
        contrastFilter.setValue(NSNumber(value: sender.value as Float), forKey: "inputContrast")
        let outputImage = contrastFilter.outputImage;
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        imageView.image = newUIImage;
    }
    
    @IBAction func sliderBrightnessChanged(_ sender: UISlider) {
        brightnessFilter.setValue(NSNumber(value: sender.value as Float), forKey: "inputBrightness");
        let outputImage = brightnessFilter.outputImage;
        let imageRef = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newUIImage = UIImage(cgImage: imageRef!)
        imageView.image = newUIImage;
    }
}
