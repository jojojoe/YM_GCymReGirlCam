//
//  VC+ImagePicker.swift
//  PhotoWatermark
//
//  Created by Conver on 5/7/19.
//  Copyright © 2019 Conver. All rights reserved.
//

import Alertift
import Photos
import SwifterSwift
import UIKit

public protocol ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkImagePicker(_ type: UIImagePickerController.SourceType,
                          controller: UIViewController)
}

public extension ImagePicker where Self: UIViewController {
    func checkImagePicker(_ type: UIImagePickerController.SourceType,
                          controller: UIViewController) {
        switch type {
        case .photoLibrary:
            photoPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, controller: controller)
            }
        case .camera:
            cameraPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, controller: controller)
            }
        case .savedPhotosAlbum:
            photoPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, controller: controller)
            }
        @unknown default:
            return
        }
    }

    private func privateCheckImage(_ type: UIImagePickerController.SourceType,
                                   controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let picker = UIImagePickerController().then {
                $0.sourceType = type
//                $0.allowsEditing = true
                $0.delegate = self
                $0.modalPresentationStyle = .overFullScreen
            }
            controller.present(picker, animated: true)
        }
    }
}

public extension UIViewController {
    func photoPermission(controller: UIViewController, block: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        let alert = {
            DispatchQueue.main.async {
                Alertift
                    .alert(title: "Error", message: "Please allow to access your photos in Settings -> \(UIApplication.shared.displayName ?? "") -> Photos")
                    .action(.default("OK"), handler: { _, _, _ in
                        UIApplication.shared.openURL(url: UIApplication.openSettingsURLString)
                    })
                    .show(on: controller, completion: nil)                
            }
        }

        switch status {
        case .authorized:
            block(true)
        case .restricted, .denied:
            alert()
        case .notDetermined:
            // Show permission popup and get new status
            PHPhotoLibrary.requestAuthorization { status in
                if status != .authorized {
                    alert()
                }
                DispatchQueue.main.async {
                    block(status == .authorized)
                }
            }
        @unknown default:
            return
        }
    }

    func cameraPermission(controller: UIViewController, block: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { response in
            if response {
                block(true)
            } else {
                Alertift
                    .alert(title: "Error", message: "Please allow to access your Camera in Settings -> \(UIApplication.shared.displayName ?? "") -> Camera")
                    .action(.default("OK"), handler: { _, _, _ in
                        UIApplication.shared.openURL(url: UIApplication.openSettingsURLString)
                    })
                    .show(on: controller, completion: nil)
            }
        }
    }
}
