//
//  GCDataManager.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/2/1.
//

import Foundation
import SwifterSwift
import GPUImage

class GCFilterItem: Codable {

    let filterName : String
    let type : String
    let imageName : String
    
    enum CodingKeys: String, CodingKey {
        case filterName
        case type
        case imageName
    }
    
}

class GCStickerItem: Codable {
    let contentImageName : String
    let thumbnail : String
}

class GCPaintItem: Codable {
    let previewImageName : String
    let StrokeType : String
    let gradualColorOne : String
    let gradualColorTwo : String
    let isDashLine : Bool
    
    
}

class GCDataManager {
    static let `default` = GCDataManager()
    var filterList : [GCFilterItem] {
        return GCDataManager.default.loadPlist([GCFilterItem].self, name: "FilterList") ?? []
    }
    var overlayerList : [GCStickerItem] {
        return GCDataManager.default.loadPlist([GCStickerItem].self, name: "OverlayerList") ?? []
    }
    var stickerList : [GCStickerItem] {
        return GCDataManager.default.loadPlist([GCStickerItem].self, name: "StickerList") ?? []
    }
    
    var paintStyleItemList:[GCPaintItem] {
        return GCDataManager.default.loadPlist([GCPaintItem].self, name: "GCPaintStyleList") ?? []
    }
}



extension GCDataManager {
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
    
}

// filter
extension GCDataManager {
    func filterOriginalImage(image: UIImage, lookupImgNameStr: String) -> UIImage? {
        
        if let gpuPic = GPUImagePicture(image: image), let lookupImg = UIImage(named: lookupImgNameStr), let lookupPicture = GPUImagePicture(image: lookupImg) {
            let lookupFilter = GPUImageLookupFilter()
            
            gpuPic.addTarget(lookupFilter, atTextureLocation: 0)
            lookupPicture.addTarget(lookupFilter, atTextureLocation: 1)
            lookupFilter.intensity = 0.7
            
            lookupPicture.processImage()
            gpuPic.processImage()
            lookupFilter.useNextFrameForImageCapture()
            let processedImage = lookupFilter.imageFromCurrentFramebuffer()
            return processedImage
        } else {
            return nil
        }
        return nil
    }
}

