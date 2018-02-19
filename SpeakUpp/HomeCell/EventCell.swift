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
    var feed = [Poll]()
    let apiService = ApiService()
    var nextPageUrl = ""
    var loadedPages = [String]()
    
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
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refresher
    }()
    
    override func setUpView() {
        super.setUpView()
        
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(feedCollectionView)
        
        self.feedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(EventItemCell.self, forCellWithReuseIdentifier: feedCellId)
        self.feedCollectionView.addSubview(refresher)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        //MARK -- start event call
        self.setUpAndCall(url: ApiUrl().allEvents())
    }
    
    
    @objc func loadData()  {
        self.loadedPages.removeAll()
        self.setUpAndCall(url: ApiUrl().allEvents())
    }
    
    //MARK - start network calls
    func setUpAndCall(url: String)  {
        self.homeController?.startProgress()
        self.getData(url: url)
    }
    
    func getData(url:String)  {
        self.apiService.allEvents(url: url) { (polls, status, message, nextUrl) in
            self.refresher.endRefreshing()
            self.homeController?.stopProgress()
            if let pollsIn = polls {
                for poll in pollsIn {
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
    
    //MARK - continue paymemt
    func continuePayment(url:String)  {
        let vc = PaymentRedirectController()
        vc.eventCell = self
        vc.url = url
        self.homeController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    //MARK - call for refresh from other places
    func callRefresh()  {
        self.feed.removeAll()
        self.loadedPages.removeAll()
        self.setUpAndCall(url: ApiUrl().allEvents())
    }
    
    //MARK- stay buying ticket
    @objc func startPayment(_ sender: UIButton) {
        let event = self.feed[sender.tag]
        if event.hasPurchased {
            let ticketVc = EventTicketController()
            ticketVc.eventId = event.id
            self.homeController?.navigationController?.pushViewController(ticketVc, animated: true)
            return
        }
        let destination = PayVottingController()
        destination.poll = event
        destination.isEvent = true
        destination.eventCell = self
        self.homeController?.navigationController?.pushViewController(destination, animated: true)
    }
}

extension EventCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! EventItemCell
        cell.feed = self.feed[indexPath.row]
        
        cell.actionButton.tag = indexPath.row
        cell.actionButton.addTarget(self, action: #selector(self.startPayment(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CellHelper.configureCellHeight(collectionView: collectionView, collectionViewLayout: collectionViewLayout, feed: self.feed[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = self.feed[indexPath.row]
        let destination = EventDetailController()
        destination.event = event
        self.homeController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 400 {
            if !(self.nextPageUrl.isEmpty) && !self.loadedPages.contains(self.nextPageUrl) {
                self.getData(url: self.nextPageUrl)
            }
        }
        
    }
    
}
