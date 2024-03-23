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
                            title: "Выполнить 3 задачи из практикума",
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
                ),
    
        TrackerCategory(title: "Уборка",
                    trackers: [
                        Tracker(
                            id: UUID(),
                            title: "Помыть посуду",
                            color: .magenta,
                            emoji: "🍴",
                            schedule: [Weekday.thursday, Weekday.saturday]
                        ),
                        Tracker(
                            id: UUID(),
                            title: "Вынести мусор",
                            color: .yellow,
                            emoji: "🗑",
                            schedule: [Weekday.sunday, Weekday.friday, Weekday.tuesday]
                        ),
                        Tracker(
                            id: UUID(),
                            title: "Постирать",
                            color: .blue,
                            emoji: "👕",
                            schedule: [Weekday.saturday]
                        )
                    ]
                )
        
    ]
    
    private init() {}
}

