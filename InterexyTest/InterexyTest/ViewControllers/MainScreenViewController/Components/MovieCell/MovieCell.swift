//
//  MovieCell.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import UIKit
import Kingfisher

final class MovieCell: UICollectionViewCell, MovieProtocol {
    
    /*
     MARK: -
     */
    
    static let CellID = "MovieCell"
    
    /*
     MARK: - Properties
     */
    
    var movie: Movie! {
        didSet {
            updateUI()
        }
    }
    
    /*
     MARK: - Outlets
     */
    
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var percentLabel: UILabel!
    
    /*
     MARK: - LifeCycle
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
     MARK: - Supporting
     */
    
    private func updateUI() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/images?api_key=\(AppConstants.apiKey)")
        print(">>>>> UrL=> \(url)")
        movieImageView.kf.setImage(with: url)
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
//        percentLabel.text
    }
}
