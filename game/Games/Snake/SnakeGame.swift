//
//  SnakeGame.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI
import Combine

struct Position: Hashable {
    let x: Int
    let y: Int
}

enum Direction {
    case up
    case down
    case left
    case right
}

class SnakeGame: ObservableObject {
    static let gridSize = 20
    
    @Published var snake: [Position] = []
    @Published var food: Position?
    @Published var direction: Direction = .right
    @Published var nextDirection: Direction = .right
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    private let gameSpeed: TimeInterval = 0.15
    
    init() {
        startGame()
    }
    
    func startGame() {
        reset()
        spawnFood()
        startTimer()
    }
    
    func reset() {
        // 뱀 초기 위치 (중앙)
        snake = [
            Position(x: SnakeGame.gridSize / 2, y: SnakeGame.gridSize / 2),
            Position(x: SnakeGame.gridSize / 2 - 1, y: SnakeGame.gridSize / 2),
            Position(x: SnakeGame.gridSize / 2 - 2, y: SnakeGame.gridSize / 2)
        ]
        direction = .right
        nextDirection = .right
        food = nil
        score = 0
        isGameOver = false
        isPaused = false
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
        timer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true) { [weak self] _ in
            self?.moveSnake()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func changeDirection(_ newDirection: Direction) {
        // 반대 방향으로는 갈 수 없음
        switch (direction, newDirection) {
        case (.up, .down), (.down, .up),
             (.left, .right), (.right, .left):
            return
        default:
            nextDirection = newDirection
        }
    }
    
    private func moveSnake() {
        guard !isGameOver, !isPaused else { return }
        
        direction = nextDirection
        
        // 새 머리 위치 계산
        let head = snake[0]
        var newHead: Position
        
        switch direction {
        case .up:
            newHead = Position(x: head.x, y: head.y - 1)
        case .down:
            newHead = Position(x: head.x, y: head.y + 1)
        case .left:
            newHead = Position(x: head.x - 1, y: head.y)
        case .right:
            newHead = Position(x: head.x + 1, y: head.y)
        }
        
        // 벽 충돌 체크
        if newHead.x < 0 || newHead.x >= SnakeGame.gridSize ||
           newHead.y < 0 || newHead.y >= SnakeGame.gridSize {
            gameOver()
            return
        }
        
        // 자신의 몸 충돌 체크
        if snake.contains(newHead) {
            gameOver()
            return
        }
        
        // 음식 먹기 체크
        if let food = food, newHead == food {
            snake.insert(newHead, at: 0)
            score += 10
            spawnFood()
        } else {
            snake.insert(newHead, at: 0)
            snake.removeLast()
        }
    }
    
    private func spawnFood() {
        var availablePositions: [Position] = []
        
        // 뱀이 없는 위치 찾기
        for x in 0..<SnakeGame.gridSize {
            for y in 0..<SnakeGame.gridSize {
                let pos = Position(x: x, y: y)
                if !snake.contains(pos) {
                    availablePositions.append(pos)
                }
            }
        }
        
        if let randomPosition = availablePositions.randomElement() {
            food = randomPosition
        } else {
            // 모든 공간이 차면 게임 승리
            isGameOver = true
            stopTimer()
        }
    }
    
    private func gameOver() {
        isGameOver = true
        stopTimer()
    }
    
    func newGame() {
        startGame()
    }
    
    deinit {
        stopTimer()
    }
}
