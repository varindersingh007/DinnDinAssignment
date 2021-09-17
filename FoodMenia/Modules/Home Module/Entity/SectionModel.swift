//
//  SectionModel.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import Foundation
import RxSwift
import RxDataSources



//Create a data type which is the element for a cell
struct CustomElementType {
    var text: String
}

//Create a type conform SectionModelType which is the element for a section
//Here we use header to represent headerView
//You can also add a property like footer to represent footerView
struct CustomSectionDataType: SectionModelType {
    var header: String
    var items: [Item]
    typealias Item = CustomElementType
    init(original: CustomSectionDataType, items: [Item]) {
        self = original
        self.items = items
    }
}
