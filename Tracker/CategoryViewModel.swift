import Foundation

typealias Binding<T> = (T) -> Void

//MARK: - CategoryViewModel
final class CategoryViewModel {
    
    //MARK: - Properties
    var onTrackerCategoriesChanged: Binding<Any?>?
    var onCategorySelected: Binding<TrackerCategory>?
    
    var selectedCategoryIndex: Int = -1
    var trackerCategories: [TrackerCategory] = [] {
        didSet {
            onTrackerCategoriesChanged?(nil)
        }
    }
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    // MARK: - Methods
    func fetchCategories() throws {
        do {
            trackerCategories = try trackerCategoryStore.getCategories()
        } catch {
            print("Fetch failed")
        }
    }
    
//    func createCategory(_ newCategory: TrackerCategory) {
//        try? trackerCategoryStore.createCategory(newCategory)
//    }
//
    func countCategories() -> Int {
        return trackerCategories.count
    }
    
    func getCategoryTitle(at indexPath: IndexPath) -> String {
        trackerCategories[indexPath.row].title
    }
    
    func selectCategory(at indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        
        let selectedCategory = trackerCategories[indexPath.row]
        
        onCategorySelected?(selectedCategory)
    }
//    trackerCategories[indexPath.row].title

}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        try? fetchCategories()
    }
}
