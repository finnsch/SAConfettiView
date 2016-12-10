//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

public class SAConfettiView: UIView {
    
    public enum ConfettiType {
        case Confetti
        case Triangle
        case Star
        case Diamond
        case Image(UIImage)
    }
    
    public enum ConfettiFactory {
        /// Creates confetti for each type without coloring
        case Types([ConfettiType])
        /// Creates random confetti for each color
        case ColorsAndTypes([UIColor], [ConfettiType])
        /// Creates confetti for each type with random coloring
        case TypesAndColors([ConfettiType], [UIColor])
    }
    
    var emitter: CAEmitterLayer!
    public var intensity: Float = 0.5
    public var factory: ConfettiFactory = .ColorsAndTypes([
        UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)
        ], [.Confetti])
    private var active: Bool = false
    
    public func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        
        switch factory {
        case .Types(let types):
            for type in types {
                cells.append(confetti(type))
            }
        case .ColorsAndTypes(let colors, let types):
            for color in colors {
                let type = randomElement(from: types) ?? .Confetti
                cells.append(confetti(type, with: color))
            }
        case .TypesAndColors(let types, let colors):
            for type in types {
                let color = randomElement(from: colors)
                cells.append(confetti(type, with: color))
            }
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func imageForType(type: ConfettiType) -> UIImage? {
        
        var fileName: String!
        
        switch type {
        case .Confetti:
            fileName = "confetti"
        case .Triangle:
            fileName = "triangle"
        case .Star:
            fileName = "star"
        case .Diamond:
            fileName = "diamond"
        case let .Image(customImage):
            return customImage
        }
        
        let path = NSBundle(forClass: SAConfettiView.self).pathForResource("SAConfettiView", ofType: "bundle")
        let bundle = NSBundle(path: path!)
        let imagePath = bundle?.pathForResource(fileName, ofType: "png")
        let url = NSURL(fileURLWithPath: imagePath!)
        let data = NSData(contentsOfURL: url)
        if let data = data {
            return UIImage(data: data)!
        }
        return nil
    }
    
    func confetti(type: ConfettiType, with color: UIColor? = nil) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
        if let color = color {
            confetti.color = color.CGColor
        }
        
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(M_PI)
        confetti.emissionRange = CGFloat(M_PI_4)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type)!.CGImage
        return confetti
    }
    
    public func isActive() -> Bool {
        return self.active
    }
    
    // MARK: Helpers
    
    func randomElement<T>(from array: [T]) -> T? {
        guard array.count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(array.count)))
        return array[index]
    }
}
