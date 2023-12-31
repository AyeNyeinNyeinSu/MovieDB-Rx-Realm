//
//  PopularMovieModel.swift
//  MovieDB
//
//  Created by MgKaung on 08/09/2023.
//

import Foundation
import RealmSwift

struct PopularMovieModel: Codable {
    let results: [PopularMovieResult]
}

class PopularMovieResult: Object, Codable {
    @objc dynamic var title: String?
    @objc dynamic var posterPath: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
   
}
