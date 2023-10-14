//
//  ViewModel.swift
//  RockPaperScissors
//
//  Created by Roman Lantsov on 14.10.2023.
//

import Foundation

enum Winner {
    case player
    case computer
    case equally
    case initial
}

protocol MainViewModelProtocol: AnyObject {
    var resultLabel: String? { get }
    var scoreLabel: String? { get }
    var computerChoiсe: String? { get }
    var buttonsIsActive: Bool { get }
    var whoWon: Winner { get }
    
    var gameSettingsDidChange: ((MainViewModelProtocol) -> Void)? { get set }
    
    init()
    func showGameSettings()
    func compareResult(with yourChoice: String)
    func reloadScore()
    func showScore(in view: Any?)
}

final class MainViewModel: MainViewModelProtocol {
    
    private let gameTools = ["🪨", "✂️", "🧻"]
    private var computerScore = 0
    private var yourScore = 0
    
    private let storageManager = StorageManager.shared
    
    var resultLabel: String? {
        didSet {
            gameSettingsDidChange?(self)
        }
    }
    
    var scoreLabel: String? {
        didSet {
            gameSettingsDidChange?(self)
        }
    }
    
    var computerChoiсe: String? {
        didSet {
            gameSettingsDidChange?(self)
        }
    }
    
    var buttonsIsActive: Bool  = true {
        didSet {
            gameSettingsDidChange?(self)
        }
    }
    
    var whoWon: Winner  = .initial {
        didSet {
            gameSettingsDidChange?(self)
        }
    }
    
    var gameSettingsDidChange: ((MainViewModelProtocol) -> Void)?
    
    required init() {}
    
    //MARK: - Methods
    func showGameSettings() {
        resultLabel = "Choice Rock or Paper or Scissors"
        scoreLabel = "AI - 0:0 - You"
        computerChoiсe = "🤖"
        storageManager.loadScores()
    }
    
    func reloadScore() {
        buttonsIsActive = true
        computerScore = 0
        yourScore = 0
        whoWon = .initial
        resultLabel = "Choice Rock or Paper or Scissors"
        scoreLabel = "AI - \(computerScore):\(yourScore) - You"
    }
    
    func compareResult(with yourChoice: String) {
        let randomValue = Int.random(in: 0...2)
        let randomComputerChoice = gameTools[randomValue]
        computerChoiсe = randomComputerChoice
        
        switch yourChoice {
        case "🪨":
            if randomComputerChoice == "✂️" {
                resultLabel = "You Won!"
                whoWon = .player
                yourScore += 1
            } else if randomComputerChoice == "🧻" {
                resultLabel = "You Lost!"
                whoWon = .computer
                computerScore += 1
            } else {
                resultLabel = "Equally!"
                whoWon = .equally
            }
        case "✂️":
            if randomComputerChoice == "🧻" {
                resultLabel = "You Won!"
                whoWon = .player
                yourScore += 1
            } else if randomComputerChoice == "🪨" {
                resultLabel = "You Lost!"
                whoWon = .computer
                computerScore += 1
            } else {
                resultLabel = "Equally!"
                whoWon = .equally
            }
        case "🧻":
            if randomComputerChoice == "🪨" {
                resultLabel = "You Won!"
                whoWon = .player
                yourScore += 1
            } else if randomComputerChoice == "✂️" {
                resultLabel = "You Lost!"
                whoWon = .computer
                computerScore += 1
            } else {
                resultLabel = "Equally!"
                whoWon = .equally
            }
        default:
            break
        }
        
        if yourScore == 3 && yourScore > computerScore {
            resultLabel = "Congratulation, You Won Totally! 🤪"
            reloadLocalScore()
            storageManager.highPlayerScore += 1
            storageManager.savePlayerScore()
        } else if computerScore == 3 && computerScore > yourScore {
            resultLabel = "Unfortunately, You Lost! 🥹"
            reloadLocalScore()
            storageManager.highComputerScore += 1
            storageManager.saveComputerScore()
        } else {
            scoreLabel = "AI - \(computerScore):\(yourScore) - You"
            reloadComputerInfo(with: "Choice Rock or Paper or Scissors", andDelay: 1)
        }
    }
    
    private func reloadLocalScore() {
        scoreLabel = "AI - \(computerScore):\(yourScore) - You"
        computerScore = 0
        yourScore = 0
        buttonsIsActive = false
        reloadComputerInfo(with: "Tap play again for restart game", andDelay: 2)
    }
    
    private func reloadComputerInfo(with text: String, andDelay: Int) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(andDelay)) { [unowned self] in
                self.resultLabel = text
                whoWon = .initial
                self.computerChoiсe = "🤖"
        }
    }
    
    func showScore(in view: Any?) {
        let view = view as? MainViewController
        let vc = ScoreViewController()
        
        if !(view?.navigationController!.topViewController! is ScoreViewController) {
            view.self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

