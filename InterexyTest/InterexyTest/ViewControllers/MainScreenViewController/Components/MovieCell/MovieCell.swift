//
//  MovieCell.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    /*
     MARK: -
     */
    
    static let CellID = "MovieCell"
    
    /*
     MARK: - Properties
     */

    
    /*
     MARK: - Outlets
     */
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var percentLabel: UILabel!
    @IBOutlet private var progressContainerView: UIView!
    @IBOutlet private var circularProgressView: CircularProgressView!
    
    /*
     MARK: - LifeCycle
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressContainerView.layer.cornerRadius = progressContainerView.frame.height / 2
    }
    
    /*
     MARK: - Methods
     */
    
    func setup(with movie: Movie) {
        let progress = Int((movie.voteAverage ?? 0.0) * 10)
        let colors = getColors(for: progress)
        
        circularProgressView.progressAnimation(progress)
        
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        percentLabel.text = "\(Int(progress))"//"\(progress)".replacingOccurrences(of: ".0", with: "")
    }
    
    
    
    private func getColors(for progress: Int) -> (UIColor, UIColor) {
        var colors: (_ : UIColor, _ : UIColor)
        if progress <= 20 {
            colors = (UIColor(named: "Color_5")!, UIColor(named: "Color_6")!)
        } else if progress > 20 && progress < 70 {
            colors = (UIColor(named: "Color_3")!, UIColor(named: "Color_4")!)
        } else {
            colors = (UIColor(named: "Color_1")!, UIColor(named: "Color_2")!)
        }
        return colors
    }
}
