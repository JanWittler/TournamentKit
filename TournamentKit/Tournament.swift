//
//  Tournament.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol Tournament {
    associatedtype MatchDay: TournamentKit.MatchDay
    typealias MatchResult = MatchDay.Match.Result
    
    var matchDays: [MatchDay] { get }
    
    func participations() -> [MatchResult.MatchParticipation]
}

public extension Tournament {
    var isFinished: Bool { return matchDays.allSatisfy { $0.isFinished } }
    
    func participations() -> [MatchResult.MatchParticipation] {
        let allParticipations = matchDays.map { $0.matches }.joined().map { $0.results }.joined().map { $0.participation }
        return allParticipations.reduce(into: []) { (result, participation) in
            if !result.contains(participation) {
                result.append(participation)
            }
        }
    }
    
    func matches() -> [MatchDay.Match] { return Array(matchDays.map { $0.matches }.joined()) }
}
