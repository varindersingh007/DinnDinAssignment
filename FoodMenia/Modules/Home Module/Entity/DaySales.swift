//
//  DaySales.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import ObjectMapper


struct DaySalesBase: Mappable {
    var daySales: [DaySales]?
    
    init?(map: Map) {
        daySales <- map["daySales"]
    }
    
    mutating func mapping(map: Map) {
        daySales <- map["daySales"]
    }
}

struct DaySales : Mappable {
    var imageName : String?

    init?(map: Map) {
        imageName <- map["imageName"]
    }
    
    mutating func mapping(map: Map) {
        imageName >>> map["imageName"]
    }
}
