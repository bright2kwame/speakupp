//
//  ZKDrawerScrollView.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

public class ZKDrawerScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    var rightWidth: CGFloat = 0
    
    var leftWidth: CGFloat = 0
    
    var mainScale: CGFloat = 1
    
    var drawerStyle: ZKDrawerCoverStyle = .cover
    
    var gestureRecognizerWidth:CGFloat = 40
    
    var shouldRequireFailureOfNavigationPopGesture: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        // use custom paging behavior instead
        self.decelerationRate = UIScrollViewDecelerationRateFast
//        self.isPagingEnabled = true
        self.panGestureRecognizer.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var needsAdjustContentOffset: Bool = true
    private var adjustPosition: ZKDrawerControllerPosition = .center
    
    func setNeedsAdjustTo(_ position: ZKDrawerControllerPosition) {
        needsAdjustContentOffset = true
        adjustPosition = position
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsAdjustContentOffset {
            switch adjustPosition {
            case .center:
                contentOffset.x = leftWidth
            case .right:
                contentOffset.x = leftWidth + rightWidth
            case .left:
                contentOffset.x = 0
            }
            needsAdjustContentOffset = false
        }
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //拿到手势生效的坐标点（相对于scrollView的内部空间）
        let point = gestureRecognizer.location(in: self)
        
        if self.contentOffset.x == 0 && leftWidth > 0 {
            //当偏移量为0时（左侧菜单完全展示）
            if point.x < self.frame.size.width {
                return true
            }
        } else if self.contentOffset.x == contentSize.width - self.frame.size.width && rightWidth > 0 {
            //当偏移量为contentSize.width时（右侧菜单完全展示）
            if point.x + self.frame.size.width > contentSize.width {
                return true
            }
        } else {
            if let pan = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = pan.velocity(in: self)
                if (point.x < leftWidth + gestureRecognizerWidth && velocity.x > 0) || (point.x > contentSize.width - rightWidth - gestureRecognizerWidth && velocity.x < 0) {
                    return true
                }
            }

        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return shouldRequireFailureOfNavigationPopGesture
        } else {
            return false
        }
    }
    
    
//    public override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
//        super.setContentOffset(contentOffset, animated: animated)
//        if animated && contentOffset != self.contentOffset {
//            self.isUserInteractionEnabled = false 
//        }
//    }
}
