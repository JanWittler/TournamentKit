//
//  Team.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object that represents a team that participates in a match. A team consists of multiple players.
public protocol Team: MatchParticipation {
    
}

public extension Team {
    var name: String { return players.map { $0.name }.joined(separator: " & ") }
}
