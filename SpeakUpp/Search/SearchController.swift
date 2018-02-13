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
    let baseRatingCellId = "baseRatingCell"
    var nextPageUrl = ""
    var loadedPages = [String]()
    var feed = [Poll]()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = self.view.frame
        searchBar.layer.masksToBounds = false
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.placeholder = "Search for poll"
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setUpViews()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpNavigationBar()
        self.view.addSubview(searchBar)
        self.view.addSubview(feedCollectionView)
        
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        feedCollectionView.register(BaseFeedCell.self, forCellWithReuseIdentifier: feedCellId)
        feedCollectionView.register(BaseRatingCell.self, forCellWithReuseIdentifier: baseRatingCellId)
        
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        self.setUpUniversalIndication()
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
    
    func getData(url:String,text:String)  {
        self.startProgress()
        self.apiService.searchPoll(url: url, serchText: text) { (polls, status, messsage, nextUrl) in
            self.stopProgress()
            if let pollsIn = polls {
                for poll in pollsIn {
                    self.feed.append(poll)
                }
                self.feedCollectionView.reloadData()
            }
        }
    }
}

extension SearchController: UISearchBarDelegate{
    
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
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
        let feedItem = feed
        if feedItem.pollType == "rating"  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseRatingCellId, for: indexPath) as! BaseRatingCell
            cell.feed = feed
            
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! BaseFeedCell
        cell.feed = feed
       
        //trigger imageView
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.previewImage(_:)))
        cell.questionImageView.isUserInteractionEnabled = true
        cell.questionImageView.tag = indexPath.row
        cell.questionImageView.addGestureRecognizer(tappedImageView)
        
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feed = self.feed[indexPath.row]
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        let bottomSectionHeight = 62.0
        let profileHeight = 82.0
        let choiceHeight = 166.0
        let feedItem = feed
        if feedItem.pollType == "rating"  {
            var starAndLabelHeight = 100.0
            let questionHeight = 116.0
            let imageHeight = 266.0
            //for unrated poll adjust the height
            if !((feedItem.hasVoted)){
                starAndLabelHeight = 30.0
            }
            let totalHeight = CGFloat(profileHeight + imageHeight + bottomSectionHeight + questionHeight + starAndLabelHeight)
            return CGSize(width: itemWidth - contentInset, height: totalHeight)
        }
        
        //image question
        if !(feedItem.image.isEmpty)  {
            let imageHeight = 266.0
            let totalHeight = CGFloat(profileHeight + imageHeight + choiceHeight + bottomSectionHeight)
            return CGSize(width: itemWidth - contentInset, height: totalHeight)
        }
        //no image question
        let questionHeight = 116.0
        let totalHeight = CGFloat(profileHeight + questionHeight + choiceHeight + bottomSectionHeight)
        return CGSize(width: itemWidth - contentInset, height: totalHeight)
        
    }
    
    @objc func share(_ sender: UIButton) {
        let poll = self.feed[sender.tag]
        ViewControllerHelper.presentSharer(targetVC: self, message: poll.question)
    }
    
    
    @objc func ratePoll(_ sender: UITapGestureRecognizer) {
        let ratingView = sender.view as! CosmosView
        let poll = self.feed[ratingView.tag]
        ratingView.didFinishTouchingCosmos = { rating in
            let rate = Int(rating)
            self.ratePoll(pollId: poll.id, ratingValue: "\(rate)")
        }
    }
    
    //MARK - rate a poll
    func ratePoll(pollId:String,ratingValue:String)  {
        for (index, pollIntended) in self.feed.enumerated() {
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
    
    @objc func previewImage(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIImageView
        let poll = self.feed[view.tag]
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
