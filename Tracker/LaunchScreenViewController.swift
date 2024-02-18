import UIKit

final class LaunchScreenViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var launchScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "LaunchScreenLogo")
        launchScreenImage.contentMode = .scaleToFill
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.heightAnchor.constraint(equalToConstant: 91).isActive = true
        launchScreenImage.widthAnchor.constraint(equalToConstant: 94).isActive = true
        return launchScreenImage
    } ()
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLaunchScreenImage()
        view.backgroundColor = .Red
    }
    
    //MARK: - Private Functions
    private func setLaunchScreenImage(){
        view.addSubview(launchScreenImage)
        NSLayoutConstraint.activate([
            launchScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

