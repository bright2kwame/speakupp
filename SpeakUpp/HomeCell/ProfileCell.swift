//
//  ProfileCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileCell: BaseCell {
    var feed = [UserWorkCloud]()
    let feedCellId = "wordCloudCellId"
    var homeController: HomeController?
    
    var profile: User? {
        didSet {
            guard let _ = profile else {return}
            self.updateUI(user: User.getUser()!)
            self.feed.append(contentsOf: UserWorkCloud.getAll())
            self.wordCloudCollectionView.reloadData()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let followersTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    let pollsTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    let followingTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    let nameTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 24)
        return textView
    }()
    
    lazy var editButton: UIButton = {
        let button = self.baseButton(title: "Edit Profile")
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var brandsButton: UIButton = {
        let button = self.baseButton(title: "Brands")
        button.addTarget(self, action: #selector(startBrands), for: .touchUpInside)
        return button
    }()
    
    lazy var interestButton: UIButton = {
        let button = self.baseButton(title: "Interests")
        button.addTarget(self, action: #selector(startInterests), for: .touchUpInside)
        return button
    }()
    
    func baseButton(title:String) -> UIButton {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = color.cgColor
        button.setTitleColor(color, for: .normal)
        button.titleLabel!.numberOfLines = 1
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.baselineAdjustment = .alignCenters
        button.titleLabel!.lineBreakMode = NSLineBreakMode.byClipping
        return button
    }
    
    lazy var coverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.7
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    
    let wordEdgeView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.clear
        uiView.layer.borderWidth = 0.5
        uiView.layer.borderColor = UIColor.white.cgColor
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var wordCloudCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        
        addSubview(imageView)
        addSubview(avatarImageView)
        addSubview(coverView)
        addSubview(profileImageView)
        addSubview(nameTextLabel)
        addSubview(wordEdgeView)
        addSubview(wordCloudCollectionView)
     
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        let height = frame.height/3
        self.avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.avatarImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.coverView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.coverView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: height-50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.nameTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.nameTextLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        self.nameTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let container = UIStackView(arrangedSubviews: [followersTextLabel,pollsTextLabel,followingTextLabel])
        container.distribution = .fillEqually
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
        
        container.bottomAnchor.constraint(equalTo: nameTextLabel.bottomAnchor,constant: 50).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //bottom section
        let buttonContainer = UIStackView(arrangedSubviews: [editButton,brandsButton,interestButton])
        buttonContainer.distribution = .fillEqually
        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 10
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonContainer)
        
        buttonContainer.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        buttonContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        buttonContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.wordEdgeView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8).isActive = true
        self.wordEdgeView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -8).isActive = true
        self.wordEdgeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.wordEdgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        self.wordCloudCollectionView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        self.wordCloudCollectionView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -16).isActive = true
        self.wordCloudCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.wordCloudCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        self.wordCloudCollectionView.register(WordCloudCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = wordCloudCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 2
        }
    
    }
    
    @objc private func editProfile() {
        let profileVc = EditProfileController()
        self.homeController?.present(UINavigationController(rootViewController: profileVc), animated: true, completion: nil)
    }
    
    @objc private func startInterests() {
        let interest = InterestController()
        interest.isOnboard = false
        self.homeController?.present(UINavigationController(rootViewController: interest), animated: true, completion: nil)
    }
    
    @objc private func startBrands() {
        let brands = BrandsController()
        brands.isOnboard = false
        self.homeController?.present(UINavigationController(rootViewController: brands), animated: true, completion: nil)
    }
    
    
    func updateUI(user: User)  {
        if  !(user.profile.isEmpty) {
            self.profileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
         if !(user.backgroundImage.isEmpty) {
            self.avatarImageView.af_setImage(
                withURL: URL(string: (user.backgroundImage))!,
                placeholderImage: Mics.placeHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
        self.nameTextLabel.text = user.fullName
        self.followersTextLabel.text = Mics.formatNumber(number: user.numberOfFollowers, text: "Follower")
        self.followingTextLabel.text = Mics.formatNumber(number: user.numberOfFollowing, text: "Following")
        self.pollsTextLabel.text = Mics.formatNumber(number: user.numberOfPolls, text: "Poll")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.feed.removeAll()
        
    }
}

extension ProfileCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! WordCloudCell
        cell.feed = feed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(2 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(3))
        return CGSize(width: size, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
}

