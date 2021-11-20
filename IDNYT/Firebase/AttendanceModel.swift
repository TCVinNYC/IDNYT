//
//  AttendenceModel.swift
//  IDNYT
//
//  Created by Prince on 11/18/21.
//

import Foundation
import FirebaseFirestoreSwift

struct AttendanceModel : Codable, Hashable{
    //@DocumentID var DateID : String? = UUID().uuidString
    var student_details: [String] = []
}
