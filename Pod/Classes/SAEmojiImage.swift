//
//  SAEmojiImage.swift
//  Pods
//
//  Created by Finnsch on 11/12/16.
//
//

import UIKit

internal class SAEmojiImage: UIImage {
    
    convenience init(emoji: String, size: CGSize) {
        let label = UILabel()
        label.font = UIFont(name: "AppleColorEmoji", size: size.height)
        label.text = emoji
        label.opaque = false
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.clearColor()
        label.frame = CGRectMake(0, 0, size.width, size.height)
        
        let image = SAEmojiImage.image(from: label)
        
        self.init(CGImage: image.CGImage!)
    }
    
    class func image(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(CGImage: image!.CGImage!)
    }
    
}
