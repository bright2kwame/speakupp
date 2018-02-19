//
//  PollDetailController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PollDetailController: UIViewController {
    
    let commentCellId = "commentCellId"
    var nextPageUrl = ""
    var loadedPages = [String]()
    var feed = [PollComment]()
    let apiService = ApiService()
    var pollId: String?
    var position = 0
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let commentAreaTextField: UITextField = {
        let commentAreaTextField =  UITextField()
        commentAreaTextField.placeholder = "Say something ..."
        commentAreaTextField.font = UIFont.systemFont(ofSize: 16)
        commentAreaTextField.borderStyle = UITextBorderStyle.roundedRect
        commentAreaTextField.autocorrectionType = UITextAutocorrectionType.no
        commentAreaTextField.keyboardType = UIKeyboardType.default
        commentAreaTextField.returnKeyType = UIReturnKeyType.done
        commentAreaTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        commentAreaTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        commentAreaTextField.translatesAutoresizingMaskIntoConstraints = false
        return commentAreaTextField
    }()
    
    let sendButton: UIButton = {
        let button = ViewControllerHelper.plainButton()
        let color = UIColor.hex(hex: Key.primaryHexCode)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Send", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(color, for: .normal)
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.setUpNavigationBar()
        self.setUpViews()
        
        if let id = self.pollId {
            let url =  "\(ApiUrl().activeBaseUrl())polls/\(id)/comments/"
            self.getData(url: url)
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Poll Comments"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    //MARK - add comment section
    @objc private func sendComment() {
        let comment = self.commentAreaTextField.text!
        if comment.isEmpty {
            ViewControllerHelper.showAlert(vc: self, message: "Add comment first", type: MessageType.warning)
            return
        }
        if let pollId = self.pollId {
            self.commentAreaTextField.text = ""
            self.commentAreaTextField.resignFirstResponder()
            self.apiService.commentOnPoll(pollId: pollId, comment: comment) { (status, comment, message) in
                if status == ApiCallStatus.SUCCESS {
                    if self.feed.isEmpty {
                        self.feed.append(comment!)
                    }  else {
                        self.feed.insert(comment!, at: 0)
                    }
                    self.feedCollectionView.reloadData()
                    let selectedIndexPath = IndexPath(item: 0, section: 0)
                    self.feedCollectionView.scrollToItem(at: selectedIndexPath, at: UICollectionViewScrollPosition(rawValue: UInt(0)), animated: true)
                    NotificationCenter.default.post(name: Notification.Name(Key.COMMENT_ADDED), object: self.position)
                }
            }
        }
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
    
    func startProgress() {
        self.indicator.startAnimating()
    }
    
    func stopProgress() {
        self.indicator.stopAnimating()
    }
    //MARK - end of indicator
    
    func getData(url: String)  {
        self.loadedPages.append(url)
        self.startProgress()
        self.apiService.getPollComments(url: url, completion: { (status, comments, message, nextUrl) in
                self.stopProgress()
                if status == ApiCallStatus.SUCCESS {
                    if let commentsIn = comments {
                       self.feed.append(contentsOf: commentsIn)
                       self.feedCollectionView.reloadData()
                    }
                    if let nextUrlIn = nextUrl {
                        self.nextPageUrl = nextUrlIn
                    }
                }
            })
    }
    
    func setUpViews()  {
        self.view.addSubview(feedCollectionView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(commentAreaTextField)
        self.view.addSubview(sendButton)
        
        self.profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        self.profileImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        
        self.sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        self.sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        
        self.commentAreaTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        self.commentAreaTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.commentAreaTextField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        self.commentAreaTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        
        self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: commentAreaTextField.topAnchor, constant: -8).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(PollCommentCell.self, forCellWithReuseIdentifier: commentCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        //MARK - update UI
        self.updateUI()
    }
    
    func updateUI()  {
        let user = User.getUser()!
        if  !(user.profile.isEmpty) {
            self.profileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
}

extension PollDetailController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! PollCommentCell
        cell.feed = feed
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

