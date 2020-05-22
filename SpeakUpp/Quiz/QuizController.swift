//
//  QuizController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 02/01/2020.
//  Copyright © 2020 Bright Limited. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuizController: UIViewController {
    let apiService = ApiService()
    var timerCount = 0
    var timer = Timer()
    let controller = ViewControllerHelper()
    var payUrl = ""
    var currentQuestionId = ""
    var curretnQuestionItem: QuestionItem?
    var quiz: QuizItem? = nil
    let feedCellId = "quizesCell"
    var feed = [AnswerItem]()
    var purchaseFirst = false
    var livesLeft = 0
    var exitQuiz = false
 
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
    
    let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let nameTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.darkGray
        textView.font = UIFont.systemFont(ofSize: 24)
        return textView
    }()
    
    let scoreTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        return textView
    }()
    
    let livesStackView: UIStackView = {
        let stackview = ViewControllerHelper.baseStackView()
        stackview.alignment = .center
        stackview.axis = .horizontal
        stackview.spacing = 5
        return stackview
    }()
    
    lazy var startButton: UIButton = {
        let button = self.baseButton(title: "JOIN QUIZ")
        button.addTarget(self, action: #selector(joinQuiz), for: .touchUpInside)
        return button
    }()
    
    let gameOverTextLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .center
           textView.textColor = UIColor.darkGray
           textView.font = UIFont.systemFont(ofSize: 24)
           return textView
    }()
    
    lazy var buyPlaysButton: UIButton = {
           let button = self.baseButton(title: "PURCHASE")
           button.addTarget(self, action: #selector(buyPlays), for: .touchUpInside)
           button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
           button.setTitleColor(UIColor.white, for: .normal)
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
        textView.backgroundColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 25
        return textView
    }()
    
    let questionTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.text = ""
        return textView
    }()
    
    let nextHintTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.darkText
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
    
    lazy var optionsCollectionView: UICollectionView = {
           let flow = UICollectionViewFlowLayout()
           flow.scrollDirection = .vertical
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
           collectionView.backgroundColor = UIColor.clear
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           return collectionView
       }()
    
    let answerStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let gameOverTitleTextLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .center
           textView.textColor = UIColor.red
           textView.font = UIFont.systemFont(ofSize: 24)
           textView.text = "GAME OVER"
           return textView
    }()
    
    let gameOverHiglightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gameOverInnerTitleTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.text = "Here is how you did"
        return textView
    }()
    
    var gameOverLeftStackView: UIStackView?
    var gameOverRightStackView: UIStackView?
    
    let gameOverRankTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Rank"
        return textView
    }()
    
    let gameOverDesignationTextLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.textColor = UIColor.hex(hex: Key.primaryHomeHexCode)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Designation"
        return textView
    }()
    
    lazy var gameOverViewBoardButton: UIButton = {
        let button = self.baseButton(title: "View Leader Board")
        button.addTarget(self, action: #selector(viewLeaderBoard), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.hex(hex: Key.primaryHomeHexCode), for: .normal)
        return button
    }()
    
    lazy var gameOverBuyPlaysButton: UIButton = {
        let button = self.baseButton(title: "PLAY AGAIN")
        button.addTarget(self, action: #selector(buyPlaysAfterOver), for: .touchUpInside)
        button.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    
    //MARK: stack  content
    let gameOverScoreLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .left
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "Your Score"
           return textView
    }()
    
    let gameOverScoreLabelValue: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "0"
        return textView
    }()

    let gameOverAttemptedLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Attempted Questions"
        return textView
    }()
       
    let gameOverAttemptedLabelValue: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .right
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "0"
           return textView
    }()
    
    let gameOverHighScoreLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "High Score"
        return textView
    }()
       
    let gameOverHighScoreLabelValue: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "0"
        return textView
    }()
    
    let gameOverCurrentPrizeLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .left
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "Current Prize"
           return textView
       }()
          
    let gameOverCurrentPrizeLabelValue: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .right
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "0"
           return textView
    }()
    
    let gameOverNextPrizeLabel: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .left
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "Next Prize"
           return textView
    }()
          
    let gameOverNextPrizeLabelValue: UILabel = {
           let textView = ViewControllerHelper.baseLabel()
           textView.textAlignment = .right
           textView.textColor = UIColor.white
           textView.font = UIFont.systemFont(ofSize: 16)
           textView.text = "0"
           return textView
    }()
    
    let gameOverTotalParticipantLabel: UILabel = {
              let textView = ViewControllerHelper.baseLabel()
              textView.textAlignment = .left
              textView.textColor = UIColor.white
              textView.font = UIFont.systemFont(ofSize: 16)
              textView.text = "Total Partcipant"
              return textView
       }()
             
       let gameOverTotalParticipantLabelValue: UILabel = {
              let textView = ViewControllerHelper.baseLabel()
              textView.textAlignment = .right
              textView.textColor = UIColor.white
              textView.font = UIFont.systemFont(ofSize: 16)
              textView.text = "0"
              return textView
       }()
    
    
    
    override func viewDidLoad() {
      
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
        self.view.addSubview(scrollView)
        
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        if purchaseFirst && self.quiz!.hasPaid {
           self.showNumberToPurchase()
        }
        self.getQuizStatus()
        
        //self.showGameOverMessageWithInfo(score: "12", attempted: "12", highScore: "20", price: "New Car", nextPrice: "Next Game", participants: "234", rank: "Teacher Rank", designation: "Senior")
    }
    
    
    //MARK: will dissappear
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController && self.timerCount > 0 && !exitQuiz {
            self.exitQuiz = true
            self.updateThatGameIsOver()
            ViewControllerHelper.showAlert(vc: self, message: "Exiting means you will loose one life.", type: MessageType.failed)
        } else {
         super.viewWillDisappear(animated)
        }
    }
    
    
    func updateThatGameIsOver() {
        let url = ApiUrl().baseUrl + "game_over/"
        let param = ["quiz_id": self.quiz!.id]
        if self.timerCount > 0 {
            apiService.makePostApiCall(url: url, params: param) { (status, data) in
                if let dataIn = data, status == ApiCallStatus.SUCCESS {
                    print("DATA \(dataIn)")
                }
            }
        }
    }
    
    private func setUpNavigationBar()  {
        let heading = "Quiz"
        navigationItem.title = heading
        navigationController?.navigationBar.isTranslucent = false
           
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Share", style: .done, target: self, action: #selector(self.action(sender:)))
    }
    
    
    @objc func action(sender: UIBarButtonItem) {
        let url = ApiUrl().baseUrl + "get_social_share_message/"
        let param = ["quiz_id": self.quiz!.id]
        apiService.makePostApiCall(url: url, params: param) { (status, data) in
            if let dataIn = data, status == ApiCallStatus.SUCCESS {
                    let responseCode = dataIn["response_code"].stringValue
                    print("DATA \(dataIn)")
                    if (responseCode == "100"){
                      let message = dataIn["message"].stringValue
                      ViewControllerHelper.presentSharer(targetVC: self, message: message)
                    }else {
                     ViewControllerHelper.showPrompt(vc: self, message: "Fialed to get sharing information")
                }
                           
            }
        }
    }
    
    //MARK: input number of plays
    func showNumberToPurchase()  {
        let alertController = UIAlertController(title: "Purchase Plays", message: "Enter number of purchases to buy. One play cost GHS \(self.quiz!.entryFee)", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Purchase Play", style: .default) { (alertAction) in
          let textField = alertController.textFields![0] as UITextField
          self.purchasePlays(numberOfPlays: textField.text ?? "1")
        }
        let actioncancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addTextField { (textField) in
          textField.placeholder = "Enter number of plays"
        }
        alertController.addAction(action)
        alertController.addAction(actioncancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: purchase the plays number now
    func purchasePlays(numberOfPlays: String) {
        let url = ApiUrl().baseUrl + "purchase_plays/"
        let param = ["quiz_id": self.quiz!.id, "num_of_plays": numberOfPlays]
        apiService.makePostApiCall(url: url, params: param) { (status, data) in
               if let dataIn = data, status == ApiCallStatus.SUCCESS {
                       let responseCode = dataIn["response_code"].stringValue
                       if (responseCode == "200"){
                         let message = dataIn["redirect_url"].stringValue
                         self.payUrl = message
                         self.continuePayment()
                       } else {
                        ViewControllerHelper.showPrompt(vc: self, message: "Fialed to start payment processor")
                   }
                              
               }
           }
    }
    
    //MARK: request to join quiz
    @objc private func joinQuiz() {
        self.continuePayment()
    }
    
    //MARK: buying more play points
      @objc private func buyPlaysAfterOver() {
        self.removeGameOver()
        if !self.quiz!.hasPaid {
            self.getQuizStatus()
        } else {
            self.showNumberToPurchase()
        }
    }
    
    //MARK: buying more play points
    @objc private func buyPlays() {
        if !self.quiz!.hasPaid {
          self.getQuizStatus()
        } else {
          self.showNumberToPurchase()
        }
    }
    
    //MARK: navigate to leader board
    @objc private func viewLeaderBoard() {
         let destination = LeaderController()
         destination.quizId = self.quiz!.id
         self.navigationController?.pushViewController(destination, animated: true)
     }
    
    //MARK: request to join quiz
    @objc private func nextQuestion() {
      self.nextHintTextLabel.removeFromSuperview()
      self.nextButton.removeFromSuperview()
      self.laterButton.removeFromSuperview()
      self.showQuestion()
    }
    
    //MARK: request to join quiz
    @objc private func returnHome() {
        self.nextHintTextLabel.removeFromSuperview()
        self.nextButton.removeFromSuperview()
        self.laterButton.removeFromSuperview()
        self.getQuizStatus()
    }
    
    //MARK: remove
    @objc private func removeGameOver() {
        self.gameOverTitleTextLabel.removeFromSuperview()
        self.gameOverTextLabel.removeFromSuperview()
        self.gameOverHiglightView.removeFromSuperview()
        self.gameOverRankTextLabel.removeFromSuperview()
        self.gameOverDesignationTextLabel.removeFromSuperview()
        self.gameOverViewBoardButton.removeFromSuperview()
        self.gameOverBuyPlaysButton.removeFromSuperview()
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
                print("\(dataIn)")
                //MARK: new user here
                if responseCode == "100" {
                    let score = dataIn["current_total_score"].stringValue
                    self.livesLeft = dataIn["lives_left"].intValue
                    dataIn["results"]["answers"].forEach { (item) in
                            let quiz = self.parseAnswer(item: item.1)
                            self.feed.append(quiz)
                    }
                    self.curretnQuestionItem = self.parseQuestion(item: dataIn["results"])
                    self.scoreTextLabel.text = "Score: \(score)"
                    self.showQuestion()
                } else if (responseCode == "101") {
                    let message = dataIn["message"].stringValue
                    let font = UIFont.systemFont(ofSize: 20)
                    let topMessage = message.formatAsAttributed(font: font, color: UIColor.darkText)
                    let combination = NSMutableAttributedString()
                    combination.append(topMessage)
                    self.showGameMessage(message: combination)
                } else {
//                    let message = dataIn["message"].stringValue
//                    let redirectUrl = dataIn["redirect_url"].stringValue
//                    self.payUrl = redirectUrl
//                    let prize = dataIn["quiz_prize"].stringValue
//                    self.showWelcome(message: message, action: redirectUrl, prize: prize)

                    self.showNumberToPurchase()
                }
            }
        }
    }
    
    
    //MARK: show message for game
    func showGameMessage(message: NSAttributedString) {
        self.scrollView.addSubview(gameOverTextLabel)
        self.scrollView.addSubview(buyPlaysButton)
        
        if !self.quiz!.hasPaid {
          buyPlaysButton.setTitle("PLAY AGAIN", for: .normal)
        } else {
           buyPlaysButton.setTitle("PURCHASE PLAY", for: .normal)
        }
        
        self.gameOverTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.gameOverTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.gameOverTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        self.gameOverTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.buyPlaysButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.buyPlaysButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.buyPlaysButton.topAnchor.constraint(equalTo: gameOverTextLabel.bottomAnchor, constant: 16).isActive = true
        self.buyPlaysButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.gameOverTextLabel.attributedText = message
        self.gameOverTextLabel.textAlignment = .center
    }
    
    
    //MARK: add all gameover params  with information
    func showGameOverMessageWithInfo(score: String, attempted: String, highScore: String, price: String, nextPrice: String,
                                     participants: String, rank: String, designation: String) {
        
        self.scrollView.addSubview(gameOverTitleTextLabel)
        self.scrollView.addSubview(gameOverHiglightView)
        self.scrollView.addSubview(gameOverRankTextLabel)
        self.scrollView.addSubview(gameOverViewBoardButton)
        self.scrollView.addSubview(gameOverDesignationTextLabel)
        self.scrollView.addSubview(gameOverBuyPlaysButton)
       
        self.gameOverTitleTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        self.gameOverTitleTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.gameOverTitleTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        self.gameOverTitleTextLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.gameOverTitleTextLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        self.gameOverHiglightView.leadingAnchor.constraint(equalTo: gameOverTitleTextLabel.leadingAnchor, constant: 0).isActive = true
        self.gameOverHiglightView.trailingAnchor.constraint(equalTo: gameOverTitleTextLabel.trailingAnchor, constant: 0).isActive = true
        self.gameOverHiglightView.topAnchor.constraint(equalTo: gameOverTitleTextLabel.bottomAnchor, constant: 16).isActive = true
        self.gameOverHiglightView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.gameOverHiglightView.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        
        self.gameOverHiglightView.addSubview(gameOverInnerTitleTextLabel)
        
        self.gameOverInnerTitleTextLabel.leadingAnchor.constraint(equalTo: gameOverHiglightView.leadingAnchor, constant: 16).isActive = true
        self.gameOverInnerTitleTextLabel.trailingAnchor.constraint(equalTo: gameOverHiglightView.trailingAnchor, constant: -16).isActive = true
        self.gameOverInnerTitleTextLabel.topAnchor.constraint(equalTo: gameOverHiglightView.topAnchor, constant: 8).isActive = true
        self.gameOverInnerTitleTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
              
        gameOverLeftStackView = UIStackView(arrangedSubviews: [gameOverScoreLabel,gameOverAttemptedLabel,gameOverHighScoreLabel,gameOverCurrentPrizeLabel,
                                                               gameOverNextPrizeLabel,gameOverTotalParticipantLabel])
        gameOverLeftStackView?.distribution = .fillEqually
        gameOverLeftStackView?.axis = .vertical
        gameOverLeftStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        gameOverRightStackView = UIStackView(arrangedSubviews: [ gameOverScoreLabelValue,gameOverAttemptedLabelValue,gameOverHighScoreLabelValue,gameOverCurrentPrizeLabelValue,
                                                                      gameOverNextPrizeLabelValue,gameOverTotalParticipantLabelValue])
        gameOverRightStackView?.distribution = .fillEqually
        gameOverRightStackView?.axis = .vertical
        gameOverRightStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.gameOverHiglightView.addSubview(gameOverLeftStackView!)
        self.gameOverHiglightView.addSubview(gameOverRightStackView!)
        
        gameOverLeftStackView?.leadingAnchor.constraint(equalTo: gameOverHiglightView.leadingAnchor, constant: 8).isActive = true
        gameOverLeftStackView?.topAnchor.constraint(equalTo: gameOverInnerTitleTextLabel.bottomAnchor, constant: 8).isActive = true
        gameOverLeftStackView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gameOverLeftStackView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        gameOverRightStackView?.trailingAnchor.constraint(equalTo: gameOverHiglightView.trailingAnchor, constant: -8).isActive = true
        gameOverRightStackView?.topAnchor.constraint(equalTo: gameOverInnerTitleTextLabel.bottomAnchor, constant: 8).isActive = true
        gameOverRightStackView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gameOverRightStackView?.leadingAnchor.constraint(equalTo: gameOverLeftStackView!.trailingAnchor, constant: 0).isActive = true
        
        let width_ = view.frame.width - 32
        self.gameOverRankTextLabel.leadingAnchor.constraint(equalTo: gameOverHiglightView.leadingAnchor, constant: 16).isActive = true
        self.gameOverRankTextLabel.widthAnchor.constraint(equalToConstant: width_/2).isActive = true
        self.gameOverRankTextLabel.topAnchor.constraint(equalTo: gameOverHiglightView.bottomAnchor, constant: 8).isActive = true
        self.gameOverRankTextLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.gameOverDesignationTextLabel.trailingAnchor.constraint(equalTo: gameOverHiglightView.trailingAnchor, constant: -16).isActive = true
        self.gameOverDesignationTextLabel.widthAnchor.constraint(equalToConstant: width_/2).isActive = true
        self.gameOverDesignationTextLabel.topAnchor.constraint(equalTo: gameOverHiglightView.bottomAnchor, constant: 8).isActive = true
        self.gameOverDesignationTextLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //MARK
        self.gameOverViewBoardButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 16).isActive = true
        self.gameOverViewBoardButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.gameOverViewBoardButton.topAnchor.constraint(equalTo: gameOverDesignationTextLabel.bottomAnchor, constant: 16).isActive = true
        self.gameOverViewBoardButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.gameOverBuyPlaysButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 16).isActive = true
        self.gameOverBuyPlaysButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.gameOverBuyPlaysButton.topAnchor.constraint(equalTo: gameOverViewBoardButton.bottomAnchor, constant: 8).isActive = true
        self.gameOverBuyPlaysButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.gameOverScoreLabelValue.text = score
        self.gameOverAttemptedLabelValue.text = attempted
        self.gameOverHighScoreLabelValue.text = highScore
        self.gameOverCurrentPrizeLabelValue.text = price
        self.gameOverNextPrizeLabelValue.text = nextPrice
        self.gameOverTotalParticipantLabelValue.text = participants
        self.gameOverRankTextLabel.text = "Rank\n\(rank)"
        self.gameOverDesignationTextLabel.text = "Designation\n\(designation)"
        
    }
    
    //MARK:show answer status, either correct or wrong
    func showAnswerstatus(isCorrect: Bool) {
         self.answerStateImageView.isHidden = false
         self.answerStateImageView.backgroundColor = isCorrect ? UIColor.red : UIColor.green
         self.answerStateImageView.image =  isCorrect ? UIImage(named: "Correct") : UIImage(named: "Deny")
    }

    //MARK:- parse answers
    func parseAnswer(item: JSON) -> AnswerItem  {
           let id = item["id"].stringValue
           let answerText = item["answer"].stringValue
           let image = item["image"].stringValue
        
           let answer = AnswerItem()
           answer.answer = answerText
           answer.id = id
           answer.image = image
           return answer
    }
    
    //MARK:- parse questions
    func parseQuestion(item: JSON) -> QuestionItem  {
        let questionId = item["id"].stringValue
        let questionText = item["question"].stringValue
        let questionImage = item["question_image"].stringValue
        let hasImage = item["has_image"].boolValue
        let hasImageAnswers = item["has_image_answers"].boolValue
        let isBonus = item["is_bonus"].boolValue
         
        let question = QuestionItem()
        question.id = questionId
        question.question = questionText
        question.hasImage = hasImage
        question.hasImageAnswers = hasImageAnswers
        question.isBonus = isBonus
        question.questionImage = questionImage
        return question
    }
    
    //MARK: answer question
     func answerQuestion(answer: AnswerItem) {
            let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {(Alert:UIAlertAction!) -> Void in
                         self.timer.invalidate()
                         self.feed.removeAll()
                         self.optionsCollectionView.reloadData()
                         self.controller.showActivityIndicator()
                         self.sendAnswer(answer: answer)
                       })
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(Alert:UIAlertAction!) -> Void in
                
            })
        let alertView = UIAlertController(title: "SpeakUpp", message: "Confirm your answer:\n \(answer.answer)", preferredStyle: .alert)
            alertView.addAction(yesAction)
            alertView.addAction(cancelAction)
            present(alertView, animated: true, completion: nil)
    }
    
    //MARK: send game over status
    func gameOver() {
        self.removeQuestionView()
        let url = ApiUrl().activeBaseUrl() + "quiz/new_submit_answer/"
        let params = ["answer_id": "0","question_id": self.currentQuestionId, "points": timerCount,"quiz_id": self.quiz!.id] as [String : Any]
        ApiService().makePostApiCall(url: url, params: params) { (status, data) in
            self.controller.hideActivityIndicator()
            if let dataIn = data, status == ApiCallStatus.SUCCESS {
                print("ANSWER RESULT \(dataIn)")
                self.getQuizStatus()
            }
        }
    }
    
    //MARK: send answer
    func sendAnswer(answer: AnswerItem)  {
        let url = ApiUrl().activeBaseUrl() + "quiz/new_submit_answer/"
        let params = ["answer_id": answer.id,"question_id": self.currentQuestionId, "points": timerCount,"quiz_id": self.quiz!.id] as [String : Any]
        ApiService().makePostApiCall(url: url, params: params) { (status, data) in
            self.controller.hideActivityIndicator()
            if let dataIn = data, status == ApiCallStatus.SUCCESS {
                let responseCode = dataIn["response_code"].stringValue
                if responseCode == "100" || responseCode == "101" {
                    self.showAnswerstatus(isCorrect: responseCode == "100")
                    dataIn["results"]["answers"].forEach { (item) in
                            let quiz = self.parseAnswer(item: item.1)
                            self.feed.append(quiz)
                    }
                    let questionItem = self.parseQuestion(item: dataIn["results"])
                    self.curretnQuestionItem = questionItem
                    
                    //MARK: delay this for 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.removeQuestionView()
                        self.showQuestion()
                    }
                } else if (responseCode == "106"){
                    self.removeQuestionView()
                    print("DATA \(dataIn)")
                    let currentPrize = dataIn["current_prize"].stringValue
                    let nextPrize = dataIn["next_prize"].stringValue
                    let score = dataIn["current_total_score"].stringValue
                    let designation = dataIn["designation"].stringValue
                    let totalParticipants = dataIn["total_participants"].stringValue
                    let attemptedQuestions = dataIn["attempted_questions"].stringValue
                    let position = dataIn["position"].stringValue
                    let highScore = dataIn["high_score"].stringValue
                    
                    self.showGameOverMessageWithInfo(score: score, attempted: attemptedQuestions, highScore: highScore, price: currentPrize,
                                                     nextPrice: nextPrize, participants: totalParticipants, rank: position, designation: designation)
                    
                } else {
                   print("DATA \(dataIn)")
                   let message = dataIn["detail"].stringValue
                    ViewControllerHelper.showPrompt(vc: self, message: message, completion: { (isDone) in
                        self.removeQuestionView()
                        self.getQuizStatus()
                    })
                }
            }
        }
    }
    
    func removeQuestionView()  {
        for view in livesStackView.subviews {
            view.removeFromSuperview()
        }
        self.scoreTextLabel.removeFromSuperview()
        self.livesStackView.removeFromSuperview()
        self.questionTextLabel.removeFromSuperview()
        self.optionsCollectionView.removeFromSuperview()
        self.countDownTimeTextLabel.removeFromSuperview()
        self.answerStateImageView.removeFromSuperview()
        self.timerCount = 99
    }
    
    //MARK: show welcome page to first time users
    func showQuestion()  {
        guard let questionItem  = self.curretnQuestionItem else {
            return
        }
        self.removeQuestionView()
        
        self.timerCount = 99
        self.countDownTimeTextLabel.text = "99"
        self.currentQuestionId = questionItem.id
        
        self.prizeImageView.removeFromSuperview()
        self.startButton.removeFromSuperview()
        self.nameTextLabel.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        
        self.scrollView.addSubview(scoreTextLabel)
        self.scrollView.addSubview(livesStackView)
        self.scrollView.addSubview(questionTextLabel)
        self.scrollView.addSubview(optionsCollectionView)
        self.scrollView.addSubview(answerStateImageView)
        self.view.addSubview(countDownTimeTextLabel)
        
        self.livesStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.livesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        self.livesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        self.livesStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        for n in 1...self.livesLeft {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "LikeActive")
            self.livesStackView.addArrangedSubview(imageView)
            print("LIVES \(n)")
        }
        
        self.scoreTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32).isActive = true
        self.scoreTextLabel.trailingAnchor.constraint(equalTo: livesStackView.leadingAnchor, constant: -16).isActive = true
        self.scoreTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        self.scoreTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
               
        
        self.questionTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32).isActive = true
        self.questionTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32).isActive = true
        self.questionTextLabel.topAnchor.constraint(equalTo: livesStackView.bottomAnchor, constant: 32).isActive = true
        self.questionTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.optionsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32).isActive = true
        self.optionsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32).isActive = true
        self.optionsCollectionView.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 16).isActive = true
        self.optionsCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.optionsCollectionView.register(QuizControllerCell.self, forCellWithReuseIdentifier: feedCellId)
        if let flowLayout = optionsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
        }
        self.answerStateImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.answerStateImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        self.answerStateImageView.topAnchor.constraint(equalTo: optionsCollectionView.bottomAnchor, constant: 16).isActive = true
        self.answerStateImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
     
        self.optionsCollectionView.reloadData()
        self.questionTextLabel.text = questionItem.question
        
        self.countDownTimeTextLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.countDownTimeTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        self.countDownTimeTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.countDownTimeTextLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
      
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    //MARK: display timer
    @objc func update() {
        self.timerCount -= 1
        self.countDownTimeTextLabel.text = "\(self.timerCount)"
        //self.animateProgress()
        //MARK: timeout so proceed
        if self.timerCount <= 0 {
             self.livesLeft = 0
             self.timer.invalidate()
             self.feed.removeAll()
             self.optionsCollectionView.reloadData()
             self.controller.showActivityIndicator()
             self.gameOver()
        }
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
        self.startButton.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        self.startButton.setTitleColor(UIColor.white, for: .normal)
        
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
        let topMessage = user.fullName.formatAsAttributed(font: boldFont, color: UIColor.darkText)
        let secondMessage = "\n\n\(message)".formatAsAttributed(font: font, color: UIColor.darkGray)
        let combination = NSMutableAttributedString()
        combination.append(topMessage)
        combination.append(secondMessage)
        self.nameTextLabel.attributedText = combination
        self.nameTextLabel.textAlignment = .center
        
        guard let unwrapedItem = self.quiz else {return}
        if unwrapedItem.hasPaid {
           self.startButton.setTitle("PLAY NOW", for: .normal)
        }  else {
           self.startButton.setTitle("JOIN QUIZ", for: .normal)
        }
    }
    
    //MARK - continue paymemt
    func continuePayment()  {
        let vc = PaymentRedirectController()
        vc.url = self.payUrl
        vc.quizController = self
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    //MARK - call for refresh from other places
    func callRefresh()  {
       self.getQuizStatus()
    }
    
}

extension QuizController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! QuizControllerCell
        cell.feed = self.feed[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.answerQuestion(answer: self.feed[indexPath.row])
    }
}

class QuizControllerCell: BaseCell {
    
    var feed: AnswerItem? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.nameLabel.text = " \(unwrapedItem.answer)"
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.nameLabel.textColor = isSelected ?  UIColor.hex(hex: Key.primaryHexCode) : UIColor.white
            self.nameLabel.backgroundColor = isSelected ? UIColor.white :  UIColor.hex(hex: Key.primaryHexCode)
            self.nameBorderLabel.backgroundColor = isSelected ? UIColor.white :  UIColor.hex(hex: Key.primaryHexCode)
        }
    }
    
    let nameBorderLabel: UILabel = {
        let textView = UILabel()
        textView.layer.borderWidth = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        textView.text = ""
        return textView
    }()
    
    
    let nameLabel: UILabel = {
        let textView = UILabel()
        textView.textAlignment = .left
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
  
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        addSubview(nameBorderLabel)
        addSubview(nameLabel)
       
        self.nameBorderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.nameBorderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.nameBorderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.nameBorderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }
}


