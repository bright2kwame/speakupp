//
//  InterestController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 12/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class InterestController: UIViewController {
    var nextPageUrl = ""
    var loadedPages = [String]()
    let feedCellId = "feedCellId"
    var feed = [PollCategory]()
    let apiService = ApiService()
    var interestIds = [String]()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var isOnboard = true
    
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
        feedCollectionView.register(InterestCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        
        //start call here
        self.getData(url: "\(ApiUrl().activeBaseUrl())fetch_interest/")
    }
    
    func getData(url:String)  {
        if feed.isEmpty {
            self.startProgress()
        }
        self.loadedPages.append(url)
        self.apiService.allInterest(url: url) { (inrerests, status, message, nextUrl) in
            self.stopProgress()
            if let feeds = inrerests {
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
        navigationItem.title = "Interest"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
       
        //MARK - indicate back for non onbaording experience
        if !isOnboard {
            let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
            let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
            navigationItem.leftBarButtonItem = menuBack
        }
        
        let menuSave = UIBarButtonItem(title: "Save Interests", style: .done, target: self, action: #selector(saveInterest))
        navigationItem.rightBarButtonItem = menuSave
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveInterest()  {
        if !self.interestIds.isEmpty {
            let list =  "\(self.interestIds)".replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "")
            self.apiService.updateUserInterest(ids: list, completion: { (status) in
                
            })
        }
        
        //MARK- cases of onboarding
        if  isOnboard {
            let brands = BrandsController()
            brands.isOnboard = self.isOnboard
            self.present(UINavigationController(rootViewController: brands), animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func addInterest(brandId:String)  {
        for (index, item) in self.feed.enumerated() {
            if item.id == brandId {
                if !item.isInterested {
                    self.interestIds.append(brandId)
                }
                item.isInterested = !item.isInterested
                let selectedIndexPath = IndexPath(item: index, section: 0)
                self.feedCollectionView.reloadItems(at: [selectedIndexPath])
                
            }
        }
    }
    
    
}

extension InterestController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! InterestCell
        cell.feed = feed
        
        cell.actionButton.tag = indexPath.row
        cell.actionButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        return CGSize(width: itemWidth - contentInset, height: 100)
    }
    
    @objc func addAction(sender: UIButton)  {
        self.addInterest(brandId: self.feed[sender.tag].id)
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
