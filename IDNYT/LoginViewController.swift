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
        
        //sets 4 images to UserData for scanning cards later
        let defaultImage = UIImage(named: "AddImage")
        let imageData = defaultImage?.jpegData(compressionQuality: 1.0)
        UserDefaults.standard.set(imageData, forKey: "nyitFront")
        UserDefaults.standard.set(imageData, forKey: "nyitBack")
        UserDefaults.standard.set(imageData, forKey: "vaxFront")
        UserDefaults.standard.set(imageData, forKey: "vaxBack")

    }
    
    @IBAction func signInClick(_ sender: Any) {
        signIn()
        return
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
                    try! Auth.auth().signOut()
                    self.performSegue(withIdentifier: "whoopsScreen", sender: self)
                }
                return
            }


        }
        
    }
    
}

