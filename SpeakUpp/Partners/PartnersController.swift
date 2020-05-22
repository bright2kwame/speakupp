//
//  PartnersController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/12/2019.
//  Copyright © 2019 Bright Limited. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class PartnersController: UIViewController {

    
    let feedCellId = "feedCellId"
    var feed = [Partner]()
    let apiService = ApiService()
    
    var nextPageUrl = ""
    var loadedPages = [String]()
    
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refresher
    }()
    
    let hintTextLabel: UILabel = {
         let textView = ViewControllerHelper.baseLabel()
         textView.textAlignment = .left
         textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
         textView.font = UIFont.systemFont(ofSize: 16)
         textView.text = "Redeem your points at any of these shops"
         return textView
     }()
    
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
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpViews()
    }
    
       
    func setUpViews() {
        self.setUpNavigationBar()
        self.view.addSubview(hintTextLabel)
        self.view.addSubview(feedCollectionView)
           
           self.hintTextLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
           self.hintTextLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
           self.hintTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
           self.hintTextLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
           self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
           self.feedCollectionView.topAnchor.constraint(equalTo: self.hintTextLabel.bottomAnchor, constant: 8).isActive = true
           self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
           self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
           self.feedCollectionView.register(PartnerCell.self, forCellWithReuseIdentifier: feedCellId)
           self.feedCollectionView.addSubview(refresher)
           
           if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.scrollDirection = .vertical
               flowLayout.minimumLineSpacing = 5
           }
           
          //MARK -- start partners call
          self.setUpAndCall(url: ApiUrl().partners())
    }
       
    
    @objc func loadData()  {
         self.loadedPages.removeAll()
         self.setUpAndCall(url: ApiUrl().partners())
     }
     
     //MARK - start network calls
     func setUpAndCall(url: String)  {
        self.refresher.beginRefreshing()
        self.getData(url: url)
     }
     
     func getData(url:String)  {
         self.apiService.makeGetApiCall(url: url) { (status, data) in
         self.refresher.endRefreshing()
         if let dataIn = data, status == ApiCallStatus.SUCCESS {
                let results = dataIn["results"].arrayValue
                results.forEach { (data) in
                    let  partner  = Partner()
                    partner.longitude = data["longitude"].stringValue
                    partner.latitude = data["latitude"].stringValue
                    partner.name = data["name"].stringValue
                    partner.image = data["logo"].stringValue
                    partner.offer = data["offer"].stringValue
                    partner.contact = data["contact"].stringValue
                    partner.categoryName = data["category_name"].stringValue
                    self.feed.append(partner)
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
    
    //MARK: set up a navigation
    private func setUpNavigationBar()  {
         navigationItem.title = "Partners"
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
      
}

extension PartnersController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = feed[indexPath.row]
        showPrompt(partner: item)
    }
    
    //MARK: show detail
    func showPrompt(partner: Partner) {
        let directionAction = UIAlertAction(title: "Get Direction", style: .default, handler: {(Alert:UIAlertAction!) -> Void in
            self.startMap(partner: partner)
        })
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: {(Alert:UIAlertAction!) -> Void in
           
        })
        let alertView = UIAlertController(title: "SpeakUpp", message: partner.offer, preferredStyle: .alert)
        alertView.addAction(directionAction)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    
    //MARK: open and start map
    func startMap(partner: Partner)  {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(partner.latitude),\(partner.longitude)&directionsmode=driving")! as URL)
             }  else {
                openMapForPlace(partner: partner)
            }
    }
    
    func openMapForPlace(partner: Partner) {
       let url = "http://maps.apple.com/maps?saddr=&daddr=\(partner.latitude),\(partner.longitude)"
       UIApplication.shared.openURL(URL(string:url)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! PartnerCell
        cell.feed = feed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        return CGSize(width: itemWidth - contentInset, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

class PartnerCell: BaseCell {
    
    var feed: Partner? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = unwrapedItem.name
            self.typeLabel.text = unwrapedItem.categoryName
            self.offerLabel.text = unwrapedItem.offer
            
            if  !(unwrapedItem.image.isEmpty) {
                           self.profileImageView.af_setImage(
                               withURL: URL(string: (unwrapedItem.image))!,
                               placeholderImage: Mics.placeHolder(),
                               imageTransition: .crossDissolve(0.2)
                       )}
                       
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        return textView
    }()
    
    let typeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    let offerLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
  
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(typeLabel)
        addSubview(offerLabel)
       
        let margin = CGFloat(8)
        let width = CGFloat(100)
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.profileImageView.layer.cornerRadius = width/2
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
      
        self.typeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        
        self.offerLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.offerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.offerLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4).isActive = true
        self.offerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        self.profileImageView.image = nil
    }
}


