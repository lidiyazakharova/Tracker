import UIKit

final class PlaceholderView: UIView {
    let placeHolderView = UIView()
    
    private lazy var emptyTrackersImage: UIImageView = {
        let emptyTrackersImage = UIImageView()
        emptyTrackersImage.image = UIImage(named: "EmptyTrackerIcon")
        emptyTrackersImage.contentMode = .scaleToFill
        emptyTrackersImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyTrackersImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return emptyTrackersImage
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
    
    func configure() {
        addSubview(questionLabel)
        addSubview(emptyTrackersImage)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: emptyTrackersImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: placeHolderView.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: placeHolderView.trailingAnchor),
            
            emptyTrackersImage.centerYAnchor.constraint(equalTo: placeHolderView.centerYAnchor),
            emptyTrackersImage.centerXAnchor.constraint(equalTo: placeHolderView.centerXAnchor)
        ])
    }
    
}