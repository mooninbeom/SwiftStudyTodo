//
//  CollectionCell.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/07/05.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    var title: UILabel!
    var subtitle: UILabel!
    var date: UILabel!
    var isSuccessed: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
        layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCell()
        setUpLabel()
        layoutSubviews()
    }
    
    func setUpCell() {
        // title
        title = UILabel()
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
//        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
//        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        date = UILabel()
        contentView.addSubview(date)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.numberOfLines = 0
        date.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        date.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        subtitle = UILabel()
        contentView.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        isSuccessed = UILabel()
        contentView.addSubview(isSuccessed)
        isSuccessed.translatesAutoresizingMaskIntoConstraints = false
        isSuccessed.numberOfLines = 0
        isSuccessed.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30).isActive = true
        isSuccessed.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 10
//        contentView.layer.backgroundColor = UIColor.systemCyan.cgColor
//        contentView.layer.borderColor = UIColor.systemCyan.cgColor
//        contentView.layer.borderWidth = 3
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    func setUpLabel() {
        title.font = UIFont.systemFont(ofSize: 20)
        title.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
