//
//  Match.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public enum MatchOvertimeResult: Equatable, Hashable {
    case noOvertime
    case overtime(suffix: String?)
}

public protocol Match {
    associatedtype Result: MatchResult
    associatedtype MatchType: TournamentKit.MatchType where MatchType.Reward == Result.Reward
    
    var matchType: MatchType { get }
    var results: [Result] { get set }
    var overtimeResult: MatchOvertimeResult? { get set }
}

public extension Match {
    var isFinished: Bool {
        return overtimeResult != nil && results.allSatisfy { $0.rank != nil }
    }
    
    var participations: [Result.MatchParticipation] { return results.map { $0.participation } }
}
