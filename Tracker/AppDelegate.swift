import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
    // MARK: - Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Tracker")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}

