//
//  CellHelper.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 14/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit

class CellHelper {
    
    
    
    static func configureCellHeight(collectionView: UICollectionView,collectionViewLayout: UICollectionViewLayout, feed: Any) -> CGSize {
     
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.frame.width
    
        //MARK - the tab section
        if feed is String {
            return CGSize(width: itemWidth , height: 50)
        }
        
        //MARK - the brand section
        if feed is Brand || feed is CorporateItem || feed is PollAuthor || feed is PollComment || feed is SchoolItem {
           return CGSize(width: itemWidth, height: 100)
        }
        
        //MARK - the brand section
        if feed is NewsItem {
            let newsFeed = feed as! NewsItem
            if newsFeed.image.isEmpty {
                return CGSize(width: itemWidth, height: 200)
            }
            return CGSize(width: itemWidth, height: 350)
        }
        
     
        
        let bottomSectionHeight = 62.0
        let profileHeight = 82.0
        var choiceHeight = 166.0
        
        //MARK - the option section
        if feed is PollOption {
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
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
            return CGSize(width: itemWidth, height: totalHeight)
        }
        
        //MAKR - event section
        if !(feedItem?.eventTitle.isEmpty)!  {
            return CGSize(width: itemWidth, height: 300)
        }
      
        //calculate height for non image options && image cell voted
        if !(feedItem?.hasImages)! || ((feedItem?.hasImages)! && (feedItem?.hasVoted)!) {
            let numberOfOptions = (feedItem?.pollChoice.count)!
            choiceHeight = Double((48 * numberOfOptions) + 16)
        }
        
        //MARK- poll with image question
        if !(feedItem?.image.isEmpty)!  {
            let imageHeight = 266.0
            let totalHeight = CGFloat(profileHeight + imageHeight + choiceHeight + bottomSectionHeight)
            return CGSize(width: itemWidth, height: totalHeight)
        }
        
        //MARK- feed no image question
        let questionHeight = 116.0
        let totalHeight = CGFloat(profileHeight + questionHeight + choiceHeight + bottomSectionHeight)
        return CGSize(width: itemWidth, height: totalHeight)
        
    }
}
