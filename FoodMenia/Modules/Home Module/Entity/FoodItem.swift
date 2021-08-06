//
//  FoodItem.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import ObjectMapper
struct FoodItem : Mappable,Equatable {
    var itemName   : String?
    var itemDetail : String?
    var itemPrice  : Int?
    var itemImage  : String?
    var itemWeight : String?
    var isVeg: Bool?

    enum CodingKeys: String, CodingKey {
        case itemName = "itemName"
        case itemDetail = "itemDetail"
        case itemPrice = "itemPrice"
        case itemImage = "itemImage"
        case itemWeight = "itemWeight"
        case isVege = "isVeg"
    }

    init?(map: Map) {
        itemName <- map[CodingKeys.itemName.rawValue]
        itemDetail <- map[CodingKeys.itemDetail.rawValue]
        itemPrice <- map[CodingKeys.itemPrice.rawValue]
        itemImage <- map[CodingKeys.itemImage.rawValue]
        itemWeight <- map[CodingKeys.itemWeight.rawValue]
        isVeg <- map[CodingKeys.isVege.rawValue]
    }
    
    mutating func mapping(map: Map) {
        itemName >>> map[CodingKeys.itemName.rawValue]
        itemDetail >>> map[CodingKeys.itemDetail.rawValue]
        itemPrice >>> map[CodingKeys.itemPrice.rawValue]
        itemImage >>> map[CodingKeys.itemImage.rawValue]
        itemWeight >>> map[CodingKeys.itemWeight.rawValue]
        isVeg >>> map[CodingKeys.isVege.rawValue]
    }
}
