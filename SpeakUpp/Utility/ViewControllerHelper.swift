//
//  ViewControllerHelper.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import SafariServices
import ZKDrawerController
import Lightbox
import Alamofire
import EFAutoScrollLabel
import Answers
import Cosmos



class ViewControllerHelper {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    func showActivityIndicator() {
        if let window = UIApplication.shared.keyWindow {
            container.frame = window.frame
            container.center = window.center
            container.backgroundColor = UIColor.hexStringToUIColor(hex: "0xffffff", alpha: 0.3)
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = window.center
            loadingView.backgroundColor = UIColor.hexStringToUIColor(hex: "0x444444", alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
            
            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            window.addSubview(container)
            activityIndicator.startAnimating()
            
            self.container.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.container.alpha = 1
            })
        }
        
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
   
    static func baseField() -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .left
        textField.textColor = UIColor.white
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.backgroundColor = UIColor.clear
        textField.text = ""
        textField.borderStyle = UITextBorderStyle.none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func mainBaseField(placeHolder:String) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.textColor = UIColor.white
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0)
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextBorderStyle.none
        textField.attributedPlaceholder =  NSAttributedString(string: placeHolder,
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    
    static func baseLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.backgroundColor = UIColor.clear
        label.text = ""
        label.minimumScaleFactor = 0.2
        label.lineBreakMode = .byClipping
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func baseScrollingLabel() -> EFAutoScrollLabel {
        let label = EFAutoScrollLabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.labelSpacing = 30                       // Distance between start and end labels
        label.pauseInterval = 1.7                     // Seconds of pause before scrolling starts again
        label.scrollSpeed = 30                        // Pixels per second
        label.textAlignment = NSTextAlignment.left    // Centers text when no auto-scrolling is applied
        label.fadeLength = 12                         // Length of the left and right edge fade, 0 to disable
        label.scrollDirection = EFAutoScrollDirection.Left
        label.observeApplicationNotifications()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    
    static func baseUISwitch() -> UISwitch {
        let uiSwitchIn = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        uiSwitchIn.isOn = false
        uiSwitchIn.onTintColor = UIColor.hex(hex: Key.primaryHexCode)
        uiSwitchIn.tintColor = UIColor.hex(hex: Key.backgroundColor)
        uiSwitchIn.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitchIn
    }
    
    
    static func baseButton() -> UIButton {
        let button = UIButton()
        let color = UIColor.hex(hex: Key.primaryHexCode)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.darkGray, for: .normal)
        let spacing = CGFloat(10)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, spacing)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func whiteBaseButton() -> UIButton {
        let button = UIButton()
        let color = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.darkGray, for: .normal)
        let spacing = CGFloat(10)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, spacing)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    
    static func plainButton() -> UIButton {
        let button = UIButton()
        let color = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func plainImageButton() -> UIButton {
        let button = UIButton()
        let color = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2,left: 10,bottom: 2,right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 5,left: 30,bottom: 5,right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func baseRatingView() -> CosmosView {
        let cosmosView = CosmosView()
        cosmosView.rating = 5
        cosmosView.settings.updateOnTouch = true
        cosmosView.settings.fillMode = .full
        cosmosView.settings.starSize = 30
        cosmosView.settings.starMargin = 5
        cosmosView.settings.filledColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.settings.emptyBorderColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.settings.filledBorderColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        return cosmosView
    }
    
    
    static func tempButton() -> UIButton {
        let button = UIButton()
        let color = UIColor.hex(hex: Key.backgroundColor)
        button.titleLabel?.font = UIFont(name: "RobotoRegular", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = color
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        let spacing = CGFloat(10)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0)
        return button
    }
    
    static func baseImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    
    static func placeCall(phone:String){
        let formatedNumber = phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        guard let number = URL(string: "telprompt://" + formatedNumber) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(number)
        }
    }
    
    static func openLink(url:String,vc: UIViewController){
        if let requestUrl = NSURL(string: url) {
            let svc = SFSafariViewController(url: requestUrl as URL)
            vc.present(svc, animated: true, completion: nil)
            //UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    static func showPrompt(vc: UIViewController,message: String) {
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertView = UIAlertController(title: "SpeakUpp", message: message, preferredStyle: .alert)
        alertView.addAction(alertAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    static func showPrompt(vc: UIViewController,message: String, completion: @escaping (Bool)-> ()) {
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {(Alert:UIAlertAction!) -> Void in
            completion(true)
        })
        let alertView = UIAlertController(title: "SpeakUpp", message: message, preferredStyle: .alert)
        alertView.addAction(alertAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    static func showAlert(vc: UIViewController,message: String,type:MessageType){
        let view = vc.view!
        view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
        view.dodo.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.dodo.style.leftButton.icon = .close
        view.dodo.style.leftButton.onTap = { /* Button tapped */ }
        view.dodo.style.leftButton.hideOnTap = true
        switch type {
        case .failed:
            view.dodo.error(message)
        case .info:
             view.dodo.info(message)
        case .success:
            view.dodo.success(message)
        case .warning:
            view.dodo.warning(message)
        }
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            view.dodo.hide()
        }
    }
    
    
    static func startHome(controller:UIViewController) -> ZKDrawerController {
            let drawer = ZKDrawerController(center: UINavigationController(rootViewController: controller), right: nil, left: nil)
            drawer.defaultRightWidth = 280
            drawer.defaultLeftWidth = 280
            drawer.shadowWidth = 5
            drawer.gestureRecognizerWidth = 40
            drawer.mainScale = 0.7
            drawer.backgroundImageView.backgroundColor = UIColor.white
            drawer.drawerStyle = .insert
            return drawer
        
    }
    
    static func presentSingleImage(targetVC: UIViewController,url:String)  {
        if url.isEmpty {
            return
        }
        let images = [
            LightboxImage(imageURL: URL(string: url)!)
        ]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        targetVC.present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: sharing -- present sharing screen
    static func presentSharer(targetVC: UIViewController,message:String){
        let link = "https://www.speakupp.com/download_app/"
        var sharingContent = [AnyObject]()
        sharingContent.append(message as AnyObject)
        sharingContent.append(link as AnyObject)
        let activityViewController = UIActivityViewController(activityItems: sharingContent, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = targetVC.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        targetVC.present(activityViewController, animated: true, completion: nil)
    }
    
    static func trackUsage(id:String?,title:String,data:[String:Any]?,type: String = "Text")  {
        Answers.logCustomEvent(withName: title, customAttributes: data)
        if let itemId = id {
            Answers.logContentView(withName: title, contentType: type, contentId: itemId, customAttributes: data)
        }
    }
    
}
