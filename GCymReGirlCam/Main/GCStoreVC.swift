//
//  GCStoreVC.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit
import NoticeObserveKit


class GCStoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupCollection()
        addNotificationObserver()
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(CoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
            
        }
        .invalidated(by: pool)
    }

}

extension GCStoreVC {
    func setupView() {
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_ic"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(CoinManager.default.coinCount)"
        topCoinLabel.textColor = UIColor.hexString("#FF8AB3")
        topCoinLabel.font = UIFont(name: "Avenir-BlackOblique", size: 14)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
            $0.width.greaterThanOrEqualTo(25)
        }
        
        let coinImageV = UIImageView()
        coinImageV.image = UIImage(named: "coin_small_ic")
        coinImageV.contentMode = .center
        view.addSubview(coinImageV)
        coinImageV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-4)
            $0.width.height.equalTo(22)
        }
        
    }
    
    func setupCollection() {
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: GCStoreCell.self)
    }
    
    func selectCoinItem(item: StoreItem) {
        CoinManager.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                CoinManager.default.addCoin(coin: item.coin)
                self.showAlert(title: "Success", message: "")
            } else {
                self.showAlert(title: "Failed", message: errorString)
            }
        }
    }
}

extension GCStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GCStoreCell.self, for: indexPath)
        let item = CoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "x \(item.coin)"
        cell.priceLabel.text = item.price
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 152, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 27, bottom: 20, right: 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
}

extension GCStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = CoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


extension GCStoreVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}








class GCStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    
    
    var bgImageV: UIImageView = UIImageView().image("store_coins_bg_ic")
    var coverImageV: UIImageView = UIImageView().image("store_coins_ic")
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        bgImageV.contentMode = .scaleAspectFit
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        coverImageV.contentMode = .center
        bgView.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(14)
            $0.width.equalTo(40)
            $0.height.equalTo(44)
        }
        
        coinCountLabel.textColor = .white
        coinCountLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(coverImageV)
            $0.left.equalTo(coverImageV.snp.right).offset(18)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(30)
        }
          
        priceLabel.textColor = UIColor.hexString("#FF3F8F")
        priceLabel.font = UIFont(name: "Avenir-Black", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.backgroundColor = .white
        priceLabel.cornerRadius = 8
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(coinCountLabel.snp.bottom).offset(2)
            $0.right.equalTo(-17)
            $0.left.equalTo(coverImageV.snp.right).offset(2)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}

