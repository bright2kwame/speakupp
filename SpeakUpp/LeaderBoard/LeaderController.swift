//
//  LeaderController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/12/2019.
//  Copyright © 2019 Bright Limited. All rights reserved.
//

import UIKit
import Foundation


class LeaderController: UIViewController {
    let feedCellId = "feedCellId"
    var quizId = ""
    var feed = [Leader]()
    let apiService = ApiService()
    
    var nextPageUrl = ""
    var loadedPages = [String]()
    
    //MARK - register collection view here
       lazy var feedCollectionView: UICollectionView = {
           let flow = UICollectionViewFlowLayout()
           flow.scrollDirection = .vertical
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
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
           super.viewDidLoad()
           self.view.backgroundColor = UIColor.groupTableViewBackground
           self.setUpViews()
       }
       
       func setUpViews() {
           self.setUpNavigationBar()
           self.view.addSubview(feedCollectionView)
           
           self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
           self.feedCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
           self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
           self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
           self.feedCollectionView.register(LeaderCell.self, forCellWithReuseIdentifier: feedCellId)
           self.feedCollectionView.addSubview(refresher)
           
           if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.scrollDirection = .vertical
               flowLayout.minimumLineSpacing = 5
           }
        
           //MARK -- start partners call
           self.setUpAndCall(url: ApiUrl().leaderBoard())
       }
    
       
       @objc func loadData()  {
           self.loadedPages.removeAll()
           self.setUpAndCall(url: ApiUrl().leaderBoard())
       }
       
       //MARK - start network calls
       func setUpAndCall(url: String)  {
          self.refresher.beginRefreshing()
          self.getData(url: url)
       }
       
       func getData(url:String)  {
        let param = ["quiz_id":quizId]
        self.apiService.makePostApiCall(url: url, params: param) { (status, data) in
           self.refresher.endRefreshing()
           if let dataIn = data, status == ApiCallStatus.SUCCESS {
                  let results = dataIn["results"].arrayValue
                  print("RESULT \(dataIn)")
                    var count = 0
                  results.forEach { (data) in
                     count += 1
                     let author = data["author"]
                     let point = data["high_score"].stringValue
                     let avatar = author["avatar"].stringValue
                     let firstName = author["first_name"].stringValue
                     let lastName = author["last_name"].stringValue
                     let username =  author["username"].stringValue
                     let leader = Leader()
                     leader.id = author["id"].stringValue
                     leader.name = username
                     leader.avatar = avatar
                     leader.point = point
                     leader.position = "\(count)"
                     self.feed.append(leader)
                  }
                 self.feedCollectionView.reloadData()
              }
           }
       }
    
    private func setUpNavigationBar()  {
         navigationItem.title = "Leader Board"
         navigationController?.navigationBar.isTranslucent = false
         
         navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
         navigationController?.navigationBar.shadowImage = UIImage()
         
         let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
         let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
         navigationItem.leftBarButtonItem = menuBack
     }
     
     @objc func handleCancel()  {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
     }
      
}

extension LeaderController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! LeaderCell
        cell.feed = feed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        return CGSize(width: itemWidth - contentInset, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

class LeaderCell: BaseCell {
    
    var feed: Leader? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = unwrapedItem.name
            self.pointsLabel.text = "\(unwrapedItem.point) pts"
            self.positionLabel.text = unwrapedItem.position
            if  !(unwrapedItem.avatar.isEmpty) {
                           self.profileImageView.af_setImage(
                               withURL: URL(string: (unwrapedItem.avatar))!,
                               placeholderImage: Mics.placeHolder(),
                               imageTransition: .crossDissolve(0.2)
                )}else {
                self.profileImageView.image = UIImage(named: "UserIcon")
            }
                       
        }
    }
    
    
    let positionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.hex(hex: Key.primaryHexCode)
        return textView
    }()
    
    let positionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.numberOfLines = 1
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let pointsLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .right
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(positionImageView)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(pointsLabel)
        addSubview(positionLabel)
        
        self.positionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.positionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.positionImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.positionImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.positionImageView.layer.cornerRadius = 20
        
        self.positionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.positionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.positionLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.positionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
       
        
        let margin = CGFloat(8)
        let width = frame.height - 2*margin
        self.profileImageView.leadingAnchor.constraint(equalTo: positionImageView.trailingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.layer.cornerRadius = width/2
        
        self.pointsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
        self.positionImageView.image = nil
        
    }
}




