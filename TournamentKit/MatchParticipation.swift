//
//  MatchParticipation.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol MatchParticipation: Comparable {
    associatedtype Player: TournamentKit.Player
    
    var players: [Player] { get }
    var name: String { get }
}

public extension MatchParticipation {
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.name < lhs.name
    }
}
