//
//  ViewController.swift
//  IDNYT
//
//  Created by Prince on 10/30/21.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInClick(_ sender: Any) {
        signIn()
    }
    
    func signIn(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
            print("broke signin")
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if(error != nil){
                    print("broke auth")
                    return
                }
                print("user signed in")
                print(user?.profile?.email)
                
                if((user?.profile?.email.hasSuffix("@nyit.edu")) == true){
                    self.performSegue(withIdentifier: "mainView", sender: self)
                }else{
                    self.performSegue(withIdentifier: "whoopsScreen", sender: self)
                }
                return
            }
        
        
        }
        
    }
    
}

