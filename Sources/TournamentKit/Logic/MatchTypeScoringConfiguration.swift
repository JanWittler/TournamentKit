//
//  MatchTypeScoringConfiguration.swift
//  TournamentKit
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

fileprivate extension Array {
    subscript(optional index: Array.Index) -> Array.Element? {
        return index >= count ? nil : self[index]
    }
}

public protocol MatchTypeReward: Comparable {
    static var zero: Self { get }
}

public protocol LocalizedDescriptionMatchTypeReward: MatchTypeReward {
    var localizedDescription: String { get }
}

public struct MatchTypeScoringConfiguration<Reward: MatchTypeReward> {
    public let winningMethod: WinningMethod
    private let rankedRewards: [Reward]
    public let overtimeConfiguration: OvertimeCofiguration?
    
    public func rewards(for rank: UInt) -> Reward {
        return rankedRewards[optional: Int(rank)] ?? .zero
    }
    
    public enum WinningMethod {
        case highestScore
        case lowestScore
        case fixedScore(score: Int)
        case flexibleScoreWithDifference(minimalScore: Int, difference: UInt)
        
        fileprivate var sortScoresDescending: Bool {
            switch self {
            case .highestScore: return true
            case .lowestScore: return false
            case .fixedScore: return true
            case .flexibleScoreWithDifference: return true
            }
        }
    }
    
    public struct OvertimeCofiguration {
        fileprivate let rankedRewards: [Reward]
        public let trigger: OvertimeTrigger
        
        public func rewards(for rank: UInt) -> Reward {
            return rankedRewards[optional: Int(rank)] ?? .zero
        }
        public enum OvertimeTrigger {
            case bySuffix(possibleSuffixes: [String])
            case byAllReachingScore(score: Int)
        }
        
        public init(rankedRewards: [Reward], trigger: OvertimeTrigger) {
            if case .bySuffix(possibleSuffixes: let suffixes) = trigger {
                precondition(!suffixes.isEmpty, "can't init an overtime trigger with no suffixes")
            }
            self.rankedRewards = rankedRewards
            self.trigger = trigger
        }
    }
    
    public init(winningMethod: WinningMethod, rankedRewards: [Reward], overtimeConfiguration: OvertimeCofiguration? = nil) {
        if case .flexibleScoreWithDifference(_, difference: let difference) = winningMethod {
            precondition(difference > 1, "the minimal allowed difference is 2")
        }
        self.winningMethod = winningMethod
        self.rankedRewards = rankedRewards
        self.overtimeConfiguration = overtimeConfiguration
    }
    
    //MARK: - Validation
    
    /**
     Evaluates whether the given results are valid for the current scoring options. If so, returns the rewards for it sorted by rank and if the results were evaluated as overtime.
     - parameters:
       - result: The result of the match. The keys will be included in the result to allow matching of the rewards.
       - overtimeSuffix: The overtime suffix selected for the match, if any.
     - returns: If the result is invalid, returns `nil`. Otherwise returns the result keys sorted by rank and associated with the reward corresponding to the rank and a boolean indicating whether the results were evaluated as overtime.
     */
    public func sortedRewardsForResultIfValid<T, S: BinaryInteger>(_ result: [T : S], overtimeSuffix: String?) -> (sortedRewards: [(element: T, score: S, reward: Reward)], isOvertime: Bool)? {
        let sortedResult = self.sortedResult(from: result)
        let sortedScores = sortedResult.map { $0.score }
        let isOvertime = self.isOvertime(sortedScores, overtimeSuffix: overtimeSuffix)
        let rankedRewards = isOvertime ? overtimeConfiguration!.rankedRewards : self.rankedRewards
        guard validateScoresDifferent(sortedScores, rankedRewards: rankedRewards),
            validateWinningMethod(for: sortedScores) else {
            return nil
        }
        if isOvertime {
            guard validateOvertime(for: sortedScores, overtimeSuffix: overtimeSuffix) else {
                return nil
            }
        }
        else {
            guard overtimeSuffix == nil else {
                return nil
            }
        }
        return (sortedResult.enumerated().map { ($0.element.object, $0.element.score, rankedRewards[optional: $0.offset] ?? .zero) }, isOvertime)
    }
    
    private func sortedResult<T, S: BinaryInteger>(from result: [T: S]) -> [(object: T, score: S)] {
        let sortedResult = Array(result.map { (object: $0.key, score: $0.value) }.sorted { $0.score > $1.score })
        return winningMethod.sortScoresDescending ? sortedResult : sortedResult.reversed()
    }
    
    private func validateScoresDifferent<S: Equatable>(_ sortedScores: [S], rankedRewards: [Reward]) -> Bool {
        var index = 1
        let rewardAt: (Int) -> Reward = { return rankedRewards[optional: $0] ?? .zero }
        repeat {
            defer { index += 1 }
            guard index < sortedScores.count else {
                if rankedRewards.count <= index {
                    continue
                }
                return false
            }
            guard sortedScores[index - 1] != sortedScores[index] else {
                return false
            }
        } while rewardAt(index - 1) != rewardAt(index)
        return true
    }
    
