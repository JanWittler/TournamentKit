//
//  TournamentManager.swift
//  TournamentKit
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object to manage scores, results and state of a tournament.
public struct TournamentManager {
    /// Errors that may occur while applying a score.
    public enum ResultError: Error {
        /// The provided results do not match with the results of the provided match.
        case invalidResultsProvided
        /// The scores are invalid.
        case invalidScores
    }
    
    public init() { }
    
    /**
     Applies the given scores to the given match. If the scores are invalid - determined based on the type of the match - an error of type `ResultError` is thrown.
     - parameters:
       - scores: The scores for the match. The results in this array must match with the results of the given match, the order does not matter.
       - match: The match to apply the given scores to.
       - overtimeSuffix: A suffix indicating some overtime if any.
     - throws: Throws an error of `ResultError` if the provided input is invalid.
     - postcondition: All `match.results.score` match their value provided in the `scores` array.
     - postcondition: All `match.results.rank` and  `match.results.reward` are updated and not `nil`.
     - postcondition: `match.overtimeResult` is updated and not `nil`.
     */
    public func applyScores<Match: TournamentKit.Match>(_ scores: [(result: Match.Result, score: Match.Result.Score)], for match: inout Match, overtimeSuffix: String?) throws {
        guard scores.count == match.results.count else {
            throw ResultError.invalidResultsProvided
        }
        let result = match.results.enumerated().reduce(into: [Int : Match.Result.Score]()) { (result, obj) in
            result[obj.offset] = scores.first { $0.result == obj.element }?.score
        }
        guard result.count == match.results.count else {
            throw ResultError.invalidResultsProvided
        }
        guard let (sortedRewards, isOvertime) = match.matchType.scoringConfiguration.sortedRewardsForResultIfValid(result, overtimeSuffix: overtimeSuffix) else {
            throw ResultError.invalidScores
        }
        sortedRewards.enumerated().map { (index, obj) -> (index: Int, score: Match.Result.Score, reward: Match.Result.Reward, rank: Int) in
            var rank = index
            while rank > 0 && sortedRewards[rank - 1].score == obj.score {
                rank -= 1
            }
            return (obj.element, obj.score, obj.reward, rank)
        }.forEach {
            match.results[$0.index].score = $0.score
            match.results[$0.index].reward = $0.reward
            match.results[$0.index].rank = UInt($0.rank)
        }
        match.overtimeResult = isOvertime ? .overtime(suffix: overtimeSuffix) : .noOvertime
    }
    
    /**
     Adjusts the existence of a decider in the given tournament.
     
     If the state of the tournament does not require a decider, all deciders are removed using `removeDecider(_:)`.
     
     If the state of the tournament requires a decider, all deciders not matching the participations for the required decider are removed using `removeDecider(_:)`. If there is not yet a decider with the required participations, a decider is added using `addDecider(with:)`.
     
     - parameters:
       - tournament: The tournament for which to adjust the decider existence.
     */
    public func adjustDeciderExistence<Tournament: TournamentKit.RoundRobinTournament>(in tournament: inout Tournament) {
        let ranking = tournament.ranking()
        guard let bestRank = ranking.map({ $0.rank }).min() else {
            return
        }
        let bestRankParticipations = ranking.filter { $0.rank == bestRank }.map { $0.participation }
        let deciders = tournament.matches().filter { $0.matchType.isDecider() }
        if bestRankParticipations.count > 1 {
            let splitDeciders = Dictionary(grouping: deciders) { decider in
                decider.participations.count == bestRankParticipations.count && bestRankParticipations.allSatisfy { decider.participations.contains($0) }
            }
            (splitDeciders[false] ?? []).forEach { tournament.removeDecider($0) }
            if splitDeciders[true] == nil {
                tournament.addDecider(with: bestRankParticipations)
            }
        }
        else {
            deciders.forEach { tournament.removeDecider($0) }
        }
    }
}
