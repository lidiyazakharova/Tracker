import UIKit

protocol ConfigureTrackerViewControllerDelegate {
    func trackerDidSaved()
}

final class ConfigureTrackerViewController: UIViewController {
    
    //MARK: - Properties
    
    var isRepeat: Bool = false
    var delegate: ConfigureTrackerViewControllerDelegate?
    let titlesForTableView = ["Категория", "Расписание"]
    private let dataManager = DataManager.shared
    private var selectedSchedule: [Weekday] = []
    private var selectedTrackerCategory: TrackerCategory?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .LightGray.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.smartInsertDeleteType = .no
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.White, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return createButton
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .White
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkButtonActivation()
    }
    
    //MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let categoryTitle = selectedTrackerCategory?.title else { return }
        
        dataManager.addTracker(
            title: textField.text ?? "",
            categoryTitle: categoryTitle,
            schedule: selectedSchedule
        )
        
        dismiss(animated: true, completion: { self.delegate?.trackerDidSaved() })
    }
    
    //MARK: - Private Functions
    
    private func setupNavBar(){
        if isRepeat {
            navigationItem.title = "Новая привычка"
        } else {
            navigationItem.title = "Новое нерегулярное событие"
        }
    }
    
    private func setupConstraints() {
        if isRepeat {
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24)
        ])
    }
    
    private func checkButtonActivation() {
        let isAvailable: Bool
        
        if(isRepeat) {
            isAvailable = !selectedSchedule.isEmpty && selectedTrackerCategory != nil
        } else {
            isAvailable = selectedTrackerCategory != nil
        }
        createButton.isEnabled = isAvailable
        
        if isAvailable {
            createButton.backgroundColor = .Black
        } else {
            createButton.backgroundColor = .Gray
        }
    }
}

// MARK: - UITableViewDataSource,Delegate

extension ConfigureTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRepeat {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableCell.reuseIdentifier, for: indexPath) as! ActivityTableCell
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .LightGray.withAlphaComponent(0.3)
        if indexPath.row == 0 {
            
            if isRepeat {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
            else { cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)}
            
            cell.titleLabel.text = titlesForTableView[indexPath.row]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.titleLabel.text = titlesForTableView[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ConfigureTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            navigationController?.pushViewController(categoryViewController, animated: true)
        } else if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
}

//MARK: - ScheduleViewControllerDelegate

extension ConfigureTrackerViewController: ScheduleViewControllerDelegate {
    func updateScheduleInfo(_ selectedDays: [Weekday], _ switchStates: [Int: Bool]) {
        self.selectedSchedule = selectedDays
        
        let subText: String
        if selectedDays.count == Weekday.allCases.count {
            subText = "Каждый день"
        } else {
            subText = selectedDays.map { $0.shortValue }.joined(separator: ", ")
        }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ActivityTableCell else {
            return
        }
        cell.set(subText: subText)
        
        checkButtonActivation()
        tableView.reloadData()
    }
}


//MARK: - CategoryViewControllerDelegate

extension ConfigureTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: TrackerCategory) {
        self.selectedTrackerCategory = category
        
        let subText = selectedTrackerCategory?.title ?? ""
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ActivityTableCell else {
            return
        }
        cell.set(subText: subText)
        tableView.reloadData()
        checkButtonActivation()
    }
}
