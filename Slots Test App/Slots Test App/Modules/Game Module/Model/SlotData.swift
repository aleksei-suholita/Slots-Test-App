struct SlotData {
    
    // MARK: - Internal Properties
    
    private(set) var slotType: SlotType
    private(set) var grid: [[Int]]
    private(set) var rows: Int = 3
    private(set) var columns: Int = 5
    
    // MARK: - Object Lifecycle
    
    init(slotType: SlotType) {
        self.slotType = slotType
        grid = []
        generateRandomGrid()
    }
    
    // MARK: - Internal Methods
    
    mutating func generateRandomGrid() {
        grid = []
        for _ in 0..<rows {
            var row: [Int] = []
            for _ in 0..<columns {
                row.append(Int.random(in: 0..<slotType.iconCount))
            }
            grid.append(row)
        }
    }
    
    func getImageNameByIndex(row: Int, column: Int) -> String {
        return slotType.iconNames[grid[row][column]]
    }
    
    func getCountOfWinCombinations() -> Int {
        var count = 0
        for row in 0..<rows {
            var win = true
            let firstNum = grid[row][0]
            for column in 1..<columns where grid[row][column] != firstNum {
                win = false
                break
            }
            count += win ? 1 : 0
        }
        
        let checkFromFirst: [[Int]] = [[grid[1][1], grid[2][2], grid[1][3], grid[0][4]],
                                       [grid[0][1], grid[1][2], grid[2][3], grid[2][4]],
                                       [grid[1][1], grid[0][2], grid[1][3], grid[0][4]],
                                       [grid[1][1], grid[1][2], grid[1][3], grid[0][4]],
                                       [grid[0][1], grid[0][2], grid[1][3], grid[2][4]]]
        checkFromFirst.forEach { count += $0.filter { $0 == grid[0][0] }.count == $0.count ? 1 : 0 }
        
        let checkFromSecond: [[Int]] = [[grid[0][1], grid[1][2], grid[2][3], grid[1][4]],
                                        [grid[2][1], grid[1][2], grid[0][3], grid[1][4]],
                                        [grid[0][1], grid[0][2], grid[0][3], grid[1][4]],
                                        [grid[2][1], grid[2][2], grid[2][3], grid[1][4]],
                                        [grid[1][1], grid[0][2], grid[1][3], grid[1][4]]]
        checkFromSecond.forEach { count += $0.filter { $0 == grid[1][0] }.count == $0.count ? 1 : 0 }
        
        let checkFromThird: [[Int]] = [[grid[1][1], grid[0][2], grid[1][3], grid[2][4]],
                                       [grid[2][1], grid[1][2], grid[0][3], grid[0][4]],
                                       [grid[1][1], grid[2][2], grid[1][3], grid[2][4]],
                                       [grid[1][1], grid[1][2], grid[1][3], grid[2][4]],
                                       [grid[2][1], grid[2][2], grid[1][3], grid[0][4]]]
        checkFromThird.forEach { count += $0.filter { $0 == grid[2][0] }.count == $0.count ? 1 : 0 }
        return count
    }
    
}
