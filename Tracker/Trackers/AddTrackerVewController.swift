import UIKit

final class AddTrackerViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Создание трекера"
        textLabel.numberOfLines = 0
        textLabel.textColor = .Black
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    } ()
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        view.backgroundColor = .White
    }
    
    //MARK: - Private Functions
    private func setLabel(){
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

