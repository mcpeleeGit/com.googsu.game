//
//  OmokGameView.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI

struct OmokGameView: View {
    @StateObject private var game = OmokGame()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color.brown.opacity(0.2), Color.orange.opacity(0.2)],
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
                        HStack(spacing: 16) {
                            VStack(spacing: 2) {
                                Text("흑")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(game.blackScore)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            
                            VStack(spacing: 2) {
                                Text("백")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(game.whiteScore)")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
                
                // 현재 플레이어 표시
                if game.gameOver, let winner = game.winner {
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(winner == .black ? Color.black : Color.white)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(winner == .white ? Color.black : Color.clear, lineWidth: 2)
                                )
                            
                            Text(winner == .black ? "흑돌 승리!" : "백돌 승리!")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Button(action: { 
                            game.newGame()
                        }) {
                            Text("새 게임")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brown)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                } else {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(game.currentPlayer == .black ? Color.black : Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(game.currentPlayer == .white ? Color.black : Color.clear, lineWidth: 2)
                            )
                        
                        Text(game.currentPlayer == .black ? "흑돌 차례" : "백돌 차례")
                            .font(.headline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                }
                
                // 게임 보드
                OmokBoardView(game: game)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                // 새 게임 버튼
                Button(action: { 
                    game.newGame()
                }) {
                    Text("새 게임")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown.opacity(0.8))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OmokBoardView: View {
    @ObservedObject var game: OmokGame
    
    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            let cellSize = boardSize / CGFloat(OmokGame.boardSize)
            let lineWidth: CGFloat = 1
            
            ZStack {
                // 보드 배경
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.96, green: 0.87, blue: 0.70))
                    .shadow(radius: 10)
                    .frame(width: boardSize, height: boardSize)
                
                // 격자선
                // 세로선
                ForEach(0..<OmokGame.boardSize, id: \.self) { col in
                    Path { path in
                        let x = CGFloat(col) * cellSize + cellSize / 2
                        path.move(to: CGPoint(x: x, y: cellSize / 2))
                        path.addLine(to: CGPoint(x: x, y: boardSize - cellSize / 2))
                    }
                    .stroke(Color.brown.opacity(0.5), lineWidth: lineWidth)
                }
                
                // 가로선
                ForEach(0..<OmokGame.boardSize, id: \.self) { row in
                    Path { path in
                        let y = CGFloat(row) * cellSize + cellSize / 2
                        path.move(to: CGPoint(x: cellSize / 2, y: y))
                        path.addLine(to: CGPoint(x: boardSize - cellSize / 2, y: y))
                    }
                    .stroke(Color.brown.opacity(0.5), lineWidth: lineWidth)
                }
                
                // 셀 그리드 (터치 영역)
                VStack(spacing: 0) {
                    ForEach(0..<OmokGame.boardSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<OmokGame.boardSize, id: \.self) { col in
                                ZStack {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: cellSize, height: cellSize)
                                    
                                    // 돌 표시
                                    let stone = game.board[row][col]
                                    if stone != .none, let color = stone.color {
                                        Circle()
                                            .fill(color)
                                            .frame(width: cellSize * 0.85, height: cellSize * 0.85)
                                            .overlay(
                                                Circle()
                                                    .stroke(stone == .white ? Color.black.opacity(0.3) : Color.clear, lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    game.placeStone(row: row, col: col)
                                }
                            }
                        }
                    }
                }
                .frame(width: boardSize, height: boardSize)
            }
            .frame(width: boardSize, height: boardSize)
        }
    }
}

#Preview {
    NavigationStack {
        OmokGameView()
    }
}
