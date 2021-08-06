//
//  WebManager.swift
//  FoodMenia
//
//  Created by Varinder on 05/08/21.
//

import Foundation
import Moya

class EndPointType: TargetType {
    var baseURL: URL
    
    var path: String = ""
    
    var method: Method
    
    var sampleData: Data
    
    var task: Task
    
    var headers: [String : String]?
    
    
}
