//
//  AddListController.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/06/28.
//

import UIKit



class AddListController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTodoList.delegate = self
        selectTodoList.dataSource = self
        inputText.delegate = self
        inputText.placeholder = "추가할 내용을 입력하세요(최대 30자)"
        textFieldSet()
        selectedList = pickerList[0]
    }
    
    
    
    
    
    @IBOutlet var selectTodoList: UIPickerView!
    @IBOutlet var inputText: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    let pickerList: [String] = ["공부하기", "독서하기", "운동하기", "여가활동", "기타"]
    
    var selectedList: String = ""
    var toolbarList: Int = 0
    
    
    
    @IBAction func goAdd(_ sender: Any) {
        // UITabBarController 안에 UIViewController가 있기 때문에
        // UITabBarController 를 먼저 열어 주고 그 안에 UIViewController 로 접근을 해야 한다.
        
        guard let preVC = self.presentingViewController as? UITabBarController else {return}
        if toolbarList == 0 {
            guard let nextVC = preVC.selectedViewController as? TodoViewController else {return}
            let title = self.selectedList
            guard let subtitle = self.inputText.text else {
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let date = formatter.string(from: datePicker.date)
            
            let todoSample = TodoList(title: title, subtitle: subtitle, date: date, isSuccessed: false)
            
            
            
            nextVC.receivedTodo = todoSample
        } else {
            guard let nextVC = preVC.selectedViewController as? CollectionViewController else {return}
            let title = self.selectedList
            guard let subtitle = self.inputText.text else {
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let date = formatter.string(from: datePicker.date)
            
            let todoSample = TodoList(title: title, subtitle: subtitle, date: date, isSuccessed: false)
            
            nextVC.sel2ReceivedTodo = todoSample
        }
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textFieldSet() {
        inputText.textAlignment = .justified
        inputText.contentVerticalAlignment = .top
        inputText.returnKeyType = .done
        inputText.font = UIFont(name: (inputText.font?.fontName)!, size: 20)
    }
    
    
}

// MARK: - UIPickerView 익스텐션
extension AddListController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedList = pickerList[row]
    }
    
    
}

// MARK: - UITextField 익스텐션
extension AddListController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let count = inputText.text else { return false }

        // backspace 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackspace = strcmp(char, "\\b")
            if isBackspace == -92 {
                return true
            }
        }
        
        // 글자수 30 이상 제한
        if count.count > 30 {
            return false
        }
        
        return true
    }
    
    
    
    
}
