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
    
    @Published var attendance = [AttendanceModel]()
    
    private var db  = Firestore.firestore()

    //private var tempUser = AttendanceModel.init(student_details: ["Stevenson Chittumuri", "schittum@nyit.edu", "Zoom", "9:53 PM"])
    
    //private var tempArr = ["Stevenson Chittumuri", "schittum@nyit.edu", "Zoom", "9:53 PM"]
    
    //db.collection("courses").document("4WnqLykBVkR4njzrUtG2").collection("attendance").document("11-18-2021"
    // document(courseDoc).collection("attendance").document(dateDoc)
    // courseDoc:String, dateDoc:String,
    
    func getStudentDetails(courseDoc:String, dateDoc:String, completion: @escaping ((String) -> Void)){
        db.collection("courses").document(courseDoc).collection("attendance").document(dateDoc).addSnapshotListener {(querySnapshot, err) in
            //guard let documents = querySnapshot?.document else{
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
                completion("done")
        }
    }
    
    func setAttendance(courseDoc:String, dateDoc:String, tempUser : [String?] ,completion: @escaping ((String)-> Void)) {
        db.collection("courses").document(courseDoc).collection("attendance").document(dateDoc).setData([
            tempUser[1]! as String : FieldValue.arrayUnion(tempUser)
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
