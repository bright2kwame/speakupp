//
//  BaseFeedCell.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 29/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import AlamofireImage
import AHAudioPlayer


class BaseFeedCell: BaseCell {
    var choices = [PollChoice]()
    let radioCellId = "feedCellId"
    let imageCellId = "menuCellId"
    let pollAnsweredCell = "pollAnsweredCellId"
    let pollAnsweredWithImageCell = "PollAnsweredWithImageCell"
    let pollAudioCell = "pollAudioCell"
    var choiceCollectionTopConsraint: NSLayoutConstraint?
    var homeCell: HomeCell?
    var searchController: SearchController?
    var pollsController: PollsController?
    
    
    var feed: Poll? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.likeButton.setTitle("\(Mics.suffixNumber(numberInt: unwrapedItem.numOfLikes))", for: .normal)
            self.commentButton.setTitle("\(Mics.suffixNumber(numberInt: unwrapedItem.numOfComments))", for: .normal)
            self.pollTypeLabel.text = unwrapedItem.pollType.formatPollType().uppercased()
            self.nameLabel.text = unwrapedItem.author?.username
            self.dateTimeLabel.text = "\(unwrapedItem.elapsedTime)\n\(unwrapedItem.expiryDate)"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let nsNumber = NSNumber(value: unwrapedItem.totalVotes)
            let message = (unwrapedItem.totalVotes == 1) ? "vote cast." : "votes cast."
            self.allVotesCountLabel.text = "\(numberFormatter.string(from: nsNumber)!) \(message)"
            //MARK- like configuration
            if unwrapedItem.hasLiked {
                self.likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
                self.likeButton.setTitleColor(UIColor.hex(hex: Key.primaryHexCode), for: .normal)
            }   else {
                self.likeButton.setImage(UIImage(named: "Like"), for: .normal)
                self.likeButton.setTitleColor(UIColor.darkGray, for: .normal)
            }
            if let author = unwrapedItem.author {
                if  !(author.profile.isEmpty) {
                    self.profileImageView.af_setImage(
                        withURL: URL(string: (author.profile))!,
                        placeholderImage: Mics.placeHolder(),
                        imageTransition: .crossDissolve(0.2)
                )}
            }
            
            //question image
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 0.5
            shadow.shadowOffset = CGSize(width: 0.2, height: 0.2)
            shadow.shadowColor = UIColor.black
            let myAttribute = [ NSAttributedStringKey.shadow: shadow ]
            let myAttrString = NSAttributedString(string: unwrapedItem.question, attributes: myAttribute)
            self.imageQuestionLabel.attributedText = myAttrString
            
            self.noImageQuestionLabel.text = unwrapedItem.question
            if  !(unwrapedItem.image.isEmpty) {
                //update constraing
                self.choiceCollectionTopConsraint?.isActive = false
                self.choiceCollectionTopConsraint = choiceCollectionView.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 8)
                self.choiceCollectionTopConsraint?.isActive = true
                //end here
                
