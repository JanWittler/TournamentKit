//
//  MatchType.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

enum MatchType: TournamentKit.MatchType {
    func isDecider() -> Bool {
        return self == .decider
    }
    
    case highestScore
    case lowestScore
    case fixedScore5
    case flexibleScore5Difference2
    case overtimeSuffix
    case overtimeScore
    case decider
    
    typealias Reward = MatchResult.Reward
    
    var scoringOptions: MatchTypeScoringOptions<MatchResult.Reward> {
        switch self {
        case .highestScore: return .init(winningMethod: .highestScore, rankedRewards: [3])
        case .lowestScore: return .init(winningMethod: .lowestScore, rankedRewards: [3])
        case .fixedScore5: return .init(winningMethod: .fixedScore(score: 5), rankedRewards: [3])
        case .flexibleScore5Difference2: return .init(winningMethod: .flexibleScoreWithDifference(minimalScore: 5, difference: 2), rankedRewards: [3])
        case .overtimeSuffix: return .init(winningMethod: .highestScore, rankedRewards: [3], overtimeConfiguration: .init(rankedRewards: [2,1], trigger: .bySuffix(possibleSuffixes: ["OT"])))
        case .overtimeScore: return .init(winningMethod: .fixedScore(score: 2), rankedRewards: [3], overtimeConfiguration: .init(rankedRewards: [2,1], trigger: .byAllReachingScore(score: 1)))
        case .decider: return .init(winningMethod: .highestScore, rankedRewards: [])
        }
    }
}
