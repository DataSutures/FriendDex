// Kimberly Smith
// ULID: C00195077
// Assignment 8
// I certify that the unattributed code in this this assignment is entirely my own work.
//

import UIKit
class ContactCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var email: UILabel!
    
    // update recieves a Contact and updates the cell Labels to the parameter's data
    func update(with contact: Contact!) {
        if let contactToDisplay = contact {
            name.text = contactToDisplay.name
            phone.text = contactToDisplay.phone
            email.text = contactToDisplay.email
        } else {
            name.text = nil
            phone.text = nil
            email.text = nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
}

