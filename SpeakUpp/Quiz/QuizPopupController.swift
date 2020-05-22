//
//  QuizPopupController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 16/05/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import UIKit

class QuizPopupController: UIViewController {
    let apiService = ApiService()
    var timerCount = 0
    let controller = ViewControllerHelper()
    var payUrl = ""
    var quiz: QuizItem? = nil
    var homeController: HomeController?
    var purchaseFirst = false
    
    
    let quizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
       
    let titleTextLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .left
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 20)
           textView.text = "SpeakUpp"
           return textView
    }()
    
    let contentTextLabel: UILabel = {
         let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playButton: UIButton = {
          let button = self.baseButton(title: "PLAY")
          button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
          return button
      }()
      
    lazy var purchaseButton: UIButton = {
          let button = self.baseButton(title: "PURCHASE PLAY")
          button.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
          return button
    }()
       
    lazy var closeButton: UIButton = {
          let button = self.baseButton(title: "X")
          button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
          return button
    }()
    
    func baseButton(title:String) -> UIButton {
         let button = ViewControllerHelper.baseButton()
         let color = UIColor.white
         button.setTitle(title.uppercased(), for: .normal)
         button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
         button.backgroundColor = UIColor.white
         button.layer.cornerRadius = 0.0
         button.layer.borderWidth = 1
         button.layer.borderColor = color.cgColor
         button.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
         button.titleLabel!.numberOfLines = 0
         button.titleLabel!.baselineAdjustment = .alignCenters
         return button
     }
     
    
    //MARK: action on the button
    @objc func playAction(sender: UIButton) {
        self.dismiss(animated: true) {
            let vc = QuizController()
            vc.quiz = self.quiz!
            vc.purchaseFirst = self.purchaseFirst
            self.homeController?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    //MARK: purchase point
    @objc func buyAction(sender: UIButton) {
         self.dismiss(animated: true) {
            let vc = QuizController()
            vc.quiz = self.quiz!
            vc.purchaseFirst = self.purchaseFirst
            self.homeController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: action on the button
    @objc func closeAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(container)
        
        self.container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        self.container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        self.container.heightAnchor.constraint(equalToConstant: 400).isActive = true
        self.container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        self.container.addSubview(titleTextLabel)
        self.container.addSubview(closeButton)
        self.container.addSubview(quizeImageView)
        self.container.addSubview(contentTextLabel)
        self.container.addSubview(playButton)
        self.container.addSubview(purchaseButton)
        
       
        self.closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        self.closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
         
        self.titleTextLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        self.titleTextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        self.titleTextLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16).isActive = true
        self.titleTextLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
               
        self.quizeImageView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 16).isActive = true
        self.quizeImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        self.quizeImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        self.quizeImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
       
        self.playButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.playButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        self.playButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
           
        self.purchaseButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        self.purchaseButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        self.purchaseButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive = true
        self.purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.contentTextLabel.topAnchor.constraint(equalTo: quizeImageView.bottomAnchor, constant: 8).isActive = true
        self.contentTextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        self.contentTextLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        self.contentTextLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -16).isActive = true
              
        self.contentTextLabel.text = ""
        let quizImage = quiz?.prize ?? ""
        if  !(quizImage.isEmpty) {
                                self.quizeImageView.af_setImage(
                                    withURL: URL(string: quizImage)!,
                                    placeholderImage: Mics.placeHolder(),
                                    imageTransition: .crossDissolve(0.2)
                                )}
        
        
        self.getQuizStatus()
    }
    
    
    //MARK: the status of the
      func getQuizStatus()  {
          self.controller.showActivityIndicator()
          let url = ApiUrl().activeBaseUrl() + "quiz/new_check_eligibility/"
          let param = ["quiz_id": self.quiz!.id]
          apiService.makePostApiCall(url: url, params: param) { (status, data) in
              self.controller.hideActivityIndicator()
              if let dataIn = data, status == ApiCallStatus.SUCCESS {
                 let responseCode = dataIn["response_code"].stringValue
                 let message = dataIn["message"].stringValue
                 self.showMessage(message: message)
                 self.purchaseFirst = responseCode != "100"
              }
          }
      }
    
    
    
    
    //MARK: display the availbale text
    func showMessage(message: String)  {
        let boldFont = UIFont.boldSystemFont(ofSize: 12)
        let font = UIFont.systemFont(ofSize: 20)
        let topMessage = "This Week".formatAsAttributed(font: boldFont, color: UIColor.white)
        let secondMessage = "\n\(message)".formatAsAttributed(font: font, color: UIColor.white)
        let combination = NSMutableAttributedString()
        combination.append(topMessage)
        combination.append(secondMessage)
        self.contentTextLabel.attributedText = combination
        self.contentTextLabel.textAlignment = .center
    }

}
