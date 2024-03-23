import UIKit

// MARK: - ScheduleViewControllerDelegate

protocol ScheduleViewControllerDelegate: AnyObject {
    func updateScheduleInfo(_ selectedDays: [Weekday],_ switchStates: [Int: Bool])
}

// MARK: - ScheduleViewController

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    var switchStates: [Int : Bool] = [:]
    
    // MARK: - Private Properties
    
    private var selectedSchedule: [Weekday] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.separatorColor = .gray
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .Black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupNavBar()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        switchStatus()
        delegate?.updateScheduleInfo(selectedSchedule, switchStates)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar(){
        navigationItem.title = "Расписание"
    }
    
    private func setupView() {
        [tableView,
         doneButton
        ].forEach { view.addSubview($0) }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        let minimumDistanceFromTableViewToDoneButton: CGFloat = 24
        let maximumDistanceFromTableViewToDoneButton: CGFloat = 47
        let minimumDistanceFromBottomSafeAreaToDoneButton: CGFloat = 16
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -minimumDistanceFromBottomSafeAreaToDoneButton),
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: minimumDistanceFromTableViewToDoneButton),
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: maximumDistanceFromTableViewToDoneButton)
        ])
    }
    
    private func switchStatus() {
        for (index, weekDay) in Weekday.allCases.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            guard let switchView = cell?.accessoryView as? UISwitch else {return}
            switchStates[index] = switchView.isOn
            if switchView.isOn {
                selectedSchedule.append(weekDay)
            } else {
                selectedSchedule.removeAll { $0 == weekDay }
            }
        }
    }
}

// MARK: - UITableViewDataSource (UITableViewDelegate)

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else { return UITableViewCell()}
        cell.backgroundColor = .LightGray 
        cell.textLabel?.text = Weekday.allCases[indexPath.row].value
        let switchButton = UISwitch(frame: .zero)
        switchButton.setOn(switchStates[indexPath.row] ?? false, animated: true)
        switchButton.onTintColor = .blue
        switchButton.tag = indexPath.row
        cell.accessoryView = switchButton
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Weekday.allCases.count - 1 {
            return 76
        } else {
            return 75
        }
    }
}