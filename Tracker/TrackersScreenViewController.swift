import UIKit

final class TrackersScreenViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var trackersScreenImage: UIImageView = {
        let trackersScreenImage = UIImageView()
        trackersScreenImage.image = UIImage(named: "EmptyTrackerIcon")
        trackersScreenImage.contentMode = .scaleToFill
        trackersScreenImage.translatesAutoresizingMaskIntoConstraints = false
        trackersScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        trackersScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return trackersScreenImage
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
        view.addSubview(trackersScreenImage)
        NSLayoutConstraint.activate([
            trackersScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackersScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setQuestionLabel(){
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: trackersScreenImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

