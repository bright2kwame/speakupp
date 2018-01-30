//
//  EventCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class EventCell: BaseCell {
    var homeController: HomeController?
    let feedCellId = "eventCellId"
    var feed = [Any]()
    
    lazy var feedCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func setUpView() {
        super.setUpView()
        
        backgroundColor = UIColor.white
        addSubview(feedCollectionView)
        
        feedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        feedCollectionView.register(EventItemCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        let feedItem = Feed()
        feedItem.id = "1"
        feed.append(feedItem)
        feed.append(feedItem)
        feedCollectionView.reloadData()
    }
}

extension EventCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _ = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! EventItemCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        return CGSize(width: itemWidth - contentInset, height: 400)
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
    
}
