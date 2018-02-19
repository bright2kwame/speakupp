//
//  PayVottingController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class PayVottingController: UIViewController {
    var poll: Poll?
    var choiceId = ""
    var homeCell: HomeCell?
    var pollsController: PollsController?
    var searchController: SearchController?
    var eventDetailController: EventDetailController?
    let utilController = ViewControllerHelper()
    let apiService = ApiService()
    var isEvent = false
    var eventCell: EventCell?
    
    
    let descriptionTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let amountToPayTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    lazy var numberOfVoteTextField: UITextField = {
        let textField = baseInnerField()
        textField.addTarget(self, action: #selector(PayVottingController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        return textField
    }()
    
    
    func baseInnerField() -> UITextField {
        let color = UIColor.darkGray
        let textField = ViewControllerHelper.mainBaseField(placeHolder: "Enter number of vote")
        textField.delegate = self
        textField.textColor = color
        textField.keyboardType = UIKeyboardType.numberPad
        textField.setBottomBorder()
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder =  NSAttributedString(string: "Enter number of vote",
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        return textField
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
       
        
        self.view.addSubview(descriptionTextLabel)
        self.view.addSubview(numberOfVoteTextField)
        self.view.addSubview(amountToPayTextLabel)
        
        self.descriptionTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.descriptionTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.descriptionTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        self.descriptionTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.numberOfVoteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        self.numberOfVoteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        self.numberOfVoteTextField.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16).isActive = true
        self.numberOfVoteTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.amountToPayTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.amountToPayTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.amountToPayTextLabel.topAnchor.constraint(equalTo: numberOfVoteTextField.bottomAnchor, constant: 16).isActive = true
        self.amountToPayTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.updateUI()
        
    }
    
    func updateUI()  {
        guard let unwrapedItem = self.poll else {return}
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        let termsAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
        let combinedText = NSMutableAttributedString()
        if !self.isEvent {
            let header = NSMutableAttributedString(string: "\(unwrapedItem.question)\n\n", attributes: attributes)
            let terms = NSMutableAttributedString(string: "A vote cost GHS \(unwrapedItem.pricePerSMS)", attributes: termsAttributes)
            combinedText.append(header)
            combinedText.append(terms)
            
        } else {
            let header = NSMutableAttributedString(string: "\(unwrapedItem.eventTitle)\n\n", attributes: attributes)
            let terms = NSMutableAttributedString(string: "A ticket cost \(unwrapedItem.price)", attributes: termsAttributes)
            combinedText.append(header)
            combinedText.append(terms)
            
            self.numberOfVoteTextField.attributedPlaceholder =  NSAttributedString(string: "Enter number of ticket",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
        
        self.descriptionTextLabel.attributedText = combinedText
       
    }
    
    private func setUpNavigationBar()  {
        let heading = self.isEvent ? "Buying Ticket" : "Voting"
        navigationItem.title = heading
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
        
        let action = self.isEvent ? "Buy" : "Vote"
        let menuVote = UIBarButtonItem(title: action, style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = menuVote
    }
    
    @objc func handleCancel()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSave()  {
        let number = self.numberOfVoteTextField.text!
        if number.isEmpty {
            ViewControllerHelper.showAlert(vc: self, message: "Provide quantity of vote to cast", type: .warning)
            return
        }
        if self.isEvent {
            if let poll = self.poll {
                self.utilController.showActivityIndicator()
                self.apiService.buyTicket(pollId: poll.id, quantity: number,completion: { (status, url) in
                    self.utilController.hideActivityIndicator()
                    if let redirectUrl = url {
                        self.navigationController?.popViewController(animated: true)
                        self.eventCell?.continuePayment(url: redirectUrl)
                        self.searchController?.continuePayment(url: redirectUrl)
                        self.eventDetailController?.continuePayment(url: redirectUrl)
                    }
                    if (status == ApiCallStatus.DETAIL || status == ApiCallStatus.FAILED ){
                        ViewControllerHelper.showAlert(vc: self, message: "Failed to initialise payment.", type: .failed)
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
            } else {
                ViewControllerHelper.showAlert(vc: self, message: "Attempt to buy ticket for undentifiable event.", type: .failed)
            }
            return
        }
        if let poll = self.poll {
            self.utilController.showActivityIndicator()
            let total = Double(poll.pricePerSMS)! * Double(number)!
            self.apiService.payForVote(pollId: poll.id, quantity: number, choiceId: self.choiceId, totalAmount: total, completion: { (status, url) in
                self.utilController.hideActivityIndicator()
                if let redirectUrl = url {
                    self.navigationController?.popViewController(animated: true)
                    self.homeCell?.continuePayment(url: redirectUrl)
                    self.pollsController?.continuePayment(url: redirectUrl)
                    self.searchController?.continuePayment(url: redirectUrl)
                }
                if (status == ApiCallStatus.DETAIL || status == ApiCallStatus.FAILED ){
                    ViewControllerHelper.showAlert(vc: self, message: "Failed to initialise payment.", type: .failed)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        } else {
           ViewControllerHelper.showAlert(vc: self, message: "Attempt to vote for undentifiable poll.", type: .failed)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateAmout()
    }
    
    func updateAmout()  {
        let number = self.numberOfVoteTextField.text!
        if let poll = self.poll {
            if self.isEvent {
                let price = poll.price.split(separator: " ")[1]
                if (!number.isEmpty){
                    let total = Double(price)! * Double(number)!
                    self.amountToPayTextLabel.text = "TOTAL AMOUNT GHS \(total)"
                } else {
                    let total = Double(price)! * Double("1")!
                    self.amountToPayTextLabel.text = "TOTAL AMOUNT GHS \(total)"
                }
                return
            }
            
            if (!number.isEmpty){
                let total = Double(poll.pricePerSMS)! * Double(number)!
                self.amountToPayTextLabel.text = "TOTAL AMOUNT GHS \(total)"
            } else {
                let total = Double(poll.pricePerSMS)! * Double("1")!
                self.amountToPayTextLabel.text = "TOTAL AMOUNT GHS \(total)"
            }
        }
    }
}

extension PayVottingController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}
