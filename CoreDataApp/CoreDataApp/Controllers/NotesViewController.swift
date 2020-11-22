//
//  ViewController.swift
//  CoreDataApp
//
//  Created by SS on 20.11.2020..
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    var noteArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Outlets:
    @IBOutlet weak var notesTableView: UITableView!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
        noteArray = DataManager.sharedInstance.loadNotes()
        noteArray = noteArray.reversed()
        notesTableView.reloadData()
    }

    
    //MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addNoteVC = self.storyboard!.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    func setUpView() {
        view.backgroundColor = UIColor.white
        notesTableView.backgroundColor = UIColor.white
    }
    
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        
        cell.setupNoteTableViewCell(title: noteArray[indexPath.row].title!, date: noteArray[indexPath.row].date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addNoteVC = self.storyboard!.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        
        addNoteVC.noteTitle = noteArray[indexPath.row].title
        addNoteVC.noteMessage = noteArray[indexPath.row].message
        addNoteVC.noteDate = noteArray[indexPath.row].date
        addNoteVC.noteIndex = indexPath.row
        
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(noteArray[indexPath.row])
            noteArray.remove(at: indexPath.row)
            
            DataManager.sharedInstance.saveNotes()
            notesTableView.reloadData()
        }
    }
}

