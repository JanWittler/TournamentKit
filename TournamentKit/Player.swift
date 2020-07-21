//
//  Player.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol Player: MatchParticipation {
    
}

public extension Player {
    var players: [Self] { return [self] }
}
