//
//  ViewController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {

    let pages = [
        Page(imageName:"TutorialOne",title: "Discover\nInteresting\nThings",message: "Create polls and rate anything you want."),
        Page(imageName:"TutorialTwo",title: "Be\nHeard",message: "Our mission is to give people this platform to connect and be heard."),
        Page(imageName:"TutorialThree",title: "Ready To\nExplore?",message: "Our app provides and extensive and accurate guide to events and activities.")
    ]
    
    let pagerCellId = "SwipingPageCellId"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LogoImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let signUpButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        button.setTitle("Log In", for: .normal)
         button.layer.borderWidth = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.white
        pc.pageIndicatorTintColor = UIColor.hex(hex: "#97C9E7")
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    
    override func viewDidLoad() {
        self.navigationController?.isToolbarHidden = true
        self.setUpLayout()
    }
    
    
    func setUpLayout()  {
        self.view.backgroundColor = UIColor.clear
        
        let bottomContainer = UIStackView(arrangedSubviews: [signUpButton,loginButton])
        bottomContainer.distribution = .fillEqually
        bottomContainer.axis = .horizontal
        bottomContainer.spacing = 20
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(feedCollectionView)
        self.view.addSubview(bottomContainer)
        self.view.addSubview(pageControl)
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        

        bottomContainer.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 100)
       
        feedCollectionView.register(SwipingPageCell.self, forCellWithReuseIdentifier: pagerCellId)
        feedCollectionView.isPagingEnabled = true
        feedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        feedCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -8).isActive = true
       
    
    }
    
    
    @objc private func loginAction() {
        let vc = LoginController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func registerAction() {
        let vc = SignUpController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.feedCollectionView.invalidateIntrinsicContentSize()
            if (self.pageControl.currentPage == 0){
                self.feedCollectionView.contentOffset = .zero
            }else{
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.feedCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }, completion: {(bear_) in
            
        })
    }

    
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x/view.frame.width)
    }
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: pagerCellId, for: indexPath) as! SwipingPageCell
        let page = pages[indexPath.row]
        cell.page = page
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

