//
//  TetrisGame.swift
//  game
//
//  Created by dongha lee on 2/6/26.
//

import SwiftUI
import Combine

class TetrisGame: ObservableObject {
    static let boardWidth = 10
    static let boardHeight = 20
    
    @Published var board: [[Color?]] = Array(repeating: Array(repeating: nil, count: boardWidth), count: boardHeight)
    @Published var currentPiece: TetrisPiece?
    @Published var score: Int = 0
    @Published var level: Int = 1
    @Published var isGameOver: Bool = false
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    private var dropInterval: TimeInterval = 1.0
    
    init() {
        startGame()
    }
    
    func startGame() {
        reset()
        spawnNewPiece()
        startTimer()
    }
    
    func reset() {
        board = Array(repeating: Array(repeating: nil, count: TetrisGame.boardWidth), count: TetrisGame.boardHeight)
        currentPiece = nil
        score = 0
        level = 1
        isGameOver = false
        isPaused = false
        dropInterval = 1.0
        stopTimer()
    }
    
    func pause() {
        isPaused = true
        stopTimer()
    }
    
    func resume() {
        isPaused = false
        startTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: dropInterval, repeats: true) { [weak self] _ in
            self?.moveDown()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func spawnNewPiece() {
        currentPiece = TetrisPiece.random()
        if !isValidPosition(currentPiece!) {
            gameOver()
        }
    }
    
    func moveLeft() {
        guard let piece = currentPiece, !isPaused, !isGameOver else { return }
        let movedPiece = piece.moved(x: -1, y: 0)
        if isValidPosition(movedPiece) {
            currentPiece = movedPiece
        }
    }
    
    func moveRight() {
        guard let piece = currentPiece, !isPaused, !isGameOver else { return }
        let movedPiece = piece.moved(x: 1, y: 0)
        if isValidPosition(movedPiece) {
            currentPiece = movedPiece
        }
    }
    
    func moveDown() {
        guard let piece = currentPiece, !isPaused, !isGameOver else { return }
        let movedPiece = piece.moved(x: 0, y: 1)
        if isValidPosition(movedPiece) {
            currentPiece = movedPiece
        } else {
            lockPiece()
        }
    }
    
    func rotate() {
        guard let piece = currentPiece, !isPaused, !isGameOver else { return }
        let rotatedPiece = piece.rotated()
        if isValidPosition(rotatedPiece) {
            currentPiece = rotatedPiece
        }
    }
    
    private func isValidPosition(_ piece: TetrisPiece) -> Bool {
        for block in piece.blocks {
            // 경계 체크
            if block.x < 0 || block.x >= TetrisGame.boardWidth ||
               block.y < 0 || block.y >= TetrisGame.boardHeight {
                return false
            }
            // 기존 블록과 충돌 체크
            if board[block.y][block.x] != nil {
                return false
            }
        }
        return true
    }
    
    private func lockPiece() {
        guard let piece = currentPiece else { return }
        
        // 블록을 보드에 고정
        for block in piece.blocks {
            board[block.y][block.x] = piece.color
        }
        
        // 완성된 라인 제거
        clearLines()
        
        // 새 블록 생성
        spawnNewPiece()
    }
    
    private func clearLines() {
        var linesToRemove: [Int] = []
        
        // 완성된 라인 찾기
        for row in 0..<TetrisGame.boardHeight {
            if board[row].allSatisfy({ $0 != nil }) {
                linesToRemove.append(row)
            }
        }
        
        // 라인 제거 및 점수 추가
        if !linesToRemove.isEmpty {
            for row in linesToRemove.reversed() {
                board.remove(at: row)
                board.insert(Array(repeating: nil, count: TetrisGame.boardWidth), at: 0)
            }
            
            // 점수 계산 (라인 수에 따라)
            let points = [0, 100, 300, 500, 800]
            let lineCount = linesToRemove.count
            score += points[min(lineCount, points.count - 1)] * (level + 1)
            
            // 레벨 업
            let newLevel = score / 1000 + 1
            if newLevel > level {
                level = newLevel
                dropInterval = max(0.1, 1.0 - Double(level - 1) * 0.1)
                startTimer()
            }
        }
    }
    
    private func gameOver() {
        isGameOver = true
        stopTimer()
    }
    
    deinit {
        stopTimer()
    }
}

// MARK: - Tetris Piece

struct Block: Hashable {
    let x: Int
    let y: Int
}

struct TetrisPiece {
    let blocks: [Block]
    let color: Color
    let center: Block
    
    static func random() -> TetrisPiece {
        let shapes: [TetrisPiece] = [
            // I 모양
            TetrisPiece(
                blocks: [Block(x: 0, y: 0), Block(x: 1, y: 0), Block(x: 2, y: 0), Block(x: 3, y: 0)],
                color: .cyan,
                center: Block(x: 1, y: 0)
            ),
            // O 모양
            TetrisPiece(
                blocks: [Block(x: 0, y: 0), Block(x: 1, y: 0), Block(x: 0, y: 1), Block(x: 1, y: 1)],
                color: .yellow,
                center: Block(x: 0, y: 0)
            ),
            // T 모양
            TetrisPiece(
                blocks: [Block(x: 1, y: 0), Block(x: 0, y: 1), Block(x: 1, y: 1), Block(x: 2, y: 1)],
                color: .purple,
                center: Block(x: 1, y: 1)
            ),
            // S 모양
            TetrisPiece(
                blocks: [Block(x: 1, y: 0), Block(x: 2, y: 0), Block(x: 0, y: 1), Block(x: 1, y: 1)],
                color: .green,
                center: Block(x: 1, y: 1)
            ),
            // Z 모양
            TetrisPiece(
                blocks: [Block(x: 0, y: 0), Block(x: 1, y: 0), Block(x: 1, y: 1), Block(x: 2, y: 1)],
                color: .red,
                center: Block(x: 1, y: 1)
            ),
            // J 모양
            TetrisPiece(
                blocks: [Block(x: 0, y: 0), Block(x: 0, y: 1), Block(x: 1, y: 1), Block(x: 2, y: 1)],
                color: .blue,
                center: Block(x: 1, y: 1)
            ),
            // L 모양
            TetrisPiece(
                blocks: [Block(x: 2, y: 0), Block(x: 0, y: 1), Block(x: 1, y: 1), Block(x: 2, y: 1)],
                color: .orange,
                center: Block(x: 1, y: 1)
            )
        ]
        return shapes.randomElement()!
    }
    
    func moved(x: Int, y: Int) -> TetrisPiece {
        TetrisPiece(
            blocks: blocks.map { Block(x: $0.x + x, y: $0.y + y) },
            color: color,
            center: Block(x: center.x + x, y: center.y + y)
        )
    }
    
    func rotated() -> TetrisPiece {
        // 중심점 기준으로 90도 회전
        let rotatedBlocks = blocks.map { block -> Block in
            let dx = block.x - center.x
            let dy = block.y - center.y
            // 90도 회전: (x, y) -> (-y, x)
            return Block(x: center.x - dy, y: center.y + dx)
        }
        return TetrisPiece(blocks: rotatedBlocks, color: color, center: center)
    }
}
