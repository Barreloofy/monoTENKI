//
//  LocationStruct.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:30 PM.
//

import Foundation

struct Location: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let time: Date?
    
    enum CodingKeys: String, CodingKey {
        case name, country
        case time = "localtime"
    }
}


struct LocationKey: Codable, Equatable {
    let name: String
    let country: String
}
