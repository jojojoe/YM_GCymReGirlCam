//
/*******************************************************************************
 
 
 File name:     WWAlbumHelper.swift
 Author:        Adrian
 
 Project name:  WallpaperWidget
 
 Description:
 
 
 History:
 2020/10/15: File created.
 
 ********************************************************************************/


import UIKit
import Photos

class WWAlbumHelper: NSObject {
    static let `default` = WWAlbumHelper()
    private var saveGroup = DispatchGroup()

    private var assetCollection:PHAssetCollection?
    private var albumFound:Bool = false
    private var photoAsset:PHFetchResult<AnyObject>?
    private var collection: PHAssetCollection?
    private var assetCollectionPlaceholder:PHObjectPlaceholder?
    private var albumName = "Photo"
//    private var image:UIImage?
    private var images:[UIImage]?
    
    private var saveImagesCompleted: ((_ error: Error?)->())?
    private var waitToSavedImages:[UIImage] = []
    
    private override init() {}
    
    private func creatAlbum(completed: ((_ error: Error?)->())?) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate.init(format: "title = %@", albumName)
        let collection : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let _ = collection.firstObject{
            self.albumFound = true
            assetCollection = collection.firstObject
            self.saveImage(completed: completed)
        } else {
            PHPhotoLibrary.shared().performChanges({
                let creatAlbumRequest:PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
                self.assetCollectionPlaceholder = creatAlbumRequest.placeholderForCreatedAssetCollection
            }) { (result, error) in
                if result{
                    self.albumFound = result
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.assetCollectionPlaceholder?.localIdentifier ?? ""], options: nil)
                    self.assetCollection = collectionFetchResult.firstObject
                    self.saveImage(completed: completed)
                }else{
                    completed?(error)
                }
            }
        }
    }
    private func saveImage(completed: ((_ error: Error?)->())?) {
        if let assetCollection = self.assetCollection {
            PHPhotoLibrary.shared().performChanges({
                if let images = self.images {
                    var assetPlaceholderList: [PHObjectPlaceholder] = []
                    for image in images {
                        let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        let assetPlaceholder = assetRequest.placeholderForCreatedAsset
                        if let assetPlaceholder_m = assetPlaceholder {
                            assetPlaceholderList.append(assetPlaceholder_m)
                        }
                    }
                    let albumChangeRequest = PHAssetCollectionChangeRequest.init(for: assetCollection)
                    albumChangeRequest?.addAssets(assetPlaceholderList as NSArray)
                }
            }) { (result, error) in
                completed?(error)
            }
        } else {
           
            if let images = self.images {
                if self.waitToSavedImages.count == 0 {
                    self.waitToSavedImages = images
                    saveImagesToRoll(completed: completed)
                }
            }
        }
        
    }
    
    func saveImagesToRoll(completed: ((_ error: Error?)->())?) {
        self.saveImagesCompleted = completed
        if self.waitToSavedImages.count > 0 {
            if let image = self.waitToSavedImages.first {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaveFinished(image:error:context:)), nil)
            }
        } else {
            self.saveImagesCompleted?(nil)
        }
        
    }
    
    @objc func imageSaveFinished(image: UIImage, error: Error, context: UnsafeRawPointer) {
        self.waitToSavedImages.removeFirst()
        
        if self.waitToSavedImages.count > 0 {
            saveImagesToRoll(completed: self.saveImagesCompleted)
        } else {
            self.saveImagesCompleted?(nil)
        }
        
    }
    func saveImage(_ image: UIImage, to albumName:String, completed: ((_ error: Error?)->())?) {
//        self.image = image
        self.images = [image]
        self.albumName = albumName
        creatAlbum(completed: completed)
    }
    
    func saveImages(_ images: [UIImage], to albumName:String, completed: ((_ error: Error?)->())?) {
        self.images = images
        self.albumName = albumName
        creatAlbum(completed: completed)
    }
    
    private func getImageCollectionFromTitle(_ name: String)->PHAssetCollection?{
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var array:[PHAssetCollection] = []
        
        result.enumerateObjects { (collection, index, _) in
            
            array.append(collection)
        }
        for item in array{
            if item.localizedTitle == self.albumName{
                return item
            }
        }
        return nil
    }
    
    private func enumerateAssets(assetCollection: PHAssetCollection?)->[UIImage] {
        var containerArr:[UIImage] = []
        
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        
        var assets: PHFetchResult<PHAsset>? = nil
        if let aCollection = assetCollection {
            assets = PHAsset.fetchAssets(in: aCollection, options: nil)
        }
        assets?.enumerateObjects({ (asset, index, _) in
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelWidth)), contentMode: .default, options: nil, resultHandler: { (img, info) in
                if let img = img {
                    containerArr.append(img)
                }
            })
        })
        return containerArr
    }
}

extension WWAlbumHelper {
    private func savePhoto(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingWithError(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func didFinishSavingWithError(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            
        }
    }
    
    
    func savePhoto(_ photoData: Data, completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
//        savePhoto(image.jpegData(compressionQuality: 1)!)
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                // Add the captured photo's file data as the main resource for the Photos asset.
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            }, completionHandler: completionHandler)
        }
    }
}

extension String {
    static let AlbumName_WallPaper = "Wallpaper for widget".localized()
    static let AlbumName_AppIcon = "Icon for widget".localized()

}
