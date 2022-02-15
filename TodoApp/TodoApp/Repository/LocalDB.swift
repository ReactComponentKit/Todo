//
//  LocalDB.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import Foundation
import GRDB
import UIKit

class LocalDBRepository: Repository {
    private let pool: DatabasePool
    
    init() {
        do {
            let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
            let dbPath = urls[0].appendingPathComponent("todo.sqlite").path
            self.pool = try DatabasePool(path: dbPath)
            try self.createTodoTableIfNotExists()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func createTodoTableIfNotExists() throws {
        try pool.write({ db in
            try db.execute(sql: """
            CREATE TABLE IF NOT EXISTS todos(
                id INTEGER PRIMARY KEY,
                title TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL DEFAULT '',
                date TEXT NOT NULL DEFAULT '',
                done INTEGER DEFAULT 0
            );
            """)
        })
    }
    
    func loadTodoList() async throws -> [Todo] {
        let rows = try await pool.read({ db in
            return try Row.fetchAll(db, sql: "SELECT id, title, content, date, done FROM todos")
        })
        let todos = rows.map { row in
            return Todo(
                id: row["id"],
                title: row["title"],
                content: row["content"],
                date: DateUtils.stringToDate(row["date"]),
                done: row["done"] == 1
            )
        }
        return todos
    }
    
    func insert(todo: Todo) async throws {
        try await pool.write({ db in
            try db.execute(sql: "INSERT INTO todos VALUES(?, ?, ?, ?, ?)", arguments: [
                todo.id,
                todo.title,
                todo.content,
                DateUtils.dateToString(todo.date),
                todo.done ? 1 : 0
            ])
        })
    }
    
    func delete(todo: Todo) async throws {
        try await pool.write({ db in
            try db.execute(sql: "DELETE FROM todos WHERE id = ?", arguments: [todo.id])
        })
    }
    
    func update(todo: Todo) async throws {
        try await pool.write({ db in
            try db.execute(sql: "UPDATE todos SET title = ?, content = ?, date = ?, done = ? WHERE id = ?", arguments: [
                todo.title,
                todo.content,
                DateUtils.dateToString(todo.date),
                todo.done ? 1 : 0,
                todo.id
            ])
        })
    }
    
    func deleteAll() async throws {
        try await pool.write({ db in
            try db.execute(sql: "DELETE FROM todos")
        })
    }
}
