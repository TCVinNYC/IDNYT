//
//  AttendanceViewModel.swift
//  IDNYT
//
//  Created by Prince on 11/18/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class AttendanceViewModel : ObservableObject {
    
    let userEmail = Auth.auth().currentUser?.email
    let userName = Auth.auth().currentUser?.displayName
    
    @Published var attendance = [AttendanceModel]()
    
    private var db  = Firestore.firestore()
    
    func getStudentDetails(courseDoc:String, dateDoc:String, completion: @escaping ((String) -> Void)){
        db.collection("courses").document(courseDoc).collection("attendance").document(dateDoc).addSnapshotListener {(querySnapshot, err) in
            guard let document = querySnapshot else {
                print("no docs")
               return completion("no docs")
            }
            guard let data = document.data() else {
                print("Empty docs")
                return completion("empty docs")
            }
            
            self.attendance = (data.map({ doc in
                AttendanceModel(student_details: doc.value as! [String])
            }))
            return completion("done")
        }
    }
    
    //change to .cache later, keep default for testing reasons
    func studentSignIn(courseDoc:String, dateDoc:String, studentEmail: String, completion: @escaping ((String) -> Void)){
        db.collection("courses").document(courseDoc).collection("attendance").document(dateDoc).getDocument(source: .default) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("checking descrip")
                if(dataDescription.contains(studentEmail)){
                    print("you exist")
                    return completion ("true")
                }
                return completion ("false")
            } else {
              print("Document does not exist in cache")
                return completion ("false")
            }
          }
    }
    
    func setAttendance(courseDoc:String, dateDoc:String, tempUser : [String?] ,completion: @escaping ((String)-> Void)) {
        db.collection("courses").document(courseDoc).collection("attendance").document(dateDoc).setData([
            tempUser[1]! as String : FieldValue.arrayUnion(tempUser as [Any])
        ], merge: true){
            err in
            if let err = err {
                print("Error uploading \(err)")
            } else {
                print("Uploaded")
            }
        }
    }
}
