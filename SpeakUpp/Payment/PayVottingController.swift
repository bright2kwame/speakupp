//
//  PayVottingController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import StoreKit

class PayVottingController: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {
   
    var poll: Poll?
    var choiceId = ""
    var multipleOptions = ""
    var homeCell: HomeCell?
    var pollsController: PollsController?
    var skProduct: SKProduct?
    var searchController: SearchController?
    var eventDetailController: EventDetailController?
    var pollVottingOptionController: PollVottingOptionController?
    let utilController = ViewControllerHelper()
    let apiService = ApiService()
    var isEvent = false
    var applePayTurnedOff = true
    var eventCell: EventCell?
    var inAppFeedOptions = [SKProduct]()
    let productId: NSString = "speakuppTier1"
    let productTierTwoId: NSString = "speakuppTier2"
    let productTierThreeId: NSString = "speakuppTier3"
    let productTierFourId: NSString = "speakuppTier4"
    let productTierFiveId: NSString = "speakuppTier5"
    let progressView = ViewControllerHelper()
    
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
    
    
    let payButton: UIButton = {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle("PAY FOR VOTE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        button.layer.cornerRadius = 20
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(pickAmount), for: .touchUpInside)
        return button
    }()
    
    
    @objc func pickAmount(_ sender: UIButton)  {
        if self.inAppFeedOptions.isEmpty {
            return
        }
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: "Choose Amount", message: "Choose Amount To Pay For", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        for item in self.inAppFeedOptions {
            actionSheet.addAction(UIAlertAction(title: "\(item.localizedTitle) - USD \(item.price)", style: .default, handler: { (action) -> Void in
                self.skProduct = item
                self.payButton.setTitle("USD \(item.price)", for: .normal)
                self.amountToPayTextLabel.text = item.localizedDescription
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        SKPaymentQueue.default().add(self)
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
       
        
        self.applePayTurnedOff = UserDefaults.standard.bool(forKey: "APPLE_PAY_STATUS")
        
        print("STATUS \(self.applePayTurnedOff)")
        self.view.addSubview(descriptionTextLabel)
        self.view.addSubview(numberOfVoteTextField)
        self.view.addSubview(payButton)
        self.view.addSubview(amountToPayTextLabel)
        self.payButton.isHidden = !applePayTurnedOff
        self.numberOfVoteTextField.isHidden = applePayTurnedOff
        
        
        self.descriptionTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.descriptionTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.descriptionTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        self.descriptionTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.numberOfVoteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        self.numberOfVoteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        self.numberOfVoteTextField.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16).isActive = true
        self.numberOfVoteTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.payButton.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16).isActive = true
        self.payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.payButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.amountToPayTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.amountToPayTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.amountToPayTextLabel.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 16).isActive = true
        self.amountToPayTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
       
        self.updateUI()
        
        if (self.applePayTurnedOff){
           self.buyInApp()
        }
    }
    
    func buyInApp()
    {
        if (SKPaymentQueue.canMakePayments())
        {
            self.utilController.showActivityIndicator()
            let productID:NSSet = NSSet(array: [self.productId,self.productTierTwoId,self.productTierThreeId,self.productTierFourId,self.productTierFiveId]);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
        }
        else
        {
           ViewControllerHelper.showAlert(vc: self, message: "Failed to initialise payment, this device does not support payment.", type: .failed)
        }
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
        if  applePayTurnedOff, let product = self.skProduct {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
            return
        }
        let number = self.numberOfVoteTextField.text!
        if number.isEmpty {
            ViewControllerHelper.showAlert(vc: self, message: "Provide quantity of vote to cast", type: .warning)
            return
        }
        if self.isEvent {
            if let poll = self.poll  {
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
            var params = ["poll_id":poll.id,"quantity":number,"choice_id": choiceId,"total_amount":total] as [String : Any]
            var url =  "\(ApiUrl().activeBaseUrl())get_paidpoll_url/"
            if self.poll?.pollType == PollType.MULTIPLE.rawValue {
                params = ["device_model":UIDevice.current.modelName,"quantity":number,"choice_id": choiceId,"total_amount":total,"parameters": self.multipleOptions] as [String : Any]
                url =  "\(ApiUrl().activeBaseUrl())polls/\(poll.id)/parameter_voting/"
            }
            print("URL \(url) \(params)")
            self.apiService.payForVote(url: url, params: params,completion: { (status, url) in
                self.utilController.hideActivityIndicator()
                if let redirectUrl = url {
                    self.navigationController?.popViewController(animated: true)
                    self.homeCell?.continuePayment(url: redirectUrl)
                    self.pollsController?.continuePayment(url: redirectUrl)
                    self.searchController?.continuePayment(url: redirectUrl)
                    self.pollVottingOptionController?.continuePayment(url: redirectUrl)
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
    
    func payWithApplePay()  {
        guard let poll = self.poll else {
            self.utilController.hideActivityIndicator()
            return
        }
        var params = ["poll_id":poll.id,"choice_id": choiceId,"total_amount":"\(self.skProduct!.price)"] as [String : Any]
        let url =  "\(ApiUrl().activeBaseUrl())pay_with_apple_pay/"
        if self.poll?.pollType == PollType.MULTIPLE.rawValue {
            params = ["device_model":UIDevice.current.modelName,"choice_id": choiceId,"total_amount":"\(self.skProduct!.price)","parameters": self.multipleOptions] as [String : Any]
        }
        print("URL \(url) \(params)")
        self.apiService.makeApplePayment(url: url, params: params,completion: { (status, message) in
            self.utilController.hideActivityIndicator()
             if let content = message, status == ApiCallStatus.SUCCESS {
                ViewControllerHelper.showPrompt(vc: self, message: content, completion: { (isDone) in
                  self.navigationController?.popViewController(animated: true)
                })
            }  else {
                ViewControllerHelper.showAlert(vc: self, message: "Failed to initialise payment.", type: .failed)
            }
        })
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
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.inAppFeedOptions = response.products
        self.utilController.hideActivityIndicator()
        if !self.inAppFeedOptions.isEmpty {
            self.skProduct = self.inAppFeedOptions[0]
            self.amountToPayTextLabel.text = self.skProduct!.localizedDescription
            self.payButton.setTitle("USD \(self.skProduct!.price)", for: .normal)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                self.utilController.showActivityIndicator()
                switch trans.transactionState {
                case .purchased:
                    self.payWithApplePay()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .failed:
                     self.utilController.hideActivityIndicator()
                     ViewControllerHelper.showPrompt(vc: self, message: "Unable to make payment.")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .restored:
                    self.utilController.hideActivityIndicator()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
            }
        }
    }
    
    
    //If an error occurs, the code will go to this function
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        ViewControllerHelper.showPrompt(vc: self, message: error.localizedDescription)
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




