//
//  RoundRobinTournament.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct RoundRobinTournament: TournamentKit.RoundRobinTournament {
    var matchDays: [MatchDay]
    
    mutating func addDecider(with participations: [Player]) {
        let match = Match(matchType: .decider, players: participations)
        let matchDay = MatchDay(matches: [match])
        matchDays.append(matchDay)
    }
    
    mutating func removeDecider(_ decider: Match) {
        guard let index = matchDays.firstIndex(where: { $0.matches.contains(decider) }) else {
            return
        }
        let matchDay = matchDays[index]
        if matchDay.matches.count == 1 {
            matchDays.removeAll { $0 == matchDay }
        }
        else {
            matchDays[index].matches.removeAll { $0 == decider }
        }
    }
}
