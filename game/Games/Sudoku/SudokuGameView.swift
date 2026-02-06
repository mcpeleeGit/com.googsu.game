//
//  SudokuGameView.swift
//  game
//
//  Created by donghalee on 2/6/26.
//

import SwiftUI

struct SudokuGameView: View {
    @StateObject private var game = SudokuGame()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color.green.opacity(0.2), Color.mint.opacity(0.2)],
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
                        Text("실수: \(game.mistakes)")
                            .font(.headline)
                            .foregroundColor(game.mistakes > 0 ? .red : .primary)
                    }
                }
                .padding()
                
                // 게임 보드
                SudokuBoardView(game: game)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                // 숫자 입력 패드
                NumberPadView(game: game)
                    .padding(.horizontal)
                
                // 새 게임 버튼
                Button(action: { 
                    game.generateNewGame()
                }) {
                    Text("새 게임")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("축하합니다!", isPresented: .constant(game.isComplete)) {
            Button("새 게임") {
                game.generateNewGame()
            }
            Button("확인", role: .cancel) { }
        } message: {
            Text("스도쿠를 완성했습니다!")
        }
    }
}

struct SudokuBoardView: View {
    @ObservedObject var game: SudokuGame
    
    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            let cellSize = boardSize / CGFloat(SudokuGame.size)
            let boxSize = cellSize * CGFloat(SudokuGame.boxSize)
            
            ZStack {
                // 배경
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 10)
                    .frame(width: boardSize, height: boardSize)
                
                // 박스 배경 (3x3)
                ForEach(0..<SudokuGame.boxSize, id: \.self) { boxRow in
                    ForEach(0..<SudokuGame.boxSize, id: \.self) { boxCol in
                        Rectangle()
                            .fill((boxRow + boxCol) % 2 == 0 ? Color.gray.opacity(0.05) : Color.gray.opacity(0.1))
                            .frame(width: boxSize, height: boxSize)
                            .offset(
                                x: CGFloat(boxCol) * boxSize + boxSize / 2 - boardSize / 2,
                                y: CGFloat(boxRow) * boxSize + boxSize / 2 - boardSize / 2
                            )
                    }
                }
                
                // 셀들
                VStack(spacing: 0) {
                    ForEach(0..<SudokuGame.size, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<SudokuGame.size, id: \.self) { col in
                                let cell = game.cells[row][col]
                                let isSelected = game.selectedCell?.row == row && game.selectedCell?.col == col
                                
                                ZStack {
                                    Rectangle()
                                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                                        .frame(width: cellSize, height: cellSize)
                                    
                                    // 박스 경계선 강조
                                    if col % SudokuGame.boxSize == 0 {
                                        Rectangle()
                                            .fill(Color.primary.opacity(0.2))
                                            .frame(width: 1, height: cellSize)
                                            .offset(x: -cellSize / 2)
                                    }
                                    if row % SudokuGame.boxSize == 0 {
                                        Rectangle()
                                            .fill(Color.primary.opacity(0.2))
                                            .frame(width: cellSize, height: 1)
                                            .offset(y: -cellSize / 2)
                                    }
                                    
                                    // 숫자
                                    Text(cell.displayValue)
                                        .font(.system(size: cellSize * 0.4, weight: cell.isFixed ? .bold : .regular))
                                        .foregroundColor(cell.isFixed ? .primary : .blue)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    game.selectCell(row: row, col: col)
                                }
                            }
                        }
                    }
                }
                .frame(width: boardSize, height: boardSize)
                
                // 외곽 경계선
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                    .frame(width: boardSize, height: boardSize)
            }
            .frame(width: boardSize, height: boardSize)
        }
    }
}

struct NumberPadView: View {
    @ObservedObject var game: SudokuGame
    
    var body: some View {
        VStack(spacing: 12) {
            // 숫자 버튼
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                        game.setValue(number)
                    }) {
                        Text("\(number)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
            
            // 지우기 버튼
            HStack {
                Button(action: {
                    game.clearCell()
                }) {
                    HStack {
                        Image(systemName: "delete.left")
                        Text("지우기")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SudokuGameView()
    }
}
