//
//  ViewController.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import UIKit
import Kingfisher

/*
 MARK: - -
 */

final class MainScreenViewController: UIViewController {
    
    /*
     MARK: - Properties
     */
    
    private var isLoading = false
    private var totalPages = 0
    private var pagesLoaded = 0
    private var popularMovies: [Movie] = []
    
    /*
     MARK: - Outlets
     */
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var collectionView: UICollectionView!
    
    /*
     MARK: - LifeCycle
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color_7")!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.backgroundColor = UIColor(named: "Color_11")!
        setupCollectionView()
        getData(page: 1)
    }
    
    /*
     MARK: - Supporting
     */
    
   private func showActivityIndicator() {
       activityIndicator.startAnimating()
   }

   private func hideActivityIndicator() {
       activityIndicator.stopAnimating()
   }
    
    private func getData(page: Int) {
        ApiManager.shared.getPopularMovies(page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                (movies.results ?? []).forEach { self.popularMovies.append($0) }
                self.totalPages = movies.totalPages ?? 1
                self.pagesLoaded += 1
            case .failure(_):
                self.showAlert()
            }
            
            self.collectionView.reloadData()
        }
    }
    
    private func loadMoreData() {
        if !isLoading, totalPages != pagesLoaded {
            isLoading = true
            showActivityIndicator()
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                let nextPage = self.pagesLoaded + 1
                self.getData(page: nextPage)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.collectionView.reloadData()
                    self.hideActivityIndicator()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func showAlert() {
        let title = "Something went wrong"
        let message = "Please try again later"
        let OKActionTitle = "OK"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAlertAction = UIAlertAction(title: OKActionTitle, style: .default)
        
        alertController.addAction(OKAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
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
            bottom: 24 * AppConstants.SizeFactor,
            trailing: 8 * AppConstants.SizeFactor
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(350 * AppConstants.SizeFactor)
            ),
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 24 * AppConstants.SizeFactor,
            trailing: 0
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 40 * AppConstants.SizeFactor,
            leading: 16 * AppConstants.SizeFactor,
            bottom: 40 * AppConstants.SizeFactor,
            trailing: 16 * AppConstants.SizeFactor
        )

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func goToDetailsViewController(_ movieID: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movieID = movieID
        
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
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
        
        if indexPath.row == popularMovies.count - 1, !isLoading {
            loadMoreData()
        }
        
        if let cell = cell as? MovieCell {
            cell.setup(with: movie)
            
            let url = URL(string: ApiManager.shared.createImageURL() + "\(movie.backdropPath ?? "")")
            cell.movieImageView.kf.indicatorType = .activity
            cell.movieImageView.kf.setImage(with: url, options: [.transition(.fade(1))])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetailsViewController(popularMovies[indexPath.row].id ?? 0)
    }
}
