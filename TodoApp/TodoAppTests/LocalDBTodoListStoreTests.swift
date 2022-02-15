//
//  LocalDBTodoListStoreTests.swift
//  TodoAppTests
//
//  Created by burt on 2022/02/15.
//

import XCTest
@testable import TodoApp

class LocalDBTodoListStoreTests: XCTestCase {
    private var store: TodoListStore!
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    override func setUpWithError() throws {
        store = TodoListStore(repository: LocalDBRepository())
    }

    override func tearDownWithError() throws {
        store = nil
    }
    
    func test_ToDo_목록_불러오기() async {
        await store.deleteAllTodoAction()
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 0)
    }
    
    func test_ToDo_추가하기() async {
        await store.deleteAllTodoAction()
        let todo = Todo(id: 0, title: "로또 1등 당첨금 수령하기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList.count, 1)
        XCTAssertEqual(store.state.todoList.last!.id, todo.id)
        XCTAssertEqual(store.state.todoList.last!.title, todo.title)
        XCTAssertEqual(DateUtils.dateToString(store.state.todoList.last!.date), DateUtils.dateToString(todo.date))
        XCTAssertEqual(store.state.todoList.last!.done, todo.done)
    }
    
    func test_Todo_모두_삭제하기() async {
        await store.deleteAllTodoAction()
        
        let todo = Todo(id: UUID().hashValue, title: "로또 1등 당첨금 수령하기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList.count, 1)
        XCTAssertEqual(store.state.todoList.last!.id, todo.id)
        XCTAssertEqual(store.state.todoList.last!.title, todo.title)
        XCTAssertEqual(DateUtils.dateToString(store.state.todoList.last!.date), DateUtils.dateToString(todo.date))
        XCTAssertEqual(store.state.todoList.last!.done, todo.done)
        
        await store.deleteAllTodoAction()
        XCTAssertEqual(store.state.todoList.count, 0)
    }
    
    func test_Todo_아디이로_삭제하기() async {
        await store.deleteAllTodoAction()
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        let todo2 = Todo(id: UUID().hashValue, title: "영화 보기", content: "", date: Date(), done: false)
        
        await store.insertTodoAction(todo: todo1)
        await store.insertTodoAction(todo: todo2)

        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 2)
        let firstTodo = store.state.todoList[0]
        let secondTodo = store.state.todoList[1]
        await store.deleteTodoAction(todo: firstTodo)
        XCTAssertEqual(store.state.todoList.count, 1)
        
        XCTAssertEqual(store.state.todoList.first!, secondTodo)
        XCTAssertEqual(store.state.todoList.first!.id, secondTodo.id)
        XCTAssertEqual(store.state.todoList.first!.title, secondTodo.title)
        XCTAssertEqual(DateUtils.dateToString(store.state.todoList.first!.date), DateUtils.dateToString(secondTodo.date))
        XCTAssertEqual(store.state.todoList.first!.done, secondTodo.done)
    }

    func test_Todo_완료하기() async {
        await store.deleteAllTodoAction()
        
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo1)
        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 1)
        
        let todo = store.state.todoList[0]
        await store.doneTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, true)
    }

    func test_Todo_완료_해제하기() async {
        await store.deleteAllTodoAction()
        
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo1)
        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 1)
        
        var todo = store.state.todoList[0]
        await store.doneTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, true)
        
        todo = store.state.todoList[0]
        await store.reopenTodoAction(todo: todo)
        XCTAssertEqual(store.state.todoList[0].done, false)
    }

    func test_Todo_제목_변경하기() async {
        await store.deleteAllTodoAction()
        
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo1)
        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 1)
        
        let todo = store.state.todoList[0]
        XCTAssertEqual(todo.title, "슈퍼마켓 가기")
        
        await store.change(todo: todo, withTitle: "자동차 세차하기")
        XCTAssertEqual(store.state.todoList[0].title, "자동차 세차하기")
    }

    func test_Todo_목표일자_변경하기() async {
        await store.deleteAllTodoAction()
        
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo1)
        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 1)
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
        await store.deleteAllTodoAction()
        
        // 처음에는 0개이다.
        XCTAssertEqual(store.state.todoList.count, 0)
        
        let todo1 = Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false)
        await store.insertTodoAction(todo: todo1)
        
        // 로드한다.
        await store.loadTodoListAction()
        XCTAssertEqual(store.state.todoList.count, 1)

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
