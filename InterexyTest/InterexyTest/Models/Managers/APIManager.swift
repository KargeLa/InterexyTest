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
    
    enum Servers {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let baseImageURL = "https://www.themoviedb.org/"
        static let youtubeBaseURL = "https://www.youtube.com/embed/"
    }
    
    /*
     MARK: - EndPoints
     */
    
    private enum EndPoints {
        static let popularMovie = "movie/popular"
        static let details = "movie/"
        static let movieImage = "t/p/w600_and_h900_bestv2/"
    }
    
    /*
     MARK: -
     */
    
    func createImageURL() -> String {
        return Servers.baseImageURL + EndPoints.movieImage
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<PopularMovies, AFError>) -> Void) {
        let parameters = ["api_key": AppConstants.apiKey, "page": String(page)]
        
        guard let url = URL(string: Servers.baseURL + EndPoints.popularMovie) else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: PopularMovies.self) { response in
            completion(response.result)
        }
    }
    
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, AFError>) -> Void) {
        let parameters = ["api_key": AppConstants.apiKey]
        
        guard let url = URL(string: Servers.baseURL + EndPoints.details + "\(movieID)") else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: MovieDetails.self) { response in
            completion(response.result)
        }
    }
    
    func getMovieTeam(movieID: Int, completion: @escaping (Result<MovieTeam, AFError>) -> Void) {
        let parameters = ["api_key": AppConstants.apiKey]
        
        guard let url = URL(string: Servers.baseURL + EndPoints.details + "\(movieID)/credits") else { return }
        
        print("URL => \(url)")
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: MovieTeam.self) { response in
            completion(response.result)
        }
    }
    
    func getVideo(movieID: Int, completion: @escaping (Result<VideoModel, AFError>) -> Void) {
        let parameters = ["api_key": AppConstants.apiKey]
        
        guard let url = URL(string: Servers.baseURL + EndPoints.details + "\(movieID)/videos") else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: VideoModel.self) { response in
            completion(response.result)
        }
    }
}
