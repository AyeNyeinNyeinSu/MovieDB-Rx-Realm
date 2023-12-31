//
//  PopularMovieViewModel.swift
//  MovieDB
//
//  Created by MgKaung on 08/09/2023.
//

import Foundation
import RxCocoa
import RxSwift

class PopularMovieViewModel {
   
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let popularMovies: Driver<[PopularMovieResult]>
    }
    
    func transform(input: PopularMovieViewModel.Input) -> PopularMovieViewModel.Output {
        
        let popularMovies = input.viewWillAppear.asObservable()
            .flatMap({ _ in 
                TMDBClient.getPopularMovies()
            })
            .asDriver(onErrorJustReturn: [])
        return PopularMovieViewModel.Output(popularMovies: popularMovies)
    }
    
}


extension UIImageView {

    func loadImage(posterPath: String, bag: DisposeBag) {
        let response = Observable.just(posterPath)
            .map({ URL(string: "https://image.tmdb.org/t/p/original" + $0)! })
            .map({ URLRequest(url: $0) })
            .flatMap({ URLSession.shared.rx.data(request: $0) })
            .subscribe(onNext: { data in
                guard let photoImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = photoImage
                }
            })
            .disposed(by: bag)
    }
}


extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
