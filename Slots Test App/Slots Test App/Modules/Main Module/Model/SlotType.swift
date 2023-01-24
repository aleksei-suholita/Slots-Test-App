import UIKit

enum SlotType: Int, CaseIterable {
    
    case fairy = 1
    case secret = 2
    case zeus = 3
    
    var isPopular: Bool {
        switch self {
        case .fairy:
            return true
        case .secret, .zeus:
            return false
        }
    }
    
    var iconCount: Int {
        switch self {
        case .zeus, .fairy, .secret:
            return 9
        }
    }
    
    var image: UIImage {
        return UIImage(named: "Slot-\(rawValue)")!
    }
    
    var iconNames: [String] {
        var imageNames: [String] = []
        for number in 1...iconCount {
            imageNames.append("Slot-\(rawValue)-\(number)-image.png")
        }
        return imageNames
    }
    
    var isWideCard: Bool {
        switch self {
        case .fairy:
            return true
        case .secret, .zeus:
            return false
        }
    }
    
}
