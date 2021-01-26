//
//  GCEditVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit

class GCEditVC: UIViewController {
    var contentImage: UIImage
    
    let topBgView = UIView()
    let contentBgView = UIView()
    var contentImageView = UIImageView()
    var overlayerImageView = UIImageView()
    let stickerBgView = UIView()
    
    let bottomBgView = UIView()
    let toolContentView = UIView()
    let btnBarView = UIView()
    
    var toolBtns: [UIButton] = []
    
    let toolSizeBtn: UIButton = UIButton(type: .custom)
    let toolFilterBtn: UIButton = UIButton(type: .custom)
    let toolBorderBtn: UIButton = UIButton(type: .custom)
    let toolStickerBtn: UIButton = UIButton(type: .custom)
    let toolLineBtn: UIButton = UIButton(type: .custom)
    
    let toolSizeView = GCToolSizeView()
    
    
    
    init(image: UIImage) {
        contentImage = image
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FFEBEC")
        setupView()
        setupCanvasView()
        setupBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toolSizeBtn.isSelected = true
        
    }
     

}

extension GCEditVC {
    func setupView() {
        
        topBgView.backgroundColor = UIColor(hexString: "#FFEBEC")
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
        
        let saveBtn = UIButton(type: .custom)
        topBgView.addSubview(saveBtn)
        saveBtn.layer.cornerRadius = 8
        saveBtn.backgroundColor = UIColor.hexString("#FF93B2")
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        saveBtn.titleColor(.white)
        saveBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-10)
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        
        
        
    }
    
    
}

extension GCEditVC {
    func setupCanvasView() {
        // content bg view
        contentBgView.backgroundColor = .purple
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.top.equalTo(topBgView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(contentBgView.snp.width)
        }
        
        // content image view
        contentImageView.clipsToBounds = true
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.image = contentImage
        contentImageView.backgroundColor = .clear
        contentImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        contentBgView.addSubview(contentImageView)
        
        // overlayer image view
        overlayerImageView.backgroundColor = .clear
        overlayerImageView.image = nil
        overlayerImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        contentBgView.addSubview(overlayerImageView)
        
        // sticker bg view
        stickerBgView.backgroundColor = .clear
        stickerBgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        contentBgView.addSubview(stickerBgView)
        
    }
    
    func setupBottomView() {
        bottomBgView.backgroundColor = .white
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-222)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            [weak self] in
            guard let `self` = self else {return}
            self.bottomBgView.roundCorners([.topLeft, .topRight], radius: 10)
        }
        
        
        bottomBgView.addSubview(btnBarView)
        btnBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }
        
        bottomBgView.addSubview(toolContentView)
        toolContentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(btnBarView.snp.top)
        }
        
        setupBtnBar()
        setupToolContentView()
    }
    
    func setupBtnBar() {
        
        toolBtns = [toolSizeBtn, toolFilterBtn, toolBorderBtn, toolStickerBtn, toolLineBtn]
        
        toolSizeBtn.setImage(UIImage(named: "cut_ic_n"), for: .normal)
        toolSizeBtn.setImage(UIImage(named: "cut_ic_s"), for: .selected)
        
        toolFilterBtn.setImage(UIImage(named: "filter_ic_n"), for: .normal)
        toolFilterBtn.setImage(UIImage(named: "filter_ic_s"), for: .selected)
        
        toolBorderBtn.setImage(UIImage(named: "frame_ic_n"), for: .normal)
        toolBorderBtn.setImage(UIImage(named: "frame_ic_s"), for: .selected)
        
        toolStickerBtn.setImage(UIImage(named: "sticker_ic_n"), for: .normal)
        toolStickerBtn.setImage(UIImage(named: "sticker_ic_s"), for: .selected)
        
        toolLineBtn.setImage(UIImage(named: "brush_ic_n"), for: .normal)
        toolLineBtn.setImage(UIImage(named: "brush_ic_s"), for: .selected)
        
        for btn in toolBtns {
            btn.addTarget(self, action: #selector(toolBtnClick(sender:)), for: .touchUpInside)
        }
        
        btnBarView.addSubview(toolSizeBtn)
        btnBarView.addSubview(toolFilterBtn)
        btnBarView.addSubview(toolBorderBtn)
        btnBarView.addSubview(toolStickerBtn)
        btnBarView.addSubview(toolLineBtn)
        
        let btnWidth: CGFloat = 44
        let padding: CGFloat = (UIScreen.width - (btnWidth * 5) - 2) / 6
        toolSizeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(padding)
            $0.width.height.equalTo(btnWidth)
        }
        toolFilterBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(toolSizeBtn.snp.right).offset(padding)
            $0.width.height.equalTo(btnWidth)
        }
        toolBorderBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(toolFilterBtn.snp.right).offset(padding)
            $0.width.height.equalTo(btnWidth)
        }
        toolStickerBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(toolBorderBtn.snp.right).offset(padding)
            $0.width.height.equalTo(btnWidth)
        }
        toolLineBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(toolStickerBtn.snp.right).offset(padding)
            $0.width.height.equalTo(btnWidth)
        }
        
        
        
    }
    
    func setupToolContentView() {
        toolSizeView.sizeValueChangeBlock = {
            [weak self] scale in
            guard let `self` = self else {return}
            
            self.updateImageViewTransitionScale(scale: scale)
        }
        
        toolSizeView.colorClickBlock = {
            [weak self] colorHex in
            guard let `self` = self else {return}
            self.updateContentBgViewColor(color: UIColor(hexString: colorHex) ?? .white)
        }
        toolContentView.addSubview(toolSizeView)
        toolSizeView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
    }
    
    
}



extension GCEditVC {
    @objc func backBtnClick(sender: UIButton) {
        self.navigationController?.popViewController()
    }
    @objc func saveBtnClick(sender: UIButton) {
        
    }

    @objc func toolBtnClick(sender: UIButton) {
        for btn in toolBtns {
            if btn == sender {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        if sender == toolSizeBtn {
            
        } else if sender == toolFilterBtn {
            
        } else if sender == toolBorderBtn {
            
        } else if sender == toolStickerBtn {
            
        } else if sender == toolLineBtn {
            
        }
    }
    
    func updateImageViewTransitionScale(scale: CGFloat) {
        contentImageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    func updateContentBgViewColor(color: UIColor) {
        contentBgView.backgroundColor = color
    }
    
}
