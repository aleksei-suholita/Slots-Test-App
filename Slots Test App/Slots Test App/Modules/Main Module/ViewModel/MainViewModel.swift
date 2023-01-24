import Foundation

protocol MainViewModelProtocol: AnyObject {
    
    var viewModelDidChange: ((MainViewModelProtocol) -> Void)? { get set }
    func getAccount() -> Int
    func getCategories() -> [SlotCategory]
    func getCategoryNames() -> [String]
    func getChoosenCategory() -> SlotCategory
    func getSlotsCount() -> Int
    func getChoosenCategoryIndex() -> Int
    func setChoosenCategoryIndex(_ newValue: Int) -> Bool
    
}

final class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var viewModelDidChange: ((MainViewModelProtocol) -> Void)?
    
    // MARK: - Private Properties
    
    private var choosenCategoryIndex: Int = 0
    
    // MARK: - Internal Methods
    
    func getCategories() -> [SlotCategory] {
        return SlotCategory.allCases
    }
    
    func getAccount() -> Int {
        return AccountService.instance.getAccount()
    }
    
    func getCategoryNames() -> [String] {
        return getCategories().map { $0.name }
    }
    
    func getChoosenCategory() -> SlotCategory {
        return getCategories()[choosenCategoryIndex]
    }
    
    func getSlotsCount() -> Int {
        return getChoosenCategory().slots.count
    }
    
    func getChoosenCategoryIndex() -> Int {
        return choosenCategoryIndex
    }
    
    func setChoosenCategoryIndex(_ newValue: Int) -> Bool {
        guard newValue >= 0 && newValue < getCategories().count else { return false }
        choosenCategoryIndex = newValue
        viewModelDidChange?(self)
        return true
    }
    
}
