//
//  ActorCell.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 16.01.23.
//

import UIKit

final class ActorCell: UICollectionViewCell {
    
    /*
     MARK: -
     */
    
    static let CellID = "ActorCell"
    
    /*
     MARK: -
     */
    
    @IBOutlet var actorImageView: UIImageView!
    @IBOutlet private var actorNameLabel: UILabel!
    @IBOutlet private var charactorNameLabel: UILabel!
    
    /*
     MARK: - LifeCycle
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    /*
     MARK: -
     */

    func setup(with actor: Person) {
        charactorNameLabel.text = actor.character
        actorNameLabel.text = actor.name
    }
}
