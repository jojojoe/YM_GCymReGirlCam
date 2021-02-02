//
//  GCEditVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit
import Alertift
import SwifterSwift

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
    
    var toolContentViews: [UIView] = []
    let toolSizeView = GCToolSizeView()
    let toolFilterView = GCToolFilterView()
    let toolOverlayerBorderView = GCToolBorderView()
    let toolStickerView = GCStickerView()
    let toolPainBarView = GCPaintBar()
    
    
    var paintContentView : MaskView!
    
    var currentUnlockPaintItem: GCPaintItem?
    
    //sticker
    var currentStickerAddonView : GCTouchStickerView?
    
    var stickerAddonViewList : [TouchStuffView]? = [TouchStuffView]()
    var isModify : Bool = false
    
    let unlockAlertView: GCUnlockBgView = GCUnlockBgView()
    
    
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
        
        saveBtn.backgroundColor = UIColor(hexString: "#FF93B2")
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
    @objc func contentBgBtnClick(sender: UIButton) {
        deselectCurrentSticker()
    }
    
}

extension GCEditVC {
    func setupCanvasView() {
        
        // add content bg btn
        let contentBgBtn = UIButton(type: .custom)
        contentBgBtn.backgroundColor = .clear
        view.addSubview(contentBgBtn)
        contentBgBtn.snp.makeConstraints {
            $0.top.equalTo(topBgView.snp.bottom)
            $0.right.bottom.left.equalToSuperview()
        }
        contentBgBtn.addTarget(self, action: #selector(contentBgBtnClick(sender:)), for: .touchUpInside)
        
        
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
        overlayerImageView.contentMode = .scaleAspectFit
        overlayerImageView.backgroundColor = .clear
        overlayerImageView.image = nil
        overlayerImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        contentBgView.addSubview(overlayerImageView)
        
        // sticker bg view
        stickerBgView.backgroundColor = .clear
        stickerBgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        contentBgView.addSubview(stickerBgView)
        
        let stickerBgBtn = UIButton(type: .custom)
        stickerBgBtn.backgroundColor = .clear
        stickerBgView.addSubview(stickerBgBtn)
        stickerBgBtn.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        stickerBgBtn.addTarget(self, action: #selector(contentBgBtnClick(sender:)), for: .touchUpInside)
        
        // add paint view
        setupPaintCotnentView()
        
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
        setupToolSizeView()
        setupToolFilter()
        setupToolOverlayer()
        setupToolStickerView()
        setupToolPaintView()
        
        updateContentToolView(currentView: toolSizeView)
        
        updateContentBgViewColor(color: UIColor(hexString: toolSizeView.colors.first ?? "#FFFFFF") ?? .white)
    }
    
    func setupToolSizeView() {
        // Tool Size
        toolContentViews.append(toolSizeView)
        toolSizeView.slider.value = 0.75
        updateImageViewTransitionScale(scale: 0.75)
        toolSizeView.sizeValueChangeBlock = {
            [weak self] scale in
            guard let `self` = self else {return}
            
            self.updateImageViewTransitionScale(scale: scale)
            self.isModify = true
        }
        toolSizeView.colorClickBlock = {
            [weak self] colorHex in
            guard let `self` = self else {return}
            self.updateContentBgViewColor(color: UIColor(hexString: colorHex) ?? .white)
            self.isModify = true
        }
        toolContentView.addSubview(toolSizeView)
        toolSizeView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
    }
    
    func setupToolFilter() {
        // Tool Filter
        toolContentViews.append(toolFilterView)
        toolFilterView.didSelectFilterItemBlock = {
            [weak self] filterItem in
            guard let `self` = self else {return}
            if filterItem.filterName == "Original" {
                self.contentImageView.image = self.contentImage
            } else {
                self.contentImageView.image = GCDataManager.default.filterOriginalImage(image: self.contentImage, lookupImgNameStr: filterItem.imageName)
                self.isModify = true
            }
        }
        toolContentView.addSubview(toolFilterView)
        toolFilterView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
        
    }
    func setupToolOverlayer() {
        toolContentViews.append(toolOverlayerBorderView)
        toolOverlayerBorderView.didSelectStickerItemBlock = {
            [weak self] overlayerItem in
            guard let `self` = self else {return}
            if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: overlayerItem.thumbnail) {
                
            } else {
                self.showUnlockBgView(currentUnlockId: overlayerItem.thumbnail, type: "border")
                return
            }
            
            if overlayerItem.contentImageName == "overlayer_sele" {
                self.overlayerImageView.image = nil
            } else {
                self.overlayerImageView.image = UIImage(named: overlayerItem.contentImageName)
                self.isModify = true
            }
            
        }
        toolContentView.addSubview(toolOverlayerBorderView)
        toolOverlayerBorderView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
    }
    
    func setupToolStickerView() {
        
        toolContentViews.append(toolStickerView)
        toolStickerView.didSelectStickerItemBlock = {
            [weak self] stickerItem in
            guard let `self` = self else {return}
            if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: stickerItem.thumbnail) {
                
            } else {
                self.showUnlockBgView(currentUnlockId: stickerItem.thumbnail, type: "sticker")
                return
            }
            
            self.creatStickerAddonWithStickerName(stickerName: stickerItem.contentImageName)
            self.isModify = true
        }
        toolContentView.addSubview(toolStickerView)
        toolStickerView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
    }
    
