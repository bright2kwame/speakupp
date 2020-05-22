//
//  EventCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class QuizesCell: BaseCell {
    var homeController: HomeController?
    let feedCellId = "quizesCell"
    var feed = [QuizItem]()
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
        self.feedCollectionView.register(QuizesItemCell.self, forCellWithReuseIdentifier: feedCellId)
        self.feedCollectionView.addSubview(refresher)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        //MARK -- start event call
        self.setUpAndCall(url: ApiUrl().quizes())
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
         self.apiService.makeGetApiCall(url: url) { (status, data) in
                  self.refresher.endRefreshing()
                  if let dataIn = data, status == ApiCallStatus.SUCCESS {
                     let results = dataIn["results"].arrayValue
                     results.forEach { (item) in
                        print("ITEM \(item)")
                        let name = item["name"].stringValue
                        let id = item["id"].stringValue
                        let prize = item["prize"].stringValue
                        let entryFee = item["entry_fee"].doubleValue
                        let hasPaid = item["is_paid"].boolValue
                        
                        let quiz = QuizItem()
                        quiz.id = id
                        quiz.name = name
                        quiz.prize = prize
                        quiz.entryFee = entryFee
                        quiz.hasPaid = hasPaid
                        self.feed.append(quiz)
                     }
                    self.feedCollectionView.reloadData()
                  }
        }
    }
    
    
    //MARK - call for refresh from other places
    func callRefresh()  {
        self.feed.removeAll()
        self.loadedPages.removeAll()
        self.setUpAndCall(url: ApiUrl().allEvents())
    }
    
}

extension QuizesCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! QuizesItemCell
        cell.feed = self.feed[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentedViewController = QuizPopupController()
        presentedViewController.quiz = self.feed[indexPath.row]
        presentedViewController.homeController = self.homeController
        presentedViewController.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
        self.homeController?.navigationController?.present(presentedViewController, animated: true, completion: nil)
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

class QuizesItemCell: BaseCell {
    
    var feed: QuizItem? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = unwrapedItem.name
            self.pointsLabel.text = "GHS \(unwrapedItem.entryFee)"
            if  !(unwrapedItem.prize.isEmpty) {
                         self.profileImageView.af_setImage(
                             withURL: URL(string: (unwrapedItem.prize))!,
                             placeholderImage: Mics.placeHolder(),
                             imageTransition: .crossDissolve(0.2)
                         )}
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.hex(hex: Key.primaryHexCode)
        return textView
    }()
    
    let pointsLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(pointsLabel)
        

        let margin = CGFloat(8)
        let width = frame.height - 2*margin
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.layer.cornerRadius = width/2
        
        self.pointsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.pointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.pointsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.pointsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
               
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        self.profileImageView.image = nil
    }
}



