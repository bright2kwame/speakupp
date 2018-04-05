//
//  HomeCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import Cosmos
import SafariServices

class HomeCell: BaseCell {
    var homeController: HomeController?
    let feedCellId = "feedCellId"
    let menuCellId = "menuCellId"
    let baseRatingCellId = "baseRatingCell"
    let coporateCellId = "coporateCellId"
    let schoolCellId = "schoolCellId"
    var nextPageUrl = ""
    var loadedPages = [String]()
    var feed = [Any]()
    let apiService = ApiService()
    var selctedPoll = HomeTabsType.CORPORATE.rawValue
    
    var typeOfPoll: String? {
        didSet {
           guard let unwrapedItem = typeOfPoll else {return}
           self.selctedPoll = unwrapedItem
           self.callRefresh()
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refresher
    }()
    
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
        feedCollectionView.register(HomeCellTopBarCell.self, forCellWithReuseIdentifier: menuCellId)
        feedCollectionView.register(BaseFeedCell.self, forCellWithReuseIdentifier: feedCellId)
        feedCollectionView.register(BaseRatingCell.self, forCellWithReuseIdentifier: baseRatingCellId)
        feedCollectionView.register(CorporateCell.self, forCellWithReuseIdentifier: coporateCellId)
        feedCollectionView.register(SchoolCell.self, forCellWithReuseIdentifier: schoolCellId)
        feedCollectionView.addSubview(refresher)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        self.callRefresh()
        
        //MARK - notfication center
         NotificationCenter.default.addObserver(self, selector: #selector(self.receivedLikedNotification(notification:)), name: Notification.Name(Key.POLL_LIKE), object: nil)
        
        
    }
    
    
    
    //MARK - receiving notification
    @objc func receivedLikedNotification(notification: Notification){
        let poll = notification.object as! Poll
        print("POSITION \(poll)")
    }
    
    
    //MARK - call for refresh from other places
    func callRefresh()  {
        self.loadedPages.removeAll()
        if selctedPoll == HomeTabsType.CORPORATE.rawValue {
            self.setUpAndCall(url: ApiUrl().corporate())
        }
        if selctedPoll == HomeTabsType.SCHOOLS.rawValue {
            self.setUpAndCall(url: ApiUrl().shools())
        }
        if selctedPoll == HomeTabsType.TIMELINE.rawValue {
            self.setUpAndCall(url: ApiUrl().timeline())
        }
    }
    
    //MARK - continue paymemt
    func continuePayment(url:String)  {
        let vc = PaymentRedirectController()
        vc.homeCell = self
        vc.url = url
        self.homeController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func loadData()  {
       self.callRefresh()
    }
    
    func setUpAndCall(url: String)  {
        feed.removeAll()
        feed.append("Header")
        feedCollectionView.reloadData()
        self.homeController?.startProgress()
        self.callByType(url: url)
    }
    
    func callByType(url:String)  {
        if selctedPoll == HomeTabsType.CORPORATE.rawValue {
           self.getCorporateData(url: url)
        }
        
        if selctedPoll == HomeTabsType.SCHOOLS.rawValue {
            self.getSchoolData(url: url)
        }
        
        if selctedPoll == HomeTabsType.TIMELINE.rawValue {
            self.getData(url: url)
        }
    }
    
    func startComment(position: Int)  {
        let poll = self.feed[position] as! Poll
        let vc = PollDetailController()
        vc.pollId = poll.id
        let destination = UINavigationController(rootViewController: vc)
        self.homeController?.present(destination, animated: true, completion: nil)
    }
    
    //MARK:- corporate call
    func getCorporateData(url:String)  {
        self.loadedPages.append(url)
        self.apiService.allCorporateGroups(url: url) { (polls, status, message, nextUrl) in
            self.handleResult(polls: polls, status: status, message: message, nextUrl: nextUrl)
        }
    }
    
    //MARK:- school call
    func getSchoolData(url:String)  {
        self.loadedPages.append(url)
        self.apiService.allSchools(url: url) { (polls, status, message, nextUrl) in
            self.handleResult(polls: polls, status: status, message: message, nextUrl: nextUrl)
        }
    }

    //MARK:- get timeline data
    func getData(url:String)  {
        self.loadedPages.append(url)
        self.apiService.allPolls(url: url) { (polls, status, message, nextUrl) in
           self.handleResult(polls: polls, status: status, message: message, nextUrl: nextUrl)
        }
    }
    
    func handleResult(polls:[Any]?, status:ApiCallStatus, message:String?, nextUrl:String?)  {
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
    
    //MARK - rate a poll
    func ratePoll(pollId:String,ratingValue:String)  {
        for (index, item) in self.feed.enumerated() {
            if item is Poll {
                let pollIntended = item as! Poll
                if (pollIntended.id == pollId) {
                    pollIntended.hasVoted = true
                    pollIntended.totalRatingVotes += 1
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                    self.apiService.ratePoll(pollId: pollId, ratingValue: ratingValue, completion: { (status,message) in
                        if let vc = self.homeController {
                            if status == ApiCallStatus.FAILED {
                                ViewControllerHelper.showAlert(vc: vc, message: message, type: MessageType.failed)
                            }
                        }
                    })
                }
            }
        }
    }
    
    //MARK: -- cast vote here
    func castVote(pollId:String,choiceId:String)  {
        for (index, item) in self.feed.enumerated() {
            if item is Poll {
                let pollIntended = item as! Poll
                if (pollIntended.id == pollId) {
                    //if the poll is a paid type
                    if (pollIntended.pollType == "paid_poll"){
                        let payVottingController = PayVottingController()
                        payVottingController.poll = pollIntended
                        payVottingController.choiceId = choiceId
                        payVottingController.homeCell = self
                        self.homeController?.navigationController?.pushViewController(payVottingController, animated: true)
                        return
                    }
                    pollIntended.hasVoted = true
                    pollIntended.votedOption = choiceId
                    pollIntended.totalVotes += 1
                    for itemsChoice in pollIntended.pollChoice.enumerated() {
                        let element = itemsChoice.element
                        if (element.id == choiceId){
                           element.numOfVotes += 1
                           element.isSelectedOption = true
                        }
                    }
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                    self.apiService.voteForPoll(pollId: pollId, choiceId: choiceId, completion: { (status,message) in
                        if let vc = self.homeController {
                            if status == ApiCallStatus.FAILED {
                                ViewControllerHelper.showAlert(vc: vc, message: message, type: MessageType.failed)
                            }
                        }
                    })
                  
                    break
                }
            }
        }
    }
    
    //MARK- rejeect and reset
    func rejectVote(pollId:String)  {
        for (index, item) in self.feed.enumerated() {
            if item is Poll {
                let pollIntended = item as! Poll
                if (pollIntended.id == pollId) {
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                }
            }
        }
    }
    
    //MARK- like poll section
    func likePoll(position:Int)  {
          let pollIntended = self.feed[position]
            if pollIntended is Poll {
                let poll = pollIntended as! Poll
                if (poll.hasLiked){
                    poll.hasLiked = false
                    poll.numOfLikes -= 1
                    self.apiService.unLikePoll(pollId: poll.id, completion: { (status) in
                         print("STATUS \(status)")
                    })
                }  else {
                   poll.hasLiked = true
                    poll.numOfLikes += 1
                    self.apiService.likePoll(pollId: poll.id, completion: { (status) in
                         print("STATUS \(status)")
                    })
                }
                let selectedIndexPath = IndexPath(item: position, section: 0)
                self.feedCollectionView.reloadItems(at: [selectedIndexPath])
            }
    }
    
}

extension HomeCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        if feed is String {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! HomeCellTopBarCell
            cell.homeCell = self
            return cell
        }
        
        if feed is CorporateItem {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: coporateCellId, for: indexPath) as! CorporateCell
            cell.homeCell = self
            cell.feed = feed as? CorporateItem
            return cell
        }
        
        if feed is SchoolItem {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: schoolCellId, for: indexPath) as! SchoolCell
            cell.homeCell = self
            cell.item = feed as? SchoolItem
            return cell
        }
        
