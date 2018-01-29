// Kimberly Smith
// ULID: C00195077
// Assignment 8
// I certify that the unattributed code in this this assignment is entirely my own work.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // set the title of the Detail View to the current Contact's Name
    var contact: Contact! {
        didSet {
            navigationItem.title = contact.name
        }
    }
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var phoneField: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    // keyboard return 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // populate the textfields with current contact data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = contact.name
        phoneField.text = contact.phone
        emailField.text = contact.email
    }
    // save user edits on return to tableview
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contact.name = nameField.text ?? ""
        contact.phone = phoneField.text ?? ""
        contact.email = emailField.text ?? ""
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            try managedContext.save()
        } catch {
            print("Core Data save failed: \(error)")
        }
    }

}

