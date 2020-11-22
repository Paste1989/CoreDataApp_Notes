//
//  AddNoteViewController.swift
//  CoreDataApp
//
//  Created by SS on 20.11.2020..
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: - Variables
    var noteArray = [Note]()
    var noteTitle: String?
    var noteMessage: String?
    var noteDate: String?
    var noteIndex: Int?
    
    
    //MARK: - UIElemnts
    let dateLabel = UILabel()
    let titleTextField = UITextField()
    let messageTextView = UITextView()
    let addButton = UIButton()
    
    let placeholderText = "Add note.."
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        messageTextView.delegate = self
        
        setupUI()
        setUIConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleTextField.text = noteTitle
        messageTextView.text = noteMessage
        dateLabel.text = noteDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
        
        if noteIndex == nil {
            addButton.setTitle("Add Note", for: .normal)
            messageTextView.textColor = UIColor.lightGray
            messageTextView.text = placeholderText
        }
        else {
            addButton.setTitle("Change Note", for: .normal)
        }
    }
    
    //MARK: - Actions
    func setUpView() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupUI() {
        //Label
        let labelHeight = 30
        let labelWidth = 250
        dateLabel.frame = CGRect(x: Int(self.view.bounds.width/2) - labelWidth/2, y: 125, width: labelWidth, height: labelHeight)
        dateLabel.textAlignment = .center
        dateLabel.text = ""
        self.view.addSubview(dateLabel)
        
        //TextField
        let textFieldHeight: CGFloat = 50.0
        let textFieldWidth: CGFloat = 300.0
        titleTextField.frame = CGRect(x: view.bounds.width/2 - textFieldWidth/2, y: view.bounds.height/3 - textFieldHeight * 1.5, width: textFieldWidth, height: textFieldHeight)
        titleTextField.textAlignment = .center
        titleTextField.font = UIFont.systemFont(ofSize: 20)
        titleTextField.backgroundColor = UIColor.white
        titleTextField.textColor = UIColor.black
        titleTextField.layer.cornerRadius = 20
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.text = ""
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Enter Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.view.addSubview(titleTextField)
        
        //TextView
        let textViewHeight: CGFloat = 300.0
        let textViewWidth: CGFloat = 300.0
        messageTextView.frame = CGRect(x: view.bounds.width/2 - textViewWidth/2, y: view.bounds.height/3, width: textViewWidth, height: textViewHeight)
        messageTextView.font = UIFont.systemFont(ofSize: 20)
        messageTextView.backgroundColor = .white
        messageTextView.textColor = UIColor.black
        messageTextView.layer.cornerRadius = 20
        messageTextView.layer.borderColor = UIColor.black.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.text = ""
        self.view.addSubview(messageTextView)

        //Button
        addButton.frame = CGRect(x: self.view.frame.size.height, y: self.view.frame.size.height - 300, width: 150, height: 65)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = UIColor.clear
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        addButton.layer.cornerRadius = 20
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(addButton)
    }
    
    func setUIConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            dateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 30),
            dateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 200),
            
            titleTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            titleTextField.widthAnchor.constraint(equalToConstant: 300),
            
            messageTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            messageTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 35) ,
            messageTextView.widthAnchor.constraint(equalToConstant: 200),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.view = view
    }
    
    func alertMessage() {
        let alert = UIAlertController(title: "Can not save Note", message: "Please enter Title and Note", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    @objc func buttonAction(sender: UIButton!) {
        if noteIndex == nil {
            if titleTextField.text != "" && messageTextView.text != "" && messageTextView.text != placeholderText {
                DataManager.sharedInstance.createNote(title: titleTextField.text!, message: messageTextView.text!)
                
                DataManager.sharedInstance.saveNotes()
                navigationController?.popViewController(animated: true)
            }
            else {
                alertMessage()
            }
        }
        else {
            if titleTextField.text != "" && messageTextView.text != "" && messageTextView.text != placeholderText {
                noteArray = DataManager.sharedInstance.loadNotes()
                DataManager.sharedInstance.updateNote(index: noteIndex!, array: noteArray, updatedTitle: titleTextField.text!, updatedMessage: messageTextView.text!)
            
                DataManager.sharedInstance.saveNotes()
                navigationController?.popViewController(animated: true)
            }
            else {
                alertMessage()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if titleTextField.text != "" {
            addButton.isEnabled = true
            return true
        }
        else {
            addButton.isEnabled = false
            titleTextField.attributedPlaceholder = NSAttributedString(string: "Need to enter Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            titleTextField.tintColor = UIColor.white
            return false
        }
    }
    
    
    //MARK: - UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeholderText {
            textView.text = ""
            messageTextView.textColor = UIColor.black
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            messageTextView.textColor = UIColor.lightGray
        }
    }
}




