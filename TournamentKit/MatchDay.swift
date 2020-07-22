//
//  MatchDay.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol MatchDay {
    associatedtype Match: TournamentKit.Match
    
    var matches: [Match] { get }
}

public extension MatchDay {
    var isFinished: Bool { return matches.allSatisfy { $0.isFinished } }
}