                self.noImageQuestionLabel.isHidden = true
                self.imageQuestionLabel.isHidden = false
                self.questionCoverView.isHidden = false
                self.questionImageView.af_setImage(
                    withURL: URL(string: (unwrapedItem.image))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )}else {
                //update constraing
                self.choiceCollectionTopConsraint?.isActive = false
                self.choiceCollectionTopConsraint = choiceCollectionView.topAnchor.constraint(equalTo: noImageQuestionLabel.bottomAnchor, constant: 8)
                self.choiceCollectionTopConsraint?.isActive = true
                //end here
              self.noImageQuestionLabel.isHidden = false
              self.imageQuestionLabel.isHidden = true
              self.questionCoverView.isHidden = true
            }
            
            self.choices.append(contentsOf: unwrapedItem.pollChoice)
            if let flowLayout = choiceCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.minimumLineSpacing = 5
                if unwrapedItem.hasVoted || !unwrapedItem.hasImages {
                     flowLayout.scrollDirection = .vertical
                } else {
                     flowLayout.scrollDirection = .horizontal
                }
            }
            self.choiceCollectionView.reloadData()
        }
    }
    

    let shareButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "Share"), for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setImage(UIImage(named:"Comment"), for: .normal)
        button.setTitle("**", for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = ViewControllerHelper.plainImageButton()
        button.tintColor = UIColor.hex(hex: Key.primaryHexCode)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "Like"), for: .normal)
        button.setTitle("**", for: .normal)
        return button
    }()
    
    let dividerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.groupTableViewBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageQuestionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.white
        return textView
    }()
    
    let noImageQuestionLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let dateTimeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let pollTypeLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .center
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.red
        return textView
    }()
    
    lazy var questionCoverView:  UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0.6
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let allVotesCountLabel: UILabel = {
        let textView = ViewControllerHelper.baseLabel()
        textView.textAlignment = .left
        textView.text = "*******"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    lazy var choiceCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func setUpView() {
        super.setUpView()
        backgroundColor = UIColor.white
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(dateTimeLabel)
        self.addSubview(pollTypeLabel)
        self.addSubview(noImageQuestionLabel)
        self.addSubview(questionImageView)
        self.addSubview(questionCoverView)
        self.addSubview(imageQuestionLabel)
        self.addSubview(choiceCollectionView)
        self.addSubview(allVotesCountLabel)
        self.addSubview(dividerView)
        
        
        self.profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.pollTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.pollTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.pollTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pollTypeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: pollTypeLabel.leadingAnchor, constant: -8).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.dateTimeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        self.dateTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        self.dateTimeLabel.trailingAnchor.constraint(equalTo: pollTypeLabel.leadingAnchor, constant: -8).isActive = true
        self.dateTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.questionImageView.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 16).isActive = true
        self.questionImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.questionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        self.imageQuestionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        self.imageQuestionLabel.centerXAnchor.constraint(equalTo: questionImageView.centerXAnchor).isActive = true
        self.imageQuestionLabel.bottomAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 0).isActive = true
        self.imageQuestionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.imageQuestionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        
        self.questionCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        self.questionCoverView.centerXAnchor.constraint(equalTo: questionImageView.centerXAnchor).isActive = true
        self.questionCoverView.bottomAnchor.constraint(equalTo: questionImageView.bottomAnchor).isActive = true
        self.questionCoverView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.questionCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        self.noImageQuestionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.noImageQuestionLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 16).isActive = true
        self.noImageQuestionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.noImageQuestionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        self.choiceCollectionTopConsraint = choiceCollectionView.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 8)
        self.choiceCollectionTopConsraint?.isActive = true
        self.choiceCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.choiceCollectionView.bottomAnchor.constraint(equalTo: allVotesCountLabel.topAnchor, constant: -8).isActive = true
        self.choiceCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.choiceCollectionView.register(PollNoImageChoiceCell.self, forCellWithReuseIdentifier: radioCellId)
        self.choiceCollectionView.register(PollImageChoiceCell.self, forCellWithReuseIdentifier: imageCellId)
        self.choiceCollectionView.register(PollAnsweredCell.self, forCellWithReuseIdentifier: pollAnsweredCell)
        self.choiceCollectionView.register(PollAnsweredWithImageCell.self, forCellWithReuseIdentifier: pollAnsweredWithImageCell)
        self.choiceCollectionView.register(PollAudioChoiceCell.self, forCellWithReuseIdentifier: pollAudioCell)
        
        
        let container = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        container.distribution = .fillEqually
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
        
        container.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
       
        
        self.allVotesCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        self.allVotesCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.allVotesCountLabel.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -8).isActive = true
        self.allVotesCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.dividerView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -8).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.af_cancelImageRequest()
        self.profileImageView.layer.removeAllAnimations()
        self.profileImageView.image = nil
        
        self.questionImageView.af_cancelImageRequest()
        self.questionImageView.layer.removeAllAnimations()
        self.questionImageView.image = nil
        
        self.choices.removeAll()
    
    }
}

