//
//  DetailedView.swift
//  MovieDB
//
//  Created by MgKaung on 13/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailView: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: PopularMovieResult!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImage.image = UIImage(systemName: "photo.fill")
        if let poster = movie.posterPath {
            posterImage.loadImage(posterPath: poster, bag: bag)
        }
        
        movieTitle.text = movie.title
        
        releasedDate.text = "Released Date - \(movie.releaseDate ?? "")"
        
        overviewLabel.attributedText = NSAttributedString(string: "Movie Overview", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        overviewTextView.text = movie.overview
    }
    

   

}
