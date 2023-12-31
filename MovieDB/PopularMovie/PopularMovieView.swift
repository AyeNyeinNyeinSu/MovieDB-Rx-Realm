//
//  PopularMovieView.swift
//  MovieDB
//
//  Created by MgKaung on 08/09/2023.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import RealmSwift

class PopularMovieView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var popularMovies: Results<PopularMovieResult>?
    let bag = DisposeBag()
    var selectedIndex = 0
    let viewModel = PopularMovieViewModel()
    let realm = try! Realm()
    
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        loadMovie()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
    }
    
    func bindViewModel() {
        
        let input = PopularMovieViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.popularMovies
            .drive(onNext: { movieResult in
                if self.realm.objects(PopularMovieResult.self).count == 0 {
                    for movie in movieResult {
                        let popMovie = PopularMovieResult()
                        popMovie.title = movie.title
                        popMovie.posterPath = movie.posterPath
                        popMovie.overview = movie.overview
                        popMovie.releaseDate = movie.releaseDate
                        self.save(movie: popMovie)
                    }
                }
                
            })
            .disposed(by: bag)
    }
    
    func save(movie: PopularMovieResult) {
        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            print("Error saving movie \(error)")
        }
        self.collectionView.reloadData()
    }
    
//    func delete(movie: PopularMovieResult) {
//        do {
//            try realm.write {
//                realm.delete(movie)
//            }
//        } catch {
//            print("Error deleting movie \(error)")
//        }
//        self.collectionView.reloadData()
//    }
    
    func loadMovie() {
        popularMovies = realm.objects(PopularMovieResult.self)
        collectionView.reloadData()
    }
    
    // MARK: - Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as! PopularMovieCollectionViewCell
        let popularMovie = popularMovies?[indexPath.item]
        
        cell.movieImage.image = UIImage(systemName: "photo.fill")
        if let poster = popularMovie?.posterPath {
            cell.movieImage.loadImage(posterPath: poster, bag: bag)
        }
        
        cell.movieTitle.text = popularMovie?.title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        performSegue(withIdentifier: "goToDetailView", sender: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5) / 3
        let height = (view.frame.height - 13) / 3
        return CGSize(width: width, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailView" {
            let detailVC = segue.destination as! MovieDetailView
            detailVC.movie = popularMovies?[selectedIndex]
        }
    }
    
}



