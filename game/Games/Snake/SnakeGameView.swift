//
//  SnakeGameView.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI

struct SnakeGameView: View {
    @StateObject private var game = SnakeGame()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.2)],
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
                        Text("길이: \(game.snake.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // 게임 보드
                SnakeBoardView(game: game)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                // 게임 상태 표시
                if game.isGameOver {
                    VStack(spacing: 12) {
                        Text("게임 오버!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("최종 점수: \(game.score)")
                            .font(.headline)
                        
                        Button(action: { game.newGame() }) {
                            Text("다시 시작")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                } else {
                    // 방향 컨트롤
                    DirectionControlsView(game: game)
                        .padding(.horizontal)
                    
                    // 일시정지/재개 버튼
                    Button(action: {
                        if game.isPaused {
                            game.resume()
                        } else {
                            game.pause()
                        }
                    }) {
                        Text(game.isPaused ? "계속하기" : "일시정지")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(game.isPaused ? Color.green : Color.gray)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SnakeBoardView: View {
    @ObservedObject var game: SnakeGame
    
    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            let cellSize = boardSize / CGFloat(SnakeGame.gridSize)
            
            ZStack {
                // 배경
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.1))
                    .shadow(radius: 10)
                    .frame(width: boardSize, height: boardSize)
                
                // 그리드
                ForEach(0..<SnakeGame.gridSize, id: \.self) { row in
                    ForEach(0..<SnakeGame.gridSize, id: \.self) { col in
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: cellSize - 1, height: cellSize - 1)
                            .offset(
                                x: CGFloat(col) * cellSize + cellSize / 2 - boardSize / 2,
                                y: CGFloat(row) * cellSize + cellSize / 2 - boardSize / 2
                            )
                    }
                }
                
                // 뱀
                ForEach(Array(game.snake.enumerated()), id: \.offset) { index, position in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index == 0 ? Color.green : Color.green.opacity(0.7))
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .offset(
                            x: CGFloat(position.x) * cellSize + cellSize / 2 - boardSize / 2,
                            y: CGFloat(position.y) * cellSize + cellSize / 2 - boardSize / 2
                        )
                }
                
                // 음식
                if let food = game.food {
                    Circle()
                        .fill(Color.red)
                        .frame(width: cellSize * 0.7, height: cellSize * 0.7)
                        .shadow(color: Color.red.opacity(0.5), radius: 4)
                        .offset(
                            x: CGFloat(food.x) * cellSize + cellSize / 2 - boardSize / 2,
                            y: CGFloat(food.y) * cellSize + cellSize / 2 - boardSize / 2
                        )
                }
                
                // 일시정지 오버레이
                if game.isPaused {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.5))
                        .frame(width: boardSize, height: boardSize)
                    
                    Text("일시정지")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(width: boardSize, height: boardSize)
        }
    }
}

struct DirectionControlsView: View {
    @ObservedObject var game: SnakeGame
    
    var body: some View {
        VStack(spacing: 12) {
            // 상단 (위쪽)
            Button(action: { game.changeDirection(.up) }) {
                Image(systemName: "arrow.up")
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
            }
            
            // 중간 (좌우)
            HStack(spacing: 20) {
                Button(action: { game.changeDirection(.left) }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                }
                
                Spacer()
                    .frame(width: 60)
                
                Button(action: { game.changeDirection(.right) }) {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                }
            }
            
            // 하단 (아래쪽)
            Button(action: { game.changeDirection(.down) }) {
                Image(systemName: "arrow.down")
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        SnakeGameView()
    }
}
