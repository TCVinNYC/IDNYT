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
        appDelegate?.overrideUserInterfaceStyle = .unspecified
        userDefaults.set(AUTO_THEME, forKey: THEME_KEY)
        userDefaults.set("", forKey: ID_KEY)
        
        
       // appDelegate?.window?.rootViewController?.performSegue(withIdentifier: "signOut", sender: self)
        
       // navigationController?.pushViewController(LaunchAnimationController, animated: true)
        
//        let launchPage = self.storyboard?.instantiateViewController(withIdentifier: "signOut")
//        let appDelegate = UIApplication.shared.delegate
//        appDelegate?.window.rootViewController = launchPage
        
//        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "signOut") as! LaunchAnimationController
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
  //          view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//
        
        //self.navigationController?.popToViewController(LaunchAnimationController(), animated: true)
        
        self.performSegue(withIdentifier: "signOut", sender: self)
        return
    }
    
    //handles app appearance
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
    
    //disables paste feature because of the TextBox
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
