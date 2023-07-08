//
//  CollectionViewController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/07/05.
//

import UIKit
import RealmSwift

class CollectionViewController: UIViewController {
    
    var sel2ReceivedTodo: TodoList?
    var sel2ReceivedDate: Date?
    var todoListArr = [Todo]()
    
    

    
    override func viewDidLoad() {
        view.backgroundColor = .white
        collectionViewStyle()
        register()
        collectionViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let a = selectedDate()
        getData(a)
        sortingList()
        getCount()
        self.collectionView.reloadData()
        todoListArr.forEach{ a in
            print("title: \(a.title), subtitle: \(a.subtitle), date: \(a.date)")
        }
    }
    
    
    // 컬렉션 뷰 객체
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 왼쪽 상단 텍스트(고정)
    lazy var todayList: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "오늘의 할 일"
        view.textAlignment = .center
        return view
    }()
    
    // 오른쪽 상단 오늘의 날짜 텍스트
    lazy var todayLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = whenToday()
        view.textAlignment = .center
        return view
    }()
    
    // todo 추가 버튼
    lazy var addBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false

        let config = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        
        view.configuration = UIButton.Configuration.filled()
        view.configuration?.image = image
        view.configuration?.baseBackgroundColor = .white
        view.configuration?.baseForegroundColor = .systemBlue
        view.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        
        return view
    }()
    
    // 달력 버튼
    lazy var calendarBtn: UIButton = {
        let view = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("달력", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.addTarget(self, action: #selector(calendarBtnAction), for: .touchUpInside)
        
        return view
    }()
    
    // 총 todo 갯수를 알려주는 Label
    lazy var todoCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.textAlignment = .center
        return view
    }()
    
    // 현재까지 남은 todo 갯수를 알려주는 Label
    lazy var leavedTodoCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.textAlignment = .center
        return view
    }()
    
    
}

extension CollectionViewController {
    func collectionViewStyle() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 270).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(todayList)
        todayList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        todayList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(todayLabel)
        todayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        view.addSubview(addBtn)
        addBtn.topAnchor.constraint(equalTo: todayList.bottomAnchor, constant: 15).isActive = true
        addBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(calendarBtn)
        calendarBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        calendarBtn.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(todoCountLabel)
        todoCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoCountLabel.topAnchor.constraint(equalTo: calendarBtn.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(leavedTodoCountLabel)
        leavedTodoCountLabel.topAnchor.constraint(equalTo: todoCountLabel.bottomAnchor, constant: 10).isActive = true
        leavedTodoCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
    }
    
    func register() {
        collectionView.register(CollectionCell.classForCoder(), forCellWithReuseIdentifier: "ColCell")
    }
    
    func collectionViewDelegate() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func whenToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        
        let currentDate = formatter.string(from: Date())
        return currentDate
    }
    
    // 현재 선택되어 있는 날짜를 리턴해주는 메소드
    func selectedDate() -> String {
        guard let date = sel2ReceivedDate else {return whenToday()}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        
        let currentDate = formatter.string(from: date)
        todayLabel.text = currentDate
        return currentDate
    }
    
    // 전체 Todo 갯수와 완료되지 않은 Todo 갯수를 Label text에 넣어주는 메소드
    func getCount() -> Void {
        self.todoCountLabel.text = (self.todoListArr.isEmpty) ? "오늘의 할 일이 없습니다!" : "오늘 \(self.todoListArr.count)개가 있어요."
        var count = 0
        self.todoListArr.forEach{ a in
            if( !a.isSuccessed ) {
                count += 1
            }
        }
        let text = (count == 0) ? "완료하였습니다!" : "할 일이 \(count)개나 남았어요!"
        self.leavedTodoCountLabel.text = text
    }
    
    // todoListArr을 저장된 시간 별로 정렬해주는 메소드
    func sortingList() {
        if todoListArr.isEmpty { return }
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
    
    // 저장된 데이터를 불러오는 메소드
    func getData(_ savedDate: String) -> Void {
        let instance = Todo()
        if sel2ReceivedTodo != nil {
            instance.title = sel2ReceivedTodo!.title
            instance.subtitle = sel2ReceivedTodo!.subtitle
            instance.date = sel2ReceivedTodo!.date
            instance.isSuccessed = sel2ReceivedTodo!.isSuccessed
            date.addTodo(when: savedDate, instance)
            sel2ReceivedTodo = nil
        }
        
        let a = date.findSelectedDate(savedDate)
        self.todoListArr = [Todo]()
       
        
        if a.isEmpty {return}
        else {
            let b = a[0].todoList
            if b.isEmpty { return }
            b.forEach{ td in
                self.todoListArr.append(td)
            }
        }
    }
    
    @objc
    func addBtnAction(_ sender: UIButton!) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "add") as? AddListController
        nextVC?.modalPresentationStyle = .fullScreen
        nextVC?.toolbarList = 1
        self.present(nextVC!, animated: true)
    }
    
    @objc
    func calendarBtnAction(_ sender: UIButton!) {
        let nextVC = CalendarViewController()
        nextVC.toolbarList = 1
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todoListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ColCell", for: indexPath) as! CollectionCell
        cell.title.text = todoListArr[indexPath.row].title
        cell.date.text = todoListArr[indexPath.row].date
        cell.subtitle.text = todoListArr[indexPath.row].subtitle
        cell.isSuccessed.text = (todoListArr[indexPath.row].isSuccessed) ? "성공~" : "노 완료~"
        if( self.todoListArr[indexPath.row].isSuccessed ){
            cell.contentView.layer.borderColor = UIColor.systemCyan.cgColor
            cell.contentView.layer.borderWidth = 3
        } else {
            cell.contentView.layer.borderColor = UIColor.red.cgColor
            cell.contentView.layer.borderWidth = 3
        }
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 100, height: 100)}
        return CGSize(width: collectionView.frame.width - flowLayout.minimumInteritemSpacing, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let handler = UIAlertController(title: "성공했나요?",
                                        message: (self.todoListArr[indexPath.row].isSuccessed) ? "이미 완료하셨습니다. 고생했어요!" : "오늘도 성공하셨나요?", preferredStyle: .alert)
        if ( !self.todoListArr[indexPath.row].isSuccessed ) {
            let ok = UIAlertAction(title: "성공", style: .default){ _ in
                try! date.realm.write{
                    self.todoListArr[indexPath.row].isSuccessed = true
                }
                date.editTodo(when: self.selectedDate(), self.todoListArr[indexPath.row], true)
                self.collectionView.reloadData()
                self.getCount()
            }
            let delete = UIAlertAction(title: "삭제", style: .destructive){ _ in
                let today = self.selectedDate()
                date.removeTodo(when: today, self.todoListArr[indexPath.row])
                self.getData(today)
                self.collectionView.reloadData()
                self.getCount()
            }
            handler.addAction(ok)
            handler.addAction(delete)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        handler.addAction(cancel)
        self.present(handler, animated: true)
    }
    
}
