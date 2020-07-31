//
//  MatchParticipation.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/**
 An abstract object to represent a participation in a match.
 
 For the most common cases there are already the `Team` and `Player` protocols that define more concrete instances of a match participation.
 */
public protocol MatchParticipation: Equatable {
    /// The associated `Player` type.
    associatedtype Player: TournamentKit.Player
    
    /// An array of players that form this participation. This **must** not be empty.
    var players: [Player] { get }
    
    /// The name of the participation.
    var name: String { get }
}

public extension MatchParticipation {
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.name < lhs.name
    }
}
