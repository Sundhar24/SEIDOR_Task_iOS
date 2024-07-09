//
//  CharacterListService.swift
//  SEIDORTask
//
//  Created by Sundhar on 06/07/24.
//

import Foundation
import Alamofire
import UIKit

class CharacterListService{
    
    static let shared = CharacterListService()

    func characterListAPI(completion: @escaping (Result<CharacterListModel, Error>) -> Void) {
        let url = "https://rickandmortyapi.com/api/character/?page=22"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let characterListModel = CharacterListModel(json: json)
                        completion(.success(characterListModel))
                    } else {
                        let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    completion(.failure(error))
                }
            }
    }



}
