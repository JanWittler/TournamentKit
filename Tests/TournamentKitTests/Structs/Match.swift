//
//  Match.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct Match: TournamentKit.Match, Equatable {
    let matchType: MatchType
    var results: [MatchResult]
    var overtimeResult: MatchOvertimeResult? = nil
    
    init(matchType: MatchType, players: [Player]) {
        self.matchType = matchType
        self.results = players.map { MatchResult(player: $0) }
    }
}
