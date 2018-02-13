//
//  BrandsController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class BrandsController: UIViewController {
    
    var nextPageUrl = ""
    var loadedPages = [String]()
    let feedCellId = "feedCellId"
    var feed = [Brand]()
    let apiService = ApiService()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    //MARK - register collection view here
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
       self.view.backgroundColor = UIColor.groupTableViewBackground
       self.setUpNavigationBar()
        
        
        self.view.addSubview(feedCollectionView)
        
        feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        feedCollectionView.register(BrandCell.self, forCellWithReuseIdentifier: feedCellId)
    
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        //start call here
        self.getData(url: "\(ApiUrl().activeBaseUrl())users/get_brands/")
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

    
    func getData(url:String)  {
        if feed.isEmpty {
            self.startProgress()
        }
        self.loadedPages.append(url)
        self.apiService.brands(url: url) { (brands, status, message, nextUrl) in
            self.stopProgress()
            if let feeds = brands {
                self.feed.append(contentsOf: feeds)
                self.feedCollectionView.reloadData()
            }
            if let next = nextUrl {
                self.nextPageUrl = next
            }
            if status == ApiCallStatus.FAILED {
                ViewControllerHelper.showAlert(vc: self, message: message!, type: MessageType.failed)
            }
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Brands"
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
    
    @objc func followAction(sender: UIButton)  {
        self.followBrand(brandId: self.feed[sender.tag].id)
    }
    
    func followBrand(brandId:String)  {
        for (index, item) in self.feed.enumerated() {
            if item.id == brandId {
                if (item.isFriend){
                   item.isFriend = false
                    self.apiService.unFollowUser(otherUserId: brandId,completion: { (status) in
                        if status == ApiCallStatus.FAILED {
                            let message = "Failed to follow brand"
                            ViewControllerHelper.showPrompt(vc: self, message: message)
                        }
                    })
                } else {
                   item.isFriend = true
                    self.apiService.followUser(otherUserId: brandId,completion: { (status) in
                        if status == ApiCallStatus.FAILED {
                            let message = "Failed to follow brand"
                            ViewControllerHelper.showPrompt(vc: self, message: message)
                        }
                        
                    })
                }
                let selectedIndexPath = IndexPath(item: index, section: 0)
                self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                
            }
        }
    }
}

extension BrandsController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! BrandCell
        cell.feed = feed
        
        cell.tag = indexPath.row
        cell.followingButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        
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

