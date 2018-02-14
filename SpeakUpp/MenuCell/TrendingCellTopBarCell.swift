//
//  TrendingCellTopBarCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class TrendingCellTopBarCell: BaseCell {
    let menuCellId = "menuCellId"
    var labels = [TrendingMenuLabel]()
    let apiService = ApiService()
    var trendingCell: TrendingCell?
    

    lazy var feedCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.white
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
        feedCollectionView.register(TrendingCellTopBarCellInner.self, forCellWithReuseIdentifier: menuCellId)
        
       
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        self.labels.append(TrendingMenuLabel(title: "ALL", id: "0"))
        self.feedCollectionView.reloadData()
        self.scrollToMenuIndex(menuIndex: 0)
        self.setUpAndCall(url: ApiUrl().allTrendingCategory())
    }
    
    func setUpAndCall(url: String)  {
        self.getData(url: url)
    }
    
    func getData(url:String)  {
        self.apiService.allPollsCategory(url: url) { (categories, status, message, nextUrl) in
            if let allCategory = categories {
                self.labels.append(contentsOf: allCategory)
                self.feedCollectionView.reloadData()
                self.scrollToMenuIndex(menuIndex: 0)
            }
        }
    }
}

extension TrendingCellTopBarCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! TrendingCellTopBarCellInner
        cell.menuItem = labels[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = CGFloat(120)
        return CGSize(width: itemWidth - contentInset, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func scrollToMenuIndex(menuIndex: Int)  {
        let selectedIndexPath = IndexPath(item: menuIndex, section: 0)
        feedCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.trendingCell?.getDataWithParam(url: ApiUrl().allTrendingDeatails(), category: self.labels[indexPath.row].id)
    }
    
}

class TrendingCellTopBarCellInner: BaseCell {
    
    var menuItem: TrendingMenuLabel? {
        didSet {
            guard let unwrapedMenuItem = menuItem else {return}
            label.text = unwrapedMenuItem.title.uppercased()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.label.textColor = isHighlighted ? UIColor.hex(hex: Key.primaryHomeHexCode) : UIColor.darkGray
            self.indicatorBar.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = isSelected ? UIColor.hex(hex: Key.primaryHomeHexCode) : UIColor.darkGray
            self.indicatorBar.isHidden = !isSelected
        }
    }
    
    
    let indicatorBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        bar.isHidden = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = ""
    }
}

