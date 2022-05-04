import Foundation


struct ToDo: Codable {
    
    // MARK: Data structure
    
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    // MARK: Helper methods
    
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "First ToDo", isComplete: true, dueDate: Date(), notes: nil)
        let todo2 = ToDo(title: "Second ToDo", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let todo3 = ToDo(title: "Third ToDo", isComplete: false, dueDate: Date(), notes: "Notes 3")
        
        return [todo1, todo2, todo3]
    }
    static var dueDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    // MARK: On-device persistance

    enum SaveSucessStatus: Error { case success ; case failure }
    
    static var toDosURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let toDosURL = documentDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
        return toDosURL
    }
    
    static func loadToDos() -> [ToDo]? {
        guard let toDoData = try? Data(contentsOf: toDosURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: toDoData)
    }
    
    static func saveToDos(toDos: [ToDo]) throws {
        let propertyListEncoder = PropertyListEncoder()
        do {
            let toDoData = try propertyListEncoder.encode(toDos)
            try toDoData.write(to: toDosURL, options: .noFileProtection)
        } catch {
            throw SaveSucessStatus.failure
        }
    }
}
