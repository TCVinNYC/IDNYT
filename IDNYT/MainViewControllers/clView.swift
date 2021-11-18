//
//  clView.swift
//  IDNYT
//
//  Created by Prince on 11/7/21.
//

import SwiftUI
import FirebaseFirestore

struct clView: View {
    //Gesture Data
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset : CGFloat = 0
    
    @ObservedObject var model = ClassViewModel()
    
    @State private var isLoading = true
    
    
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
                                ForEach(model.classes, id: \.self) {data in
                                    if(data.course_days.contains(currentDay())){
                                        Button(action: {}){
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60)
                                                .foregroundColor(.white)
                                            Divider().frame(width: 15, height: 70)
                                            //Spacer()
                                            VStack(alignment: .leading, spacing: 3){
                                                Text("\(data.course_name) - \(data.course_section)")
                                                    .bold()
                                                    .font(.system(size: 23))
                                                    .foregroundColor(.white)
                                                Text(data.course_location)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                Text("\(data.course_time_start) - \(data.course_time_end)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                Text("\(data.prof_name) - \(data.prof_email)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                            }
                                            Spacer()
                                        }
                                        .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                                        .padding()
                                        .background(Color.blue)
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
                                    .foregroundColor(.white)
                                Divider().frame(width: 15, height: 70)
                                //Spacer()
                                VStack(alignment: .leading, spacing: 3){
                                    Text("\(data.course_name) - \(data.course_section)")
                                        .bold()
                                        .font(.system(size: 23))
                                        .foregroundColor(.white)
                                    Text(data.course_location)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("\(data.course_time_start) - \(data.course_time_end)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("\(data.prof_name) - \(data.prof_email)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: UIScreen.main.bounds.size.width - 95)
                            .padding()
                            .background(Color.blue)
                            .opacity(0.7)
                            .cornerRadius(20)
                        }
                    }
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
