//
//  Error.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/14/25 at 3:54 PM.
//

import Foundation

enum PathError: Error {
    case malformedURL(String = "")
}


enum LocationError: Error {
    case unavailableLocation
}
