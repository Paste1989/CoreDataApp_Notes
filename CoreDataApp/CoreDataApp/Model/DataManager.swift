//
//  DataManager.swift
//  CoreDataApp
//
//  Created by SS on 21.11.2020..
//

import UIKit
import Foundation
import CoreData

class DataManager: NSObject {
    
    public static let sharedInstance = DataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveNotes() {
        do {
            try context.save()
        }
        catch {
            print("Error saving contex \(error)")
        }
    }
   
    func loadNotes() -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        var array = [Note]()
        do {
            array = try context.fetch(request)
        }
        catch {
            print("Error fetching data from contex \(error)")
        }
        return array
    }
    
    func createNote(title: String, message: String) {
        var array = [Note]()
        let newNote = Note(context: context)
        newNote.title = title
        newNote.message = message

        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy-MM-dd, HH:mm:ss")
        newNote.date = formate

        array.append(newNote)
    }
    
    func updateNote(index: Int, array: [Note], updatedTitle: String, updatedMessage: String) {
        array[index].title = updatedTitle
        array[index].message = updatedMessage
    }
}
