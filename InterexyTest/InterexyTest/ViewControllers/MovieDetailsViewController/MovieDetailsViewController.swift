//
//  MovieDetailsViewController.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 15.01.23.
//

import Foundation
import UIKit
import DeviceKit
import Kingfisher

final class MovieDetailsViewController: UIViewController {
    
    /*
     MARK: - Properties
     */
    
    var movieDetails: MovieDetails!
    
    /*
     MARK: - LifeCycle
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>>> moviesDetails => \(String(describing: movieDetails))")
        self.view.backgroundColor = .red
    }
}
