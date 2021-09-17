//
//  Pizza.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import ObjectMapper
struct Foods : Mappable {
    var name : String?
    var foodItems : [FoodItem]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case foodItems = "data"
    }
    
    init?(map: Map) {
        name <- map[CodingKeys.name.rawValue]
        foodItems <- map[CodingKeys.foodItems.rawValue]
    }
    
    mutating func mapping(map: Map) {
        name >>> map[CodingKeys.name.rawValue]
        foodItems >>> map[CodingKeys.foodItems.rawValue]
    }
}


