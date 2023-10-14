//
//  ScoreViewModel.swift
//  RockPaperScissors
//
//  Created by Roman Lantsov on 14.10.2023.
//

import Foundation

protocol ScoreViewModelProtocol: AnyObject {
    var computer: String { get }
    var player: String { get }
    var playerName: String? { get }
    var computerScore: String? { get }
    var playerScore: String? { get }
    
    var scoreSettingsDidChange: ((ScoreViewModelProtocol) -> Void)? { get set }
    
    init()
    
    func showScoreSettings()
    func setScore()
    func setPlayer(name: String)
}

final class ScoreViewModel: ScoreViewModelProtocol {
    var computer = "🤖"
    var player = "🤪"
    
    var playerName: String? {
        didSet {
            scoreSettingsDidChange?(self)
        }
    }
    
    var computerScore: String? {
        didSet {
            scoreSettingsDidChange?(self)
        }
    }
    
    var playerScore: String? {
        didSet {
            scoreSettingsDidChange?(self)
        }
    }
    
    private let storageManager = StorageManager.shared
    var scoreSettingsDidChange: ((ScoreViewModelProtocol) -> Void)?
    
    required init() {}
    
    //MARK: - Methods
    func showScoreSettings() {
        storageManager.loadScores()
        setScore()
    }
    
    func setScore() {
        playerScore = String(storageManager.highPlayerScore)
        computerScore = String(storageManager.highComputerScore)
        playerName = "Hello, \(storageManager.playerName)"
    }
    
    func setPlayer(name: String) {
        storageManager.playerName = name
        storageManager.savePlayerName()
        playerName = "Hello, \(storageManager.playerName)"
    }
}
