//
//  HomeController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 27/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ZKDrawerController
import LinearProgressBarMaterial

class HomeController: UIViewController {
    
    let homeCellId = "homeCellId"
    let trendingCellId = "trendingCellId"
    let eventCellId = "eventCellId"
    let acountCellId = "acountCellId"
    let labels = ["Home","Trending","Event","Me"]
    let user = User.getUser()!
    let apiService = ApiService()
    

    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    lazy var menuBar: HomeMenuBar = {
        let menuBar = HomeMenuBar()
        menuBar.homeController = self
        menuBar.backgroundColor = UIColor.white
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        return menuBar
    }()
    
    var homeDrawerController: ZKDrawerController!
    var homeController: HomeController?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpMenu()
        
        self.setUpLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = LeftDrawerController()
        vc.homeDrawerController = self.homeDrawerController
        vc.homeController = self
        homeDrawerController.leftViewController = vc
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeDrawerController.leftViewController = nil
    }
    
    func setUpLayouts()  {
        
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        
        menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: self.homeCellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: self.trendingCellId)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: self.eventCellId)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: self.acountCellId)
        
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: menuBar.topAnchor,constant: -2).isActive = true
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }

        self.setUpUniversalIndication()
        
     
        self.updateUtil()
    }
    
    
    func updateUtil() {
        let url =  "\(ApiUrl().baseUrl)word_cloud_value/"
        self.apiService.workCloud(url: url) { (words, status, message) in
           print("CLOUDS \(status)")
        }
        self.apiService.saveCredentials { (status) in
            print("CREDENTAILS \(status)")
        }
        self.apiService.getUser(completion: { (status) in
           print("USER \(status)")
        })
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

    func setUpMenu()  {
        navigationItem.title = ""
        let titleImageView = UIImageView(image: UIImage(named: "LogoImage"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.layer.masksToBounds = true
        navigationItem.titleView = titleImageView
        
        let menuIcon = UIImage(named:"MenuIcon")?.withRenderingMode(.alwaysOriginal)
        let drawerMenu = UIBarButtonItem(image: menuIcon, style: .plain, target: self, action: #selector(handleDrawer))
        
        let searchIcon = UIImage(named:"Search")?.withRenderingMode(.alwaysOriginal)
        let searchMenu = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(startSearch))
        
        navigationItem.leftBarButtonItem = drawerMenu
        navigationItem.rightBarButtonItem = searchMenu
    }
    
    @objc private func handleDrawer() {
        homeDrawerController.show(.left, animated: true)
    }

    @objc private func startSearch() {
        let nav = UINavigationController(rootViewController: SearchController())
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! HomeCell
            cell.homeController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendingCellId, for: indexPath) as! TrendingCell
            cell.homeController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as! EventCell
            cell.homeController = self
            return cell
        }  else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: acountCellId, for: indexPath) as! ProfileCell
            cell.homeController = self
            cell.profile = self.user
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        return CGSize(width: collectionView.frame.width - contentInset, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func scrollToMenuIndex(menuIndex: Int)  {
        let selectedIndexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func scrollBothToMenuIndex(menuIndex: Int)  {
        let selectedIndexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        menuBar.menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let currentPage = Int(x/view.frame.width)
        
        let selectedIndexPath = IndexPath(item: currentPage, section: 0)
        menuBar.menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
}
