//
//  NetworkManager.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL: String = "https://zenquotes.io/api/random"
    
    func performRequest() -> AnyPublisher<[Quote], Error> {
        request()
            .decode(type: [Quote].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func request() -> AnyPublisher<Data, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
    
    private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.decodingFailed
        }
        switch response.statusCode {
        case 200..<300:
            return output.data
        case 401:
            throw NetworkError.unauthorized
        case 500..<600:
            throw NetworkError.serverError
        default:
            return output.data
        }
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(String(describing: error.localizedDescription))
        }
    }
}
