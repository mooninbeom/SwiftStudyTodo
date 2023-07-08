//
//  CalendarViewController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/07/01.
//

import UIKit


class CalendarViewController: UIViewController {
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var toolbarList: Int = 0
    
    var selectedDate: DateComponents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyConstraints()
        style()
        setCalendar()
    }
    
    
    
    
    
    
    
}

extension CalendarViewController{
    fileprivate func style() {
        view.backgroundColor = .systemBackground
    }
    
    fileprivate func applyConstraints() {
        view.addSubview(dateView)
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    fileprivate func reloadDateView(date: Date?) {
        if date == nil {
            return
        }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // 캘린더 날짜 하단부에 그 날짜의 Todo 목록 갯수를 표현
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        //10 보다 작을 경우 앞에 0을 붙여 데이터에 저장된 날짜와 통일
        let day = (dateComponents.day! < 10) ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
        let month = (dateComponents.month! < 10) ? "0\(dateComponents.month!)" : "\(dateComponents.month!)"
        let now = "\(month)월 \(day)일"
        
        let count = date.getCount(now)
        
        return .customView {
            let label = UILabel()
            label.text = (count == 0) ? "•" : "\(count)"
            label.textAlignment = .center
            label.textColor = (count == 0) ? .black : .orange
            return label
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let preVC = self.presentingViewController as? UITabBarController else {return}
        if toolbarList == 0 {
            guard let goVC = preVC.selectedViewController as? TodoViewController else {return}
            let sendingDate = dateComponents!.date

            goVC.selectedDate = sendingDate
        } else {
            guard let goVC = preVC.selectedViewController as? CollectionViewController else {return}
            let sendingDate = dateComponents!.date
            
            goVC.sel2ReceivedDate = sendingDate
        }
        
        
        
        self.presentingViewController?.dismiss(animated: true)
        
    }
    
    
    
    
}
