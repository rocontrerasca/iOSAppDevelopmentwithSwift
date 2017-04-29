//: Playground - noun: a place where people can play

import UIKit

enum  HueLevel: UInt8 {
    case low = 0
    case medium = 128
    case high = 255
}

let image = UIImage(named: "sample")

// Process the image!
class ImageProcessing {
    var image: RGBAImage
    
    init(image: UIImage) {
        self.image = RGBAImage(image: image)!
    }
    
    func processing(filters: [String]) {
        for filter in filters {
            switch filter {
            case "lowRed":
                self.changeRed(HueLevel.low.rawValue)
            case "mediumRed":
                self.changeRed(HueLevel.medium.rawValue)
            case "highRed":
                self.changeRed(HueLevel.high.rawValue)
            case "lowGreen":
                self.changeGreen(HueLevel.low.rawValue)
            case "mediumGreen":
                self.changeGreen(HueLevel.medium.rawValue)
            case "highGreen":
                self.changeGreen(HueLevel.high.rawValue)
            case "lowBlue":
                self.changeBlue(HueLevel.low.rawValue)
            case "mediumBlue":
                self.changeBlue(HueLevel.medium.rawValue)
            case "highBlue":
                self.changeBlue(HueLevel.high.rawValue)
            case "halfBrightness":
                self.halfBrightness()
            case "2xBrightness":
                self.doubleBrightness()
            case "halfTone":
                self.customFilter("CICMYKHalftone")
            case "chrome":
                self.customFilter("CIPhotoEffectChrome")
            case "fade":
                self.customFilter("CIPhotoEffectFade")
            case "grayScale":
                self.customFilter("CIPhotoEffectTonal")
            case "sepia":
                self.customFilter("CISepiaTone")
            default:
                print("The Filter you specified doesn't exist.")
            }
        }
    }
    
    func changeRed(value: UInt8) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width {
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                pixel.red = value;
                self.image.pixels[index] = pixel
            }
        }
    }
    
    func changeGreen(value: UInt8) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width {
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                pixel.green = value;
                self.image.pixels[index] = pixel
            }
        }
    }
    
    func customFilter(filterName: String) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self.toUIImage())
        let filter = CIFilter(name: filterName )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
        let imageForButton = UIImage(CGImage: filteredImageRef);
        self.image = RGBAImage(image: imageForButton)!
    }
    
    func changeBlue(value: UInt8) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width {
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                pixel.blue = value;
                self.image.pixels[index] = pixel
            }
        }
    }
    
    func halfBrightness() {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width {
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                pixel.red /= 2
                pixel.green /= 2
                pixel.blue /= 2
                self.image.pixels[index] = pixel
            }
        }
    }
    
    func doubleBrightness(){
        for y in 0..<self.image.height {
            for x in 0..<self.image.width {
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                pixel.red = UInt8(max(min(255, Int(pixel.red) * 2), 0))
                pixel.green = UInt8(max(min(255, Int(pixel.green) * 2), 0))
                pixel.blue = UInt8(max(min(255, Int(pixel.blue) * 2), 0))
                self.image.pixels[index] = pixel
            }
        }
    }
    
    func toUIImage() -> UIImage {
        return self.image.toUIImage()!
    }
}

/*
 Filters options:
 lowRed
 mediumRed
 highRed
 lowGreen
 mediumGreen
 highGreen
 lowBlue
 mediumBlue
 highBlue
 halfBrightness
 2xBrightness
 halfTone
 chrome
 fade
 grayScale
 sepia
 */

let filters = ["highRed","fade","halfTone"]

let imageProcessing = ImageProcessing(image: image!)
imageProcessing.processing(filters)
let newImage = imageProcessing.toUIImage()





