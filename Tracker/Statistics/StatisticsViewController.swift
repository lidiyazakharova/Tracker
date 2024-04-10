import UIKit


struct Statistics {
    var title: String
    var count: String
}

final class StatisticsViewController: UIViewController {

    private var completedTrackers: [TrackerRecord] = []
    private let trackerRecordStore = TrackerRecordStore.shared
    private var statistics: [Statistics] = []
    
    //MARK: - Private Properties
    private lazy var titleHeader: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics.title", comment: "")
//        label.text = "Cтатистика"
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var emptyScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "ErrorSmile")
        launchScreenImage.contentMode = .scaleToFill
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        launchScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return launchScreenImage
    } ()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("emptyStatistics.text", comment: "")
//        label.text = "Анализировать пока нечего"
        label.numberOfLines = 0
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.register(
            StatisticsCell.self,
            forCellWithReuseIdentifier: StatisticsCell.identifier)
        return collectionView
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatisticScreen()
        view.backgroundColor = .White
    }
    
    //MARK: - Private Functions
    private func configureStatisticScreen() {
        
        view.addSubview(emptyStatisticsLabel)
        view.addSubview(emptyScreenImage)
        view.addSubview(titleHeader)
        
        NSLayoutConstraint.activate([
            
            titleHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105),
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyStatisticsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStatisticsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
    }
}
