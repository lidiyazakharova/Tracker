import UIKit

//TO DO починить логику

protocol TrackersViewControllerDelegate: AnyObject {
    func createdTracker(tracker: Tracker, categoryTitle: String)
}

final class TrackersViewController: UIViewController {
    
    //MARK: - Properties
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        button.tintColor = .Black
        return button
    }()
    
    private let titleHeader: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .DateBackground
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.layer.zPosition = 10
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 8
        picker.tintColor = .Blue
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private let searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .Background
        textField.textColor = .Black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.Gray
        ]
        
        let attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.delegate = self
        
        textField.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)//need check
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .Blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.widthAnchor.constraint(equalToConstant: 83).isActive = true
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var cancelConstraint: NSLayoutConstraint = {
        return searchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -5)
    }()
    private lazy var noCancelConstraint: NSLayoutConstraint = {
        return searchTextField.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor, constant: -5)
    }()
    
    private let placeholderView = PlaceholderView()
    private let emptySearchPlaceholderView = EmptySearchPlaceholderView()
    
    private var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private let dataManager = DataManager.shared
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        configureView()
        addElements()
        setupConstraints()
        configureCollectionView()
        placeholderView.configureEmptyTrackerPlaceholder()
        emptySearchPlaceholderView.configureEmptySearchPlaceholder()
        emptySearchPlaceholderView.isHidden = true
    }
    

    //MARK: - helpers
    
    private func configureView() {
        view.backgroundColor = .White
        searchTextField.returnKeyType = .done
    }
    
    private func reloadData() {
        categories = dataManager.categories
        filteredCategories = categories
        dateChanged()
    }
    
    private func addElements() {
        view.addSubview(headerView)
        view.addSubview(placeholderView)
        view.addSubview(emptySearchPlaceholderView)
        view.addSubview(collectionView)
        
        headerView.addSubview(plusButton)
        headerView.addSubview(titleHeader)
        headerView.addSubview(dateLabel)
        headerView.addSubview(datePicker)
        headerView.addSubview(searchStackView)
        searchStackView.addSubview(searchTextField)
        searchStackView.addSubview(cancelButton)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        collectionView.register(
            HeaderSectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderSectionView.identifier
        )
        collectionView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        
            NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 138),
            
            plusButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            titleHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleHeader.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            
            datePicker.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchStackView.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 7),
            searchStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            searchStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
            
            emptySearchPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySearchPlaceholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            searchTextField.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor),
            noCancelConstraint,

            cancelButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor)
        ])
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    private func updateDateLabelTitle(with date: Date) {
        let dateString = formattedDate(from: date)
        dateLabel.text = dateString
    }
    
    @objc private func addTask() {
        let createTrackerVC = AddTrackerViewController()
        let navVC = UINavigationController(rootViewController: createTrackerVC)
        present(navVC, animated: true)
    }
    
    @objc private func cancelSearch() {
        cancelButton.isHidden = true
        cancelConstraint.isActive = false
        noCancelConstraint.isActive = true
        searchTextField.text = ""
        
        reloadFilteredCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    @objc private func dateChanged() {
        updateDateLabelTitle(with: datePicker.date)
        reloadFilteredCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filteredWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                
                let dateCondition = tracker.schedule.contains(where: { weekDay in
                    weekDay.rawValue == filteredWeekDay
                }) == true
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
        emptySearchPlaceholderView.isHidden = !filteredCategories.isEmpty
    }
    
    private func reloadPlaceholder() {
        placeholderView.isHidden = !categories.isEmpty
    }
    
}



extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadFilteredCategories(text: textField.text, date: datePicker.date)
        cancelButton.isHidden = false
        cancelConstraint.isActive = true
        noCancelConstraint.isActive = false
        return true
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionView.identifier, for: indexPath) as? HeaderSectionView else { return UICollectionReusableView() }//check

        let titleCategory = filteredCategories[indexPath.section].title
        view.configure(titleCategory)

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = filteredCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else { return UICollectionViewCell() }
        
        let cellData = filteredCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.trackerID == tracker.id
        }.count
        
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
           
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.trackerID == id && isSameDay
    }
}

// MARK: - ListTrackersViewCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    
    func completedTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerID == id && isSameDay
        }
            collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - UICollectionViewFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 46)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: CGFloat(148)) //need check
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)//need check
    }
}

//
//// MARK: - TrackersViewControllerDelegate
//
//extension TrackersViewController: TrackersViewControllerDelegate {
//    func createdTracker(tracker: Tracker, categoryTitle: String) {
//        do {
//            try trackerStore.addTracker(tracker, toCategory: TrackerCategory(categoryTitle: categoryTitle, trackers: []))
//            categories.append(TrackerCategory(categoryTitle: categoryTitle, trackers: [tracker]))
//            filterVisibleCategories(for: currentDate)
//            collectionView.reloadData()
//            reloadData()
//        } catch {
//            print("Failed to add tracker to Core Data: \(error)")
//        }
//    }
//}
//
//// MARK: - UITextFieldDelegate
//
//extension TrackersViewController: UISearchTextFieldDelegate {
//    private func textFieldShouldReturn(_ textField: UISearchTextField) -> Bool {
//        textField.resignFirstResponder()
//        hideNoResultsImage()
//        return true
//    }
//}
//
//
//
//
//
//// MARK: - TrackerCollectionViewCellDelegate
//
//extension TrackersViewController: TrackerCollectionViewCellDelegate {
//    func competeTracker(id: UUID) {
//        guard currentDate <= Date() else {
//            return
//        }
//        completedTrackers.append(TrackerRecord(trackerID: id, date: currentDate))
//        collectionView.reloadData()
//    }
//
//    func uncompleteTracker(id: UUID) {
//        completedTrackers.removeAll { element in
//            if (element.trackerID == id &&  Calendar.current.isDate(element.date, equalTo: currentDate, toGranularity: .day)) {
//                return true
//            } else {
//                return false
//            }
//        }
//        collectionView.reloadData()
//    }
//}
