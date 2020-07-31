//
//  MatchDay.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/**
 An object that represents a group of matches within a tournament.
 
 Grouping matches may be used to indicate a time, space, or logical similarity among matches.
 */
public protocol MatchDay {
    /// The associated `Match` type.
    associatedtype Match: TournamentKit.Match
    
    /// The group of matches associated with this instance.
    var matches: [Match] { get }
}

public extension MatchDay {
    /// Indicates whether all matches of this match day are finished.
    var isFinished: Bool { return matches.allSatisfy { $0.isFinished } }
}
