//
//  TetrisGameView.swift
//  game
//
//  Created by dongha lee on 2/6/26.
//

import SwiftUI

struct TetrisGameView: View {
    @StateObject private var game = TetrisGame()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 헤더
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("점수: \(game.score)")
                            .font(.headline)
                        Text("레벨: \(game.level)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // 게임 보드
                GameBoardView(game: game)
                    .aspectRatio(0.5, contentMode: .fit)
                    .padding()
                
                // 컨트롤 버튼
                GameControlsView(game: game)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct GameBoardView: View {
    @ObservedObject var game: TetrisGame
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(
                geometry.size.width / CGFloat(TetrisGame.boardWidth),
                geometry.size.height / CGFloat(TetrisGame.boardHeight)
            )
            
            ZStack {
                // 배경 그리드
                ForEach(0..<TetrisGame.boardHeight, id: \.self) { row in
                    ForEach(0..<TetrisGame.boardWidth, id: \.self) { col in
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: cellSize - 1, height: cellSize - 1)
                            .position(
                                x: CGFloat(col) * cellSize + cellSize / 2,
                                y: CGFloat(row) * cellSize + cellSize / 2
                            )
                    }
                }
                
                // 고정된 블록들
                ForEach(0..<TetrisGame.boardHeight, id: \.self) { row in
                    ForEach(0..<TetrisGame.boardWidth, id: \.self) { col in
                        if let color = game.board[row][col] {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color)
                                .frame(width: cellSize - 2, height: cellSize - 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .position(
                                    x: CGFloat(col) * cellSize + cellSize / 2,
                                    y: CGFloat(row) * cellSize + cellSize / 2
                                )
                        }
                    }
                }
                
                // 현재 떨어지는 블록
                if let currentPiece = game.currentPiece {
                    ForEach(currentPiece.blocks, id: \.self) { block in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(currentPiece.color)
                            .frame(width: cellSize - 2, height: cellSize - 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                            .position(
                                x: CGFloat(block.x) * cellSize + cellSize / 2,
                                y: CGFloat(block.y) * cellSize + cellSize / 2
                            )
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    let horizontal = value.translation.width
                    let vertical = value.translation.height
                    
                    if abs(horizontal) > abs(vertical) {
                        if horizontal > 0 {
                            game.moveRight()
                        } else {
                            game.moveLeft()
                        }
                    } else {
                        if vertical > 0 {
                            game.moveDown()
                        } else {
                            game.rotate()
                        }
                    }
                }
        )
    }
}

struct GameControlsView: View {
    @ObservedObject var game: TetrisGame
    
    var body: some View {
        VStack(spacing: 16) {
            // 상단 컨트롤 (회전, 아래로)
            HStack(spacing: 20) {
                Button(action: { game.rotate() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: { game.moveDown() }) {
                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .clipShape(Circle())
                }
            }
            
            // 하단 컨트롤 (좌, 우)
            HStack(spacing: 20) {
                Button(action: { game.moveLeft() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: { game.moveRight() }) {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .clipShape(Circle())
                }
            }
            
            // 게임 상태 버튼
            if game.isGameOver {
                Button(action: { game.reset() }) {
                    Text("다시 시작")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            } else if game.isPaused {
                Button(action: { game.resume() }) {
                    Text("계속하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
            } else {
                Button(action: { game.pause() }) {
                    Text("일시정지")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TetrisGameView()
    }
}
