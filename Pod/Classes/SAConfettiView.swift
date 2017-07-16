//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

open class SAConfettiView: UIView {
    
    public enum ConfettiType {
        case confetti
        case triangle
        case star
        case diamond
        case emoji(String)
        case image(UIImage)
    }
    
    public enum ConfettiFactory {
        /// Creates confetti for each type without coloring
        case types([ConfettiType])
        /// Creates random confetti for each color
        case colorsAndTypes([UIColor], [ConfettiType])
        /// Creates confetti for each type with random coloring
        case typesAndColors([ConfettiType], [UIColor])
    }
    
    var emitter: CAEmitterLayer!
    open var intensity: Float = 0.5
    open var factory: ConfettiFactory = .colorsAndTypes([
        UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)
        ], [.confetti])
    fileprivate var active: Bool = false
    
    open func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        
        switch factory {
        case .types(let types):
            for type in types {
                cells.append(confetti(type))
            }
        case .colorsAndTypes(let colors, let types):
            for color in colors {
                let type = randomElement(from: types) ?? .confetti
                cells.append(confetti(type, with: color))
            }
        case .typesAndColors(let types, let colors):
            for type in types {
                let color = randomElement(from: colors)
                cells.append(confetti(type, with: color))
            }
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    open func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func imageForType(_ type: ConfettiType) -> UIImage? {
        
        var fileName: String!
        
        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .emoji(emoji):
            return SAEmojiImage(emoji: emoji, size: CGSize(width: 40, height: 40))
        case let .image(customImage):
            return customImage
        }
        
        let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle")
        let bundle = Bundle(path: path!)
        let imagePath = bundle?.path(forResource: fileName, ofType: "png")
        let url = URL(fileURLWithPath: imagePath!)
        let data = try? Data(contentsOf: url)
        if let data = data {
            return UIImage(data: data)!
        }
        return nil
    }
    
    func confetti(_ type: ConfettiType, with color: UIColor? = nil) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
        if let color = color {
            confetti.color = color.cgColor
        }
        
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type)!.cgImage
        return confetti
    }
    
    open func isActive() -> Bool {
        return self.active
    }
    
    // MARK: Helpers
    
    func randomElement<T>(from array: [T]) -> T? {
        guard array.count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(array.count)))
        return array[index]
    }
}
