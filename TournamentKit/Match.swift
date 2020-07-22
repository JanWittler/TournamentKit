//
//  Match.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// A value indicating whether some match finished in overtime.
public enum MatchOvertimeResult: Equatable, Hashable {
    /// The match did not finish in overtime.
    case noOvertime
    /// The match did finish in overtime. May contain a `suffix` to specify the overtime.
    case overtime(suffix: String?)
}

/// An object that represents a match within a tournament.
public protocol Match {
    /// The associated `MatchResult` type.
    associatedtype Result: MatchResult
    /// The associated `MatchType` type.
    associatedtype MatchType: TournamentKit.MatchType where MatchType.Reward == Result.Reward
    
    /// The type of the match.
    var matchType: MatchType { get }
    /// The results of the match.
    var results: [Result] { get set }
    /**
     An indicator specifying whether the match was finished in overtime. If the match is not yet finished, returns `nil`.
     
     - important: Do not set this value directly but rather by using `TournamentManager.applyScores(_:for:overtimeSuffix:)`.
     */
    var overtimeResult: MatchOvertimeResult? { get set }
}

public extension Match {
    /// Indicates whether this match is finished, i.e. if results are entered.
    var isFinished: Bool {
        return overtimeResult != nil && results.allSatisfy { $0.rank != nil }
    }
    
    /// The participations participating in this match.
    var participations: [Result.MatchParticipation] { return results.map { $0.participation } }
}
