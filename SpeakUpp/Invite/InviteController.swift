//
//  InviteController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import ContactsUI
import Foundation

class InviteController: UIViewController {
    
    let feedCellId = "feedCellId"
    var feed = [Contact]()
    let apiService = ApiService()
    
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
        self.view.addSubview(feedCollectionView)
        
        
        self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.feedCollectionView.register(InviteCell.self, forCellWithReuseIdentifier: feedCellId)
        
        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        
        self.phoneNumberWithContryCode()
    }
    
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Invite Friends"
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
    
    func phoneNumberWithContryCode()  {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (isGranted, error) in
            // Check the isGranted flag and proceed if true
            let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor,CNContactImageDataKey as CNKeyDescriptor])
            
            fetchRequest.sortOrder = CNContactSortOrder.userDefault
            let store = CNContactStore()
            do {
                try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                    let contactIn = Contact(contact: contact, isInvite: false)
                    self.feed.append(contactIn)
                })
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
            
        }
    }
}

extension InviteController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.feed[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! InviteCell
        cell.feed = feed
        
        cell.inviteButton.tag = indexPath.row
        cell.inviteButton.addTarget(self, action: #selector(inviteUser(sender:)), for: .touchUpInside)
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
    
    @objc  func inviteUser(sender: UIButton)  {
        let position = sender.tag
        let item = self.feed[position]
        if item.isInvite {
            ViewControllerHelper.showAlert(vc: self, message: "Invite already sent", type: MessageType.warning)
            return
        }
        let number = "\(item.contact.phoneNumbers.first?.value.stringValue ?? ""))"
        if number.isEmpty || item.isInvite {
            ViewControllerHelper.showAlert(vc: self, message: "Unable to send invite", type: MessageType.failed)
            return
        }
        item.isInvite = true
        let selectedIndexPath = IndexPath(item: position, section: 0)
        self.feedCollectionView.reloadItems(at: [selectedIndexPath])
        self.apiService.inviteViaSMS(number: number) { (status, message) in
            if status != ApiCallStatus.SUCCESS {
               ViewControllerHelper.showAlert(vc: self, message: "Invitation failed, try again", type: MessageType.failed)
            }
        }
    }
    
}

