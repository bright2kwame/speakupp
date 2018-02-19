//
//  FaqController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class FaqController: UIViewController {
    let feedCellId = "feedCellId"
    var feed = [FAQItem]()
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
        feedCollectionView.register(FaqCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        self.setUpUniversalIndication()
        self.startProgress()
        self.getData(url: "faqs")
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
        navigationItem.title = "FAQ"
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
    
    func getData(url: String)  {
        self.apiService.getFaqMessages(url: url) { (faqs, status, report) in
            self.stopProgress()
            if status == ApiCallStatus.SUCCESS {
                if let content = faqs {
                    self.feed.append(contentsOf: content)
                    self.feedCollectionView.reloadData()
                }
            }
        }
    }
}

extension FaqController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! FaqCell
        cell.feed = feed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width - contentInset
        let text = self.feed[indexPath.row].answer.attributeText(fontSize: 14)
        let headerHeight =  CGFloat(20)
        let height = Mics.getHeightOfLabel(text: text, fontSize: 16, width: itemWidth, numberOfLines: 0)
        return CGSize(width: itemWidth - contentInset, height: headerHeight + height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //ViewControllerHelper.showPrompt(vc: self, message: self.feed[indexPath.row])
    }
}

class  FaqCell: BaseCell {
    
    var feed: FAQItem? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.questionLabel.text = unwrapedItem.question
            self.answerLabel.text = unwrapedItem.answer
        }
    }
    
    let questionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    let answerLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        addSubview(questionLabel)
        addSubview(answerLabel)
        
        self.questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.questionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8).isActive = true
        self.answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
}


