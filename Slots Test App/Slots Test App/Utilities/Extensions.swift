import UIKit
import SpriteKit

// MARK: - UIImage

extension UIImage {
    
    static func gradientImage(withBounds: CGRect, colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = withBounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

// MARK: - SKLabelNode

extension SKLabelNode {
    
    func adjustLabelFontSizeToFitRect(rectOf size: CGSize, multiplier: CGFloat = 1, maxFontSize: Int? = nil) {
        let scalingFactor = min(size.width / frame.width, size.height / frame.height)
        fontSize = floor(fontSize * scalingFactor * multiplier)
        
    }
    
}

// MARK: - SKTexture

extension SKTexture {
    
    func getAdjustedTextureSize(rect: CGSize, multiplier: CGFloat = 1) -> CGSize {
        let scalingFactor = min(rect.width / size().width, rect.height / size().height) * multiplier
        return CGSize(width: size().width * scalingFactor, height: size().height * scalingFactor)
    }
    
}
