//
//  HomeCellTopBarCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class HomeCellTopBarCell: BaseCell {
    
    let menuCellId = "menuCellId"
    let labels = [HomeTabsType.TIMELINE.rawValue,HomeTabsType.POLLS.rawValue,HomeTabsType.NEWS.rawValue]
    var homeCell: HomeCell?
    
    lazy var feedCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        addSubview(feedCollectionView)
        
        feedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        feedCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        feedCollectionView.register(HomeCellTopBarCellInner.self, forCellWithReuseIdentifier: menuCellId)
        
        self.scrollToMenuIndex(menuIndex: 0)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
    }
}

extension HomeCellTopBarCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! HomeCellTopBarCellInner
        cell.menuItem = labels[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = frame.width / 3
        return CGSize(width: itemWidth - contentInset, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.scrollToMenuIndex(menuIndex: indexPath.row)
         self.homeCell?.typeOfPoll = self.labels[indexPath.row]
    }
    
    func scrollToMenuIndex(menuIndex: Int)  {
        let selectedIndexPath = IndexPath(item: menuIndex, section: 0)
        self.feedCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

class HomeCellTopBarCellInner: BaseCell {
    
    var menuItem: String? {
        didSet {
            guard let unwrapedMenuItem = menuItem else {return}
            label.text = unwrapedMenuItem
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.label.textColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 229, green: 229, blue: 229, alpha: 1)
            self.indicatorBar.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = isSelected ? UIColor.white : UIColor.rgb(red: 229, green: 229, blue: 229, alpha: 1)
            self.indicatorBar.isHidden = !isSelected
        }
    }
    
    
    let indicatorBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        bar.isHidden = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        addSubview(label)
        addSubview(indicatorBar)
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: indicatorBar.topAnchor, constant: -2).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        indicatorBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        indicatorBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        indicatorBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}
