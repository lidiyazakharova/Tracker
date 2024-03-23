import UIKit

//TO DO выбор заголовка и кнопки расписания от статуса
//выстроить констрейнты и вью

final class ConfigureTrackerViewController: UIViewController {
    
    //weak var delegate: AddTrackerViewControllerDelegate? - TODO
    
    let dataForTableView = ["Категория", "Расписание"]
    var selectedSchedule: [Weekday] = []
    var selectedCategory = String()
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var selectedEmojiIndex: Int?
    var selectedColorIndex: Int?
    var isCategorySelected = false
    var isScheduleSelected = false
    var emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    var colors: [UIColor] = [ .blue, .red, .green, .purple, .yellow, .lightGray, .systemPink, .magenta, .gray] // TO DO
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var emojiAndColorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(
            EmojiAndColorCollectionCell.self,
            forCellWithReuseIdentifier: EmojiAndColorCollectionCell.reuseIdentifier
        )
        collectionView.register(
            EmojiAndColorHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiAndColorHeaderView.reuseIdentifier
        )
        return collectionView
    }()
    
    
    
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
        //        textField.addLeftPadding(16)
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.smartInsertDeleteType = .no
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .gray
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(
            ActivityTableCell.self,
            forCellReuseIdentifier: ActivityTableCell.reuseIdentifier
        )
        return tableView
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.Red, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.Red.cgColor
        cancelButton.addTarget(ConfigureTrackerViewController.self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.backgroundColor = .Gray
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.White, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(ConfigureTrackerViewController.self, action: #selector(createButtonTapped), for: .touchUpInside)
        return createButton
    }()
    
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setLabel()
        setupNavBar()
        setupConstraints()
        //        setupButtons()
        view.backgroundColor = .White
//        view.addSubview(textField)
//        view.addSubview(tableView)
//        view.addSubview(emojiAndColorCollectionView)
//        view.addSubview(stackView)
//        stackView.addArrangedSubview(cancelButton)
//        stackView.addArrangedSubview(createButton)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [textField,
         tableView,
         emojiAndColorCollectionView,
         stackView
        ].forEach { scrollView.addSubview($0) }
        
       
        
//        textField.delegate = self
        tableView.dataSource = self
        emojiAndColorCollectionView.dataSource = self
        emojiAndColorCollectionView.delegate = self
        
        [cancelButton,
         createButton
        ].forEach { stackView.addArrangedSubview($0) }

    }
    
    
    
    
    
    //MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        //        presenter.createActivity(for: presenter.selectedDate)
        navigationController?.dismiss(animated: true)
    }
    
    //MARK: - Private Functions
    
    private func setupNavBar(){
        navigationItem.title = "Новая привычка"
    }
    
    //       private func setupButtons() {
    ////           cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    ////           createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    //           stackView.addArrangedSubview(cancelButton)
    //           stackView.addArrangedSubview(createButton)
    //       }
    
    private func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),//need check
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),//need check
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 460)
        ])
    }
    
//    func updateSaveButton(isEnabled: Bool) {
//        createButton.isEnabled = isEnabled
//        createButton.backgroundColor = isEnabled ? .Black : .Gray
//    }//Todo
    
    func checkButtonActivation() {
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        let isCategoryTextEmpty = textField.text?.isEmpty ?? true
        
        if isCategorySelected && !isCategoryTextEmpty && isEmojiSelected && isColorSelected {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .gray
        }
    }
}



// MARK: - UITableViewDataSource

extension ConfigureTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("This method must be overridden by the subclass")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("This method must be overridden by the subclass")
    }
}

// MARK: - UICollectionViewDataSource

extension ConfigureTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else if section == 1 {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCollectionCell.reuseIdentifier, for: indexPath) as! EmojiAndColorCollectionCell
        
        if indexPath.section == 0 {
            let emoji = emojis[indexPath.row]
            cell.titleLabel.text = emoji
        } else if indexPath.section == 1 {
            let color = colors[indexPath.row]
            cell.titleLabel.backgroundColor = color
        }
        
        cell.titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EmojiAndColorHeaderView.reuseIdentifier,
            for: indexPath
        ) as! EmojiAndColorHeaderView
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else if indexPath.section == 1 {
            view.titleLabel.text = "Цвет"
        }
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ConfigureTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 40, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let selectedEmojiIndex = selectedEmojiIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedEmojiIndex, section: 0)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojiAndColorCollectionCell {
                    cell.backgroundColor = .clear
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as! EmojiAndColorCollectionCell
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.backgroundColor = .LightGray
            selectedEmoji = emojis[indexPath.row]
            selectedEmojiIndex = indexPath.row
        } else if indexPath.section == 1 {
            if let selectedColorIndex = selectedColorIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedColorIndex, section: 1)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojiAndColorCollectionCell {
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as! EmojiAndColorCollectionCell
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
            cell.layer.borderWidth = 3
            selectedColor = colors[indexPath.row]
            selectedColorIndex = indexPath.row
        }
        checkButtonActivation()
    }
}












//
//func configureUIElements() {
//    view.addSubview(scrollView)
//    scrollView.addSubview(contentView)
//    [textField,
//     tableView,
//     emojisAndColorsCollectionView,
//     stackView
//    ].forEach { scrollView.addSubview($0) }
//
//    contentView.addSubview(emojisAndColorsCollectionView)
//
//    textField.delegate = self
//    tableView.dataSource = self
//    emojisAndColorsCollectionView.dataSource = self
//    emojisAndColorsCollectionView.delegate = self
//
//    [cancelButton,
//     createButton
//    ].forEach { stackView.addArrangedSubview($0) }
//
//    NSLayoutConstraint.activate([
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//        contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//
//        textField.heightAnchor.constraint(equalToConstant: 75),
//        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//        textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
//
//        tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
//        tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
//        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
//
//        emojisAndColorsCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
//        emojisAndColorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//        emojisAndColorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        emojisAndColorsCollectionView.heightAnchor.constraint(equalToConstant: 460),
//
//        stackView.heightAnchor.constraint(equalToConstant: 60),
//        stackView.topAnchor.constraint(equalTo: emojisAndColorsCollectionView.bottomAnchor, constant: 16),
//        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//        stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
//    ])
//    scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 105)
//}
//
// TODO REPLACE CODE
