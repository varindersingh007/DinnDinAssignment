//
//  FoodBaseModel.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import ObjectMapper


struct FoodBaseModel : Mappable {
    var foodsDrinks : [Foods]?

    enum CodingKeys: String, CodingKey {
        case foodsDrinks = "foodDrinks"
    }

    init?(map: Map) {
        foodsDrinks <- map[CodingKeys.foodsDrinks.rawValue]
    }
    
    mutating func mapping(map: Map) {
        foodsDrinks >>> map[CodingKeys.foodsDrinks.rawValue]
    }
}
