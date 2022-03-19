//
//  APIService.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import Foundation
import Alamofire

protocol APIMethods {
    func getAssets<T: Decodable>(type: T.Type,
                                 search: String,
                                 limit: Int,
                                 offset: Int,
                                 withSuccess : @escaping (T) -> (),
                                 withError: @escaping (CustomError) -> ())
    func getAssetsByIds<T: Decodable>(type: T.Type,
                                      ids: [String],
                                      withSuccess : @escaping (T) -> (),
                                      withError: @escaping (CustomError) -> ())
    func getHistoryPrice<T: Decodable>(type: T.Type,
                                       id: String,
                                       interval: String,
                                       withSuccess : @escaping (T) -> (),
                                       withError: @escaping (CustomError) -> ())
}

class APIService: APIMethods {
    
    private let baseURL = "https://api.coincap.io/v2/"
    
    func getAssets<T: Decodable>(type: T.Type,
                                 search: String,
                                 limit: Int,
                                 offset: Int,
                                 withSuccess : @escaping (T) -> (),
                                 withError: @escaping (CustomError) -> ()) {
        let requestUrl = "\(baseURL)assets?search=\(search)&offset=\(offset)&limit=\(limit)"
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
    
    func getAssetsByIds<T: Decodable>(type: T.Type,
                                      ids: [String],
                                      withSuccess : @escaping (T) -> (),
                                      withError: @escaping (CustomError) -> ()) {
        let requestUrl = "\(baseURL)assets?ids=\(ids.joined(separator: ","))"
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
    
    func getHistoryPrice<T: Decodable>(type: T.Type,
                                       id: String,
                                       interval: String,
                                       withSuccess : @escaping (T) -> (),
                                       withError: @escaping (CustomError) -> ()) {
        let requestUrl = "\(baseURL)assets/\(id)/history?interval=\(interval)"
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
