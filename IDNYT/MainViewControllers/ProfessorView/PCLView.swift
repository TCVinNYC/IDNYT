//
//  PCLView.swift
//  IDNYT
//
//  Created by Prince on 11/8/21.
//
/// this is the professor's class list view
/// basically allows the prof to add, edit and delete classes

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PCLView: View {
    
    @ObservedObject var model = ClassViewModel()
    
    let database = Firestore.firestore()
    @State var showSheet = false
    @State private var isActive : Bool = false
    @State private var isLoading = true
    
    var body: some View {
        NavigationView{
                VStack{
                    if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.5)
                        .padding(.bottom, 50)
                    } else{
                        ZStack{
                            List{
                                ForEach(model.classes, id: \.self) {data in
                                    NavigationLink(destination: AttendenceViewController(isActive: self.$isActive, currentCourse: data), isActive: $isActive){
                                            VStack(alignment: .leading, spacing: 3){
                                                Text("\(data.course_name) - \(data.course_section)")
                                                    .bold()
                                                    .lineLimit(2)
                                                    .font(.title3)
                                                Text(data.course_location)
                                                    .minimumScaleFactor(0.001)
                                                    .lineLimit(1)
                                                    .font(.subheadline)
                                                Text("\(data.course_time_start) - \(data.course_time_end)")
                                                    .minimumScaleFactor(0.001)
                                                    .lineLimit(1)
                                                    .font(.subheadline)
                                                Text(data.course_days.joined(separator: ", "))
                                                    .minimumScaleFactor(0.001)
                                                    .lineLimit(1)
                                                    .font(.subheadline)
                                            }
                                            
                                    }.isDetailLink(false)
                                }
                            }
                            
                            HStack{
                                Spacer()
                                Button(action: {self.showSheet.toggle()}){
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .foregroundColor(Color("TextColor"))
                                    Text("Add Class")
                                        .font(.title3)
                                        .foregroundColor(Color("TextColor"))
                                }.sheet(isPresented: $showSheet){
                                    ClassDetailsView(showSheet: self.$showSheet)
                                }
                                .padding(20)
                                .foregroundColor(Color.black)
                                .background(Color.accentColor)
                                .cornerRadius(.infinity)
                                .shadow(color: Color.gray, radius: 1, x: 2, y: 3)
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.trailing, 15)
                            .padding(.bottom, 15)
                            .background(.clear)
                        }
                    
                }
            }
            .navigationTitle("My Class List")
            .toolbar{
                Menu("Fall 2021"){
                    Button("Placeholder for all semesters"){}
                }
                .foregroundColor(.blue)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear(perform: downloadCoursesCall)
    }

    private func downloadCoursesCall(){
        if isLoading{
            print("downloading courses")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                model.getProfessorCourses { String in
                    if String == "done"{
                        isLoading = false
                    }
                }
            }
        }
    }
    
    private func forceUpdate(){
        isLoading = true
        downloadCoursesCall()
    }
    
}

struct PCLView_Previews: PreviewProvider {
    static var previews: some View {
        PCLView()
    }
}