    func setupToolPaintView() {
        
        toolContentViews.append(toolPainBarView)
        
        toolPainBarView.didSelectPaintStyleBlock = {[weak self] paintStyleItem in
            guard let `self` = self else { return }
            
            self.currentUnlockPaintItem = paintStyleItem
            
            if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: paintStyleItem.previewImageName) {
                
            } else {
                self.showUnlockBgView(currentUnlockId: paintStyleItem.previewImageName, type: "paint")
                return
            }
            
            MaskConfigManager.sharedInstance().lineColorOne = UIColor.init(hexString: paintStyleItem.gradualColorOne) ?? UIColor.white
            MaskConfigManager.sharedInstance().lineColorTwo = UIColor.init(hexString: paintStyleItem.gradualColorTwo) ?? UIColor.white
            if paintStyleItem.StrokeType == "Normal" {
                MaskConfigManager.sharedInstance().strokeType = .normal
            } else {
                MaskConfigManager.sharedInstance().strokeType = .gradient
            }
            self.isModify = true
        }
        toolPainBarView.lineWidthStrengthBlock = {[weak self] lineWidthStrength in
            guard let `self` = self else { return }
            MaskConfigManager.sharedInstance().lineWidth = CGFloat(lineWidthStrength)
            self.isModify = true
        }
        
        toolPainBarView.clearAllPathAction = {[weak self] in
            guard let `self` = self else { return }
            self.paintContentView.clearPath()
            self.isModify = true
        }
         
        
        toolContentView.addSubview(toolPainBarView)
        toolPainBarView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-30)
        }
    }
    
    func setupPaintCotnentView()  {
        paintContentView = MaskView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.width, height: UIScreen.width))
        contentBgView.addSubview(paintContentView)
        paintContentView.perPaintMoveCompletion = {[weak self] canBeforeAction, canNextAction in
            guard let `self` = self else { return }
            self.isModify = true
        }
        showPaintContentView(isInteractionEnabled: false)
    }
    
    func showPaintContentView(isInteractionEnabled:Bool)  {
        paintContentView.isUserInteractionEnabled = isInteractionEnabled
        paintContentView.touchView.canEditStatus = isInteractionEnabled
    }
    
}

extension GCEditVC {
    func creatStickerAddonWithStickerName(stickerName:String) {
        
        if currentStickerAddonView != nil {
            currentStickerAddonView?.setHilight(false)
        }
        
        let stickerWidth = UIScreen.width * 1 / 2
        let stickerAddon: GCTouchStickerView = GCTouchStickerView.init(stickerName: stickerName, withStickerSize: CGSize.init(width: stickerWidth, height: stickerWidth))
        stickerAddon.delegate = self
        stickerAddon.center = CGPoint.init(x: self.stickerBgView.width / 2, y: self.stickerBgView.height / 2)
        stickerBgView.addSubview(stickerAddon)
        
        currentStickerAddonView = stickerAddon
        stickerAddonViewList?.append(stickerAddon)
        currentStickerAddonView?.setHilight(true)
        
        
        
    }
    
}

extension GCEditVC {
    func updateContentToolView(currentView: UIView) {
        for view in toolContentViews {
            if view == currentView {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
}

extension GCEditVC {
    
}

extension GCEditVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if isModify == true {
            Alertift.alert(title: "Are you sure you want to exit, your operation will not be saved.", message: "")
                .action(.cancel("Cancel"))
                .action(.default("Ok"), handler: {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.navigationController?.popViewController()
                    }
                })
                .show(on: self, completion: nil)
            
        } else {
            self.navigationController?.popViewController()
        }
        
        
    }
    @objc func saveBtnClick(sender: UIButton) {
        deselectCurrentSticker()
        
        if let image = contentBgView.screenshot {
            let saveVC = GCSaveVC(image: image)
            self.navigationController?.pushViewController(saveVC, animated: true)
        }
        
    }

