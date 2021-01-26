//
//  GCMainVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit
import SnapKit



class GCMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
        
        let editVC = GCEditVC(image: UIImage(named: "giltter_home_ic")!)
        self.navigationController?.pushViewController(editVC, animated: true)
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