    private func validateWinningMethod<S: BinaryInteger>(for sortedScores: [S]) -> Bool {
        switch winningMethod {
        case .highestScore, .lowestScore:
            return true
        case .fixedScore(score: let score):
            return sortedScores[0] == score
        case .flexibleScoreWithDifference(minimalScore: let score, difference: let difference):
            let scoreDifference = abs(Int(sortedScores[0]) - Int(sortedScores[1]))
            if sortedScores[0] > score {
                return scoreDifference == difference
            }
            return scoreDifference >= difference
        }
    }
    
    private func isOvertime<S: BinaryInteger>(_ sortedScores: [S], overtimeSuffix: String?) -> Bool {
        guard let overtimeConfiguration = overtimeConfiguration else {
            return false
        }
        switch overtimeConfiguration.trigger {
        case .bySuffix: return overtimeSuffix != nil
        case .byAllReachingScore(score: let score): return sortedScores.allSatisfy { $0 >= score }
        }
    }
    
    private func validateOvertime<S>(for sortedScores: [S], overtimeSuffix: String?) -> Bool {
        guard let overtimeConfiguration = overtimeConfiguration else {
            return false
        }
        switch overtimeConfiguration.trigger {
        case .bySuffix(possibleSuffixes: let possibleSuffixes): return overtimeSuffix != nil && possibleSuffixes.contains(overtimeSuffix!)
        case .byAllReachingScore:
            return true
        }
    }
}

//MARK: - Localized explanation

extension MatchTypeScoringConfiguration where Reward: LocalizedDescriptionMatchTypeReward {
    public func localizedScoreExplanation(forPlayersCount playersCount: UInt) -> String {
        var explanation: String
        switch winningMethod {
        case .highestScore:
            explanation = NSLocalizedString("HighestScore", comment: "")
        case .lowestScore:
            explanation = NSLocalizedString("LowestScore", comment: "")
        case .fixedScore(score: let score):
            explanation = String.localizedStringWithFormat(NSLocalizedString("FixedScore", comment: ""), score)
        case .flexibleScoreWithDifference(minimalScore: let score, difference: let difference):
            explanation = String.localizedStringWithFormat(NSLocalizedString("FlexibleScoreWithDifference", comment: ""), score, difference, score - 1, score - 1, difference)
        }
        
        if let overtimeConfiguration = overtimeConfiguration {
            explanation += "\n"
            switch overtimeConfiguration.trigger {
            case .bySuffix(possibleSuffixes: let suffixes):
                let quotedSuffixes = suffixes.map { (Locale.current.quotationBeginDelimiter ?? "") + $0 + (Locale.current.quotationEndDelimiter ?? "") }
                let suffixesText: String
                let separator = ", "
                if quotedSuffixes.count > 1, let last = quotedSuffixes.last {
                    suffixesText = quotedSuffixes.dropLast().joined(separator: separator) + " " + NSLocalizedString("Overtime.bySuffix.Or", comment: "") + " " + last
                }
                else {
                    suffixesText = quotedSuffixes.joined(separator: separator)
                }
                explanation += String.localizedStringWithFormat(NSLocalizedString("Overtime.bySuffix", comment: ""), suffixesText, suffixes.count)
            case .byAllReachingScore(score: let score):
                explanation += String.localizedStringWithFormat(NSLocalizedString("Overtime.byAllReachingScore", comment: ""), score)
            }
        }
        
        let rewardExplanation: ([Reward]) -> String = {
            $0.enumerated().map {
                String.localizedStringWithFormat(NSLocalizedString("Reward", comment: ""), NumberFormatter.localizedString(from: NSNumber(value: $0.offset + 1), number: .ordinal), $0.element.localizedDescription) }.joined(separator: "\n")
        }
        
        if !rankedRewards.isEmpty {
            let rewards = (0..<playersCount).map { self.rewards(for: $0) }
            explanation += "\n\n" + NSLocalizedString("Scores.Title", comment: "") + "\n" +
                rewardExplanation(rewards)
        }
        
        if let overtimeConfiguration = overtimeConfiguration {
            if !overtimeConfiguration.rankedRewards.isEmpty {
                let rewards = (0..<playersCount).map { overtimeConfiguration.rewards(for: $0) }
                explanation += "\n\n" + NSLocalizedString("Scores.Overtime.Title", comment: "") + "\n" + rewardExplanation(rewards)
            }
        }
        return explanation
    }
}

private func NSLocalizedString(_ key: String, comment: String) -> String {
    return Foundation.NSLocalizedString(key, tableName: "ScoringOptions", comment: comment)
}
