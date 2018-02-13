//
//  TrendingCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class TrendingCell: BaseCell {
    var homeController: HomeController?
    let feedCellId = "trendingItemCell"
    let menuCellId = "menuCellId"
    var nextPageUrl = ""
    var feed = [Any]()
    let apiService = ApiService()
    
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
        
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(feedCollectionView)
        
        feedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        feedCollectionView.register(TrendingCellTopBarCell.self, forCellWithReuseIdentifier: menuCellId)
        feedCollectionView.register(TrendingItemCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 2
        }
        
        self.feed.append("HEADER")
        self.feedCollectionView.reloadData()
        self.setUpAndCall(url: ApiUrl().allTrendings())
    }
    
    func setUpAndCall(url: String)  {
        self.homeController?.startProgress()
        self.getData(url: url)
    }
    
    func getData(url:String)  {
        self.apiService.allPolls(url: url) { (polls, status, message, nextUrl) in
            self.manageData(polls: polls, status: status, message: message, nextUrl: nextUrl)
        }
    }
    
    func getDataWithParam(url:String,category:String)  {
        if category == "0" {
          self.setUpAndCall(url: ApiUrl().allTrendings())
        } else {
            self.homeController?.startProgress()
            self.apiService.allPollsInCategory(url: url,category: category) { (polls, status, message, nextUrl) in
                self.manageData(polls: polls, status: status, message: message, nextUrl: nextUrl)
            }
        }
       
    }
    
    func manageData(polls:[Poll]?, status:ApiCallStatus, message:String?, nextUrl:String?) {
         self.homeController?.stopProgress()
        if let pollsIn = polls {
            for poll in pollsIn {
                self.feed.removeAll()
                self.feed.append("HEADER")
                self.feedCollectionView.reloadData()
                self.feed.append(poll)
            }
            self.feedCollectionView.reloadData()
        }
        if let next = nextUrl {
            self.nextPageUrl = next
        }
        if let vc = self.homeController {
            if status == ApiCallStatus.FAILED {
                ViewControllerHelper.showAlert(vc: vc, message: message!, type: MessageType.failed)
            }
        }
    }
    
}

extension TrendingCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        if feed is String {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! TrendingCellTopBarCell
            cell.trendingCell = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! TrendingItemCell
        cell.feed = feed as? Poll
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feed = self.feed[indexPath.row]
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        if feed is String {
            return CGSize(width: itemWidth - contentInset, height: 50)
        }
        let trend = feed as! Poll
        let width = itemWidth - contentInset - CGFloat(90)
        let calculatedHeight = Mics.getHeightOfLabel(text: trend.question.attributeText(fontSize: 16), fontSize: 16, width: width, numberOfLines: 0)
        let heigth = CGFloat(calculatedHeight + 16)
        return CGSize(width: itemWidth - contentInset, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}
