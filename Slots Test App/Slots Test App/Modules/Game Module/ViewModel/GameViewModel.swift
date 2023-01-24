import Foundation

protocol GameViewModelProtocol: AnyObject {
    
    var viewModelDidChange: ((GameViewModelProtocol) -> Void)? { get set }
    var bet: Int { get set }
    var lastGameText: String { get }
    init(slotType: SlotType)
    func getAccount() -> Int
    func updateBet(isPlus: Bool)
    func imageNameForCell(at index: IndexPath) -> String
    func getNumberColumns() -> Int
    func getNumberRows() -> Int
    func spin()
    
}

class GameViewModel: GameViewModelProtocol {
    
    // MARK: - Instance Properties
    
    struct Constants {
        static let betStep = 10
    }
    
    var isSpinAvailable: Bool { bet < getAccount() }
    var viewModelDidChange: ((GameViewModelProtocol) -> Void)?
    var slotData: SlotData
    var bet: Int
    var lastGameText = "WIN: 0" { didSet {  } }
    
    // MARK: - Object Lifecycle
    
    required init(slotType: SlotType) {
        self.slotData = SlotData(slotType: slotType)
        bet = 50
    }
    
    // MARK: - Internal Methods
    
    func getAccount() -> Int {
        return AccountService.instance.getAccount()
    }
    
    func updateBet(isPlus: Bool) {
        if isPlus {
            bet += Constants.betStep
            viewModelDidChange?(self)
        } else if bet > Constants.betStep {
            bet -= Constants.betStep
            viewModelDidChange?(self)
        }
    }
    
    func getNumberColumns() -> Int {
        return slotData.columns
    }
    
    func getNumberRows() -> Int {
        return slotData.rows
    }
    
    func spin() {
        if AccountService.instance.tryDebit(bet) {
            slotData.generateRandomGrid()
            let winCount = slotData.getCountOfWinCombinations()
            _ = AccountService.instance.tryDeposit(bet * winCount * 2)
            lastGameText = winCount > 0 ? "WIN: \(bet * winCount)" : "LOSE: \(bet)"
            viewModelDidChange?(self)
        }
    }
    
    func imageNameForCell(at index: IndexPath) -> String {
        slotData.getImageNameByIndex(row: index.row, column: index.section)
    }
}
