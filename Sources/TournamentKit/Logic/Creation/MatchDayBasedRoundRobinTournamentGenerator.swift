//
//  MatchDayBasedRoundRobinTournamentGenerator.swift
//  TournamentKit
//
//  Created by Jan Wittler on 02.11.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/**
 A tournament generator which generates a round robin tournament schedule using match day based scheduling. This means that each match of a match day is assumed to be held in parallel such that each participation has equally long waiting times.
 
 Each generated match is a 1vs1 match.
 
 For one match day each participation is participating in one match. An exeption to this is an odd number of participations, in which case each match day another participation is pausing.
 */
struct MatchDayBasedRoundRobinTournamentGenerator<MatchType: TournamentKit.MatchType>: TournamentGenerator {
    /// The match type for all matches of the generated tournament descriptions.
    let matchType: MatchType
    
    /**
     Initializes the generator with the given match type.
     - parameters:
       - matchType: The match type for all matches of the generated tournament descriptions.
     */
    init(matchType: MatchType) {
        self.matchType = matchType
    }
    
    func generateTournament<Participation: MatchParticipation>(participations: [Participation]) -> TournamentCreationDescription<MatchType, Participation> {
        precondition(participations.count >= 2, "invalid number of participations provided. At least 2 are required.")
        let allPairings = generateAllPairings(participations: participations)
        //TODO: normalize home <-> away pairings
        let matches = allPairings.map { day in
            day.shuffled().map { TournamentCreationDescription<MatchType, Participation>.MatchDescription(matchType: matchType, participations: [$0.0, $0.1]) }
        }
        return .init(matches: matches)
    }
    
    private func generateAllPairings<Participation: MatchParticipation>(participations: [Participation]) -> [[(Participation, Participation)]] {
        //using https://en.wikipedia.org/wiki/Round-robin_tournament#Circle_method
        var participations: [Participation?] = participations
        if participations.count % 2 == 1 {
            participations.insert(nil, at: 0)
        }
        var firstHalf = participations[0 ..< participations.count / 2]
        var secondHalf = participations[participations.count / 2 ..< participations.count]
        var result: [[(Participation, Participation)]] = []
        for _ in 0 ..< participations.count - 1{
            result.append(zip(firstHalf, secondHalf).compactMap { $0 == nil || $1 == nil ? nil : ($0!, $1!) })
            firstHalf.insert(secondHalf.removeFirst(), at: 1)
            secondHalf.append(firstHalf.removeLast())
        }
        return result
    }
}
