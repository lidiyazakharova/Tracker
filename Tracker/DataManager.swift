import Foundation

class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
        
        TrackerCategory(title: "Обучение",
                    trackers: [
                        Tracker(
                            id: UUID(),
                            title: "Прочитать 1 урок",
                            color: .green,
                            emoji: "📕",
                            schedule: [Weekday.monday, Weekday.wednesday]
                        ),
                        Tracker(
                            id: UUID(),
                            title: "Выполнить 3 задачи",
                            color: . purple,
                            emoji: "👩‍💻",
                            schedule: [Weekday.tuesday, Weekday.friday]
                        ),
                    ]
                ),
        
        TrackerCategory(title: "Спорт",
                    trackers: [
                        Tracker(
                            id: UUID(),
                            title: "Сходить на тренировку",
                            color: .red,
                            emoji: "💪",
                            schedule: [Weekday.monday, Weekday.saturday]
                        ),
                        Tracker(
                            id: UUID(),
                            title: "Позаниматься йогой",
                            color: .blue,
                            emoji: "🧘‍♀️",
                            schedule: [Weekday.saturday, Weekday.friday]
                        ),
                    ]
                )
    
    ]
    
    private init() {}
}

