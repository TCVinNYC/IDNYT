//
//  ClassListViewController.swift
//  IDNYT
//
//  Created by Prince on 11/7/21.
//

import UIKit
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ClassListViewController: UIViewController {
    private var db  = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we need a loading animation
        checkUserType { String in
            if(String == "professor"){
                    print("showing prof view")
                    let vc = PCLView()
                    
                    let hostingController = UIHostingController.init(rootView: vc)
                    self.addChild(hostingController)
                    hostingController.didMove(toParent: self)
                    self.view.addSubview(hostingController.view)
                    
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                        hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    ])
                    
                }else if (String == "student"){
                    print("showing student view")
                    let vc = clView()
                    
                    let hostingController = UIHostingController.init(rootView: vc)
                    self.addChild(hostingController)
                    hostingController.didMove(toParent: self)
                    self.view.addSubview(hostingController.view)
                    
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                        hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    ])
                }else{
                    print("broke")
                }
        }
    }
    
    func checkUserType(completion: @escaping ((String) -> Void)){
        var type : String = ""
        
        let docRef = db.collection("users").document((Auth.auth().currentUser?.email)!)
        docRef.getDocument {(document, error) in
            if let document = document, document.exists{
                let docData = document.data()
                type = docData?["type"] as? String ?? "no type"
                DispatchQueue.main.async{
                    completion(type)
                }
                return
            }else if let error = error{
                print("Document does not exist")
                print(error.localizedDescription)
                DispatchQueue.main.async{
                    completion("error")
                }
                return
            }
        }
    }
}
