// Kimberly Smith
// ULID: C00195077
// Assignment 8
// I certify that the unattributed code in this this assignment is entirely my own work.
//

import UIKit
import CoreData
class ContactViewController: UITableViewController {
var contactItems = [Contact]()
var selectedindexPaths = [IndexPath]()
var nameField : UITextField!
var phoneField : UITextField!
var emailField : UITextField!


@IBAction func done(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: nil)
}
// show Detail View for selected row
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
                    case "showContact"?:
                        if let row = tableView.indexPathForSelectedRow?.row {
                            let contact = self.contactItems[row]
                            let detailViewController = segue.destination as! DetailViewController
                            detailViewController.contact = contact
                        }
                    default:
                            preconditionFailure("Unexpected segue identifier")
                    }
}
    // popup modal that allows user to add a new contact
@IBAction func addNewContact(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
    
    alertController.addTextField {
        (nameField) -> Void in nameField.placeholder = "Name"
        nameField.autocapitalizationType = .words
        self.nameField = nameField
    }
    alertController.addTextField {
        (phoneField) -> Void in phoneField.placeholder = "337-555-5555"
        phoneField.keyboardType = UIKeyboardType.phonePad ;
        self.phoneField = phoneField
    }
    alertController.addTextField {
        (emailField) -> Void in emailField.placeholder = "emailName@gmail.com"
        emailField.keyboardType = UIKeyboardType.emailAddress;
        self.emailField = emailField
    }
    let okAction = UIAlertAction(title: "OK", style: .default) {
        (action) -> Void in
        
        if let contactName = self.nameField.text,
            let contactPhone = self.phoneField.text,
            let contactEmail = self.emailField.text{
            self.saveContact(name: contactName, phone: contactPhone, email: contactEmail)
            self.tableView.reloadData()
        }
        else {print("enter all required data")}
        
    }
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController,animated: true, completion: nil)
}
// save a new contact to database
func saveContact(name:String, phone: String, email: String){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let newContact = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)
    let contact = NSManagedObject(entity: newContact!, insertInto: managedContext) as! Contact
    contact.setValue(name, forKey: "name")
    contact.setValue(phone, forKey: "phone")
    contact.setValue(email, forKey: "email")
    
    print("contact: \(name)\n \(phone)\n \(email)")
    do {
        try managedContext.save()
    
        self.contactItems.append(contact)
        print("Core Data save successful")
    }catch{
        print("Core Data save failed: \(error)")
    }
    
}
    // load core data on view load
override func viewWillAppear(_ animated: Bool) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
    
    do {
        let results = try managedContext.fetch(fetchRequest)
        contactItems = results as! [Contact]
    }
    catch {
        print("failed to load")
    }
       tableView.reloadData()
}
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactItems.count
}
    // On Edit delete and move rows
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let contact = contactItems[indexPath.row]
            let title = "Delete \(contact.name!)?"
            let message = "Are you sure?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                self.contactItems.remove(at: indexPath.row)
                 managedContext.delete(contact)
                do {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    try managedContext.save()
                } catch {
                    print("Core Data save failed: \(error)")
                }
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
        }
    }
// move rows and save context
override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveContact(from: sourceIndexPath.row, to: destinationIndexPath.row)
    do {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        try managedContext.save()
    } catch {
        print("Core Data save failed: \(error)")
    }
}
    // move from one index to another
func moveContact(from fromIndex: Int, to toIndex: Int) {
    
        if fromIndex == toIndex {
            return
        }
        let movedContact = contactItems[fromIndex]
        contactItems.remove(at: fromIndex)
        contactItems.insert(movedContact, at: toIndex)
    
}
    // update cell or poulate cells 
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ContactCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
    let contact = contactItems[indexPath.row]
    cell.update(with: contact)
    return cell
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    navigationItem.leftBarButtonItem = editButtonItem
}
}
