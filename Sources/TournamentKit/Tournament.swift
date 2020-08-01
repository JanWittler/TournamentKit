//
//  Tournament.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/**
 An abstract object to represent some tournament.
 
 - note: Due to its abstract intention, there is no notion how the results of a match influence the outcome of the tournament.
 */
public protocol Tournament {
    /// The associated `MatchDay` type.
    associatedtype MatchDay: TournamentKit.MatchDay
    /// The associated `MatchResult` type.
    typealias MatchResult = MatchDay.Match.Result
    
    /// The match days of which this tournament consists.
    var matchDays: [MatchDay] { get }
    
    /**
     The participations for this tournament.
     
     - important: The returned array must contain all and only those participations contained in the tournament's matches. There must be no duplicates.
     */
    func participations() -> [MatchResult.MatchParticipation]
    /**
     The winner of this tournament. If the tournament is not yet finished, `nil` is returned.
     - invariant: `\result != nil` ==> `isFinished == true`
     */
    func winner() -> MatchResult.MatchParticipation?
}

public extension Tournament {
    /// Indicates whether the tournament is finished, i.e. all its matches are finished.
    var isFinished: Bool { return matchDays.allSatisfy { $0.isFinished } }
    
    func participations() -> [MatchResult.MatchParticipation] {
        let allParticipations = matchDays.map { $0.matches }.joined().map { $0.results }.joined().map { $0.participation }
        return allParticipations.reduce(into: []) { (result, participation) in
            if !result.contains(participation) {
                result.append(participation)
            }
        }
    }
    
    /// A convenience accessor to all matches of this tournament. Matches are returned in the order they appear in their match days and in the order their match days appear in the tournament.
    func matches() -> [MatchDay.Match] { return Array(matchDays.map { $0.matches }.joined()) }
}
