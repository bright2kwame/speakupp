//
//  CellHelper.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class CellHelper {
    
    
    
    static func configureCellHeight(collectionView: UICollectionView,  feed: Any) -> CGSize {
        let contentInset = collectionView.contentInset.left * 2
        let itemWidth = collectionView.frame.width
        //MARK - the tab section
        if feed is String {
            return CGSize(width: itemWidth - contentInset, height: 50)
        }
        
        //MARK - the brand section
        if feed is Brand  {
           return CGSize(width: itemWidth - contentInset, height: 100)
        }
        
        let bottomSectionHeight = 62.0
        let profileHeight = 82.0
        let choiceHeight = 166.0
        let feedItem = feed as? Poll
        //MAKK- rating section
        if feedItem?.pollType == "rating"  {
            var starAndLabelHeight = 100.0
            let questionHeight = 116.0
            let imageHeight = 266.0
            //for unrated poll adjust the height
            if !((feedItem?.hasVoted)!){
                starAndLabelHeight = 30.0
            }
            let totalHeight = CGFloat(profileHeight + imageHeight + bottomSectionHeight + questionHeight + starAndLabelHeight)
            return CGSize(width: itemWidth - contentInset, height: totalHeight)
        }
        
        //MAKR - event section
        if !(feedItem?.eventTitle.isEmpty)!  {
            return CGSize(width: itemWidth - contentInset, height: 300)
        }
    
        //MARK- feed with image question
        if !(feedItem?.image.isEmpty)!  {
            let imageHeight = 266.0
            let totalHeight = CGFloat(profileHeight + imageHeight + choiceHeight + bottomSectionHeight)
            return CGSize(width: itemWidth - contentInset, height: totalHeight)
        }
        //MARK- feed no image question
        let questionHeight = 116.0
        let totalHeight = CGFloat(profileHeight + questionHeight + choiceHeight + bottomSectionHeight)
        return CGSize(width: itemWidth - contentInset, height: totalHeight)
        
    }
}
