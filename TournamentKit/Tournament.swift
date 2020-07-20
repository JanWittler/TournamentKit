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
    
    var name: String { get }
    var date: Date { get }
    var matchDays: [MatchDay] { get }
    
    func participations() -> Set<MatchResult.MatchParticipation>
}

public extension Tournament {
    var isFinished: Bool { return matchDays.allSatisfy { $0.isFinished } }
    func participations() -> Set<MatchResult.MatchParticipation> {
        return Set(matchDays.map { $0.matches }.joined().map { $0.results }.joined().map { $0.participation })
    }
    
    func matches() -> [MatchDay.Match] { return Array(matchDays.map { $0.matches }.joined()) }
}
