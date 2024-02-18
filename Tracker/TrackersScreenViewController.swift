import UIKit

final class MainScreenViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var mainScreenImage: UIImageView = {
        let mainScreenImage = UIImageView()
        mainScreenImage.image = UIImage(named: "EmptyTrackerIcon")
        mainScreenImage.contentMode = .scaleToFill
        mainScreenImage.translatesAutoresizingMaskIntoConstraints = false
        mainScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return mainScreenImage
    } ()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.numberOfLines = 0
        questionLabel.textColor = .Black
        questionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questionLabel.textAlignment = NSTextAlignment.center
        return questionLabel
    }()
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setQuestionLabel()
        view.backgroundColor = .White
    }
    
    //MARK: - Private Functions
    private func setImage(){
        view.addSubview(mainScreenImage)
        NSLayoutConstraint.activate([
            mainScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setQuestionLabel(){
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: mainScreenImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

