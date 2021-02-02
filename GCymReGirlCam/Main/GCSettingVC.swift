//
//  GCSettingVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit


let AppName: String = "Magic Girl Cam"
let purchaseUrl = ""
let TermsofuseURLStr = "http://subsequent-use.surge.sh/Terms_of_use.htm"
let PrivacyPolicyURLStr = "http://subsequent-use.surge.sh/Privacy_Agreement.htm"

let feedbackEmail: String = "magicgirlcambuild@126.com"
let AppAppStoreID: String = ""


class GCSettingVC: UIViewController {
    let backBtn = UIButton(type: .custom)
    let feedbackBgView = UIView()
    let privacyBgView = UIView()
    let termBgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
     

}

extension GCSettingVC {
    func setupView() {
        
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_ic"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        
        setupFeedback()
        setupPrivacy()
        setupTermsofuse()
        
        
    }
}

extension GCSettingVC {
    func setupFeedback() {
        // feedback
        
        feedbackBgView.backgroundColor = .clear
        view.addSubview(feedbackBgView)
        feedbackBgView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(70)
        }
        
        let feedbackBtn = UIButton(type: .custom)
        feedbackBgView.addSubview(feedbackBtn)
        feedbackBtn.setBackgroundImage(UIImage(named: "setting_bg_ic"), for: .normal)
        feedbackBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        let feedbackLabel = UILabel()
        feedbackLabel.text = "Feedback"
        feedbackLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        feedbackLabel.textColor = UIColor(hexString: "#FFFFFF")
        feedbackBgView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(62)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func setupPrivacy() {
        // Privacy
        
        privacyBgView.backgroundColor = .clear
        view.addSubview(privacyBgView)
        privacyBgView.snp.makeConstraints {
            $0.top.equalTo(feedbackBgView.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(70)
        }
        
        let privacyBtn = UIButton(type: .custom)
        privacyBgView.addSubview(privacyBtn)
        privacyBtn.setBackgroundImage(UIImage(named: "setting_bg_ic"), for: .normal)
        privacyBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        privacyBtn.addTarget(self, action: #selector(provateBtnClick(sender:)), for: .touchUpInside)
        let privacyLabel = UILabel()
        privacyLabel.text = "Privacy"
        privacyLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        privacyLabel.textColor = UIColor(hexString: "#FFFFFF")
        privacyBgView.addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(62)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func setupTermsofuse() {
        // Termsofuse
        
        termBgView.backgroundColor = .clear
        view.addSubview(termBgView)
        termBgView.snp.makeConstraints {
            $0.top.equalTo(privacyBgView.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(70)
        }
        
        let termBtn = UIButton(type: .custom)
        termBgView.addSubview(termBtn)
        termBtn.setBackgroundImage(UIImage(named: "setting_bg_ic"), for: .normal)
        termBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        termBtn.addTarget(self, action: #selector(termsofuseBtnClick(sender:)), for: .touchUpInside)
        let termLabel = UILabel()
        termLabel.text = "Terms of use"
        termLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        termLabel.textColor = UIColor(hexString: "#FFFFFF")
        termBgView.addSubview(termLabel)
        termLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(62)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
}

extension GCSettingVC {
    @objc func backBtnClick(sender: UIButton) {
        self.navigationController?.popViewController()
    }
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    @objc func provateBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    @objc func termsofuseBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    
    
    
}



extension GCSettingVC: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
           controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion ?? "1.0")", isHTML: false)
           
           //打开界面
           self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}


extension UIDevice {
  
   ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
   var modelName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
      
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8, value != 0 else {
               return identifier
           }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
      
       switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
           case "iPhone4,1":                               return "iPhone 4s"
           case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
           case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
           case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
           case "iPhone7,2":                               return "iPhone 6"
           case "iPhone7,1":                               return "iPhone 6 Plus"
           case "iPhone8,1":                               return "iPhone 6s"
           case "iPhone8,2":                               return "iPhone 6s Plus"
           case "iPhone8,4":                               return "iPhone SE"
           case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
           case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
           case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6":                return "iPhone X"
           case "iPhone11,2":                              return "iPhone XS"
           case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
           case "iPhone11,8":                              return "iPhone XR"
           case "iPhone12,1":                              return "iPhone 11"
           case "iPhone12,3":                              return "iPhone 11 Pro"
           case "iPhone12,5":                              return "iPhone 11 Pro Max"
           case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
           case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
           case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
           case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
           case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
           case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
           case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
           case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
           case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
           case "AppleTV5,3":                              return "Apple TV"
           case "i386", "x86_64":                          return "Simulator"
           default:                                        return identifier
       }
   }
}
