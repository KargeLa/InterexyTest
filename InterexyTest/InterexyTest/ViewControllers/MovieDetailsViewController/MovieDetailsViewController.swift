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
import WebKit

final class MovieDetailsViewController: UIViewController {
    
    /*
     MARK: - Properties
     */
    
    var error: Error?
    var movieDetails: MovieDetails?
    var movieTeam: MovieTeam?
    var videoKey: String?
    var movieID: Int!
    
    private var actors: [Person] = []
    
    /*
     MARK: - 
     */
    
    @IBOutlet private var themeView: UIView!
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var progressContainerView: UIView!
    @IBOutlet private var movieNameLabel: UILabel!
    @IBOutlet private var circularProgressView: CircularProgressView!
    @IBOutlet private var percentLabel: UILabel!
    @IBOutlet private var movieTagLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    /*
     MARK: - LifeCycle
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "Color_11")!
        
        setupCollectionView()
        
        getDetailsFor(movieID)
    }
    
    /*
     MARK: - Supporting
     */
    
    private func updateUI() {
        setupImage()
        setupText()
        setupProgressView()
        collectionView.reloadData()
        
        hideTheme()
    }
    
    private func hideTheme() {
        UIView.animate(withDuration: 0.3, animations: {
            self.themeView.alpha = 0
        }) { (finished) in
            self.themeView.isHidden = finished
        }
    }
    
    private func setupImage() {
        let movieImageURL = URL(string: ApiManager.shared.createImageURL() + "\(movieDetails?.posterPath ?? "")")
        print("")
        let backgroundImageURL = URL(string: ApiManager.shared.createImageURL() + "\(movieDetails?.backdropPath ?? "")")
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(with: movieImageURL, options: [.transition(.fade(1))])
        
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: backgroundImageURL, options: [.transition(.fade(1))])
    }
    
    private func setupCollectionView() {
        collectionView.register(
            UINib(
                nibName: ActorCell.CellID,
                bundle: .main
            ),
            forCellWithReuseIdentifier: ActorCell.CellID
        )
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.458),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 16 * AppConstants.SizeFactor,
            leading: 8 * AppConstants.SizeFactor,
            bottom: 16 * AppConstants.SizeFactor,
            trailing: 8 * AppConstants.SizeFactor
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16 * AppConstants.SizeFactor,
            bottom: 0,
            trailing: 16 * AppConstants.SizeFactor
        )
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        /*
         */
           
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupText() {
        let progress = Int((movieDetails?.voteAverage ?? 0.0) * 10)
        
        percentLabel.text = "\(progress)"
        movieNameLabel.text = movieDetails?.title
        movieTagLabel.text = movieDetails?.tagline
        overviewLabel.text = movieDetails?.overview
    }
    
    private func setupProgressView() {
        progressContainerView.layer.cornerRadius = progressContainerView.frame.height / 2
        
        let progress = Int((movieDetails?.voteAverage ?? 0.0) * 10)
        let colors = getColors(for: progress)
        
        circularProgressView.progressAnimation(progress,
                                               backgroundColor: colors.1,
                                               progressColor: colors.0)
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
    
    private func getDetailsFor(_ movieID: Int) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        ApiManager.shared.getMovieDetails(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
            case .failure(let error):
                self.error = error
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ApiManager.shared.getMovieTeam(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movieTeam):
                self.movieTeam = movieTeam
                self.actors = movieTeam.cast ?? []
            case .failure(let error):
                self.error = error
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ApiManager.shared.getVideo(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let video):
                self.videoKey = video.results?
                    .filter({$0.type == "Trailer"})
                    .first?
                    .key
            case .failure(let error):
                self.error = error
            }
            
            self.setupTrailer(with: self.videoKey ?? "")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            
            guard
                self.error == nil
            else {
                print(">>>>> error => \(self.error?.localizedDescription)")
                self.showAlert()
                return
            }
            
            self.updateUI()
        }
    }
    
    private func showAlert() {
        let title = "Something went wrong"
        let message = "Please try again later"
        let OKActionTitle = "OK"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAlertAction = UIAlertAction(title: OKActionTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(OKAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupTrailer(with videoID: String) {
        guard let url = URL(string: ApiManager.Servers.youtubeBaseURL + videoID) else { return }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

/*
 MARK: - UICollectionViewDelegate, UICollectionViewDataSource
 */

extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCell.CellID,
            for: indexPath
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let actor = actors[indexPath.row]
        
        if let cell = cell as? ActorCell {
            cell.setup(with: actor)
            
            let url = URL(string: ApiManager.shared.createImageURL() + "\(actor.profilePath ?? "")")
            cell.actorImageView.kf.indicatorType = .activity
            cell.actorImageView.kf.setImage(with: url,
                                            placeholder: UIImage(named: actor.gender == 2 ? "maleplaceholder" : "femaleplaceholder"),
                                            options: [.transition(.fade(1))])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}
