//
//  GCSaveVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit

class GCSaveVC: UIViewController {
    let topBgView = UIView()
    
    var contentImage: UIImage
    init(image: UIImage) {
        contentImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
    }
     

}

extension GCSaveVC {
    
    func setupView() {
        topBgView.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.addSubview(topBgView)
        topBgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
         
        let backBtn = UIButton(type: .custom)
        topBgView.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_ic"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        let contentImageView = UIImageView()
        contentImageView.contentMode = .scaleAspectFill
        view.addSubview(contentImageView)
        contentImageView.image = contentImage
        contentImageView.snp.makeConstraints {
            $0.top.equalTo(topBgView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.width)
            $0.height.equalTo(UIScreen.width)
        }
        
        let startBtn = UIButton(type: .custom)
        view.addSubview(startBtn)
        startBtn.layer.cornerRadius = 12
        
        startBtn.backgroundColor = UIColor(hexString: "#FF89B4")
        startBtn.setTitle("Start new", for: .normal)
        startBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        startBtn.titleColor(.white)
        startBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(54)
            $0.top.equalTo(contentImageView.snp.bottom).offset(30)
        }
        startBtn.addTarget(self, action: #selector(startBtnClick(sender:)), for: .touchUpInside)
    }
    
    
    
}

extension GCSaveVC {
    @objc func backBtnClick(sender: UIButton) {
        self.navigationController?.popViewController()
    }
    @objc func startBtnClick(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
}
