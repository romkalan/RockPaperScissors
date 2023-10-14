//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by Roman Lantsov on 13.10.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol! {
        didSet {
            self.viewModel.gameSettingsDidChange = { [unowned self] viewModel in
                self.resultLabel.text = viewModel.resultLabel
                self.scoreLabel.text = viewModel.scoreLabel
                self.computerChoiсe.text = viewModel.computerChoiсe
                
                self.rockChoice.isEnabled = viewModel.buttonsIsActive
                self.paperChoice.isEnabled = viewModel.buttonsIsActive
                self.scissorsChoice.isEnabled = viewModel.buttonsIsActive
                
                switch viewModel.whoWon {
                case .player:
                    self.resultLabel.textColor = .systemGreen
                case .computer:
                    self.resultLabel.textColor = .red
                case .equally:
                    self.resultLabel.textColor = .gray
                case .initial:
                    self.resultLabel.textColor = .label
                }
            }
        }
    }
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Choice Rock or Paper or Scissors"
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "AI - 0:0 - You"
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var computerChoiсe: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.text = "🤖"
        label.font = UIFont.systemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rockChoice: UIButton = {
        let button = self.setupButton(
            withSize: 80,
            title: "🪨",
            andAction: UIAction { [unowned self] _ in
                viewModel.compareResult(with: "🪨")
            })
        return button
    }()
    
    private lazy var paperChoice: UIButton = {
        let button = self.setupButton(
            withSize: 80,
            title: "🧻",
            andAction: UIAction { [unowned self] _ in
                viewModel.compareResult(with: "🧻")
            })
        return button
    }()
    
    private lazy var scissorsChoice: UIButton = {
        let button = self.setupButton(
            withSize: 80,
            title: "✂️",
            andAction: UIAction { [unowned self] _ in
                viewModel.compareResult(with: "✂️")
            })
        return button
    }()
    
    private lazy var playAgainButton: UIButton = {
        let button = self.setupButton(
            withSize: 20,
            title: "Play again",
            andAction: UIAction { [unowned self] _ in
                viewModel.reloadScore()
            })
        return button
    }()
    
    private lazy var showTotalScore: UIButton = {
        let button = self.setupButton(
            withSize: 20,
            title: "Show Total Score",
            andAction: UIAction { [unowned self] _ in
                viewModel.showScore(in: self)
            })
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        viewModel = MainViewModel()
        viewModel.showGameSettings()
    }
    
    // MARK: - Methods
    private func setupButton(
        withSize size: CGFloat,
        title: String,
        andAction: UIAction?) -> UIButton {
            var attributes = AttributeContainer()
            attributes.font = UIFont.boldSystemFont(ofSize: size)
            
            var buttonConfiguration = UIButton.Configuration.plain()
            buttonConfiguration.attributedTitle = AttributedString(
                title,
                attributes: attributes
            )
            
            let button = UIButton(
                configuration: buttonConfiguration,
                primaryAction: andAction
            )
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    // MARK: - Navigation
//    func showScore() {
//        let vc = ScoreViewController()
//        
//        if !(navigationController!.topViewController! is ScoreViewController) {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        addViews()
        setupNavBar()
        setConstraints()
    }
    
    func setupNavBar() {
        navigationItem.title = "Rock Paper Scissors"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func addViews() {
        view.addSubview(resultLabel)
        view.addSubview(scoreLabel)
        view.addSubview(computerChoiсe)
        view.addSubview(rockChoice)
        view.addSubview(paperChoice)
        view.addSubview(scissorsChoice)
        view.addSubview(playAgainButton)
        view.addSubview(showTotalScore)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            resultLabel.widthAnchor.constraint(equalToConstant: 320),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15),
            
            computerChoiсe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            computerChoiсe.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
            
            scissorsChoice.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scissorsChoice.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
            
            rockChoice.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -125),
            rockChoice.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
            
            paperChoice.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 125),
            paperChoice.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
            
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playAgainButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 130),
            
            showTotalScore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showTotalScore.topAnchor.constraint(equalTo: playAgainButton.bottomAnchor),
        ])
    }
}





