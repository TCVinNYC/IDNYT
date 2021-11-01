//
//  AccountInfoController.swift
//  IDNYT
//
//  Created by Prince on 11/1/21.
//

import UIKit
import Firebase

class AccountInfoController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var appAppearance: UISegmentedControl!
    @IBOutlet weak var signOutBtn: UIButton!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = user?.displayName
        userEmail.text = user?.email
    }
    @IBAction func signOut(_ sender: Any) {
        print("Signing Out")
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "signOut", sender: self)
    }
    
}
