//
//  PollsController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 17/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.

import UIKit
import Cosmos

class PollsController: UIViewController {
    
    let feedCellId = "feedCellId"
    let baseRatingCellId = "baseRatingCell"
    var nextPageUrl = ""
    var feed = [Poll]()
    let apiService = ApiService()
    var categoryId: String?
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //MARK - register collection view here
    lazy var feedCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
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
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpNavigationBar()
        self.setUpViews()
        
        if let id = self.categoryId {
            self.getData(id: id)
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Poll"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    @objc func handleCancel()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK - indicator section
    func setUpUniversalIndication()   {
        self.indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.indicator.center = view.center
        self.view.addSubview(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //MARK - call for refresh from other places
    func callRefresh()  {
        self.feed.removeAll()
        self.feedCollectionView.reloadData()
        
        if let id = self.categoryId {
            self.getData(id: id)
        }
    }
    
    func startProgress() {
        self.indicator.startAnimating()
    }
    
    func stopProgress() {
        self.indicator.stopAnimating()
    }
    //MARK - end of indicator
    
    func setUpViews()  {
        self.view.addSubview(feedCollectionView)
        
        self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(BaseFeedCell.self, forCellWithReuseIdentifier: feedCellId)
        self.feedCollectionView.register(BaseRatingCell.self, forCellWithReuseIdentifier: baseRatingCellId)
        self.feedCollectionView.addSubview(refresher)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }

    }
    
    func getData(id: String)  {
        self.startProgress()
        self.apiService.getPoll(pollId: self.categoryId!,completion: { (status,poll,message) in
            self.stopProgress()
            self.refresher.endRefreshing()
            if status == ApiCallStatus.SUCCESS {
                if let pollIn = poll {
                    self.feed.append(pollIn)
                    self.feedCollectionView.reloadData()
                }
            }
        })
    }
    
    //MARK - continue paymemt
    func continuePayment(url:String)  {
        let vc = PaymentRedirectController()
        vc.pollsController = self
        vc.url = url
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func loadData()  {
        callRefresh()
    }
    
    func startComment(position: Int)  {
        let poll = self.feed[position]
        let vc = PollDetailController()
        vc.pollId = poll.id
        let destination = UINavigationController(rootViewController: vc)
        self.present(destination, animated: true, completion: nil)
    }
    
    
    //MARK - rate a poll
    func ratePoll(pollId:String,ratingValue:String)  {
        for (index, pollIntended) in self.feed.enumerated() {
                if (pollIntended.id == pollId) {
                    pollIntended.hasVoted = true
                    pollIntended.totalRatingVotes += 1
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
    
    //MARK: -- cast vote here
    func castVote(pollId:String,choiceId:String)  {
        for (index, pollIntended) in self.feed.enumerated() {
                if (pollIntended.id == pollId) {
                    //if the poll is a paid type
                    if (pollIntended.pollType == "paid_poll"){
                        let payVottingController = PayVottingController()
                        payVottingController.poll = pollIntended
                        payVottingController.choiceId = choiceId
                        payVottingController.pollsController = self
                        self.navigationController?.pushViewController(payVottingController, animated: true)
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
                            if status == ApiCallStatus.FAILED {
                                ViewControllerHelper.showAlert(vc: self, message: message, type: MessageType.failed)
                            }
                    })
                    break
                }
        }
        
    }
    
    //MARK- rejeect and reset
    func rejectVote(pollId:String)  {
        for (index, pollIntended) in self.feed.enumerated() {
                if (pollIntended.id == pollId) {
                    let selectedIndexPath = IndexPath(item: index, section: 0)
                    self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                }
        }
    }
    
    //MARK- like poll section
    func likePoll(position:Int)  {
        let poll = self.feed[position]
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

extension PollsController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    //MARK - calls on the feec cell
    @objc func share(_ sender: UIButton) {
        let poll = self.feed[sender.tag]
        ViewControllerHelper.presentSharer(targetVC: self, message: poll.question)
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
        let poll = self.feed[ratingView.tag]
        ratingView.didFinishTouchingCosmos = { rating in
            let rate = Int(rating)
            self.ratePoll(pollId: poll.id, ratingValue: "\(rate)")
        }
    }
    
    @objc func previewImage(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIImageView
        let poll = self.feed[view.tag]
        ViewControllerHelper.presentSingleImage(targetVC: self, url: poll.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedItem = self.feed[indexPath.row]
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
            
            cell.commentButton.tag = indexPath.row
            cell.commentButton.addTarget(self, action: #selector(self.startComment(_:)), for: .touchUpInside)
            
            
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(self.like(_:)), for: .touchUpInside)
            
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! BaseFeedCell
        cell.feed = feedItem
        cell.pollsController = self
        
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
        return CellHelper.configureCellHeight(collectionView: collectionView, collectionViewLayout: collectionViewLayout, feed: self.feed[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
 
}
