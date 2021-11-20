//
//  clView.swift
//  IDNYT
//
//  Created by Prince on 11/7/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct clView: View {
    //Gesture Data
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset : CGFloat = 0
    
    @ObservedObject var model = ClassViewModel()
    var attend = AttendanceViewModel()
    
    @State private var isLoading = true
    @State private var confirmationShown = false
    
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .leading){
                VStack{
                    if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(1.5)
                        .padding(.bottom, 50)
                    } else {
                        
                    HStack{
                        Label("Today:", systemImage: "calendar.circle")
                            .imageScale(Image.Scale.large)
                            .font(.title)
                            .padding(10)
                            .padding(.leading, 33)
                        Spacer()
                    }
                        VStack{
                            ScrollView {
                              //  let modelSorted = model.classes.sorted{ $0.course_time_start.formatted(date: .omitted, time: .standard) < $1.course_time_start.formatted(date: .omitted, time: .standard) }
                                
                                // model.classes.sorted{ stringTime(item: $0.course_time_start) < stringTime(item: $1.course_time_start) }
                                // sort by time if you can
                                ForEach( model.classes, id: \.self) {data in
                                    if(data.course_days.contains(currentDay())){
                                        Button(action: {
                                            confirmationShown = true
                                        }){
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60)
                                                .foregroundColor(Color("TextColor"))
                                            Divider().frame(width: 15, height: 70)
                                            //Spacer()
                                            VStack(alignment: .leading, spacing: 3){
                                                Text("\(data.course_name) - \(data.course_section)")
                                                    .bold()
                                                    .font(.system(size: 23))
                                                    .foregroundColor(Color("TextColor"))
                                                Text(data.course_location)
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                                Text("\(data.course_time_start) - \(data.course_time_end)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                                Text("\(data.prof_name) - \(data.prof_email)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("TextColor"))
                                            }
                                            Spacer()
                                        }
                                        .confirmationDialog("Sign Into Class", isPresented: $confirmationShown) {
                                            Button("NFC Scanner"){
                                                //code for NFC
                                            }
                                            Button("Zoom"){
                                                //code for Zoom Link on iPhone
                                                attend.setAttendance(courseDoc: data.id!, dateDoc: date4Doc(), tempUser: gatherUserData() ) { String in
                                                    print(String)
                                                }
                                            }
                                        }
                                        
                                        .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                                        .padding()
                                        .background(Color.accentColor)
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        .shadow(radius: 4)

                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .navigationTitle("Class List")
                .toolbar{
                    Menu("Fall 2021"){
                        Button("Placeholder for all semesters"){}
                    }
                    .foregroundColor(.blue)
                }
                
                GeometryReader {reader in
                    BottomSheet()
                        .frame(maxHeight: .infinity)
                        .offset(y: reader.frame(in: .global).height - 80)
                        .offset(y: offset)
                        
                    //this is where the old gesture code was
                        .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            let maxHeight = reader.frame(in: .global).height - 80
                            withAnimation {
                                //Logic for moving the view
                                if -offset > 100 && -offset < maxHeight/2{
                                    offset = -(maxHeight/2)
                                } else if -offset > maxHeight/2{
                                    offset = -maxHeight
                                }else{
                                    offset = 0
                                }
                            }
                            lastOffset = offset
                        }))
                }
                .onAppear{
                    downloadCoursesCall()
                    
                }
                }
            }
    
    }
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func downloadCoursesCall(){
        if isLoading{
            print("downloading courses")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                model.getStudentCourses() { String in
                    if String == "done"{
                        isLoading = false
                    }
                }
            }
        }
    }
    
    func gatherUserData() -> [String?] {
        let temp : [String?] = [Auth.auth().currentUser?.displayName, Auth.auth().currentUser?.email, "Zoom", currentTime()]
        return temp
    }
    
    func stringTime(item : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        
        let temp : Date = dateFormatter.date(from: item)!
        
        
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: temp as Date)
    }
}

struct BottomSheet : View {
    @State private var model = ClassViewModel()
    
    var body : some View{
        VStack(){
            Capsule()
                .fill(Color.black)
                .frame(width: 40, height: 5)
            Label("Upcoming:", systemImage: "hourglass.circle")
                .imageScale(Image.Scale.large)
                .font(.title)
                .offset(x: -80, y: 0)
            ScrollView(.vertical){
                LazyVStack(alignment: .center){
                    ForEach(model.classes, id: \.self) {data in
                        if(!data.course_days.contains(currentDay())){
                            Button(action: {}){
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(Color("TextColor"))
                                Divider().frame(width: 15, height: 70)
                                //Spacer()
                                VStack(alignment: .leading, spacing: 3){
                                    Text("\(data.course_name) - \(data.course_section)")
                                        .bold()
                                        .font(.system(size: 23))
                                        .foregroundColor(Color("TextColor"))
                                    Text(data.course_location)
                                        .font(.subheadline)
                                        .foregroundColor(Color("TextColor"))
                                    Text("\(data.course_time_start) - \(data.course_time_end)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("\(data.prof_name) - \(data.prof_email)")
                                        .font(.subheadline)
                                        .foregroundColor(Color("TextColor"))
                                }
                                Spacer()
                            }
                            .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                            .padding()
                            .background(Color.accentColor)
                            .opacity(0.7)
                            .cornerRadius(20)
                        }
                    }
                    .disabled(true)
                }
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(25)
        .ignoresSafeArea(.all , edges: .bottom)
        .onAppear(){
            model.getStudentCourses() { String in
                    print(String)
                print(model.classes.count)
                }
        }
    }

}

struct BlurView: UIViewRepresentable{
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct clView_Previews: PreviewProvider {
    static var previews: some View {
        clView()
            .previewDevice("iPhone 13 Pro Max")
    }
}

func currentDay() -> String{
    let dateForm = DateFormatter()
    dateForm.dateFormat = "EEEE"
    let weekDay = dateForm.string(from: Date())
    return String(weekDay.prefix(3))
}

func date4Doc() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter.string(from: Date()).replacingOccurrences(of: "/", with: "-")
}

func currentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: Date())
}



// old code
//                        .gesture(DragGesture().onChanged({(value) in
//                            withAnimation {
//                                if value.startLocation.y > reader.frame(in: .global).midX{
//                                    offset = value.translation.height
//                                }
//                                if value.startLocation.y < reader.frame(in: .global).midX{
//                                    offset = (-reader.frame(in: .global).height + 150) + value.translation.height
//                                }
//
//                            }
//                        }).onEnded({ value in
//                            withAnimation {
//                                if value.startLocation.y > reader.frame(in: .global).midX{
//                                    if -value.translation.height > reader.frame(in: .global).midX{
//                                        offset = (-reader.frame(in: .global).height + 150)
//                                        return
//                                    }
//                                    offset = 0
//
//                                }
//                                if value.startLocation.y < reader.frame(in: .global).midX{
//                                    if value.translation.height < reader.frame(in: .global).midX{
//                                        offset = (-reader.frame(in: .global).height + 150)
//                                        return
//                                    }
//                                    offset = 0
//                                }
//                            }
//                        }))
