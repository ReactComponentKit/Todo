//
//  TodoAppTests.swift
//  TodoAppTests
//
//  Created by burt on 2021/11/09.
//

import XCTest
@testable import TodoApp

class InMemoryTodoListStoreTests: XCTestCase {
    
    private var store: TodoListStore!

    override func setUpWithError() throws {
        store = TodoListStore(repository: InMemoryRepository())
    }

    override func tearDownWithError() throws {
        store = nil
    }
    
    func test_ToDo목록불러오기() async {
        await store.loadTodoListAction()
        XCTAssertGreaterThan(store.state.todoList.count, 0)
        XCTAssertEqual(store.state.todoList.count, 4)
    }
    
    func test_ToDo추가하기() async {
        let todo = Todo(id: UUID().uuidString, title: "로또 1등 당첨금 수령하기", date: Date(), done: false)
        await store.insertTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList.count, 5)
        XCTAssertEqual(store.state.todoList.last!, todo)
    }
    
    func test_Todo아디이로_삭제하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        let firstTodo = store.state.todoList[0]
        let secondTodo = store.state.todoList[1]
        await store.deleteTodoAction(todo: firstTodo)
        XCTAssertEqual(store.state.todoList.count, 3)
        XCTAssertEqual(store.state.todoList.first!, secondTodo)
    }
    
    func test_Todo_완료하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        let todo = store.state.todoList[0]
        await store.doneTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, true)
    }
    
    func test_Todo_완료해제하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        var todo = store.state.todoList[0]
        await store.doneTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, true)
        todo = store.state.todoList[0]
        await store.reopenTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, false)
    }
    
    func test_Todo_제목_변경하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        let todo = store.state.todoList[0]
        XCTAssertEqual(todo.title, "슈퍼마켓 가기")
        await store.change(todo: todo, withTitle: "자동차 세차하기")
        XCTAssertEqual(store.state.todoList[0].title, "자동차 세차하기")
    }
    
    func test_Todo_목표일자_변경하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        let todo = store.state.todoList[0]
        
        let dateString = "2021-12-24 12:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)!
        await store.change(todo: todo, withDate: date)
        
        let resultDateString = dateFormatter.string(from: store.state.todoList[0].date)
        XCTAssertEqual(resultDateString, "2021-12-24 12:00:00")
    }
    
    func test_Todo_변경하기() async {
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 4)
        
        let dateString = "2021-12-24 12:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)!
        
        var todo = store.state.todoList[0]
        todo.done = true
        todo.date = date
        todo.title = "크리스마스 선물 사기"
        
        await store.change(todo: todo)
        
        let firstTodo = store.state.todoList[0]
        
        XCTAssertEqual(firstTodo.done, true)
        XCTAssertEqual(firstTodo.date, date)
        XCTAssertEqual(firstTodo.title, "크리스마스 선물 사기")
    }
}
