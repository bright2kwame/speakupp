//
//  SearchMenuBar.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SearchMenuBar: BaseUIView {
    let menuCellId = "menuCellId"
    let labels = [SearchMenuLabel(title: "POLL",type: SearchType.poll),SearchMenuLabel(title: "PEOPLE",type: SearchType.people),SearchMenuLabel(title: "BRANDS",type: SearchType.brands),SearchMenuLabel(title: "EVENTS",type: SearchType.events)]
    var searchController: SearchController?
    
    
    lazy var menuCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func setUpLayout() {
        super.setUpLayout()
        backgroundColor = UIColor.white
        addSubview(menuCollectionView)
        
        self.menuCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.menuCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.menuCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.menuCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.menuCollectionView.register(SearchBarCell.self, forCellWithReuseIdentifier: menuCellId)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        self.menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if let flowLayout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 5
        }
        
    }
}
extension SearchMenuBar: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! SearchBarCell
        cell.menuItem = labels[indexPath.row].title
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width / 4
        return CGSize(width: itemWidth - contentInset, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchController?.setSearchType(type: self.labels[indexPath.row].type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}

class SearchBarCell: BaseCell {
    
    var menuItem: String? {
        didSet {
            guard let unwrapedMenuItem = menuItem else {return}
            self.label.text = unwrapedMenuItem.uppercased()
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
        
        self.label.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        self.label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8).isActive = true
        self.label.bottomAnchor.constraint(equalTo: indicatorBar.topAnchor, constant: -2).isActive = true
        self.label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        self.indicatorBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        self.indicatorBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.indicatorBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.indicatorBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = ""
        
    }
}

