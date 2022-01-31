//
//  ContentView.swift
//  TheBrickGame
//
//  Created by François-Xavier Méité on 30/01/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @AppStorage("BestScore") var bestScore = 0
    @StateObject private var gameScene = GameScene()
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
            VStack(alignment: .leading){
                Text("Lvl: \(gameScene.level)")
                    .font((.system(size: 20, weight: .heavy, design: .rounded)))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.top)
                
                Text("Score: \(gameScene.score)")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if gameScene.isGameOver {
                VStack {
                    Text("💀 Game Over 💀")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading)
                    if gameScene.score > bestScore {
                        Text("🔥 New Highest Score 🔥")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading)
                        Text("\(gameScene.score)")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading)
                    }
                    Text("Play Again")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding()
                        .onTapGesture {
                            if gameScene.score > bestScore {
                                bestScore = gameScene.score
                            }
                            gameScene.isGameOver.toggle()
                            gameScene.makeBall()
                            gameScene.makeBricks()
                            gameScene.score = 0
                        }
                }
            }
            
            
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
