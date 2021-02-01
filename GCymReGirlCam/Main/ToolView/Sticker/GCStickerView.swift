//
//  GCStickerView.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/2/1.
//

import UIKit
 

class GCStickerView: UIView {

    var collection: UICollectionView!
    var didSelectStickerItemBlock: ((_ stickerItem: GCStickerItem) -> Void)?
    var currentSelectIndexPath : IndexPath?
    
    
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
        
        
    }

}

extension GCStickerView {
    func refreshContentCollection() {
        collection.reloadData()
    }
}


extension GCStickerView {
    func loadData() {
        
    }
    
    func setupView() {
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
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        collection.register(cellWithClass: GCStickerCell.self)
    }
    
}

extension GCStickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = GCDataManager.default.stickerList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: GCStickerCell.self, for: indexPath)
        
        cell.contentImageView.image = UIImage(named: item.thumbnail)
        cell.contentImageView.layer.masksToBounds = true
        cell.contentImageView.layer.cornerRadius = 14
        cell.selectView.layer.cornerRadius = 14
        if currentSelectIndexPath?.item == indexPath.item {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: item.thumbnail) {
            cell.lockImageView.isHidden = true
        } else {
            cell.lockImageView.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GCDataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCStickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
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

extension GCStickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = GCDataManager.default.stickerList[indexPath.item]
        didSelectStickerItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GCStickerCell: UICollectionViewCell {
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











