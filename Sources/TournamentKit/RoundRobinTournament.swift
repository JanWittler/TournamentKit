//
//  RoundRobinTournament.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object to represent a rank for some participation in a round robin tournament.
public struct RoundRobinTournamentRanking<MatchResult: TournamentKit.MatchResult>: Comparable {
    /// The participation of the ranking.
    public let participation: MatchResult.MatchParticipation
    /// The rank of the ranking. Best rank is 0.
    public let rank: UInt
    /// The reward of the participation gained in the tournament.
    public let reward: MatchResult.Reward
    
    public static func <(lhs: RoundRobinTournamentRanking, rhs: RoundRobinTournamentRanking) -> Bool {
        return lhs.rank < rhs.rank
    }
}

/// An object to represent a round robin tournament, i.e. a tableau based tournament whose winner is that participation with the highest accumulated reward.
public protocol RoundRobinTournament: Tournament {
    /**
     Returns the accumulated reward for the given participation.
     - parameters:
       - participation: The participation for which to compute the accumulated reward.
     - returns: The accumulated reward.
     
     */
    func accumulatedReward(for participation: MatchResult.MatchParticipation) -> MatchDay.Match.Result.Reward
    
    /**
     Returns the current ranking of the tournament, sorted by rank.
     
     Participations are ranked based on their accumulated reward. The highest reward has the highest rank. If multiple participations have an equal accumulated reward, they share a rank.
     */
    func ranking() -> [RoundRobinTournamentRanking<MatchResult>]
    
    /**
     Adds a new decider match to the current tournament with the given participations.
     
     You should never call this method directly. Instead, this method is called by the `TournamentManager` to adjust the existence of a decider in the tournament based on its current ranking.
     
     - parameters:
       - participations: The participations to participate in the new decider.
     */
    mutating func addDecider(with participations: [MatchResult.MatchParticipation])
    
    /**
     Removes the given decider from the tournament.
     
     You should never call this method directly. Instead, this method is called by the `TournamentManager` to adjust the existence of a decider in the tournament based on its current ranking.
     
     - parameters:
       - decider: The match to remove from the tournament.
     */
    mutating func removeDecider(_ decider: MatchDay.Match)
}

public extension RoundRobinTournament {
    func ranking() -> [RoundRobinTournamentRanking<MatchResult>] {
        let allParticipations = participations().sorted { $0.name < $1.name }
        let participationsAndRewards = allParticipations.map { ($0, accumulatedReward(for: $0)) }
        
        if let decider = matchDays.map({ $0.matches }).joined().first(where: { $0.matchType.isDecider() }), decider.isFinished {
            let splitParticipations = Dictionary(grouping: participationsAndRewards) { decider.results.map { $0.participation }.contains($0.0) }
            let sortedDeciderParticipations = (splitParticipations[true] ?? []).map { (participation, reward) in
                RoundRobinTournamentRanking<MatchResult>(participation: participation, rank: decider.results.first { $0.participation == participation }!.rank!, reward: reward)
            }.sorted()
            let sortedOtherParticipations = ranks(for: splitParticipations[false] ?? [], rankOffset: UInt(sortedDeciderParticipations.count))
            return sortedDeciderParticipations + sortedOtherParticipations
        }
        
        return ranks(for: participationsAndRewards)
    }
    
    /**
     Sorts the given participations by their gained rewards and maps them to their rankings.
     - parameters:
       - participationsAndRewards: The participations together with their gained rewards for the tournament. These need not to be all participations of the tournament.
       - rankOffset: The rank offset to apply to the final ranking. This can be used if there is custom logic for a part of the ranking and the trailing part is ranked using this method.
     - returns: Returns rankings for the given participations. The result is sorted by rank.
     */
    func ranks(for participationsAndRewards: [(participation: MatchResult.MatchParticipation, reward: MatchResult.Reward)], rankOffset: UInt = 0) -> [RoundRobinTournamentRanking<MatchResult>] {
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
            return RoundRobinTournamentRanking(participation: element.participation, rank: UInt(rank) + rankOffset, reward: element.reward)
        }
    }
}

public extension RoundRobinTournament where MatchResult.Reward: AdditiveArithmetic {
    func accumulatedReward(for participation: MatchResult.MatchParticipation) -> MatchDay.Match.Result.Reward {
        return matches().map { $0.results }.joined().filter { $0.participation == participation }.compactMap { $0.reward }.reduce(.zero, +)
    }
}
