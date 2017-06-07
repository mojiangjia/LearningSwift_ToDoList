//
//  ToDo.swift
//  ToDoList
//
//  Created by MoJ on 6/7/17.
//  Copyright © 2017 MoJ. All rights reserved.
//

import Foundation

class ToDo: NSObject, NSCoding {
    var title: String
    var dueDate: Date
    var isComplete: Bool
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos")
    
    struct PropertyKey {
        static let title = "title"
        static let isComplete = "isComplete"
        static let dueDate = "dueDate"
        static let notes = "notes"
    }
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?) {
        guard !title.isEmpty else {
            fatalError("Reminder requires a non-empty title")
        }
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [ToDo]
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        NSKeyedArchiver.archiveRootObject(todos, toFile: ArchiveURL.path)
    }
    
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let todo2 = ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let todo3 = ToDo(title: "ToDo Three", isComplete: true, dueDate: Date(), notes: "Notes 3")
        return [todo1, todo2, todo3]
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String,
            let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? Date else {
                return nil
        }

        let isComplete = aDecoder.decodeBool(forKey: PropertyKey.isComplete)
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        self.init(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(isComplete, forKey: PropertyKey.isComplete)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    
    
}
