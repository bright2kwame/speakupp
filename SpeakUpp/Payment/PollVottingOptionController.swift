//
//  PollVottingOptionController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 25/06/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PollVottingOptionController: BaseController {
    
    let feedCellId = "feedCellId"
    var feed: Poll?
    var selectedChoice = ""
    var feedOptions = [PollOption]()
    
    
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(collectionView)
        
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        collectionView.register(PollOptionCell.self, forCellWithReuseIdentifier: feedCellId)
        
        for option in (self.feed?.vottingOptions)! {
            self.feedOptions.append(option)
        }
        
        collectionView.reloadData()
        setUpNavigationBar(title: "Proceed To Vote")
        
    }
    
    //MARK - continue paymemt
    func continuePayment(url:String)  {
        let vc = PaymentRedirectController()
        vc.pollVottingOptionController = self
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension PollVottingOptionController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feedOptions[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! PollOptionCell
        cell.feed = feed
     
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(self.reject(_:)), for: .touchUpInside)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(self.accept(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc func reject(_ sender: UIButton) {
        let position = sender.tag
        let poll = self.feedOptions[position]
        poll.selectedState = 1
        if position == self.feedOptions.count - 1 {
           self.finalizeVote()
        } else {
          let indexPath = IndexPath(row: position + 1, section: 0)
          self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK- send liking action
    @objc func accept(_ sender: UIButton) {
        let position = sender.tag
        let poll = self.feedOptions[position]
        poll.selectedState = 0
        if position == self.feedOptions.count - 1 {
          self.finalizeVote()
        } else {
          let indexPath = IndexPath(row: position + 1, section: 0)
          self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func finalizeVote()  {
       var optionPicked = [String]()
        for items in self.feedOptions {
            optionPicked.append(items.formatVote())
        }
        let payVottingController = PayVottingController()
        payVottingController.poll = self.feed
        payVottingController.choiceId = self.selectedChoice
        payVottingController.multipleOptions = "\(optionPicked)".replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        payVottingController.pollVottingOptionController = self
        self.navigationController?.pushViewController(payVottingController, animated: true)
    }

}
