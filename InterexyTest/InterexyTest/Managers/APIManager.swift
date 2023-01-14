//
//  APIManager.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import Alamofire

final class ApiManager {
    
    /*
     MARK: -
     */
    
    static var shared = ApiManager()
    
    /*
     MARK: - Constants
     */
    
    private enum Servers {
        static let baseURL = "https://api.themoviedb.org/3/"
    }
    
    /*
     MARK: - EndPoints
     */
    
    private enum EndPoints {
        static let popularMovie = "movie/popular"
        static let details = "movie/"
    }
    
    /*
     MARK: -
     */
    
    func getPopularMovies(completion: @escaping ((PopularMovies) -> ())) {
        
        /*
         */
        
        let parameters = ["api_key": AppConstants.apiKey]
        
        /*
         */
        
        guard let url = URL(string: Servers.baseURL + EndPoints.popularMovie) else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: PopularMovies.self) { response in
            switch response.result {
            case .success(let movies):
                completion(movies)
            case .failure(let error):
                print(">>>>> Error => \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    /*
     */
    
    func getMovieDetails(movieID: Int, completion: @escaping ((MovieDetails) -> ())) {
        
        /*
         */
        
        let parameters = ["api_key": AppConstants.apiKey]
        
        /*
         */
        
        guard let url = URL(string: Servers.baseURL + EndPoints.details + "\(movieID)") else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: MovieDetails.self) { response in
            switch response.result {
            case .success(let movieDetails):
                completion(movieDetails)
            case .failure(let error):
                print(">>>>> Error => \(String(describing: error.localizedDescription))")
            }
        }
    }
}
