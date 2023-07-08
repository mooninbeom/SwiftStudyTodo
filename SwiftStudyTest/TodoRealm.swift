//
//  TodoRealm.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/07/01.
//


import RealmSwift

class date: Object {
    @Persisted var savedDate: String = ""
    @Persisted var todoList: List<Todo>
}


class Todo: Object {
    @Persisted var title: String = ""
    @Persisted var subtitle: String = ""
    @Persisted var date: String = ""
    @Persisted var isSuccessed: Bool = false
}


extension date {
    public static var realm = try! Realm()
    
    
    
    private static func findAll() -> Results<date> {
        let a = realm.objects(date.self)
        return a
    }
    
    static func findSelectedDate(_ savedDate: String) -> Results<date> {
        let allObj = realm.objects(date.self)
        let selectedObj = allObj.where { a in
            a.savedDate == savedDate
        }
        return selectedObj
    }
    
    static func addTodo(when savedDate: String, _ todo: Todo) -> Void {
        let now = findSelectedDate(savedDate)
        
        try! realm.write{
            if now.isEmpty {
                let a = date()
                a.savedDate = savedDate
                a.todoList.append(todo)
                realm.add(a)
            } else {
                now[0].todoList.append(todo)
            }
        }
    }
    
    static func removeTodo(when savedDate: String, _ todo: Todo) -> Void {
        let now = findSelectedDate(savedDate)
        if now.isEmpty {
            print(savedDate)
            print("error!!")
            return
        }
        
        let idx = now[0].todoList.firstIndex(where: {
            if $0.title == todo.title && $0.subtitle == todo.subtitle && $0.date == todo.date {
                return true
            } else {
                return false
            }
        })
        
        let removeTodo = realm.objects(Todo.self).where{ td in
            (td.title == todo.title) && (td.subtitle == todo.subtitle) && (td.date == todo.date)
        }.first
        
        try! realm.write {
            now[0].todoList.remove(at: idx!)
            realm.delete(removeTodo!)
        }
    }
    
    static func editTodo(when savedDate: String, _ todo: Todo, _ isSuccess: Bool) -> Void {
        let now = findSelectedDate(savedDate)
        if now.isEmpty {
            print(savedDate)
            print("error!!")
            return
        }
        
        let idx = now[0].todoList.firstIndex(where: {
            if $0.title == todo.title && $0.subtitle == todo.subtitle && $0.date == todo.date {
                return true
            } else {
                return false
            }
        })
        
        try! realm.write {
            now[0].todoList[idx!].isSuccessed = isSuccess
        }
        
        
        
    }
    
    static func getCount(_ savedDate: String) -> Int {
        let a = findSelectedDate(savedDate)
        if a.isEmpty {
            return 0
        } else {
            let count = a[0].todoList.count
            return count
        }
    }
    
}
