import UIKit

final class AppUtility {
    
    // MARK: - Singleton & init
    
    static let instance = AppUtility()
    
    private init() { }
    
    // MARK: - Methods
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
}
