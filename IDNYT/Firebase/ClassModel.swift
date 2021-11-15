//
//  ClassModel.swift
//  IDNYT
//
//  Created by Prince on 11/11/21.
//

import Foundation
import FirebaseFirestoreSwift

struct ClassModel : Identifiable, Codable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    //var prof_image : Image
    var prof_name : String
    var prof_email : String
    var course_name : String
    var course_section : String
    var course_location : String
    //var course_locZoom : String
    var course_time_start : String
    var course_time_end : String
    var course_days : [String]
    var course_semester : String
}

//func copyData(id: String, prof_name: String, prof_email:String, course_name:String, course_section:String, course_location:String, couse_time_start:String){
//    
//    
//}
