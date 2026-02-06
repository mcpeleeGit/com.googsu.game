//
//  GameMenuView.swift
//  game
//
//  Created by dongha lee on 2/6/26.
//

import SwiftUI

struct GameMenuView: View {
    @State private var selectedGame: GameType?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 헤더
                        VStack(spacing: 8) {
                            Text("🎮")
                                .font(.system(size: 60))
                            Text("캐주얼 게임 모음")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("간단하고 재미있는 게임들을 즐겨보세요")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        // 게임 목록
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(GameType.allCases, id: \.self) { gameType in
                                GameCard(gameInfo: gameType.info)
                                    .onTapGesture {
                                        selectedGame = gameType
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(item: $selectedGame) { gameType in
                gameView(for: gameType)
            }
        }
    }
    
    @ViewBuilder
    private func gameView(for gameType: GameType) -> some View {
        switch gameType {
        case .tetris:
            TetrisGameView()
        case .omok:
            OmokGameView()
        case .sudoku:
            SudokuGameView()
        case .snake:
            SnakeGameView()
        }
    }
}

struct GameCard: View {
    let gameInfo: GameInfo
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: gameInfo.icon)
                .font(.system(size: 40))
                .foregroundColor(gameInfo.color)
                .frame(height: 60)
            
            Text(gameInfo.name)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(gameInfo.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: gameInfo.color.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(gameInfo.color.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    GameMenuView()
}
