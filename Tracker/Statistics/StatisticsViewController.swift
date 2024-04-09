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
        label.text = "Cтатистика"
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
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализировать пока нечего"
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
        
        view.addSubview(label)
        view.addSubview(emptyScreenImage)
        view.addSubview(titleHeader)
        
        NSLayoutConstraint.activate([
            
            titleHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105),
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
    }
}
//
//
////MARK: - Lifecycle
//override func viewDidLoad() {
//    super.viewDidLoad()
//    configure()
//    try? fetchStats()
//    checkEmptyStats()
//}
//
//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    try? fetchStats()
//    checkEmptyStats()
//}
//
////MARK: - Private methods
//private func checkEmptyStats() {
//    if !completedTrackers.isEmpty {
//        stubView.isHidden = true
//        collectionView.isHidden = false
//    } else {
//        stubView.isHidden = false
//        collectionView.isHidden = true
//    }
//    collectionView.reloadData()
//}
//
//private func fetchStats() throws {
//    do {
//        completedTrackers = try trackerRecordStore.fetchRecords()
//        getStatisticsCalculation()
//    } catch {
//        throw ErrorStore.error
//    }
//}
//
//private func getStatisticsCalculation() {
//    if completedTrackers.isEmpty {
//        stats.removeAll()
//    } else {
//        stats = [
//            Stats(
//                title: "Трекеров завершено",
//                count: "\(completedTrackers.count)")
//        ]
//    }
//}
//
//private func configure() {
//    view.backgroundColor = Color.whiteDay
//    addViews()
//    layoutViews()
//}
//
//private func addViews() {
//    [statsLabel,
//     stubView,
//     collectionView].forEach {
//        view.addSubview($0)
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    [stubImage,
//     stubLabel].forEach {
//        stubView.addSubview($0)
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//}
//
//private func layoutViews() {
//    NSLayoutConstraint.activate([
//        statsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
//        statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//        collectionView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 77),
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        stubView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor),
//        stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        stubView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        stubImage.heightAnchor.constraint(equalToConstant: 80),
//        stubImage.widthAnchor.constraint(equalToConstant: 80),
//        stubImage.topAnchor.constraint(equalTo: stubView.topAnchor, constant: 246),
//        stubImage.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
//        stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
//        stubLabel.centerXAnchor.constraint(equalTo: stubView.centerXAnchor)
//    ])
//}
//}
//
////MARK: - TrackerCategoryStoreDelegate
//extension StatsViewController: TrackerRecordStoreDelegate {
//func didUpdateData(in store: TrackerRecordStore) {
//    try? fetchStats()
//    checkEmptyStats()
//}
//}
//
////MARK: - UICollectionViewDelegate
//extension StatsViewController: UICollectionViewDelegate {
//func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath
//) -> CGSize {
//    CGSize(width: collectionView.frame.width, height: 90)
//}
//}
//
////MARK: - UICollectionViewDataSource
//extension StatsViewController: UICollectionViewDataSource {
//func collectionView(
//    _ collectionView: UICollectionView,
//    numberOfItemsInSection section: Int
//) -> Int {
//    stats.count
//}
//
//func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(
//        withReuseIdentifier: StatsCell.identifier,
//        for: indexPath
//    ) as? StatsCell else {
//        return UICollectionViewCell()
//    }
//
//    let newStats = stats[indexPath.row]
//    cell.configureCell(stats: newStats)
//    return cell
//}
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//extension StatsViewController: UICollectionViewDelegateFlowLayout {
//func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    minimumLineSpacingForSectionAt section: Int
//) -> CGFloat {
//    20
//}
//
//func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    minimumInteritemSpacingForSectionAt section: Int
//) -> CGFloat {
//    20
//}
//}
