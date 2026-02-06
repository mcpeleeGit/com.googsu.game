//
//  OmokGame.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI
import Combine

enum Stone: Equatable {
    case none
    case black
    case white
    
    var color: Color? {
        switch self {
        case .black: return .black
        case .white: return .white
        case .none: return nil
        }
    }
}

class OmokGame: ObservableObject {
    static let boardSize = 15
    
    @Published var board: [[Stone]] = Array(repeating: Array(repeating: .none, count: boardSize), count: boardSize)
    @Published var currentPlayer: Stone = .black
    @Published var winner: Stone? = nil
    @Published var gameOver: Bool = false
    @Published var blackScore: Int = 0
    @Published var whiteScore: Int = 0
    
    init() {
        reset()
    }
    
    func reset() {
        // 모든 상태를 명시적으로 초기화
        board = Array(repeating: Array(repeating: .none, count: OmokGame.boardSize), count: OmokGame.boardSize)
        currentPlayer = .black
        winner = nil
        gameOver = false
        
        // UI 업데이트를 강제하기 위해 objectWillChange 발행
        objectWillChange.send()
    }
    
    func placeStone(row: Int, col: Int) {
        guard !gameOver,
              row >= 0 && row < OmokGame.boardSize,
              col >= 0 && col < OmokGame.boardSize,
              board[row][col] == .none else {
            return
        }
        
        board[row][col] = currentPlayer
        
        if checkWin(row: row, col: col) {
            winner = currentPlayer
            gameOver = true
            if currentPlayer == .black {
                blackScore += 1
            } else {
                whiteScore += 1
            }
        } else {
            // 다음 플레이어로 전환
            currentPlayer = currentPlayer == .black ? .white : .black
        }
    }
    
    private func checkWin(row: Int, col: Int) -> Bool {
        let player = board[row][col]
        guard player != .none else { return false }
        
        // 방향: 가로, 세로, 대각선(왼쪽 위->오른쪽 아래), 대각선(오른쪽 위->왼쪽 아래)
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]
        
        for (dx, dy) in directions {
            var count = 1 // 현재 위치 포함
            
            // 양방향으로 확인
            for direction in [-1, 1] {
                var checkRow = row
                var checkCol = col
                
                for _ in 1..<5 {
                    checkRow += dx * direction
                    checkCol += dy * direction
                    
                    if checkRow >= 0 && checkRow < OmokGame.boardSize &&
                       checkCol >= 0 && checkCol < OmokGame.boardSize &&
                       board[checkRow][checkCol] == player {
                        count += 1
                    } else {
                        break
                    }
                }
            }
            
            if count >= 5 {
                return true
            }
        }
        
        return false
    }
    
    func newGame() {
        reset()
    }
}
