//
//  SudokuGame.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI
import Combine

struct Cell: Identifiable {
    let id = UUID()
    var value: Int?
    var isFixed: Bool = false
    var row: Int
    var col: Int
    
    var displayValue: String {
        value.map { String($0) } ?? ""
    }
}

class SudokuGame: ObservableObject {
    static let size = 9
    static let boxSize = 3
    
    @Published var cells: [[Cell]] = []
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var isComplete: Bool = false
    @Published var mistakes: Int = 0
    
    private var solution: [[Int]] = []
    
    init() {
        generateNewGame()
    }
    
    func generateNewGame() {
        // 간단한 스도쿠 퍼즐 생성 (난이도: 중간)
        solution = generateSolution()
        cells = createPuzzle(from: solution, difficulty: 0.4) // 40% 채워진 상태
        isComplete = false
        mistakes = 0
        selectedCell = nil
    }
    
    private func generateSolution() -> [[Int]] {
        // 간단한 유효한 스도쿠 솔루션 생성
        var grid = Array(repeating: Array(repeating: 0, count: SudokuGame.size), count: SudokuGame.size)
        
        // 대각선 박스들을 먼저 채움 (서로 독립적이므로)
        fillDiagonalBoxes(&grid)
        
        // 나머지 셀 채우기
        solveSudoku(&grid)
        
        return grid
    }
    
    private func fillDiagonalBoxes(_ grid: inout [[Int]]) {
        for box in 0..<SudokuGame.boxSize {
            fillBox(&grid, box * SudokuGame.boxSize, box * SudokuGame.boxSize)
        }
    }
    
    private func fillBox(_ grid: inout [[Int]], _ row: Int, _ col: Int) {
        var numbers = Array(1...SudokuGame.size).shuffled()
        var index = 0
        
        for i in 0..<SudokuGame.boxSize {
            for j in 0..<SudokuGame.boxSize {
                grid[row + i][col + j] = numbers[index]
                index += 1
            }
        }
    }
    
    private func solveSudoku(_ grid: inout [[Int]]) -> Bool {
        for row in 0..<SudokuGame.size {
            for col in 0..<SudokuGame.size {
                if grid[row][col] == 0 {
                    let numbers = Array(1...SudokuGame.size).shuffled()
                    for num in numbers {
                        if isValid(grid, row, col, num) {
                            grid[row][col] = num
                            if solveSudoku(&grid) {
                                return true
                            }
                            grid[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    private func isValid(_ grid: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        // 행 체크
        for c in 0..<SudokuGame.size {
            if grid[row][c] == num { return false }
        }
        
        // 열 체크
        for r in 0..<SudokuGame.size {
            if grid[r][col] == num { return false }
        }
        
        // 박스 체크
        let boxRow = (row / SudokuGame.boxSize) * SudokuGame.boxSize
        let boxCol = (col / SudokuGame.boxSize) * SudokuGame.boxSize
        for r in boxRow..<boxRow + SudokuGame.boxSize {
            for c in boxCol..<boxCol + SudokuGame.boxSize {
                if grid[r][c] == num { return false }
            }
        }
        
        return true
    }
    
    private func createPuzzle(from solution: [[Int]], difficulty: Double) -> [[Cell]] {
        var puzzle: [[Cell]] = []
        
        for row in 0..<SudokuGame.size {
            var rowCells: [Cell] = []
            for col in 0..<SudokuGame.size {
                let shouldShow = Double.random(in: 0...1) < difficulty
                rowCells.append(Cell(
                    value: shouldShow ? solution[row][col] : nil,
                    isFixed: shouldShow,
                    row: row,
                    col: col
                ))
            }
            puzzle.append(rowCells)
        }
        
        return puzzle
    }
    
    func selectCell(row: Int, col: Int) {
        if !cells[row][col].isFixed {
            selectedCell = (row, col)
        }
    }
    
    func setValue(_ value: Int?) {
        guard let (row, col) = selectedCell,
              !cells[row][col].isFixed else { return }
        
        // 유효성 검사
        if let value = value {
            if !isValidMove(row: row, col: col, value: value) {
                mistakes += 1
                return
            }
        }
        
        cells[row][col].value = value
        checkCompletion()
    }
    
    private func isValidMove(row: Int, col: Int, value: Int) -> Bool {
        // 행 체크
        for c in 0..<SudokuGame.size {
            if c != col, cells[row][c].value == value {
                return false
            }
        }
        
        // 열 체크
        for r in 0..<SudokuGame.size {
            if r != row, cells[r][col].value == value {
                return false
            }
        }
        
        // 박스 체크
        let boxRow = (row / SudokuGame.boxSize) * SudokuGame.boxSize
        let boxCol = (col / SudokuGame.boxSize) * SudokuGame.boxSize
        for r in boxRow..<boxRow + SudokuGame.boxSize {
            for c in boxCol..<boxCol + SudokuGame.boxSize {
                if r != row || c != col {
                    if cells[r][c].value == value {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    private func checkCompletion() {
        for row in 0..<SudokuGame.size {
            for col in 0..<SudokuGame.size {
                if cells[row][col].value == nil {
                    isComplete = false
                    return
                }
            }
        }
        isComplete = true
    }
    
    func clearCell() {
        setValue(nil)
    }
}
