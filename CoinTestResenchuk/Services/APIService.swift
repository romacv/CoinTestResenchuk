//
//  APIService.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import Foundation
import Alamofire

class APIService {
    
    private let sourcesURL = URL(string: "http://dummy.restapiexample.com/api/v1/employees")!
    
    func getAssets<T: Decodable>(type: T.Type,
                                 search: String,
                                 limit: Int,
                                 offset: Int,
                                 withSuccess : @escaping (T) -> (),
                                 withError: @escaping (CustomError) -> ()){
        let requestUrl = "https://api.coincap.io/v2/assets?search=\(search)&offset=\(offset)&limit=\(limit)"
        AF.request(requestUrl)
            .validate()
            .responseDecodable(of: T.self) { (response) in
                guard response.error == nil else {
                    withError(CustomError(error: response.error!, errorMessage: response.error!.localizedDescription))
                    return
                }
                guard let responseValue = response.value else { return }
                withSuccess(responseValue)
            }
    }
}
