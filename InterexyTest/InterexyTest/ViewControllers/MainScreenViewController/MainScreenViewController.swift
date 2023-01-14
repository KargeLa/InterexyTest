//
//  ViewController.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import UIKit

protocol MovieProtocol {
    var movie: Movie! { get set }
}

/*
 MARK: - -
 */

final class MainScreenViewController: UIViewController {
    
    /*
     MARK: - Properties
     */
    
    private var popularMovies: [Movie] = [] {
        didSet {
            
        }
    }
    
    /*
     MARK: - Outlets
     */
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    /*
     MARK: - LifeCycle
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         */
        
        self.setupCollectionView()
        
        /*
         */
        
        ApiManager.shared.getPopularMovies { [weak self] popularMovies in
            guard let self = self else { return }
            
            self.popularMovies = popularMovies.results
            self.collectionView.reloadData()
        }
    }
    
    /*
     MARK: - Supporting
     */
    
    private func setupCollectionView() {
        collectionView.register(
            UINib(
                nibName: MovieCell.CellID,
                bundle: .main
            ),
            forCellWithReuseIdentifier: MovieCell.CellID
        )
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8 * AppConstants.SizeFactor,
            bottom: 0,
            trailing: 8 * AppConstants.SizeFactor
        )

        /*
         */

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(300 * AppConstants.SizeFactor)
            ),
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 24 * AppConstants.SizeFactor,
            trailing: 0
        )

        /*
         */

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 40 * AppConstants.SizeFactor,
            leading: 16 * AppConstants.SizeFactor,
            bottom: 40 * AppConstants.SizeFactor,
            trailing: 16 * AppConstants.SizeFactor
        )

        /*
         */

        return UICollectionViewCompositionalLayout(section: section)
    }
}

/*
 MARK: - UICollectionViewDelegate, UICollectionViewDataSource
 */

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.CellID,
            for: indexPath
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movie = popularMovies[indexPath.row]
        
        /*
         */
        
        if var cell = cell as? MovieProtocol {
            cell.movie = movie
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ApiManager.shared.getMovieDetails(movieID: popularMovies[indexPath.row].id) { [weak self] movieDetails in
            guard let self = self else { return }
            
            let movieDetailsViewController = MovieDetailsViewController(nibName: "MovieDetailsViewController",
                                                                        bundle: nil)
            movieDetailsViewController.movieDetails = movieDetails
            self.present(movieDetailsViewController, animated: true)
        }
    }
}
