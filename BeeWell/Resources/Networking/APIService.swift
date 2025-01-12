//
//  APIService.swift
//  BeeWell
//
//  Created by Furkan Doğan on 12.01.2025.
//

import Combine

protocol APIService {
    func performRequest() -> AnyPublisher<[QuoteModel], Error>
}
