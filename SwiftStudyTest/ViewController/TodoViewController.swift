//
//  TodoViewController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/06/28.
//

import UIKit
import RealmSwift



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
            reloadCount = self.todoListArr.count
        }
        self.tableview.reloadData()
        countTodo()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "add") as? AddListController
        addVC?.modalPresentationStyle = .fullScreen
        addVC?.toolbarList = 0
        self.present(addVC!, animated: true)
    }
    
    @IBAction func goToCalendarButton(_ sender: Any) {
        let secondVC = CalendarViewController()
        secondVC.toolbarList = 0
        secondVC.modalPresentationStyle = .fullScreen
        self.present(secondVC, animated: true)
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        tableview.reloadData()
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
                let instance = TodoList(title: td.title, subtitle: td.subtitle, date: td.date, isSuccessed: td.isSuccessed)
                todoListArr.append(instance)
            }
        }
    }
    
    func removeAlert() {
        let controller = UIAlertController(title: "테스트", message: "정말로 삭제할래?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        controller.addAction(ok)
        controller.addAction(cancel)
        self.present(controller, animated: false)
        
    }
}


// MARK: - UITableView 익스텐션
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArr.count
    }
    
    // 각 셀에 들어가는 텍스트 할당
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "todo") as! TodoCell
        
        cell.title.text = todoListArr[indexPath.row].title
        cell.subtitle.text = todoListArr[indexPath.row].subtitle
        cell.date.text = todoListArr[indexPath.row].date
        cell.isSuccessed.text = (todoListArr[indexPath.row].isSuccessed) ? "완료~" : "아직 안함ㅋ"
        
        cell.selectionStyle = .blue
        cell.backgroundColor = .red.withAlphaComponent(0.6)
        
        
//        cell.layer.masksToBounds = true
//        cell.layer.cornerRadius = 20
        
//        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        cell.layoutMarginsDidChange()
        
        return cell
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Swipe 하여 완료, 삭제 action 구현 메소드
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 삭제, 수정을 위한 Todo() 객체 생성
        let indexTodo = Todo()
        indexTodo.title = self.todoListArr[indexPath.row].title
        indexTodo.subtitle = self.todoListArr[indexPath.row].subtitle
        indexTodo.date = self.todoListArr[indexPath.row].date
        
        // 삭제 버튼
        let discard = UIContextualAction(style: .normal, title: "삭제") { _,_, success in
            
//            print("title: \(indexTodo.title), subtitle: \(indexTodo.subtitle), date: \(indexTodo.date)")
            
            let controller = UIAlertController(title: "삭제", message: "정말로 삭제할래?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){ _ in
                date.removeTodo(when: self.now!, indexTodo)

                self.nowDate()
                self.countTodo()
                self.tableview.reloadData()
                print("\(indexPath.row)discard")
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            controller.addAction(ok)
            controller.addAction(cancel)
            self.present(controller, animated: false)
            
            success(true)
        }
        discard.backgroundColor = .systemPink
        
        // 완료 버튼
        let clear = UIContextualAction(style: .normal, title: "완료") { _, _, success in
            self.todoListArr[indexPath.row].isSuccessed = true
            date.editTodo(when: self.now!, indexTodo, true)
            self.tableview.reloadData()
            success(true)
        }
        clear.backgroundColor = .systemCyan
        
        return UISwipeActionsConfiguration(actions: [clear, discard])
    }
    
    // 셀 선택시 실행되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = TodoCellSelectionViewController()
        nextVC.receivedTitle = self.todoListArr[indexPath.row].title
        nextVC.receivedSubtitle = self.todoListArr[indexPath.row].subtitle
        nextVC.receivedDate = self.todoListArr[indexPath.row].date
        nextVC.receivedSuccessed = self.todoListArr[indexPath.row].isSuccessed
        
        nextVC.modalPresentationStyle = .formSheet
        
        tableview.deselectRow(at: indexPath, animated: true)
        self.present(nextVC, animated: true)
        
    }
    
}




