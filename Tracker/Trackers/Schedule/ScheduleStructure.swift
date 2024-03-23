import Foundation

struct Schedule {
    let value: Weekday
    let isOn: Bool
}

//enum Weekday: Int {
//    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
//
//    var shortName: String {
//        switch self {
//        case .monday: return "Пн"
//        case .tuesday: return "Вт"
//        case .wednesday: return "Ср"
//        case .thursday: return "Чт"
//        case .friday: return "Пт"
//        case .saturday: return "Сб"
//        case .sunday: return "Вс"
//        }
//    }
//}
enum Weekday: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    var value: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресение"
        }
    }
}