extension BaseFeedCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = self.choices[indexPath.row]
        if  (feed.poll?.hasVoted)! {
            
            if (feed.poll?.hasImages)! {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pollAnsweredWithImageCell, for: indexPath) as! PollAnsweredWithImageCell
                cell.feed = feed
                return cell
                
            } else {
                //take care of the image voted cells
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pollAnsweredCell, for: indexPath) as! PollAnsweredCell
                cell.feed = feed
                return cell
            }
            
        } else if !feed.image.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PollImageChoiceCell
            cell.feed = feed
            
            //cast vote for image ballot
            let tappedContent = UITapGestureRecognizer(target: self, action: #selector(self.vote(_:)))
            cell.acceptImageView.isUserInteractionEnabled = true
            cell.acceptImageView.tag = indexPath.row
            cell.acceptImageView.addGestureRecognizer(tappedContent)
            
            //cancel attempt here
            let tappedRejectContent = UITapGestureRecognizer(target: self, action: #selector(self.rejectVote(_:)))
            cell.rejectImageView.isUserInteractionEnabled = true
            cell.rejectImageView.tag = indexPath.row
            cell.rejectImageView.addGestureRecognizer(tappedRejectContent)
            
            return cell
        }/** else if !feed.audio.isEmpty {
            //MARK - audio cell section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pollAudioCell, for: indexPath) as! PollAudioChoiceCell
            cell.feed = feed
            
            //cast vote for image ballot
            let tappedContent = UITapGestureRecognizer(target: self, action: #selector(self.vote(_:)))
            cell.optionImageView.isUserInteractionEnabled = true
            cell.optionImageView.tag = indexPath.row
            cell.optionImageView.addGestureRecognizer(tappedContent)
            
            //play answer audio here
            let playContent = UITapGestureRecognizer(target: self, action: #selector(self.playAudio(_:)))
            cell.playImageView.isUserInteractionEnabled = true
            cell.playImageView.tag = indexPath.row
            cell.playImageView.addGestureRecognizer(playContent)
            
            return cell
        }**/else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: radioCellId, for: indexPath) as! PollNoImageChoiceCell
            cell.feed = feed
            
            //vote for non image ballot
            let tappedContent = UITapGestureRecognizer(target: self, action: #selector(self.vote(_:)))
            cell.contentView.isUserInteractionEnabled = true
            cell.contentView.tag = indexPath.row
            cell.contentView.addGestureRecognizer(tappedContent)
            return cell
        }
    }
    
    @objc func playAudio(_ sender: UITapGestureRecognizer) {
        let feed = self.choices[(sender.view?.tag)!]
        print("AUDIO \(feed.audio)")
        AHAudioPlayerManager.shared.stop()
        let url = URL(string: feed.audio)
        AHAudioPlayerManager.shared.play(trackId: 0, trackURL: url!)
      
    }
    
    @objc func vote(_ sender: UITapGestureRecognizer) {
        let feed = self.choices[(sender.view?.tag)!]
        self.homeCell?.castVote(pollId: (feed.poll?.id)!, choiceId: feed.id)
        self.searchController?.castVote(pollId: (feed.poll?.id)!, choiceId: feed.id)
        self.pollsController?.castVote(pollId: (feed.poll?.id)!, choiceId: feed.id)
    }
    
    @objc func rejectVote(_ sender: UITapGestureRecognizer) {
        let feed = self.choices[(sender.view?.tag)!]
        self.homeCell?.rejectVote(pollId: (feed.poll?.id)!)
        self.searchController?.rejectVote(pollId: (feed.poll?.id)!)
        self.pollsController?.rejectVote(pollId: (feed.poll?.id)!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feed = self.choices[indexPath.row]
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        if (feed.poll?.hasVoted)! {
            return CGSize(width: itemWidth - contentInset, height: 40)
        }
        if !feed.image.isEmpty {
            return CGSize(width: collectionView.frame.height - contentInset, height: collectionView.frame.height)
        }
        return CGSize(width: itemWidth - contentInset, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func scrollToMenuIndex(menuIndex: Int)  {
        let selectedIndexPath = IndexPath(item: menuIndex, section: 0)
        self.choiceCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

