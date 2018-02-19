//
//  SettingController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 30/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    
    let user = User.getUser()!
    let profileCell = "profileCell"
    let nonSwitchTableCell = "nonSwitchTableCell"
    let switchTableCell = "switchTableCell"
    
    let items = [SettingItem(title:"Profile",isSelectable: false,type: SettingType.profile),SettingItem(title:"Activity Log",isSelectable: false, type: SettingType.log),SettingItem(title:"Notifications",isSelectable: true,type: SettingType.notification),SettingItem(title:"Sound",isSelectable: true,type: SettingType.sound),SettingItem(title:"Privacy",isSelectable: false,type: SettingType.privacy),SettingItem(title:"Tell a Friend",isSelectable: false,type: SettingType.friend),SettingItem(title:"Contact Us",isSelectable: false,type: SettingType.contact),SettingItem(title:"FAQs",isSelectable: false,type: SettingType.faq),SettingItem(title:"About",isSelectable: false,type: SettingType.about)]
    
    //MARK - register collection view here
    lazy var settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    override func viewDidLoad() {
        self.setUpView()
    }
    
    func setUpView() {
        self.setUpNavigationBar()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(settingTableView)
        
        self.settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.settingTableView.register(ProfileTableCell.self, forCellReuseIdentifier: profileCell)
        self.settingTableView.register(NonSwitchTableCell.self, forCellReuseIdentifier: nonSwitchTableCell)
        self.settingTableView.register(SwitchTableCell.self, forCellReuseIdentifier: switchTableCell)
        
        
    }
    
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Settings"
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
    
    @objc func handleActivityLog()  {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! ProfileTableCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.user = self.user
            return cell
        }
        
        let feed = self.items[indexPath.row]
        if feed.isSelectable {
            let cell = tableView.dequeueReusableCell(withIdentifier: switchTableCell, for: indexPath) as! SwitchTableCell
            cell.item = feed
            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nonSwitchTableCell, for: indexPath) as! NonSwitchTableCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.item = feed
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(100)
        }
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row].type
        if indexPath.row == 0 {
           self.startEditPage()
        } else if (item == SettingType.privacy)  {
            startPage(type: item)
        } else if (item == SettingType.about)  {
            startPage(type: item)
        } else if (item == SettingType.faq){
            startFAQPage()
        } else if (item == SettingType.friend){
            let user = User.getUser()!
            ViewControllerHelper.presentSharer(targetVC: self, message: "This is \(user.username), Check out and download the SpeakUPP App.")
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor.clear
        cell!.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = UIColor.clear
        cell!.selectionStyle = .none
    }
    
    func startFAQPage()  {
        let destination = FaqController()
        let vc = UINavigationController(rootViewController: destination)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK- start the privacy and about
    func startPage(type: SettingType)  {
        let destination = SettingPageController()
        let header = (type == SettingType.about) ? "About" : "Privacy"
        destination.header = header
        destination.type = type
        let vc = UINavigationController(rootViewController: destination)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK- start to edit page
    func startEditPage()  {
        let vc = UINavigationController(rootViewController: EditProfileController())
        self.present(vc, animated: true, completion: nil)
    }

}

class ProfileTableCell: BaseTableCell {
    
    var user: User! {
        didSet{
            guard let unwrapedItem = user else {return}
            if !unwrapedItem.profile.isEmpty {
                self.profileImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.profile))!,
                    placeholderImage: Mics.userPlaceHolder(),
                    imageTransition: .crossDissolve(0.2)
                )
            }
            self.nameLabel.text = user.fullName
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    override func setUpView() {
        addSubview(profileImageView)
        addSubview(nameLabel)
       
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 84).isActive = true
        self.profileImageView.layer.cornerRadius = 42

        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

    }
}

class NonSwitchTableCell: BaseTableCell {
    
    var item: SettingItem! {
        didSet{
            guard let unwrapedItem = item else {return}
            self.nameLabel.text = unwrapedItem.title
        }
    }
    

    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    
    override func setUpView() {
        addSubview(nameLabel)
    
        self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
}

class SwitchTableCell: BaseTableCell {
    
    var item: SettingItem! {
        didSet{
            guard let unwrapedItem = item else {return}
            self.nameLabel.text = unwrapedItem.title
        }
    }
    
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.numberOfLines = 0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkText
        return textView
    }()
    
    lazy var switchLabel: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = true
        switchDemo.setOn(true, animated: false)
        switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        switchDemo.translatesAutoresizingMaskIntoConstraints = false
        return switchDemo
    }()
    
    
  
    
    override func setUpView() {
        addSubview(nameLabel)
        addSubview(switchLabel)
        
        self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: switchLabel.leadingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        self.switchLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.switchLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.switchLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        self.switchLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
       
    }
}
