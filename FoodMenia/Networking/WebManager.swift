//
//  WebManager.swift
//  FoodMenia
//
//  Created by Varinder on 05/08/21.
//

import Foundation
import Moya
import ObjectMapper

enum FoodEndPointType: String {
    case daySales = "DaySales"
    case foodDrinks = "FoodDrinks"
    case pizza = "Pizza"
    case sushi = "Sushi"
    case drinks = "Drinks"
    
}

extension FoodEndPointType: TargetType {
    var method: Moya.Method {
        .post
    }
    
    var baseURL: URL {
        return URL(fileURLWithPath: self.path)
    }
    
    var path: String {
        Bundle.main.path(forResource: self.rawValue, ofType: "json")!
    }
    
    var sampleData: Data {
        try! Data(contentsOf: self.baseURL, options: .mappedIfSafe)
    }
    
    var task: Task {
        .requestJSONEncodable(sampleData)
    }
    
    var headers: [String : String]? { [:] }
}


class WebService {
    static let shared = WebService()
    
    func fetchData<T:Mappable>(endPointType: FoodEndPointType,completion: @escaping((Result<T,WebError>)->Void)) {
        let data = endPointType.sampleData
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return }
            if let value = T(JSON: json) {
                completion(.success(value))
            } else {
                completion(.failure(WebError.failed("Data not found.")))
            }
        } catch {
            print("Unable to Initialize Weather Data")
            completion(.failure(WebError.failed("Data not found.")))
        }
    }
}
