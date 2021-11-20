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
    
    var body: some View {
            VStack{
                //Attendee List
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
                   //     Button(action: {print("editing course")}){
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.red)
                            Text("Edit")
                                .foregroundColor(.red)
                      //  }
                    }

                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Text("\(attendingCount)/\(maxAttend) Students")
                }
                

            }
            
            .onAppear {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                date = formatter.string(from: Date()).replacingOccurrences(of: "/", with: "-")
                
                model.getStudentDetails(courseDoc: currentCourse.id!, dateDoc: date, completion: { String in
                        print(String)
                        attendingCount = model.attendance.count
                        maxAttend = currentCourse.student_list.count
                })
                

            }
        }
        
    }
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
