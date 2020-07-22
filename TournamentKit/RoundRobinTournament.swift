//
//  RoundRobinTournament.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public struct RoundRobinTournamentRanking<MatchResult: TournamentKit.MatchResult>: Comparable {
    public let participation: MatchResult.MatchParticipation
    public let rank: Int
    public let reward: MatchResult.Reward
    
    public static func <(lhs: RoundRobinTournamentRanking, rhs: RoundRobinTournamentRanking) -> Bool {
        return lhs.rank < rhs.rank
    }
}

public protocol RoundRobinTournament: Tournament {
    func accumulatedReward(for participation: MatchResult.MatchParticipation) -> MatchDay.Match.Result.Reward
    func ranking() -> [RoundRobinTournamentRanking<MatchResult>]
    
    mutating func addDecider(with participantions: [MatchResult.MatchParticipation])
    mutating func removeDecider(_ decider: MatchDay.Match)
}

public extension RoundRobinTournament {
    func ranking() -> [RoundRobinTournamentRanking<MatchResult>] {
        let allParticipations = participations().sorted()
        let participationsAndRewards = allParticipations.map { ($0, accumulatedReward(for: $0)) }
        
        if let decider = matchDays.map({ $0.matches }).joined().first(where: { $0.matchType.isDecider() }), decider.isFinished {
            let splitParticipations = Dictionary(grouping: participationsAndRewards) { decider.results.map { $0.participation }.contains($0.0) }
            let sortedDeciderParticipations = (splitParticipations[true] ?? []).map { (participation, reward) in
                RoundRobinTournamentRanking<MatchResult>(participation: participation, rank: decider.results.first { $0.participation == participation }!.rank!, reward: reward)
            }.sorted()
            let sortedOtherParticipations = ranks(for: splitParticipations[false] ?? [], rankOffset: sortedDeciderParticipations.count)
            return sortedDeciderParticipations + sortedOtherParticipations
        }
        
        return ranks(for: participationsAndRewards)
    }
    
    func ranks(for participationsAndRewards: [(participation: MatchResult.MatchParticipation, reward: MatchResult.Reward)], rankOffset: Int = 0) -> [RoundRobinTournamentRanking<MatchResult>] {
        let sortedRanking = participationsAndRewards.enumerated().sorted { (lhs, rhs) in
            if lhs.element.reward != rhs.element.reward {
                return lhs.element.reward > rhs.element.reward
            }
            return lhs.offset < rhs.offset
        }.map { $0.element }
        return sortedRanking.enumerated().map { (index, element) in
            var rank = index
            while rank > 0 && sortedRanking[rank - 1].reward == element.reward {
                rank -= 1
            }
            return RoundRobinTournamentRanking(participation: element.participation, rank: rank + rankOffset, reward: element.reward)
        }
    }
}

public extension RoundRobinTournament where MatchResult.Reward: AdditiveArithmetic {
    func accumulatedReward(for participation: MatchResult.MatchParticipation) -> MatchDay.Match.Result.Reward {
        return matches().map { $0.results }.joined().filter { $0.participation == participation }.compactMap { $0.reward }.reduce(.zero, +)
    }
}
