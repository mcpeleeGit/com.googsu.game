//
//  Game.swift
//  game
//
//  Created by dongha lee on 2/6/26.
//

import SwiftUI

/// 게임 프로토콜 - 모든 게임이 구현해야 하는 인터페이스
protocol Game {
    var id: String { get }
    var name: String { get }
    var icon: String { get }
    var color: Color { get }
    var description: String { get }
}

/// 게임 뷰 프로토콜 - 게임 화면을 표시하는 뷰
protocol GameView: View {
    associatedtype GameType: Game
    var game: GameType { get }
}

/// 게임 정보 구조체
struct GameInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GameInfo, rhs: GameInfo) -> Bool {
        lhs.id == rhs.id
    }
}

/// 게임 타입 열거형
enum GameType: String, CaseIterable, Hashable {
    case tetris = "tetris"
    case omok = "omok"
    case sudoku = "sudoku"
    case snake = "snake"
    
    var info: GameInfo {
        switch self {
        case .tetris:
            return GameInfo(
                id: "tetris",
                name: "테트리스",
                icon: "square.stack.3d.up",
                color: .blue,
                description: "클래식 테트리스 게임"
            )
        case .omok:
            return GameInfo(
                id: "omok",
                name: "오목",
                icon: "circle.grid.3x3",
                color: .brown,
                description: "5개 연속으로 놓기"
            )
        case .sudoku:
            return GameInfo(
                id: "sudoku",
                name: "스도쿠",
                icon: "number.square",
                color: .green,
                description: "숫자 퍼즐 게임"
            )
        case .snake:
            return GameInfo(
                id: "snake",
                name: "스네이크",
                icon: "figure.walk",
                color: .orange,
                description: "뱀 게임"
            )
        }
    }
}
