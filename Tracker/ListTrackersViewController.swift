import UIKit
final class ListTrackersViewController: UIViewController {
    
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
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .Blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        button.isHidden = true
        return button
    }()
    
    private let placeholderView = PlaceholderView()
    
    private var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Фильтры", for: .normal)
        button.backgroundColor = .Blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.tintColor = .White
        button.addTarget(
            self,
            action: #selector(selectFilter),
            for: .touchUpInside
        )
        button.layer.cornerRadius = 16 // need check
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
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
//        updateDataLabelTitle(with: Date())
    }
    
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: view.frame.size.width/2.2,
//                                 height: view.frame.size.width/2.2)
//        collectionView = UICollectionView (frame: .zero, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .clear
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    } примерверстки
   
    //MARK: - helpers
    
    private func configureView() {
        view.backgroundColor = .White
        searchTextField.returnKeyType = .done
        filterButton.layer.zPosition = 2
    }
    
    private func reloadData() {
        categories = dataManager.categories
//        filteredCategories = categories
        dateChanged()
    }
    
    private func addElements() {
        view.addSubview(headerView)
//        view.addSubview(placeholderView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        
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
            
//            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            placeholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
//            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -5),
            
            cancelButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor),
            
//            categories.setContentCompressionResistancePriority(<#T##UILayoutPriority#>, for: <#T##NSLayoutConstraint.Axis#>)
//            categories.setContentHuggingPriority(<#T##priority: UILayoutPriority##UILayoutPriority#>, for: <#T##NSLayoutConstraint.Axis#>)
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
//        createTrackerVC.updateDelegate = self
        
        let navVC = UINavigationController(rootViewController: createTrackerVC)
        present(navVC, animated: true)
    }
    
    @objc private func selectFilter() {
        print("Tapped filter")
    }
    
    @objc private func dateChanged() {
        updateDateLabelTitle(with: datePicker.date)
        reloadFilteredCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
//        let filteredWeekDay = calendar.component(.weekday, from: datePicker.date)
//        let filterText = (searchTextField.text ?? "").lowercased()
            let filteredWeekDay = calendar.component(.weekday, from: date)
            let filterText = (text ?? "").lowercased()
        
        
        filteredCategories = categories.compactMap { category in
          let trackers = category.trackers.filter { tracker in
              let textCondition = filterText.isEmpty ||
              tracker.title.lowercased().contains(filterText)
//              let dateCondition = tracker.schedule?.contains { weekDay in
//                        weekDay.numberValue == filteredWeekDay
//                    } == true
              return textCondition //&& dateCondition
                }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
//        placeholderView.isHidden = !categories.isEmpty
    }
    
}



extension ListTrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        reloadFilteredCategories()
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        <#code#>
//    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ListTrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ListTrackersViewController: TrackerCellDelegate {
    
    func completedTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
//            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
//            return trackerRecord.trackerID == id && isSameDay
        }
            collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - UICollectionViewFlowLayout
extension ListTrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 49)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 2 / 3) //need check
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        10
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)//need check
    }
}



//// Размеры для коллекции:
//let size = CGRect(origin: CGPoint(x: 0, y: 0),
//                  size: CGSize(width: 400, height: 600))
//// Указываем, какой Layout хотим использовать:
//let layout = UICollectionViewFlowLayout()
//
//let helper = SupplementaryCollection(count: 31)
//let collection = UICollectionView(frame: size,
//                                  collectionViewLayout: layout)
//// Регистрируем ячейку в коллекции.
//// Регистрируя ячейку, мы сообщаем коллекции, какими типами ячеек она может распоряжаться.
//// При попытке создать ячейку с незарегистрированным идентификатором коллекция выдаст ошибку.
//collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
//collection.backgroundColor = .lightGray
//collection.dataSource = helper

