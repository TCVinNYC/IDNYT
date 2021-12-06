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
    
    let userEmail = Auth.auth().currentUser?.email
    let userName = Auth.auth().currentUser?.displayName
    
    @Published var classes = [ClassModel]()
    
    private var db  = Firestore.firestore()
    
    @Published var locationList : [String] = []
    @Published var city : String = ""
    
    //later you can add the field comparing the semesters (maybe only give it to professor for now
    func getProfessorCourses(completion: @escaping ((String) -> Void)){
        db.collection("courses").whereField("professor_email", isEqualTo: userEmail ?? "no email").addSnapshotListener {(querySnapshot, err) in
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
                               course_zoomLink: doc["course_zoomLink"] as? String ?? "",
                               course_time_start: doc["course_start_time"] as? String ?? "",
                               course_time_end: doc["course_end_time"] as? String ?? "",
                               course_days: doc["course_days"] as? [String] ?? [],
                               course_semester: doc["course_semester"] as? String ?? "",
                               student_list: doc["student_list"] as? [String] ?? [])
                    
                }))!
                completion("done")
            }
        }
    }
    

    
    
    func getStudentCourses(completion: @escaping ((String) -> Void)){
        db.collection("courses").whereField("student_list", arrayContains: userEmail ?? "no email").addSnapshotListener {(querySnapshot, err) in
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
                               course_zoomLink: doc["course_zoomLink"] as? String ?? "",
                               course_time_start: doc["course_start_time"] as? String ?? "",
                               course_time_end: doc["course_end_time"] as? String ?? "",
                               course_days: doc["course_days"] as? [String] ?? [],
                               course_semester: doc["course_semester"] as? String ?? "",
                               student_list: doc["student_list"] as? [String] ?? [])
                    
                }))!
                completion("done")
            }
        }
    }
    
    func addCourse(prof_name:String, prof_email:String, c_name: String, section: String, location: String, zoomLink: String, time_s: String, time_e: String, days:[String], semester: String, student_list:[String]) {

        db.collection("courses").addDocument(data: ["professor_name":prof_name, "professor_email":prof_email, "course_name":c_name, "course_section":section, "course_location":location, "course_zoomLink":zoomLink, "course_start_time":time_s, "course_end_time":time_e, "course_days":days, "course_semester":semester, "student_list":student_list]){error in
            
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
             "course_zoomLink":courseToUpdate.course_location,
             "course_start_time":courseToUpdate.course_time_start,
             "course_end_time":courseToUpdate.course_time_end,
             "course_days":courseToUpdate.course_days,
             "course_semester":courseToUpdate.course_semester,
             "student_list":courseToUpdate.student_list]){
            error in
            if error == nil {
                self.getProfessorCourses { String in
                    print(String)
                }
                print("course updated!")
            }else{
                print("course failed to update!")
            }
        }
    }
    
    func deleteCourse(docID : String){
        db.collection("courses").document(docID).delete() {err in
            if err != nil {
                print("Error removing doc")
            } else {
                print("Deleted Doc!")
            }
        }
    }
    
    func getCourseLocations(city : String, completion: @escaping ((String) -> Void)){
        db.collection("locations").document(city).getDocument(source: .default) { (document, error) in
            if let document = document {
            guard let data = document.data() else {
                print("Empty docs")
                return completion("no docs")
            }
            var temp : [String] = []
            for place in data["rooms"] as! [String] {
                temp.append(place)
            }
            self.locationList = temp.sorted()
            return completion("done")
            }
        }
    }
    
    func studentParser(textEditorText : String) -> [String]{
        let separator = CharacterSet(charactersIn: " ,-;:\n")
        let tempStudentArr : [String] = textEditorText.components(separatedBy: separator)
        var finalStudentArr:[String] = []
        for student in tempStudentArr{
            if(student.hasSuffix("nyit.edu")){
                finalStudentArr.append(student)
            }
        }
        return finalStudentArr.sorted()
    }
    
    func getLocationDetails(course_Loc : String, completion: @escaping ((String) -> Void)){
        db.collection("locations").whereField("rooms", arrayContains: course_Loc).getDocuments { snapshot, err in
            if (snapshot?.documents) == nil{
                print("no classrooms")
                return completion("no classrooms")
            }
            self.city = snapshot?.documents[0].documentID ?? "nothing"
            return completion("done")
        }
    }
    
}