        let feedItem = feed as? Poll
        if feedItem?.pollType == "rating"  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseRatingCellId, for: indexPath) as! BaseRatingCell
            cell.feed = feed as? Poll
            
            //trigger rating
            let tappedRatingView = UITapGestureRecognizer(target: self, action: #selector(self.ratePoll(_:)))
            cell.ratingView.isUserInteractionEnabled = true
            cell.ratingView.tag = indexPath.row
            cell.ratingView.addGestureRecognizer(tappedRatingView)
            
            
            //trigger imageView
            let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.previewImage(_:)))
            cell.questionImageView.isUserInteractionEnabled = true
            cell.questionImageView.tag = indexPath.row
            cell.questionImageView.addGestureRecognizer(tappedImageView)
            
            cell.shareButton.tag = indexPath.row
            cell.shareButton.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
            
            cell.commentButton.tag = indexPath.row
            cell.commentButton.addTarget(self, action: #selector(self.startComment(_:)), for: .touchUpInside)
            
            
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(self.like(_:)), for: .touchUpInside)
            
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! BaseFeedCell
        cell.feed = feed as? Poll
        cell.homeCell = self
        
        //trigger imageView
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.previewImage(_:)))
        cell.questionImageView.isUserInteractionEnabled = true
        cell.questionImageView.tag = indexPath.row
        cell.questionImageView.addGestureRecognizer(tappedImageView)
        
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(self.startComment(_:)), for: .touchUpInside)
        
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(self.like(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feed = self.feed[indexPath.row]
        return CellHelper.configureCellHeight(collectionView: collectionView, collectionViewLayout: collectionViewLayout, feed: feed)
        
    }
    
    @objc func share(_ sender: UIButton) {
        let poll = self.feed[sender.tag] as! Poll
        ViewControllerHelper.presentSharer(targetVC: self.homeController!, message: poll.question)
    }
    
    //MARK- send liking action
    @objc func like(_ sender: UIButton) {
        self.likePoll(position: sender.tag)
    }
    
    //MARK- start commenting
    @objc func startComment(_ sender: UIButton) {
        self.startComment(position: sender.tag)
    }
    
    @objc func ratePoll(_ sender: UITapGestureRecognizer) {
        let ratingView = sender.view as! CosmosView
        let poll = self.feed[ratingView.tag] as! Poll
        ratingView.didFinishTouchingCosmos = { rating in
            let rate = Int(rating)
            self.ratePoll(pollId: poll.id, ratingValue: "\(rate)")
        }
    }
    
    @objc func previewImage(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIImageView
        let poll = self.feed[view.tag] as! Poll
        ViewControllerHelper.presentSingleImage(targetVC: self.homeController!, url: poll.image)
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
        let item = self.feed[indexPath.row]
        if item is CorporateItem {
            let corporate = item as? CorporateItem
            let vc = PollsController()
            vc.corporateId = corporate?.id
            self.homeController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
        
        if item is SchoolItem {
            let school = item as? SchoolItem
            let vc = PollsController()
            vc.schoolId = school?.id
            self.homeController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 400 {
            if !(self.nextPageUrl.isEmpty) && !self.loadedPages.contains(self.nextPageUrl) {
                self.callByType(url: self.nextPageUrl)
            }
        }
    }
    
}




