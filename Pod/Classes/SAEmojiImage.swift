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
        label.isOpaque = false
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.clear
        label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let image = SAEmojiImage.image(from: label)
        
        self.init(cgImage: image.cgImage!)
    }
    
    class func image(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: image!.cgImage!)
    }
    
}
