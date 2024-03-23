import UIKit

class HeaderSectionView: UICollectionReusableView {
    
    static let identifier = "headerCellIdentifier"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .green // NEED DELETE
        addSubview(titleLabel)
    
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    //func setTrackerSupplementaryView(text: String) {
    //    titleLabel.text = text
    //}
    //}
    
    func configure(_ text: String) {
        titleLabel.text = text
    }
//        addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
//        ])
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ])
//    }
}


//override init(frame: CGRect) {
//    super.init(frame: frame)
//
//    addSubview(titleLabel)
//
//    NSLayoutConstraint.activate([
//        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
//    ])
//}
//
//required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//}
//
//func setTrackerSupplementaryView(text: String) {
//    titleLabel.text = text
//}
//}


//class SupplementaryView: UICollectionReusableView {
//    let titleLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
