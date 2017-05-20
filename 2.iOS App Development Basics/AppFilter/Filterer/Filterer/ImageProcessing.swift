//
//  ImageProcessing.swift
//  Filterer
//
//  Created by Developer 1 on 5/20/17.
//  Copyright © 2017 UofT. All rights reserved.
//

import UIKit

func changeRed(value: UInt8, image:UIImage) -> UIImage {
    var img = RGBAImage(image: image)!
    for y in 0..<Int(image.size.height) {
        for x in 0..<Int(image.size.width) {
            let index = y * Int(image.size.width) + x
            var pixel = img.pixels[index]
            pixel.red = value;
            img.pixels[index] = pixel
        }
    }
    return img.toUIImage()!
}

func changeGreen(value: UInt8, image:UIImage) -> UIImage {
    var img = RGBAImage(image: image)!
    for y in 0..<Int(image.size.height) {
        for x in 0..<Int(image.size.width) {
            let index = y * Int(image.size.width) + x
            var pixel = img.pixels[index]
            pixel.green = value;
            img.pixels[index] = pixel
        }
    }
    return img.toUIImage()!
}

func customFilter(filterName: String, image:UIImage) -> UIImage {
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: image)
    let filter = CIFilter(name: filterName )
    filter!.setDefaults()
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
    let imageForButton = UIImage(CGImage: filteredImageRef);
    return imageForButton
}

func changeBlue(value: UInt8, image:UIImage) -> UIImage {
    var img = RGBAImage(image: image)!
    for y in 0..<Int(image.size.height) {
        for x in 0..<Int(image.size.width) {
            let index = y * Int(image.size.width) + x
            var pixel = img.pixels[index]
            pixel.blue = value;
            img.pixels[index] = pixel
        }
    }
    return img.toUIImage()!
}

func halfBrightness(image:UIImage) -> UIImage {
    var img = RGBAImage(image: image)!
    for y in 0..<Int(image.size.height) {
        for x in 0..<Int(image.size.width) {
            let index = y * Int(image.size.width) + x
            var pixel = img.pixels[index]
            pixel.red /= 2
            pixel.green /= 2
            pixel.blue /= 2
            img.pixels[index] = pixel
        }
    }
    return img.toUIImage()!
}

func doubleBrightness(image:UIImage) -> UIImage {
    var img = RGBAImage(image: image)!
    for y in 0..<Int(image.size.height) {
        for x in 0..<Int(image.size.width){
            let index = y * Int(image.size.width) + x
            var pixel = img.pixels[index]
            pixel.red = UInt8(max(min(255, Int(pixel.red) * 2), 0))
            pixel.green = UInt8(max(min(255, Int(pixel.green) * 2), 0))
            pixel.blue = UInt8(max(min(255, Int(pixel.blue) * 2), 0))
            img.pixels[index] = pixel
        }
    }
    return img.toUIImage()!
}
