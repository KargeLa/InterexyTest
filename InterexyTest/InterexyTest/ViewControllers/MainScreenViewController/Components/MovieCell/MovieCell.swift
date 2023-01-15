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
    @IBOutlet private var progressContainerView: UIView!
    
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
        setupProgreesView()
        setupImage()
        setupText()
    }
    
    /*
     */
    
    private func setupText() {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        percentLabel.text = "\(movie.voteAverage * 10)".replacingOccurrences(of: ".0", with: "")
    }
    
    /*
     */
    
    private func setupProgreesView() {
        progressContainerView.layer.cornerRadius = progressContainerView.frame.height / 2
        
        /*
         */
        
        addProgresView()
    }
    
    /*
     */
    
    private func setupImage() {
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 10
        
        /*
         */
        
        let url = URL(string: ApiManager.shared.createImageURL() + "\(movie.backdropPath)")
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(with: url, options: [.transition(.fade(1))])
    }
    
    /*
     */
    
    private func addProgresView() {
        let view = CircularProgressView()
        view.frame = progressContainerView.bounds
        view.progressAnimation(Float(movie.voteAverage) * 10)
        progressContainerView.addSubview(view)
    }
    
    /*
     */
    
//    private func getColor(_ percent: Float) -> (UIColor?, UIColor?) {
//        var colors: (_ : UIColor?, _ : UIColor?)
//        if percent <= 20 {
//            colors = (UIColor(named: "Color_5"), UIColor(named: "Color_6"))
//        } else if percent > 20 && percent < 70 {
//            colors = (UIColor(named: "Color_3"), UIColor(named: "Color_4"))
//        } else if percent >= 70 {
//            colors = (UIColor(named: "Color_1"), UIColor(named: "Color_2"))
//        }
//        return colors
//    }
}
