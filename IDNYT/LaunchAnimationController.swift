//
//  LaunchAnimationController.swift
//  IDNYT
//
//  Created by Prince on 10/30/21.
//

import UIKit
import GoogleSignIn
import Firebase

class LaunchAnimationController: UIViewController {
    
    @IBOutlet weak var nyitIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nyitIcon.alpha = 0
        animate()
        setTheme()
    }
    
    private func animate(){
        /// idk how to do the bounce thing but fix later?
        
        UIView.animate(withDuration: 0.5){
            self.nyitIcon.alpha = 1
           //self.nyitIcon.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+25, height: self.view.frame.height+25)
            //print("big")
            
            self.nyitIcon.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            print("normal")
            
        } completion: { done in
            if done {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    
                    let user = Auth.auth().currentUser
                    print(user?.email ?? "no email")
                    if((user?.email?.hasSuffix("@nyit.edu")) == true){
                        print("User Exists")
                        self.performSegue(withIdentifier: "mainView", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "LoginScreen", sender: self)
                        print("moving to login")
                    }
                }

            }
        }

    }
    
    private func setTheme(){
        let userDefaults = UserDefaults.standard
        let THEME_KEY = "themeKey"
        let AUTO_THEME = "autoTheme"
        let LIGHT_THEME = "lightTheme"
        let DARK_THEME = "darkTheme"
        let theme = userDefaults.string(forKey: THEME_KEY)
        let appDelegate = UIApplication.shared.windows.first
        
        if(theme == AUTO_THEME){ appDelegate?.overrideUserInterfaceStyle = .unspecified }
        else if (theme == LIGHT_THEME) { appDelegate?.overrideUserInterfaceStyle = .light }
        else if (theme == DARK_THEME) { appDelegate?.overrideUserInterfaceStyle = .dark }
        else {appDelegate?.overrideUserInterfaceStyle = .unspecified }
        print("our theme is")
        print(theme ?? "default auto")
    }
}
