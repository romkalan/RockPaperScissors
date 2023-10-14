//
//  ScoreViewController.swift
//  RockPaperScissors
//
//  Created by Roman Lantsov on 13.10.2023.
//

import UIKit

final class ScoreViewController: UIViewController {
    
    var viewModel: ScoreViewModelProtocol! {
        didSet {
            self.viewModel.scoreSettingsDidChange = { [unowned self] viewModel in
                self.computer.text = viewModel.computer
                self.player.text = viewModel.player
                
                self.playerNameLabel.text = viewModel.playerName
                self.playerScoreLabel.text = viewModel.playerScore
                self.computerScoreLabel.text = viewModel.computerScore
            }
        }
    }
    
    private let storageManager = StorageManager.shared
    
    private lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var computer: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.font = UIFont.systemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var computerScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playerScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var player: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.font = UIFont.systemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeNameButton: UIButton = {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 20)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString("Change player name", attributes: attributes)
        
        let button = UIButton(
            configuration: buttonConfiguration,
            primaryAction: UIAction { [unowned self] _ in
                self.showAlert(withTitle: "Player Name", andMessage: "Please, write your name")
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        viewModel = ScoreViewModel()
        viewModel.showScoreSettings()
    }
}

// MARK: - Alert Controller
private extension ScoreViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let saveAction = UIAlertAction(title: "Save Name", style: .default) { [unowned self] action in
            guard let text = alert.textFields?.first?.text else { return }
            viewModel.setPlayer(name: text)
            viewModel.setScore()
        }
        alert.addTextField { textField in
            textField.placeholder = "New Name"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Setup UI
private extension ScoreViewController {
    func setupUI() {
        addViews()
        setConstraints()
    }

    func addViews() {
        view.addSubview(computer)
        view.addSubview(player)
        view.addSubview(computerScoreLabel)
        view.addSubview(playerScoreLabel)
        view.addSubview(playerNameLabel)
        view.addSubview(changeNameButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            computer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 75),
            computer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            player.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
            player.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            computerScoreLabel.centerXAnchor.constraint(equalTo: computer.centerXAnchor),
            computerScoreLabel.topAnchor.constraint(equalTo: computer.bottomAnchor),
            
            playerScoreLabel.centerXAnchor.constraint(equalTo: player.centerXAnchor),
            playerScoreLabel.topAnchor.constraint(equalTo: player.bottomAnchor),
            
            playerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            changeNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeNameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
    }
}
