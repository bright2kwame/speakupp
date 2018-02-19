//
//  EventTicketController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 17/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class EventTicketController: UIViewController {
    
    let apiService = ApiService()
    var eventId: String?
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.sizeToFit()
        scrollView.contentSize = self.view.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentEventTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let dateDividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func viewDidLoad() {
        self.setUpNavigationBar()
        
        //MARK- set up the UI and 
        self.setUpUI()
    }
    
    
    func setUpUI()  {
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(qrCodeImageView)
        self.contentView.addSubview(dateDividerView)
        self.contentView.addSubview(contentEventTextLabel)
       
        let screenWidth = self.view.frame.width
        let heightWidth = (self.view.frame.height/2) - 50
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        self.scrollView.backgroundColor = UIColor.groupTableViewBackground
        
        self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        self.contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
       
        self.qrCodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        self.qrCodeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.qrCodeImageView.heightAnchor.constraint(equalToConstant: heightWidth).isActive = true
        self.qrCodeImageView.widthAnchor.constraint(equalToConstant: screenWidth - 50).isActive = true
        
        self.dateDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        self.dateDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        self.dateDividerView.topAnchor.constraint(equalTo: qrCodeImageView.bottomAnchor, constant: 8).isActive = true
        self.dateDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.contentEventTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        self.contentEventTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        self.contentEventTextLabel.topAnchor.constraint(equalTo: dateDividerView.bottomAnchor, constant: 8).isActive = true
        self.contentEventTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.contentEventTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        

        //CALL DATA
        self.setUpUniversalIndication()
        self.setData()
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
    
    func setData()  {
        self.startProgress()
        if let eventId = self.eventId {
            self.apiService.getEventTicket(pollId: eventId, completion: { (status, event, message) in
                self.stopProgress()
                if status == ApiCallStatus.SUCCESS {
                  self.showDetails(ticket: event!)
                } else {
                  self.dateDividerView.isHidden = true
                  ViewControllerHelper.showPrompt(vc: self, message: message!)
                }
            })
        }
    }
    
    func showDetails(ticket: EventTicket) {
        if let qrCode = Mics.generateQRCode(from: ticket.orderNumber) {
            self.qrCodeImageView.image = qrCode
            if ticket.isUsed {
               self.qrCodeImageView.alpha = 0.2
            }  else {
               self.qrCodeImageView.alpha = 1
            }
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
            let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
            
            let eventTitle = NSMutableAttributedString(string: "Event Name\n", attributes: attributes)
            let event = NSMutableAttributedString(string: "\(ticket.poll?.eventTitle ?? "")", attributes: titleAttributes)
            
            let priceTitle = NSMutableAttributedString(string: "\n\nPrice\n", attributes: attributes)
            let price = NSMutableAttributedString(string: "\(ticket.totalAmount)", attributes: titleAttributes)
            
            let quantityTitle = NSMutableAttributedString(string: "\n\nQuantity\n", attributes: attributes)
            let quantity = NSMutableAttributedString(string: "\(ticket.quantity)", attributes: titleAttributes)
            
            let dateTitle = NSMutableAttributedString(string: "\n\nDate Redeemed\n", attributes: attributes)
            let date = NSMutableAttributedString(string: "\(ticket.dateRedeemed.formateEventDate())", attributes: titleAttributes)
            
            let issuerTitle = NSMutableAttributedString(string: "\n\nIssued By\n", attributes: attributes)
            let issuer = NSMutableAttributedString(string: "\(ticket.author?.username ?? "")", attributes: titleAttributes)
            
            
            let combinedText = NSMutableAttributedString()
            combinedText.append(eventTitle)
            combinedText.append(event)
            combinedText.append(priceTitle)
            combinedText.append(price)
            combinedText.append(quantityTitle)
            combinedText.append(quantity)
            combinedText.append(dateTitle)
            combinedText.append(date)
            combinedText.append(issuerTitle)
            combinedText.append(issuer)
            
            self.contentEventTextLabel.attributedText = combinedText
            
           
        }
    }
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Ticket"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
    }
    
    @objc func handleCancel()  {
        self.navigationController?.popViewController(animated: true)
    }
     
}
