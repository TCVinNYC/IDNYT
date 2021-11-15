//
//  ClassViewModel.swift
//  IDNYT
//
//  Created by Prince on 11/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ClassViewModel : ObservableObject{
    
    let userEmail = "schittum@nyit.edu"///Auth.auth().currentUser?.email
    
    @Published var classes = [ClassModel]()
    
    
    private var db  = Firestore.firestore()
    
    //later you can add the field comparing the semesters (maybe only give it to professor for now
    
    func getProfessorCourses(completion: @escaping ((String) -> Void)){
        db.collection("courses").whereField("professor_email", isEqualTo: userEmail).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("no docs - \(err)")
                completion("no docs")
            }else{
                self.classes = (querySnapshot?.documents.map({ doc in
                    ClassModel(id: doc.documentID,
                               prof_name: doc["professor_name"] as? String ?? "",
                               prof_email: doc["professor_email"] as? String ?? "",
                               course_name: doc["course_name"] as? String ?? "",
                               course_section: doc["course_section"] as? String ?? "",
                               course_location: doc["course_location"] as? String ?? "",
                               course_time_start: doc["course_start_time"] as? String ?? "",
                               course_time_end: doc["course_end_time"] as? String ?? "",
                               course_days: doc["course_days"] as? [String] ?? [],
                               course_semester: doc["course_semester"] as? String ?? "")
                    
                }))!
                completion("done")
            }
        }
    }
    
    func getStudentCourses(){
        db.collection("courses").whereField("students", isEqualTo: userEmail).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("no docs - \(err)")
            }else{
                self.classes = (querySnapshot?.documents.map({ doc in
                    ClassModel(id: doc.documentID,
                               prof_name: doc["professor_name"] as? String ?? "",
                               prof_email: doc["professor_email"] as? String ?? "",
                               course_name: doc["course_name"] as? String ?? "",
                               course_section: doc["course_section"] as? String ?? "",
                               course_location: doc["course_location"] as? String ?? "",
                               course_time_start: doc["course_start_time"] as? String ?? "",
                               course_time_end: doc["course_end_time"] as? String ?? "",
                               course_days: doc["course_days"] as? [String] ?? [],
                               course_semester: doc["course_semester"] as? String ?? "")
                    
                }))!
            }
        }
    }
    
    func addCourse(prof_name:String, prof_email:String, c_name: String, section: String, location: String, time_s: String, time_e: String, days:[String], semester: String) {

        db.collection("courses").addDocument(data: ["professor_name":prof_name, "professor_email":prof_email, "course_name":c_name, "course_section":section, "course_location":location, "course_start_time":time_s, "course_end_time":time_e, "course_days":days, "course_semester":semester]){error in
            
            if error == nil {
                self.getProfessorCourses { String in
                    print(String)
                }
                print("new course uploaded!")
            }else{
                print("course failed to upload!")
            }
        }
    }
    
    func updateCourse(courseToUpdate: ClassModel){
        db.collection("courses").document(courseToUpdate.id!).updateData(
            ["professor_name":courseToUpdate.prof_name,
             "professor_email":courseToUpdate.prof_email,
             "course_name":courseToUpdate.course_name,
             "course_section":courseToUpdate.course_section,
             "course_location":courseToUpdate.course_location,
             "course_start_time":courseToUpdate.course_time_start,
             "course_end_time":courseToUpdate.course_time_end,
             "course_days":courseToUpdate.course_days,
             "course_semester":courseToUpdate.course_semester]){
            error in
            if error == nil {
                self.getProfessorCourses { String in
                    print(String)
                }
                print("new course uploaded!")
            }else{
                print("course failed to update!")
            }
        }
    }
    
//    func getSpecificCourse(findID:String, completion: @escaping ((ClassModel))){
//        db.collection("courses").document(findID).getDocument(source: .cache) {(document, error) in
//            if let doc = document {
//                let temp = ClassModel(id: findID, prof_name: doc["professor_name"] as? String ?? "",
//                                  prof_email: doc["professor_email"] as? String ?? "",
//                                  course_name: doc["course_name"] as? String ?? "",
//                                  course_section: doc["course_section"] as? String ?? "",
//                                  course_location: doc["course_location"] as? String ?? "",
//                                  course_time_start: doc["course_start_time"] as? String ?? "",
//                                  course_time_end: doc["course_end_time"] as? String ?? "",
//                                  course_days: doc["course_days"] as? [String] ?? [],
//                                  course_semester: doc["course_semester"] as? String ?? "")
//                completion(temp)
//            }else{
//                print("error finding course")
//                return
//                
//            }
//        }
//    }
    
    
}


//old code

//        db.collection("courses").whereField("professor_email", isEqualTo: userEmail ?? "Temp Email").addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else{
//                completion("no docs")
//                return
//            }
//            DispatchQueue.main.async {
//                print("you have courses")
//                self.classes = documents.map({ doc in
//                     ClassModel(id: doc.documentID,
//                                      prof_name: doc["professor_name"] as? String ?? "",
//                                      prof_email: doc["professor_email"] as? String ?? "",
//                                      course_name: doc["course_name"] as? String ?? "",
//                                      course_section: doc["course_section"] as? String ?? "",
//                                      course_location: doc["course_location"] as? String ?? "",
//                                      course_time_start: doc["course_start_time"] as? String ?? "",
//                                      course_time_end: doc["course_end_time"] as? String ?? "",
//                                      course_days: doc["course_days"] as? [String] ?? [],
//                                      course_semester: doc["course_semester"] as? String ?? "")
//
//                })
//                completion("sent courses")
//                return
//            }
//        }
