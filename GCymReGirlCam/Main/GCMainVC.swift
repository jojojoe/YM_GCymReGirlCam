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

    let goBtn = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // he /*
        HightLigtingHelper.default.delegate = self
        // he */
        
        setupView()
        
    }
    
 
}

extension GCMainVC: HightLigtingHelperDelegate {

    func open(isO: Bool) {
        debugPrint("isOpen = \(isO)")
    }
    
    func open() -> UIButton? {
        let coreButton = UIButton()
        coreButton.setImage(UIImage(named: "get_li\("ke_btn")"), for: .normal)
        coreButton.addTarget(self, action: #selector(coreButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(coreButton)
        coreButton.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(68)
            make.bottom.equalTo(goBtn.snp.top).offset(-24)
            make.centerX.equalTo(self.view)
        }

        return coreButton
    }
    
    @objc func coreButtonClick(button: UIButton) {
        HightLigtingHelper.default.present()
    }
    
    func preparePopupKKAd(placeId: String?, placeName: String?) {
        
    }

    
    func showAd(type: Int, userId: String?, source: String?, complete: @escaping ((Bool, Bool, Bool) -> Void)) {
        var adType:String = ""
        switch type {
        case 0:
            adType = "KKAd"
        case 1:
            adType = "interstitial Ad"
        case 2:
            adType = "reward Video Ad"
        default:
            break
        }
        
        
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
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                case .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        
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










