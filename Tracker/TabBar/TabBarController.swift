import UIKit

final class TabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSeparatop()
        generateTabBar()
    }
    
    private func addSeparatop() {
    let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
    separator.backgroundColor = .Gray
    tabBar.addSubview(separator)
    }
    
    private func generateTabBar() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistics"),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
}