    @objc func toolBtnClick(sender: UIButton) {
        for btn in toolBtns {
            if btn == sender {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        
        deselectCurrentSticker()
        
        showPaintContentView(isInteractionEnabled: false)
        
        if sender == toolSizeBtn {
            updateContentToolView(currentView: toolSizeView)
        } else if sender == toolFilterBtn {
            updateContentToolView(currentView: toolFilterView)
        } else if sender == toolBorderBtn {
            updateContentToolView(currentView: toolOverlayerBorderView)
        } else if sender == toolStickerBtn {
            updateContentToolView(currentView: toolStickerView)
        } else if sender == toolLineBtn {
            updateContentToolView(currentView: toolPainBarView)
            
            showPaintContentView(isInteractionEnabled: true)
            
            if toolPainBarView.currentPaintStyleItem == nil {
                toolPainBarView.didSelectPaintStyleBlock?(GCDataManager.default.paintStyleItemList[0])
            }
        }
    }
    
    func updateImageViewTransitionScale(scale: CGFloat) {
        contentImageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    func updateContentBgViewColor(color: UIColor) {
        contentBgView.backgroundColor = color
    }
    
}

extension GCEditVC {
    // type  =  sticker  border  paint
    func showUnlockBgView(currentUnlockId: String, type: String) {
        if unlockAlertView.superview == nil {
            view.addSubview(unlockAlertView)
            unlockAlertView.snp.makeConstraints {
                $0.top.right.left.bottom.equalToSuperview()
            }
            unlockAlertView.alpha = 0
            
            
        }
        
        unlockAlertView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.3) {
                [weak self] in
                guard let `self` = self else {return}
                self.unlockAlertView.alpha = 0
            }
        }
        
        unlockAlertView.okBtnClickBlock = {
            UIView.animate(withDuration: 0.3) {
                [weak self] in
                guard let `self` = self else {return}
                self.unlockAlertView.alpha = 0
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                [weak self] in
                guard let `self` = self else {return}
                if CoinManager.default.coinCount >= CoinManager.default.coinCostCount {
                    
                    ITContentPurchasedUnlockManager.sharedInstance().unlockContentItem(withItemId: currentUnlockId) {
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            Alertift.alert(title: "Unlock successfully", message: "")
                                .action(.cancel("Ok"))
                                .show(on: self, completion: nil)
                            CoinManager.default.costCoin(coin: CoinManager.default.coinCostCount)
                            if type == "sticker" {
                                self.toolStickerView.refreshContentCollection()
                            } else if type == "border" {
                                self.toolOverlayerBorderView.refreshContentCollection()
                            } else if type == "paint" {
                                self.toolPainBarView.refreshContentCollection()
                                if let currentUnlockPaintItem_m = self.currentUnlockPaintItem  {
                                    MaskConfigManager.sharedInstance().lineColorOne = UIColor.init(hexString: currentUnlockPaintItem_m.gradualColorOne) ?? UIColor.white
                                    MaskConfigManager.sharedInstance().lineColorTwo = UIColor.init(hexString: currentUnlockPaintItem_m.gradualColorTwo) ?? UIColor.white
                                    if currentUnlockPaintItem_m.StrokeType == "Normal" {
                                        MaskConfigManager.sharedInstance().strokeType = .normal
                                    } else {
                                        MaskConfigManager.sharedInstance().strokeType = .gradient
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    Alertift.alert(title: "Diamonds not enough, click and jump to store page.", message: "")
                        .action(.cancel("Cancel"))
                        .action(.default("Ok"), handler: {
                            DispatchQueue.main.async {
                                [weak self] in
                                guard let `self` = self else {return}
                                self.present(GCStoreVC())
                            }
                        })
                        .show(on: self, completion: nil)
                }
            }
        }
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            guard let `self` = self else {return}
            self.unlockAlertView.alpha = 1
        }
        
        
    }
}




extension GCEditVC : TouchStuffViewDelegate {

    func deselectCurrentSticker() {
        if currentStickerAddonView != nil {
            currentStickerAddonView?.setHilight(false)
            currentStickerAddonView = nil
        }
    }
    
    func viewTouchUp(_ sender: TouchStuffView!) {
        
    }
    
    func viewTouchMoved(_ sender: TouchStuffView!) {
        self.isModify = true
    }
    
    func viewSingleClick(_ sender: TouchStuffView!) {
        
        if sender.className == "GCTouchStickerView" {
            if currentStickerAddonView != nil {
                currentStickerAddonView?.setHilight(false)
            }
            
            currentStickerAddonView = (sender as! GCTouchStickerView)
            sender.setHilight(true)
            
        } else {
            if currentStickerAddonView != nil {
                currentStickerAddonView?.setHilight(false)
                currentStickerAddonView = nil
            }
        }
        
        
    }
    
    func viewDeleteBtnClick(_ sender: TouchStuffView!) {
        
        sender.removeFromSuperview()
        currentStickerAddonView = nil
        stickerAddonViewList?.removeAll(sender)

    }
    
    
}






class GCUnlockBgView: UIView {
    
    var cancelBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.right.equalToSuperview().offset(-23)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        
        let contentImageV = UIImageView()
        contentImageV.contentMode = .center
        contentImageV.image = UIImage(named: "store_coins_ic")
        addSubview(contentImageV)
        contentImageV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(-60)
            $0.width.height.equalTo(90)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        titleLabel.textAlignment = .center
        
        titleLabel.text = "Unlock need cost \(CoinManager.default.coinCostCount) Diamonds."
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentImageV.snp.bottom).offset(8)
            $0.width.equalTo(240)
            $0.height.equalTo(80)
        }
        
        let okBtn = UIButton(type: .custom)
        addSubview(okBtn)
        okBtn.setTitle("Ok", for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        okBtn.setTitleColor(UIColor(hexString: "#FF3F8F"), for: .normal)
        okBtn.setBackgroundColor(.white, for: .normal)
        okBtn.layer.cornerRadius = 12
        okBtn.layer.masksToBounds = true
        okBtn.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164)
            $0.height.equalTo(40)
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    
    
    
    
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    
}
