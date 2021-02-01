//
//  GCMainVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit
import SnapKit
import Photos


class GCMainVC: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    

    

}

extension GCMainVC {
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showEditVC(image: UIImage) {
        let editVC = GCEditVC(image: image)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension GCMainVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.showEditVC(image: image)
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.showEditVC(image: image)
            }
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}

extension GCMainVC {
    func setupView() {
        let bgImageV = UIImageView()
        bgImageV.contentMode = .scaleAspectFill
        bgImageV.image = UIImage(named: "giltter_home_bg_ic")
        view.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        let topImageV = UIImageView()
        topImageV.contentMode = .scaleAspectFit
        topImageV.image = UIImage(named: "giltter_home_ic")
        view.addSubview(topImageV)
        topImageV.snp.makeConstraints {
            $0.centerY.equalTo(view).offset(-90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(314)
            $0.height.equalTo(426)
        }
        
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = .clear
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(180)
        }
        
        let goBtn = UIButton(type: .custom)
        goBtn.setImage(UIImage(named: "go_strat_ic"), for: .normal)
        bottomBgView.addSubview(goBtn)
        goBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        goBtn.addTarget(self, action: #selector(goBtnClick(sender:)), for: .touchUpInside)
        
        
         
        let storeBtn = UIButton(type: .custom)
        storeBtn.setImage(UIImage(named: "store_ic"), for: .normal)
        bottomBgView.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.right.equalTo(goBtn.snp.left).offset(-50)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        
        
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting_ic"), for: .normal)
        bottomBgView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.left.equalTo(goBtn.snp.right).offset(50)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        
         
    }
    
    
    
    
}

extension GCMainVC {
    @objc func goBtnClick(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                    
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    }
                case .denied:
                    let alert = UIAlertController(title: "没有权限获取照片信息", message: "照片权限已被拒绝，请开启权限后再更改照片", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "去设置", style: .default, handler: { (goSettingAction) in
                        DispatchQueue.main.async {
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url, options: [:])
                        }
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                    alert.addAction(confirmAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                case .restricted: let alert = UIAlertController(title: "权限限制", message: "照片的获取被限制了无法获取", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .default)
                    alert.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                    
                default: break
                }
            }
        }
        
        
    }
    
    @objc func settingBtnClick(sender: UIButton) {
        let settingVC = GCSettingVC()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        let storeVC = GCStoreVC()
        self.navigationController?.pushViewController(storeVC, animated: true)
    }
    
}










