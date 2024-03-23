import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompletedTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier = "taskCellIdentifier"
    
    //MARK: - Properties
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .White.withAlphaComponent(0.3)
        label.clipsToBounds = true
        label.layer.cornerRadius = 24 / 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .White
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.backgroundColor = .Red // NEED DELETE
        return stack
    }()
    
    private let counterDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
//        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
//        let image = UIImage(systemName: "Plus", withConfiguration: pointSize)
//        button.tintColor = .Red
//        button.setImage(image, for: .normal)
//        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.tintColor = .White
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 34 / 2
        button.addTarget(TrackerCell.self, action: #selector(trackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerCellDelegate?
    private var isCompletedToday: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    
    //MARK: - Helpers
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerID = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        let color = tracker.color
        addElements()
        setupConstraints()
        
        mainView.backgroundColor = color
        taskTitleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        let wordDay = pluralizeDays(completedDays) //need check
        counterDayLabel.text = "\(wordDay)"
        
//        let image = isCompletedToday ? doneImage : plusImage
        let image = isCompletedToday ? UIImage(named: "Done") : UIImage(named: "Plus")
        plusButton.tintColor = color
        plusButton.alpha = isCompletedToday ? 0.3 : 1
        plusButton.setImage(image, for: .normal)
    }
    
    private func addElements() {
        contentView.addSubview(mainView)
        contentView.addSubview(stackView)
        
        mainView.addSubview(emojiLabel)
        mainView.addSubview(taskTitleLabel)
        stackView.addSubview(counterDayLabel)
        stackView.addSubview(plusButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            taskTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            taskTitleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            taskTitleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
//            plusButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 121),
//
            counterDayLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            counterDayLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), //need check
//            stackView.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 58)
        
            
        ])
    }
    
    private func pluralizeDays(_ count: Int) -> String {
    let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
//    private let doneImage = UIImage(systemName: "Done")
//    private let plusImage: UIImage = {
//        let pointSize = UIImage.SymbolConfiguration(pointSize:11)
//        let image = UIImage(systemName: "Plus", withConfiguration: pointSize) ?? UIImage()
//        return image
//    }()
    
    @objc private func trackButtonTapped() {
        //cell delegate
        guard let trackerID = trackerID, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return
        }

        if isCompletedToday {
            delegate?.uncompletedTracker(id: trackerID, at: indexPath)
        } else {
            delegate?.completedTracker(id: trackerID, at: indexPath)
        }
    }

}//end of class
