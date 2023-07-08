//
//  TodoCellSelectionViewController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/07/04.
//

import UIKit

class TodoCellSelectionViewController: UIViewController {
    lazy var viewTitle: UILabel = {
        var view = UILabel()
        view.text = receivedTitle ?? "fail!"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    lazy var viewSubtitle: UILabel = {
       var view = UILabel()
        view.text = receivedSubtitle ?? "fail2!"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    lazy var viewDate: UILabel = {
        var view = UILabel()
        view.text = receivedDate ?? "fail3!"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    lazy var isSuccessed: UILabel = {
        var view = UILabel()
        view.text = receivedSuccessed! ? "완료" : "실패"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    var receivedTitle: String?
    var receivedSubtitle: String?
    var receivedDate: String?
    var receivedSuccessed: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

// MARK: - UI 구현 메소드
extension TodoCellSelectionViewController {
    
    fileprivate func style() -> Void {
        view.backgroundColor = .white
        view.addSubview(viewTitle)
        view.addSubview(viewSubtitle)
        view.addSubview(viewDate)
        view.addSubview(isSuccessed)
    }
    
    fileprivate func layout() {
        NSLayoutConstraint.activate([
            viewTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            viewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
        
        NSLayoutConstraint.activate([
            viewDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            viewDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            viewSubtitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            viewSubtitle.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 100)
        ])
        
        NSLayoutConstraint.activate([
            isSuccessed.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            isSuccessed.topAnchor.constraint(equalTo: viewDate.bottomAnchor, constant: 100)
        ])
    }
}
