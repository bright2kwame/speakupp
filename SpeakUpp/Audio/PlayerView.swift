//
//  PlayerView.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/03/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import EFAutoScrollLabel
import AHAudioPlayer

class PlayerView: BaseUIView {
    var timer:Timer? = nil
    var playerItem: PlayerItem?
    var delegate: PlayerDelegate?
    
    var audioArt: String?{
        didSet {
            guard let unwrapedItem = audioArt else {return}
            if  !(unwrapedItem.isEmpty) {
                self.imageView.af_setImage(
                    withURL: URL(string: (unwrapedItem))!,
                    placeholderImage: Mics.placeHolder(),
                    imageTransition: .crossDissolve(0.2)
                )
            }
        }
    }
    
    let imageView: UIImageView = {
        let imageView = ViewControllerHelper.baseImageView()
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "AppIcon")
        imageView.image = image
        return imageView
    }()
    
    let bgImageView: UIImageView = {
        let imageView = ViewControllerHelper.baseImageView()
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "AudioWave")
        imageView.image = image
        return imageView
    }()
    
    lazy var closeImageView: UIImageView = {
        let imageView = ViewControllerHelper.baseImageView()
        imageView.image = UIImage(named: "CloseCross")
        imageView.contentMode = .scaleAspectFit
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.stopPlayer(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tappedImageView)
        return imageView
    }()
    
    lazy var playPauseImageView: UIImageView = {
        let imageView = ViewControllerHelper.baseImageView()
        imageView.image = UIImage(named: "Play")
        imageView.contentMode = .scaleAspectFit
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(self.playPause(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tappedImageView)
        return imageView
    }()
    
    let titleTextLabel: EFAutoScrollLabel = {
        let label = ViewControllerHelper.baseScrollingLabel()
        return label
    }()
    
    let progressTextLabel: EFAutoScrollLabel = {
        let label = ViewControllerHelper.baseScrollingLabel()
        return label
    }()
    
    let progressUIView: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progress = 0
        progressBar.trackTintColor = UIColor.hex(hex: Key.primaryHexCode)
        progressBar.tintColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        progressBar.backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        progressBar.layer.borderWidth = 0
        progressBar.layer.borderColor = UIColor.hex(hex: Key.primaryHexCode).cgColor
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    


    override func setUpLayout() {
        super.setUpLayout()
        backgroundColor = UIColor.hex(hex: Key.primaryHexCode)
        
        addSubview(bgImageView)
        addSubview(imageView)
        addSubview(titleTextLabel)
        addSubview(closeImageView)
        addSubview(playPauseImageView)
        addSubview(progressUIView)
        addSubview(progressTextLabel)
        
        
        self.bgImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.bgImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.bgImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.bgImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        self.progressUIView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.progressUIView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.progressUIView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.progressUIView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        self.imageView.topAnchor.constraint(equalTo: progressUIView.bottomAnchor, constant: 4).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.closeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.closeImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.closeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.closeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.playPauseImageView.trailingAnchor.constraint(equalTo: closeImageView.leadingAnchor, constant: -8).isActive = true
        self.playPauseImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.playPauseImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.playPauseImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.titleTextLabel.trailingAnchor.constraint(equalTo: playPauseImageView.leadingAnchor, constant: -4).isActive = true
        self.titleTextLabel.bottomAnchor.constraint(equalTo: progressTextLabel.topAnchor, constant: -2).isActive = true
        self.titleTextLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        self.titleTextLabel.topAnchor.constraint(equalTo: progressUIView.bottomAnchor, constant: 2).isActive = true
        
        self.progressTextLabel.trailingAnchor.constraint(equalTo: playPauseImageView.leadingAnchor, constant: -4).isActive = true
        self.progressTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        self.progressTextLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        self.progressTextLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    
    
    @objc func playPause(_ sender: UITapGestureRecognizer){
        if let _ = self.playerItem {
            let image = UIImage(named: "Play")
            if self.playPauseImageView.image == image {
                self.playAudio()
            }   else {
                self.playPauseImageView.image =  UIImage(named: "Play")
                AHAudioPlayerManager.shared.stop()
            }
        }
    }
    
    func playAudio()  {
        AHAudioPlayerManager.shared.stop()
        self.playPauseImageView.image =  UIImage(named: "Play")
        if let item = self.playerItem {
            self.titleTextLabel.text = item.audioTitle
            let url = URL(string: item.audioUrl)
            AHAudioPlayerManager.shared.play(trackId: item.audioId, trackURL: url!)
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(updatePlayer), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .commonModes)
            self.playPauseImageView.image =  UIImage(named: "Pause")
        }
    }
    
    @objc func updatePlayer() {
        let loadedProgress = CGFloat(AHAudioPlayerManager.shared.loadedProgress)
        let progress = AHAudioPlayerManager.shared.progress
        let currentTime = AHAudioPlayerManager.shared.currentTimePretty
        let duration = AHAudioPlayerManager.shared.durationPretty
        let _ = AHAudioPlayerManager.shared.rate.rawValue > 0 ? "\(AHAudioPlayerManager.shared.rate.rawValue)x" : "1.0x"
        
        if loadedProgress != 1.0 {
          self.progressTextLabel.text = "Loading ..."
        } else {
          self.progressTextLabel.text = "\(duration) : \(currentTime)"
          self.progressUIView.progress = Float(progress)
        }
        if progress == 0.0 {
           self.playPauseImageView.image =  UIImage(named: "Play")
        }  else {
           self.playPauseImageView.image =  UIImage(named: "Pause")
        }
        //print("STATS \(loadedProgress) \(progress) \(currentTime) \(duration) \(speedStr)")
    }
    
    @objc func stopPlayer(_ sender: UITapGestureRecognizer) {
       AHAudioPlayerManager.shared.stop()
       self.delegate?.closePlayer()
    }
}
