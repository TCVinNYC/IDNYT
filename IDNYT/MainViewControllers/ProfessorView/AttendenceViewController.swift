//
//  AttendenceViewController.swift
//  IDNYT
//
//  Created by Prince on 11/18/21.
//

import SwiftUI
import FirebaseFirestore

struct AttendenceViewController: View {
    
    var currentCourse: ClassModel
    @ObservedObject var model = AttendanceViewModel()
    let database = Firestore.firestore()
    
    @State private var date : String = ""
    @State private var attendingCount : Int = 0
    @State private var maxAttend : Int = 0
    
    @State private var daysOfClass : [String] = []

    var body: some View {
            VStack{
                List{
                    ForEach(model.attendance, id: \.self) {data in
                        VStack{
                            Spacer()
                            HStack {
                                Text("\(data.student_details[0]) -")
                                    .bold()
                                    .font(.system(size: 18))
                                
                                Text(data.student_details[1])
                                    .italic()
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("Method: \(data.student_details[2])")
                                Spacer()
                                Text("Time: \(data.student_details[3])")
                            }
                            
                            Spacer()
                        }
                }
                
            }
            .navigationTitle("Attendance List")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    
                    Button(action: {
                        //show list of all the attendance docs
                        
                        
                    }){
                            Image(systemName: "calendar.circle.fill")
                                .foregroundColor(.blue)
                            Text(date)
                                .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: editClass(currentCourse: currentCourse)){
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.red)
                            Text("Edit")
                                .foregroundColor(.red)
                    }

                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Text("\(attendingCount)/\(maxAttend) Students")
                }
                

            }
            
            .onAppear {
                //getAllDates()
                
                let dateObj = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                
                //compare current day with class days
                date = formatter.string(from: dateObj).replacingOccurrences(of: "/", with: "-")
                
                formatter.dateFormat = "EEEE"
                let currentDay : String = formatter.string(from: dateObj).prefix(3).lowercased()
                
                model.getStudentDetails(courseDoc: currentCourse.id!, dateDoc: date, completion: { String in
                        print(String)
                        attendingCount = model.attendance.count
                        maxAttend = currentCourse.student_list.count
                })
                
//                if currentCourse.course_days.contains(currentDay){
//                    model.getStudentDetails(courseDoc: currentCourse.id!, dateDoc: date, completion: { String in
//                            print(String)
//                            attendingCount = model.attendance.count
//                            maxAttend = currentCourse.student_list.count
//                    })
//                }else{
//
//                }
            }
        }
        
    }
    
    
//    mutating func getAllDates(){
//        Firestore.firestore().collection("courses").document(currentCourse.id!).collection("attendance").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    daysOfClass.append(document.documentID)
//                }
//
//            }
//        }
//    }
    
    
    
}



//struct AttendenceViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendenceViewController()
//    }
//}



//model.setAttendance { String in
//    print(String)
//}
//
//model.getStudentDetails { String in
//    print(String)
//}
//model.attendance.forEach { String in
//    print(String)
//}
