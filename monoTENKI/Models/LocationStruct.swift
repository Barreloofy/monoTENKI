//
//  LocationStruct.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:30 PM.
//

import Foundation

struct Location: Decodable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let country: String
    let time: Date?
    
    enum CodingKeys: String, CodingKey {
        case time = "localtime"
        case name, country
    }
}


struct LocationIdentity: Codable, Equatable {
    let name: String
    let country: String
}
