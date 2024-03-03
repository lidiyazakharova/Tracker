//
//  HeaderSectionView.swift
//  Tracker
//
//  Created by Пользователь on 03.03.2024.
//

import UIKit

class HeaderSectionView: UICollectionReusableView {
    
    static let identifier = "headerCellIdentifier"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Black
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(_ text: String) {
        titleLabel.text = text
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}


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
