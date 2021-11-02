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
    
    let appDelegate = UIApplication.shared.windows.first
    let userDefaults = UserDefaults.standard
    let THEME_KEY = "themeKey"
    let AUTO_THEME = "autoTheme"
    let LIGHT_THEME = "lightTheme"
    let DARK_THEME = "darkTheme"
    let ID_KEY = "idKey"
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        userID.keyboardType = .asciiCapableNumberPad
        userID.returnKeyType = .done
        userName.text = user?.displayName
        userEmail.text = user?.email
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    //loads all the user data
    func loadSettings(){
        let theme = userDefaults.string(forKey: THEME_KEY)
        if(theme == AUTO_THEME){ appAppearance.selectedSegmentIndex = 0 }
        else if (theme == LIGHT_THEME) { appAppearance.selectedSegmentIndex = 1 }
        else if (theme == DARK_THEME) { appAppearance.selectedSegmentIndex = 2 }
        
        if(userDefaults.string(forKey: ID_KEY) != nil){
            userID.text = userDefaults.string(forKey: ID_KEY)
        }
    }
    
    @IBAction func idNumber(_ sender: Any) {
        if(userID.hasText){
            userDefaults.set(userID.text, forKey: ID_KEY)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        print("Signing Out")
        try! Auth.auth().signOut()
        //erase user data
        self.performSegue(withIdentifier: "signOut", sender: self)
        appDelegate?.overrideUserInterfaceStyle = .unspecified
        userDefaults.set(AUTO_THEME, forKey: THEME_KEY)
        userDefaults.set("", forKey: ID_KEY)
    }
    
    @IBAction func indexChanged(_sender: Any){
        switch appAppearance.selectedSegmentIndex{
        case 0:
            appDelegate?.overrideUserInterfaceStyle = .unspecified
            userDefaults.set(AUTO_THEME, forKey: THEME_KEY)
        case 1:
            appDelegate?.overrideUserInterfaceStyle = .light
            userDefaults.set(LIGHT_THEME, forKey: THEME_KEY)
        case 2:
            appDelegate?.overrideUserInterfaceStyle = .dark
            userDefaults.set(DARK_THEME, forKey: THEME_KEY)
        default:
            appDelegate?.overrideUserInterfaceStyle = .unspecified
            userDefaults.set(AUTO_THEME, forKey: THEME_KEY)
        }
    }
    
    @objc func handleTap() {
        userID.resignFirstResponder() // dismiss keyoard
    }
}
