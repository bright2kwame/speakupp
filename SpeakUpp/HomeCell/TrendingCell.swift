//
//  TrendingCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class TrendingCell: BaseCell {
    var homeController: HomeController?
    let apiService = ApiService()
    var timerCount = 0
    var timer = Timer()
    let controller = ViewControllerHelper()
    var payUrl = ""
    var currentQuestionId = ""
    var curretnQuestionItem: QuestionItem?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppBg")
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
    
    let hintProfileImageView: UIImageView = {
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
    
    let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 24)
        return textView
    }()
    
    lazy var startButton: UIButton = {
        let button = self.baseButton(title: "JOIN QUIZ")
        button.addTarget(self, action: #selector(joinQuiz), for: .touchUpInside)
        return button
    }()
    
    func baseButton(title:String) -> UIButton {
        let button = ViewControllerHelper.baseButton()
        let color = UIColor.white
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
        button.titleLabel!.numberOfLines = 0
        button.titleLabel!.baselineAdjustment = .alignCenters
        return button
    }
    
    
    let countDownTimeTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.boldSystemFont(ofSize: 24)
        textView.text = "00:00:00"
        return textView
    }()
    
    let questionTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.text = ""
        return textView
    }()
    
    let nextHintTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.text = ""
        return textView
    }()
    
    lazy var nextButton: UIButton = {
        let button = self.baseButton(title: "NEXT")
        button.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        return button
    }()
    
    lazy var laterButton: UIButton = {
        let button = self.baseButton(title: "HOME")
        button.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
        return button
    }()
    
    lazy var answerStack: UIStackView = {
        let stackView = ViewControllerHelper.baseStackView()
        return stackView
    }()
    
    
    func answerButton(title: String) -> UIButton {
        let button =  ViewControllerHelper.baseButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.titleLabel!.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }
    
    lazy var firstAnswerButton: UIButton = {
        let button =  self.answerButton(title: "")
        button.addTarget(self, action: #selector(answerQuestion), for: .touchUpInside)
        return button
    }()
    
    lazy var secondAnswerButton: UIButton = {
        let button = self.answerButton(title: "")
        button.addTarget(self, action: #selector(answerQuestion), for: .touchUpInside)
        return button
    }()
    
    lazy var thirdAnswerButton: UIButton = {
        let button = self.answerButton(title: "")
        button.addTarget(self, action: #selector(answerQuestion), for: .touchUpInside)
        return button
    }()
    
    lazy var fouthAnswerButton: UIButton = {
        let button = self.answerButton(title: "")
        button.addTarget(self, action: #selector(answerQuestion), for: .touchUpInside)
        return button
    }()
    
    
    override func setUpView() {
        super.setUpView()

        addSubview(imageView)
        addSubview(scrollView)
        
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.getQuizStatus()
    }
    
    //MARK: request to join quiz
    @objc private func joinQuiz() {
       self.continuePayment()
    }
    
    //MARK: request to join quiz
    @objc private func nextQuestion() {
      self.hintProfileImageView.removeFromSuperview()
      self.nextHintTextLabel.removeFromSuperview()
      self.nextButton.removeFromSuperview()
      self.laterButton.removeFromSuperview()
      self.showQuestion()
    }
    
    //MARK: request to join quiz
    @objc private func returnHome() {
        self.hintProfileImageView.removeFromSuperview()
        self.nextHintTextLabel.removeFromSuperview()
        self.nextButton.removeFromSuperview()
        self.laterButton.removeFromSuperview()
        self.getQuizStatus()
    }
    
    //MARK: the status of the
    func getQuizStatus()  {
        self.controller.showActivityIndicator()
        let url = ApiUrl().activeBaseUrl() + "quiz/check_eligibility/"
        ApiService().makeGetApiCall(url: url) { (status, data) in
            self.controller.hideActivityIndicator()
            if let dataIn = data, status == ApiCallStatus.SUCCESS {
                print("IN \(dataIn)")
                let responseCode = dataIn["response_code"].stringValue
                //MARK: new user here
                if responseCode == "101" {
                    let message = dataIn["message"].stringValue
                    let redirectUrl = dataIn["redirect_url"].stringValue
                    self.payUrl = redirectUrl
                    let prize = dataIn["quiz_prize"].stringValue
                    self.showWelcome(message: message, action: redirectUrl, prize: prize)
                }  else {
                    let message = dataIn["message"].stringValue
                    let questionId = dataIn["results"]["id"].stringValue
                    let question = dataIn["results"]["question"].stringValue
                    let option1 = dataIn["results"]["option1"].stringValue
                    let option2 = dataIn["results"]["option2"].stringValue
                    let option3 = dataIn["results"]["option3"].stringValue
                    let option4 = dataIn["results"]["option4"].stringValue
                   
                    self.showNextAction(message: message, isStarting: true)
                }
            }
        }
    }
    
    //MARK: answer question
    @objc private func answerQuestion(sender: UIButton) {
        if let vc = self.homeController {
            let answerText = sender.titleLabel?.text! ?? ""
            ViewControllerHelper.showPrompt(vc: vc, message: "Confirm your answer:\n \(answerText)", completion: { (isDone) in
                self.timer.invalidate()
                self.controller.showActivityIndicator()
                self.sendAnswer(answerText: answerText)
            })
        }
    }
    
    
    //MARK: send answer
    func sendAnswer(answerText: String)  {
        let url = ApiUrl().activeBaseUrl() + "quiz/submit_answer/"
        let params = ["answer": answerText,"question_id": self.currentQuestionId, "time_spent": timerCount] as [String : Any]
        ApiService().makePostApiCall(url: url, params: params) { (status, data) in
            self.controller.hideActivityIndicator()
            if let dataIn = data, status == ApiCallStatus.SUCCESS {
                self.removeQuestionView()
                let responseCode = dataIn["response_code"].stringValue
                print("RESULT \(dataIn)")
                if responseCode == "102" {
                    let message = dataIn["message"].stringValue
                    let questionId = dataIn["results"]["id"].stringValue
                    let question = dataIn["results"]["question"].stringValue
                    let option1 = dataIn["results"]["option1"].stringValue
                    let option2 = dataIn["results"]["option2"].stringValue
                    let option3 = dataIn["results"]["option3"].stringValue
                    let option4 = dataIn["results"]["option4"].stringValue
                   
                    self.showNextAction(message: message, isStarting: false)
                } else {
                   let message = dataIn["message"].stringValue
                    ViewControllerHelper.showPrompt(vc: self.homeController!, message: message, completion: { (isDone) in
                        self.getQuizStatus()
                    })
                }
            }
        }
    }
    
    func removeQuestionView()  {
        self.questionTextLabel.removeFromSuperview()
      
        self.countDownTimeTextLabel.removeFromSuperview()
    }
    
    
    func showNextAction(message: String, isStarting: Bool)  {
        
        self.questionTextLabel.removeFromSuperview()
        self.countDownTimeTextLabel.removeFromSuperview()
        self.answerStack.removeFromSuperview()
        
        self.scrollView.addSubview(hintProfileImageView)
        self.scrollView.addSubview(nextHintTextLabel)
        self.scrollView.addSubview(nextButton)
        self.scrollView.addSubview(laterButton)
        
        self.hintProfileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.hintProfileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        self.hintProfileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.hintProfileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nextHintTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nextHintTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nextHintTextLabel.topAnchor.constraint(equalTo: hintProfileImageView.bottomAnchor, constant: 32).isActive = true
        self.nextHintTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.nextButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.nextButton.topAnchor.constraint(equalTo: nextHintTextLabel.bottomAnchor, constant: 32).isActive = true
        self.nextButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.laterButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.laterButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.laterButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16).isActive = true
        self.laterButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.laterButton.isHidden = isStarting
        
       
        let user = User.getUser()!
        let boldFont = UIFont.boldSystemFont(ofSize: 30)
        let font = UIFont.systemFont(ofSize: 20)
        let topMessage = user.fullName.formatAsAttributed(font: boldFont, color: UIColor.white)
        let secondMessage = "\n\n\(message)".formatAsAttributed(font: font, color: UIColor.white)
        let combination = NSMutableAttributedString()
        combination.append(topMessage)
        combination.append(secondMessage)
        self.nextHintTextLabel.attributedText = combination
        self.nextHintTextLabel.textAlignment = .center
        
        if  !(user.profile.isEmpty) {
            self.hintProfileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    //MARK: show welcome page to first time users
    func showQuestion()  {
        guard let questionItem  = self.curretnQuestionItem else {
            return
        }
        self.timerCount = 0
        self.countDownTimeTextLabel.text = "00:00:00"
        self.currentQuestionId = questionItem.id
        
        self.prizeImageView.removeFromSuperview()
        self.startButton.removeFromSuperview()
        self.nameTextLabel.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        
        self.scrollView.addSubview(countDownTimeTextLabel)
        self.scrollView.addSubview(questionTextLabel)
        self.scrollView.addSubview(answerStack)
        
        self.countDownTimeTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.countDownTimeTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.countDownTimeTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        self.countDownTimeTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.countDownTimeTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.questionTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32).isActive = true
        self.questionTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32).isActive = true
        self.questionTextLabel.topAnchor.constraint(equalTo: countDownTimeTextLabel.bottomAnchor, constant: 32).isActive = true
        self.questionTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.answerStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32).isActive = true
        self.answerStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32).isActive = true
        self.answerStack.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 32).isActive = true
        self.answerStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TrendingCell.update), userInfo: nil, repeats: true)
    }
    
    //MARK: display timer
    @objc func update() {
        timerCount += 1
        let hours = Int(timerCount) / 3600
        let minutes = Int(timerCount) / 60 % 60
        let seconds = Int(timerCount) % 60
        self.countDownTimeTextLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //MARK: show welcome page to first time users
    func showWelcome(message: String, action: String, prize: String)  {
        
        self.scrollView.addSubview(profileImageView)
        self.scrollView.addSubview(nameTextLabel)
        self.scrollView.addSubview(prizeImageView)
        self.scrollView.addSubview(startButton)
       
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.nameTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.nameTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.nameTextLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        self.nameTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.prizeImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.prizeImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.prizeImageView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 16).isActive = true
        self.prizeImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
       
        self.startButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.startButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.startButton.topAnchor.constraint(equalTo: prizeImageView.bottomAnchor, constant: 16).isActive = true
        self.startButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.updateUI(user: User.getUser()!, message: message,action: action,prize: prize)
    }
    
    //MARK: update the user
    func updateUI(user: User, message: String, action: String, prize: String)  {
        if  !(user.profile.isEmpty) {
            self.profileImageView.af_setImage(
                withURL: URL(string: (user.profile))!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
        
        if  !(prize.isEmpty) {
            self.prizeImageView.af_setImage(
                withURL: URL(string: prize)!,
                placeholderImage: Mics.userPlaceHolder(),
                imageTransition: .crossDissolve(0.2)
            )
        }
        
        let boldFont = UIFont.boldSystemFont(ofSize: 30)
        let font = UIFont.systemFont(ofSize: 20)
        let topMessage = user.fullName.formatAsAttributed(font: boldFont, color: UIColor.white)
        let secondMessage = "\n\n\(message)".formatAsAttributed(font: font, color: UIColor.white)
        let combination = NSMutableAttributedString()
        combination.append(topMessage)
        combination.append(secondMessage)
        self.nameTextLabel.attributedText = combination
        self.nameTextLabel.textAlignment = .center
    }
    
    //MARK - continue paymemt
    func continuePayment()  {
        let vc = PaymentRedirectController()
        vc.trendingCell = self
        vc.url = self.payUrl
        self.homeController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    //MARK - call for refresh from other places
    func callRefresh()  {
       self.getQuizStatus()
    }
    
}
