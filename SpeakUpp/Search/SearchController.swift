//
//  SearchController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import Cosmos

class SearchController: UIViewController {
    let apiService = ApiService()
    let searchUrl = "\(ApiUrl().activeBaseUrl())new_search_poll/"
    let feedCellId = "feedCellId"
    let brandCellId = "brandCellId"
    let baseRatingCellId = "baseRatingCell"
    let eventCellId = "eventCellId"
    let peopleCellId = "peopleCellId"
    let pollAudioCell = "pollAudioCell"
    var nextPageUrl = ""
    var loadedPages = [String]()
    var feed = [Any]()
    var searchType = SearchType.poll
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = self.view.frame
        searchBar.layer.masksToBounds = false
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.placeholder = "Search SpeakUPP"
        searchBar.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        searchBar.showsSearchResultsButton = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
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
    
    lazy var menuBar: SearchMenuBar = {
      let menubar = SearchMenuBar()
      menubar.searchController = self
      menubar.translatesAutoresizingMaskIntoConstraints = false
      return menubar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setUpViews()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpNavigationBar()
        self.view.addSubview(searchBar)
        self.view.addSubview(menuBar)
        self.view.addSubview(feedCollectionView)
        
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.menuBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.menuBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.menuBar.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0).isActive = true
        
        self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: self.menuBar.bottomAnchor, constant: 8).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(BaseFeedCell.self, forCellWithReuseIdentifier: feedCellId)
        self.feedCollectionView.register(BaseRatingCell.self, forCellWithReuseIdentifier: baseRatingCellId)
        self.feedCollectionView.register(BrandCell.self, forCellWithReuseIdentifier: brandCellId)
        self.feedCollectionView.register(EventItemCell.self, forCellWithReuseIdentifier: eventCellId)
        self.feedCollectionView.register(PeopleCell.self, forCellWithReuseIdentifier: peopleCellId)
        
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        self.setUpUniversalIndication()
        
        //MARK - notfication center
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedPaymentDoneNotification(notification:)), name: Notification.Name(Key.PAYMENT_DONE), object: nil)
    }
    
    //MARK - receiving notification
    @objc func receivedPaymentDoneNotification(notification: Notification){
        self.setSearchType(type: SearchType.poll)
    }
    
    func setUpUniversalIndication()   {
        self.indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.indicator.center = view.center
        self.view.addSubview(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func startProgress() {
        self.indicator.startAnimating()
    }
    
    func stopProgress() {
        self.indicator.stopAnimating()
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Search SpeakUpp"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    func setSearchType(type: SearchType) {
        self.searchType = type
        let searchText = self.searchBar.text!
        if searchText.count < 3 {
            return
        }
        var url = self.searchUrl
        if self.searchType == SearchType.brands {
            url =  "\(ApiUrl().activeBaseUrl())search_brand/"
        }
        if self.searchType == SearchType.events {
            url =  "\(ApiUrl().activeBaseUrl())search_event/"
        }
        if self.searchType == SearchType.people {
            url =  "\(ApiUrl().activeBaseUrl())users/search_user/"
        }
        
        self.feed.removeAll()
        self.feedCollectionView.reloadData()
        self.startProgress()
        self.getData(url: url, text: searchText)
    }
    
    
    //MARK- stay buying ticket
    @objc func startEventPayment(_ sender: UIButton) {
        let event = self.feed[sender.tag] as! Poll
        if event.hasPurchased {
            let ticketVc = EventTicketController()
            ticketVc.eventId = event.id
            self.navigationController?.pushViewController(ticketVc, animated: true)
            return
        }
        let destination = PayVottingController()
        destination.poll = event
        destination.isEvent = true
        destination.searchController = self
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    //MARK - continue paymemt
    func continuePayment(url:String)  {
        let vc = PaymentRedirectController()
        vc.searchController = self
        vc.url = url
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func getData(url:String,text:String)  {
        self.apiService.searchPoll(url: url, serchText: text,type: self.searchType) { (result, status, messsage, nextUrl) in
            self.stopProgress()
            if let resultIn = result {
                for item in resultIn {
                    self.feed.append(item)
                }
                self.feedCollectionView.reloadData()
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
                        payVottingController.searchController = self
                        self.navigationController?.pushViewController(payVottingController, animated: true)
                        return
                    }
                    pollIntended.hasVoted = true
                    pollIntended.totalVotes += 1
                    for itemsChoice in pollIntended.pollChoice.enumerated() {
                        let element = itemsChoice.element
                        if (element.id == choiceId){
                            element.numOfVotes += 1
                        }
                    }
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                    self.apiService.voteForPoll(pollId: pollId, choiceId: choiceId, completion: { (status,message) in
                            if status == ApiCallStatus.FAILED {
                                ViewControllerHelper.showAlert(vc: self, message: message, type: MessageType.failed)
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
}

extension SearchController: UISearchBarDelegate {
    
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
           self.feed.removeAll()
           self.feedCollectionView.reloadData()
           self.startProgress()
           self.getData(url: self.searchUrl, text: searchText)
        }
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         self.view.endEditing(true)
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension SearchController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        if feed is Poll {
            let feedItem = feed as! Poll
            if feedItem.pollType == "rating"  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseRatingCellId, for: indexPath) as! BaseRatingCell
                cell.feed = feedItem
            
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
            
                return cell
            }
            
            if !feedItem.eventTitle.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as! EventItemCell
                cell.feed = feedItem
                
                cell.actionButton.tag = indexPath.row
                cell.actionButton.addTarget(self, action: #selector(self.startEventPayment(_:)), for: .touchUpInside)
                
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! BaseFeedCell
            cell.feed = feedItem
       
            //trigger imageView
            let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.previewImage(_:)))
            cell.questionImageView.isUserInteractionEnabled = true
            cell.questionImageView.tag = indexPath.row
            cell.questionImageView.addGestureRecognizer(tappedImageView)
        
            cell.shareButton.tag = indexPath.row
            cell.shareButton.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        
            return cell
            
        }  else if (feed is PollAuthor) {
            let feedItem = feed as! PollAuthor
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleCellId, for: indexPath) as! PeopleCell
            cell.feed = feedItem
            cell.tag = indexPath.row
            //cell.followingButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
            return cell
        } else {
            let feedItem = feed as! Brand
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: brandCellId, for: indexPath) as! BrandCell
            cell.feed = feedItem
            cell.tag = indexPath.row
            //cell.followingButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feed = self.feed[indexPath.row]
        return CellHelper.configureCellHeight(collectionView: collectionView, collectionViewLayout: collectionViewLayout, feed: feed)
    }
    
    @objc func share(_ sender: UIButton) {
        let poll = self.feed[sender.tag] as! Poll
        ViewControllerHelper.presentSharer(targetVC: self, message: poll.question)
    }
    
    
    @objc func ratePoll(_ sender: UITapGestureRecognizer) {
        let ratingView = sender.view as! CosmosView
        let poll = self.feed[ratingView.tag] as! Poll
        ratingView.didFinishTouchingCosmos = { rating in
            let rate = Int(rating)
            self.ratePoll(pollId: poll.id, ratingValue: "\(rate)")
        }
    }
    
    //MARK - rate a poll
    func ratePoll(pollId:String,ratingValue:String)  {
        for (index, poll) in self.feed.enumerated() {
                let pollIntended = poll as! Poll
                if (pollIntended.id == pollId) {
                    pollIntended.hasVoted = true
                    pollIntended.totalRatingVotes = pollIntended.totalRatingVotes + 1
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                    self.apiService.ratePoll(pollId: pollId, ratingValue: ratingValue, completion: { (status,message) in
                    if status == ApiCallStatus.FAILED {
                        ViewControllerHelper.showAlert(vc: self, message: message, type: MessageType.failed)
                     }
                    })
                }
        }
    }
    
    //MARK -- present image
    @objc func previewImage(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIImageView
        let poll = self.feed[view.tag] as! Poll
        ViewControllerHelper.presentSingleImage(targetVC: self, url: poll.image)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 400 {
            if !(self.nextPageUrl.isEmpty) && !self.loadedPages.contains(self.nextPageUrl) {
                self.getData(url: self.nextPageUrl, text: self.searchBar.text!)
            }
        }
        
    }
}
