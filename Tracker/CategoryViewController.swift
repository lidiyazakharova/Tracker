import UIKit

protocol CategoryViewControllerDelegate {
    func didSelectCategory(_ category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    var delegate: CategoryViewControllerDelegate?
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    
    // MARK: - Private Properties
    
    private lazy var emptyScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "EmptyTrackerIcon")
        launchScreenImage.contentMode = .scaleToFill
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        launchScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return launchScreenImage
    } ()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно объединить по смыслу"
        label.numberOfLines = 0
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .Black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.White, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(pushAddCategoryButton), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.separatorColor = .gray
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private var trackerCategories: [TrackerCategory] = []
    private var selectedCategoryIndex = -1
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerCategoryStore.setDelegate(self)
        
        do {
            trackerCategories = try trackerCategoryStore.getCategories()
        } catch {
            print("Get categories failed")
        }
        
        view.backgroundColor = .White
        
        setupNavBar()
        addViews()
        setupConstraints()
        updateEmptyStateVisibility()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc private func pushAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Категория"
    }
    
    private func addViews() {
        [label,
         emptyScreenImage,
         addCategoryButton,
         tableView
        ].forEach {
            view.addSubview($0)
        }
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),
        ])
    }
    
    private func showEmptyStateImage() {
        emptyScreenImage.isHidden = false
        label.isHidden = false
        tableView.isHidden = true
    }
    
    private func hideEmptyStateImage() {
        emptyScreenImage.isHidden = true
        label.isHidden = true
        tableView.isHidden = false
    }
    
    private func updateEmptyStateVisibility() {
        if trackerCategories.isEmpty {
            showEmptyStateImage()
        } else {
            hideEmptyStateImage()
        }
    }
}

// MARK: - NewCategoryViewControllerDelegate
extension CategoryViewController: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        do {
            trackerCategories = try trackerCategoryStore.getCategories()
            updateEmptyStateVisibility()
            tableView.reloadData()
        } catch {
            print("Update failed")
        }
    }    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath)
        guard cell is CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = trackerCategories[indexPath.row].title
        cell.backgroundColor = .LightGray.withAlphaComponent(0.3)
        cell.separatorInset = UIEdgeInsets( top: 0, left: 16, bottom: 0, right: 16 )
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16.0
        
        if trackerCategories.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == 0 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.maskedCorners = []
            }
        }
        
        if indexPath.row == selectedCategoryIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategoryIndex = indexPath.row
        tableView.reloadData()
        
        let selectedCategory = trackerCategories[indexPath.row]
        delegate?.didSelectCategory(selectedCategory)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

