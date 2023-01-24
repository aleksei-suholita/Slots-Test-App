import Foundation

final class AccountService {
    
    // MARK: - Private Properties
    
    private let defaults = UserDefaults.standard
    private let accountKey = "user-account"
    
    // MARK: - Properties
    
    private var account: Int {
        get {
            defaults.integer(forKey: accountKey)
        } set {
            defaults.set(newValue, forKey: accountKey)
        }
    }
    
    // MARK: - Singleton & init
    
    static let instance = AccountService()
    
    private init() { }
    
    // MARK: - Methods
    
    func getAccount() -> Int { return account }
    
    func tryDeposit(_ sum: Int) -> Bool {
        if sum > 0 {
            account += sum
            return true
        }
        return false
    }
    
    func tryDebit(_ sum: Int) -> Bool {
        if account > sum && sum > 0 {
            account -= sum
            return true
        }
        return false
    }
    
}
