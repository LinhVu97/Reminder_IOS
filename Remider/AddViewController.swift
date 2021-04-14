//
//  AddViewController.swift
//  Remider
//
//  Created by Vũ Linh on 14/04/2021.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleRemider: UITextField!
    @IBOutlet weak var bodyRemider: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleRemider.delegate = self
        bodyRemider.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }
    
    @objc func save() {
        if let titleText = titleRemider.text, !titleText.isEmpty,
           let bodyText = bodyRemider.text, !bodyText.isEmpty {
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
