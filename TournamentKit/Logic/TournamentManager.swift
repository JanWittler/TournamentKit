//
//  TournamentManager.swift
//  TournamentKit
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public struct TournamentManager {
    public enum ResultError: Error {
        case invalidResultsProvided
        case invalidScores
    }
    
    public init() { }
    
    public func applyScores<Match: TournamentKit.Match>(_ scores: [(result: Match.Result, score: Int)], for match: inout Match, overtimeSuffix: String?) throws {
        guard scores.count == match.results.count else {
            throw ResultError.invalidResultsProvided
        }
        let result = match.results.enumerated().reduce(into: [Int : Int]()) { (result, obj) in
            result[obj.offset] = scores.first { $0.result == obj.element }?.score
        }
        guard result.count == match.results.count else {
            throw ResultError.invalidResultsProvided
        }
        guard let (sortedRewards, isOvertime) = match.matchType.scoringOptions.sortedRewardsForResultIfValid(result, overtimeSuffix: overtimeSuffix) else {
            throw ResultError.invalidScores
        }
        sortedRewards.enumerated().map { (index, obj) -> (index: Int, score: Int, reward: Match.Result.Reward, rank: Int) in
            var rank = index
            while rank > 0 && sortedRewards[rank - 1].score == obj.score {
                rank -= 1
            }
            return (obj.element, obj.score, obj.reward, rank)
        }.forEach {
            match.results[$0.index].score = $0.score
            match.results[$0.index].reward = $0.reward
            match.results[$0.index].rank = $0.rank
        }
        match.overtimeResult = isOvertime ? .overtime(suffix: overtimeSuffix) : .noOvertime
    }
    
    public func adjustDeciderExistence<Tournament: TournamentKit.RoundRobinTournament>(in tournament: inout Tournament) {
        let ranking = tournament.ranking()
        guard let bestRank = ranking.map({ $0.rank }).min() else {
            return
        }
        let bestRankParticipations = ranking.filter { $0.rank == bestRank }.map { $0.participation }
        let deciders = tournament.matches().filter { $0.matchType == .decider }
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
