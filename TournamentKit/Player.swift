//
//  Player.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object that represents a player. A player can be part of a team or participate by itself in a match.
public protocol Player: MatchParticipation {
    
}

public extension Player {
    /// An array containing only the instance itself, as there are no other players forming this match participation.
    var players: [Self] { return [self] }
}
