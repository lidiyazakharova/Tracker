import UIKit

final class EXTrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private let searchData = ["Яблоко", "Огурец", "Лимон", "Перец", "Помидор"]
    private var filteredData = [String]()
//    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Private Properties
    private lazy var trackersScreenImage: UIImageView = {
        let trackersScreenImage = UIImageView()
        trackersScreenImage.image = UIImage(named: "EmptyTrackerIcon")
        trackersScreenImage.contentMode = .scaleToFill
        trackersScreenImage.translatesAutoresizingMaskIntoConstraints = false
        trackersScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        trackersScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return trackersScreenImage
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
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.backgroundColor = .DateBackground
        dateLabel.textColor = .Black
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        return dateLabel
    }()
    
    private lazy var largeTitleLabel: UILabel = {
        let largeTitleLabel = UILabel()
        largeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        largeTitleLabel.text = "Трекеры"
        largeTitleLabel.textColor = .Black
        largeTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        largeTitleLabel.textAlignment = NSTextAlignment.left
        largeTitleLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        largeTitleLabel.widthAnchor.constraint(equalToConstant: 254).isActive = true
        return largeTitleLabel
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()
    
    private lazy var addTrackerButton: UIButton = {
        let addTrackerButton = UIButton.systemButton(
            with: UIImage(named: "AddTracker")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        addTrackerButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        addTrackerButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        addTrackerButton.tintColor = .Black
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        return addTrackerButton
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        searchBar.backgroundImage = UIImage()
//        searchBar.backgroundColor = .Red
        searchBar.placeholder = "Поиск"
        let textInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textInsideSearchBar?.textColor = .Black
//        textInsideSearchBar?.leftViewMode = UITextField.ViewMode.never
        return searchBar
    }()

    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setQuestionLabel()
        setDateLabel()
        setLargeTitleLabel()
        setButton()
        setSearchBar()
        self.searchBar.delegate = self
        view.backgroundColor = .White
    }
    
    //MARK: - Private Functions
    private func setImage(){
        view.addSubview(trackersScreenImage)
        NSLayoutConstraint.activate([
            trackersScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackersScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setQuestionLabel(){
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: trackersScreenImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDateLabel() {
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
    }
    private func setLargeTitleLabel() {
        view.addSubview(largeTitleLabel)
        NSLayoutConstraint.activate([
            largeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            largeTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            
        ])
    }
    private func setSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: largeTitleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
            
        ])
    }
    
    private func setButton() {
        view.addSubview(addTrackerButton)
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
    }
    
    @objc
    private func didTapButton() {
        print("PLUS")
            }
}

//extension TrackersViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
//}

extension EXTrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredData.removeAll()
        guard searchText != "" || searchText != " " else {
            print("empty search")
            return
        }
        
        for item in searchData {
            let text = searchText.lowercased()
            let isArrayContain = item.lowercased().range(of: text)
            
            if isArrayContain != nil {
                print("Search complete")
                filteredData.append(item)
            }
        }
        print(filteredData)
    }
}

