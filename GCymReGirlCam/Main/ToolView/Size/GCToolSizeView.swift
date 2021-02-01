//
//  GCToolSizeView.swift
//  GCymReGirlCam
//
//  Created by JOJO on 2021/1/26.
//

import UIKit

class GCToolSizeView: UIView {
    
    var collection: UICollectionView!
    var slider: UISlider = UISlider.init(frame: .zero)
    var colors: [String] = []
    var colorClickBlock: ((String)->Void)?
    var sizeValueChangeBlock: ((CGFloat)->Void)?
    
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
    }

}

extension GCToolSizeView {
    
    func loadData() {
        colors = ["#FFB3BB", "#FFDFB9", "#FFFFB9", "#BAFEC9", "#E0CDE0", "#FDE6EB", "#F8A3C4", "#FFDFB9", "#FFFFB9", "#BAFEC9", "#E0CDE0", "#FDE6EB", "#F8A3C4"]
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
            $0.height.equalTo(44)
        }
        collection.register(cellWithClass: GCColorCell.self)
        
        // slider
        
        addSubview(slider)
        slider.value = 1.0
        slider.maximumValue = 1.0
        slider.minimumValue = 0.3
        slider.setThumbImage( UIImage(named: "edit_slide_ic"), for: .normal)
        slider.minimumTrackTintColor = UIColor.hexString("#FF93B2")
        slider.maximumTrackTintColor = UIColor.hexString("#FF93B2")
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        slider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(24)
        }
    }
    
    
    @objc func sliderValueChange(sender: UISlider) {
        
        sizeValueChangeBlock?(CGFloat(sender.value))
    }
    
    
}

extension GCToolSizeView {
    func updateCurrentSizeSlider(value: CGFloat) {
        slider.value = Float(value)
    }
}

extension GCToolSizeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withClass: GCColorCell.self, for: indexPath)
        let color = colors[indexPath.item]
        cell.colorView.backgroundColor = UIColor.hexString(color)
        cell.colorView.layer.masksToBounds = true
        cell.colorView.layer.cornerRadius = 16
        cell.selectView.layer.cornerRadius = 17
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCToolSizeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 34, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

extension GCToolSizeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.item]
        colorClickBlock?(color)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class GCColorCell: UICollectionViewCell {
    
    let colorView: UIView = UIView()
    let selectView: UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
            $0.left.equalToSuperview().offset(2)
            $0.right.equalToSuperview().offset(-2)
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






