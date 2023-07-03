//
//  TodoViewController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/06/28.
//

import UIKit


class TodoViewController: UIViewController{
    @IBOutlet var todayDate: UILabel!
    @IBOutlet var todoCount: UILabel!
    @IBOutlet var tableview: UITableView!
    
    var todoListArr = [TodoList]()
    var receivedTodo: TodoList?
    var reloadCount: Int?
    var now: String?
    var selectedDate: Date?
    

    
    override func viewDidLoad() {
        tableview.dataSource = self
        tableview.delegate = self
        reloadCount = self.todoListArr.count
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        nowDate()
        // 추가된 Todo가 있을 시 tableview에 추가
        if receivedTodo != nil {
            todoListArr.append(receivedTodo!)
            
            // 데이터베이스에 추가된 Todo를 저장한다
            let addTodo = Todo()
            addTodo.title = receivedTodo!.title
            addTodo.subtitle = receivedTodo!.subtitle
            addTodo.date = receivedTodo!.date
            date.addTodo(when: now!, addTodo)
            
            receivedTodo = nil
        }
        // 과거 todoListArr의 카운트 보다 증가 or 감소 할 경우 sorting 후 reload 한다.
        if (reloadCount != self.todoListArr.count) {
            sortingList()
            self.tableview.reloadData()
            reloadCount = self.todoListArr.count
        }
        countTodo()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "add") as? AddListController
        addVC?.modalPresentationStyle = .fullScreen
        
        self.present(addVC!, animated: true)
    }
    
    @IBAction func goToCalendarButton(_ sender: Any) {
        let secondVC = CalendarViewController()
        secondVC.modalPresentationStyle = .fullScreen
        self.present(secondVC, animated: true)
    }
    
    
    
}


// MARK: - UI 메소드 모음
extension TodoViewController {
    // 현재 날짜 불러오기
    func nowDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        if selectedDate == nil { // 초기 화면 일시
            
            let currentDate = formatter.string(from: Date())
            todayDate.text = currentDate
            now = currentDate
            
            todoToStruct(currentDate)
            
            
        } else { // 달력을 통해 날짜가 선택 될 시
            let selection = formatter.string(from: selectedDate!)
            todayDate.text = selection
            now = selection
            todoToStruct(selection)
        }
    }
    
    
    // 현재 날짜의 Todo Count를 표시
    func countTodo(){
        let count = todoListArr.count
        if count == 0 {
            todoCount.text = "오늘의 할 일 클리어~"
        } else {
            todoCount.text = "할 일이 \(todoListArr.count)개나 남았어요!"
        }
    }
    
    // todoListArr를 시간 순서대로 정렬하는 메소드
    func sortingList() {
        self.todoListArr = self.todoListArr.sorted(by: { (s1, s2) in
            let t1Hour = Int(s1.date.prefix(2))!
            let t2Hour = Int(s2.date.prefix(2))!
            
            if(t1Hour == t2Hour) {
                let t1Min = Int(s1.date.suffix(2))!
                let t2Min = Int(s2.date.suffix(2))!
                return t1Min < t2Min
            } else {
                return t1Hour < t2Hour
            }
        })
    }
    
    // 저장된 데이터를 불러와 구조체로 옮기는 메소드
    func todoToStruct(_ savedDate: String) {
        let a = date.findSelectedDate(savedDate)
        todoListArr = [TodoList]()
        
        if !a.isEmpty {
            a[0].todoList.forEach { td in
                let instance = TodoList(title: td.title, subtitle: td.subtitle, date: td.date)
                todoListArr.append(instance)
            }
        }
    }
}


// MARK: - UITableView 익스텐션
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "todo") as! TodoCell
        
        cell.title.text = todoListArr[indexPath.row].title
        cell.subtitle.text = todoListArr[indexPath.row].subtitle
        cell.date.text = todoListArr[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Swipe 하여 완료, 삭제 action 구현
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let discard = UIContextualAction(style: .normal, title: "삭제") { _,_, success in
            let indexTodo = Todo()
            indexTodo.title = self.todoListArr[indexPath.row].title
            indexTodo.subtitle = self.todoListArr[indexPath.row].subtitle
            indexTodo.date = self.todoListArr[indexPath.row].date
            
            date.removeTodo(when: self.now!, indexTodo)
            
            self.nowDate()
            self.countTodo()
            self.tableview.reloadData()
            print("\(indexPath.row)discard")
            success(true)
        }
        discard.backgroundColor = .systemPink
        
        let clear = UIContextualAction(style: .normal, title: "완료") { _, _, success in
            print("\(indexPath.row)clear")
            success(true)
        }
        clear.backgroundColor = .systemCyan
        
        return UISwipeActionsConfiguration(actions: [discard, clear])
    }
    
    
}




