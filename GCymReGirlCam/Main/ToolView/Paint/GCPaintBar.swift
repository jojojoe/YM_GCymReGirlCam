//
//  GCPaintBar.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/2/1.
//

import UIKit

class GCPaintBar: UIView {
    //public
    var didSelectPaintStyleBlock: ((_ paintStyleItem:GCPaintItem) -> Void)?
    var lineWidthStrengthBlock:((_ lineWidthStrength:Int) -> Void)?
    var clearAllPathAction:(() -> Void)?
    var beforeStepAction:(() -> Void)?
    var nextStepAction:(() -> Void)?
    var currentPaintStyleItem: GCPaintItem?
    //
    
    let topView = UIView()
    var collection: UICollectionView!
    
    var widthBtns: [UIButton] = []
    let widthBtn1 = UIButton(type: .custom)
    let widthBtn2 = UIButton(type: .custom)
    let widthBtn3 = UIButton(type: .custom)
    let widthBtn4 = UIButton(type: .custom)
    let widthBtn5 = UIButton(type: .custom)
    let resetBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        collection.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        widthBtn3.isSelected = true
    }

}

extension GCPaintBar {
    func refreshContentCollection() {
        collection.reloadData()
    }
}



extension GCPaintBar {
    func loadData() {
        
    }
    
    func setupView() {
        
        
        addLineWidthBtns()
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        collection.register(cellWithClass: GCPaintCell.self)
        
        
    }
    func addLineWidthBtns() {
        topView.backgroundColor = .clear
        addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        let btnWidth: CGFloat = 40
        let btnPadding: CGFloat = 4
        
        widthBtns.append(widthBtn1)
        widthBtns.append(widthBtn2)
        widthBtns.append(widthBtn3)
        widthBtns.append(widthBtn4)
        widthBtns.append(widthBtn5)
        // 3
        widthBtn3.setImage(UIImage(named: "paintWidth3"), for: .normal)
        widthBtn3.setImage(UIImage(named: "paintWidth3_sele"), for: .selected)
        topView.addSubview(widthBtn3)
        widthBtn3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(btnWidth)
        }
        widthBtn3.addTarget(self, action: #selector(lineWidthBtnClick(sender:)), for: .touchUpInside)
        
        // 4
        widthBtn4.setImage(UIImage(named: "paintWidth4"), for: .normal)
        widthBtn4.setImage(UIImage(named: "paintWidth4_sele"), for: .selected)
        topView.addSubview(widthBtn4)
        widthBtn4.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(widthBtn3.snp.right).offset(btnPadding)
            $0.width.height.equalTo(btnWidth)
        }
        widthBtn4.addTarget(self, action: #selector(lineWidthBtnClick(sender:)), for: .touchUpInside)
        
        // 5
        widthBtn5.setImage(UIImage(named: "paintWidth5"), for: .normal)
        widthBtn5.setImage(UIImage(named: "paintWidth5_sele"), for: .selected)
        topView.addSubview(widthBtn5)
        widthBtn5.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(widthBtn4.snp.right).offset(btnPadding)
            $0.width.height.equalTo(btnWidth)
        }
        widthBtn5.addTarget(self, action: #selector(lineWidthBtnClick(sender:)), for: .touchUpInside)
        
        
        
        // 2
        widthBtn2.setImage(UIImage(named: "paintWidth2"), for: .normal)
        widthBtn2.setImage(UIImage(named: "paintWidth2_sele"), for: .selected)
        topView.addSubview(widthBtn2)
        widthBtn2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(widthBtn3.snp.left).offset(-btnPadding)
            $0.width.height.equalTo(btnWidth)
        }
        widthBtn2.addTarget(self, action: #selector(lineWidthBtnClick(sender:)), for: .touchUpInside)
        
        // 1
        widthBtn1.setImage(UIImage(named: "paintWidth1"), for: .normal)
        widthBtn1.setImage(UIImage(named: "paintWidth1_sele"), for: .selected)
        topView.addSubview(widthBtn1)
        widthBtn1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(widthBtn2.snp.left).offset(-btnPadding)
            $0.width.height.equalTo(btnWidth)
        }
        widthBtn1.addTarget(self, action: #selector(lineWidthBtnClick(sender:)), for: .touchUpInside)
        
        // reset btn
        topView.addSubview(resetBtn)
        resetBtn.setImage(UIImage(named: "reset_ic"), for: .normal)
        resetBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(btnWidth)
            $0.right.equalToSuperview().offset(-15)
        }
        resetBtn.addTarget(self, action: #selector(resetBtnBtnClick(sender:)), for: .touchUpInside)
    }
    
    
    @objc func lineWidthBtnClick(sender: UIButton) {
        for btn in widthBtns {
            if btn == sender {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        if sender == widthBtn1 {
            lineWidthStrengthBlock?(4)
        } else if sender == widthBtn2 {
            lineWidthStrengthBlock?(12)
        } else if sender == widthBtn3 {
            lineWidthStrengthBlock?(20)
        } else if sender == widthBtn4 {
            lineWidthStrengthBlock?(30)
        } else if sender == widthBtn5 {
            lineWidthStrengthBlock?(40)
        }
        
    }
    
    @objc func resetBtnBtnClick(sender: UIButton) {
        clearAllPathAction?()
    }
}

extension GCPaintBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withClass: GCPaintCell.self, for: indexPath)
        let item : GCPaintItem = GCDataManager.default.paintStyleItemList[indexPath.item]
        cell.contentImageView.image = UIImage.init(named: item.previewImageName)
        cell.contentImageView.layer.masksToBounds = true
        cell.contentImageView.layer.cornerRadius = 12
        cell.selectView.layer.cornerRadius = 12
        
        if currentPaintStyleItem?.previewImageName == item.previewImageName {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: item.previewImageName) {
            cell.lockImageView.isHidden = true
        } else {
            cell.lockImageView.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GCDataManager.default.paintStyleItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCPaintBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 50
        return CGSize(width: height*3, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension GCPaintBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item : GCPaintItem = GCDataManager.default.paintStyleItemList[indexPath.item]
        currentPaintStyleItem = item
        didSelectPaintStyleBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GCPaintCell: UICollectionViewCell {
    var contentImageView: UIImageView = UIImageView()
    let selectView: UIView = UIView()
    let lockImageView: UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImageView.contentMode = .scaleAspectFill
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        selectView.isHidden = true
        selectView.backgroundColor = .clear
        selectView.layer.borderWidth = 2
        selectView.layer.borderColor = UIColor(hexString: "#FF93B2")?.cgColor
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
        }
        
        contentView.addSubview(lockImageView)
        lockImageView.image = UIImage(named: "locak_ic")
        lockImageView.contentMode = .scaleAspectFit
        lockImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(29)
        }
        lockImageView.isHidden = true
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectView.isHidden = false
            } else {
                selectView.isHidden = true
            }
        }
    }
    
}

