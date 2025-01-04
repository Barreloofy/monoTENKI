//
//  LocationStruct.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:30 PM.
//

import Foundation

struct Location: Decodable, Identifiable {
    let id: Int?
    let name: String
    let country: String
}
