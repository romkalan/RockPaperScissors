//
//  StorageManager.swift
//  RockPaperScissors
//
//  Created by Roman Lantsov on 13.10.2023.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let playerKey = "playerScore"
    private let playerNameKey = "player"
    private let computerKey = "computerScore"
    
    var highPlayerScore: Int = 0
    var highComputerScore: Int = 0
    var playerName: String = "Player"
    
    private init() {}
    
    func savePlayerScore() {
        userDefaults.set(highPlayerScore, forKey: playerKey)
        userDefaults.synchronize()
    }
    
    func savePlayerName() {
        userDefaults.set(playerName, forKey: playerNameKey)
        userDefaults.synchronize()
    }
    
    func saveComputerScore() {
        userDefaults.set(highComputerScore, forKey: computerKey)
        userDefaults.synchronize()
    }
    
    func loadScores() {
        guard userDefaults.value(forKey: playerKey) != nil else { return }
        highPlayerScore = userDefaults.integer(forKey: playerKey)
        
        guard userDefaults.value(forKey: computerKey) != nil else { return }
        highComputerScore = userDefaults.integer(forKey: computerKey)
        
        guard userDefaults.value(forKey: playerNameKey) != nil else { return }
        playerName = userDefaults.string(forKey: playerNameKey) ?? ""
    }
}
