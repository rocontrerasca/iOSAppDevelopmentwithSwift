//
//  ImageProcessing.swift
//  Filterer
//
//  Created by Developer 1 on 5/20/17.
//  Copyright © 2017 UofT. All rights reserved.
//

import UIKit

func changeRed(_ value: UInt8, image:UIImage) -> UIImage {
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

func changeGreen(_ value: UInt8, image:UIImage) -> UIImage {
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

func customFilter(_ filterName: String, image:UIImage) -> UIImage {
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: image)
    let filter = CIFilter(name: filterName )
    filter!.setDefaults()
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    let imageForButton = UIImage(cgImage: filteredImageRef!);
    return imageForButton
}

func changeBlue(_ value: UInt8, image:UIImage) -> UIImage {
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

func halfBrightness(_ image:UIImage) -> UIImage {
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

func doubleBrightness(_ image:UIImage) -> UIImage {
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
