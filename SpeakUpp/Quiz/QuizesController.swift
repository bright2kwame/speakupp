//
//  EventCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class QuizesController: UIViewController {
    let feedCellId = "quizesCell"
    var feed = [QuizItem]()
    let apiService = ApiService()
    var nextPageUrl = ""
    var loadedPages = [String]()
    var isLeaderBoard = false
    
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
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpNavigationBar()
        self.view.addSubview(feedCollectionView)
               
        self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(QuizesItemCell.self, forCellWithReuseIdentifier: feedCellId)
        self.feedCollectionView.addSubview(refresher)
               
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .vertical
                flowLayout.minimumLineSpacing = 5
        }
        //MARK -- start event call
        self.setUpAndCall(url: ApiUrl().quizes())
     }
    

     private func setUpNavigationBar()  {
        navigationItem.title = "Choose Quiz"
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
       
    @objc func loadData()  {
        self.loadedPages.removeAll()
        self.setUpAndCall(url: ApiUrl().allEvents())
    }
    
    //MARK - start network calls
    func setUpAndCall(url: String)  {
        self.refresher.beginRefreshing()
        self.getData(url: url)
    }
    
    //MARK: get data from sever
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

extension QuizesController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
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
        if self.isLeaderBoard {
            let vc = LeaderController()
            vc.quizId = self.feed[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = QuizController()
        vc.quiz = self.feed[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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


