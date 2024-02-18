import UIKit

extension UIColor {
    static var Red: UIColor { UIColor(named: "Red") ?? UIColor.red }
    static var Blue: UIColor { UIColor(named: "Blue") ?? UIColor.blue }
    static var Black: UIColor { UIColor(named: "Black") ?? UIColor.black }
    static var Background: UIColor { UIColor(named: "Background") ?? UIColor.darkGray }
    static var Gray: UIColor { UIColor(named: "Gray") ?? UIColor.gray }
    static var White: UIColor { UIColor(named: "White") ?? UIColor.white }
    static var LightGray: UIColor { UIColor(named: "Light Gray") ?? UIColor.lightGray }
    static var DateBackground: UIColor { UIColor(named: "DateBackground") ?? UIColor.lightGray }
}

