//
//  TournamentCreationDescription.swift
//  TournamentKit
//
//  Created by Jan Wittler on 27.10.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object to describe the structure of an arbitrary tournament.
public struct TournamentCreationDescription<MatchType: TournamentKit.MatchType, Participation: MatchParticipation>: CustomStringConvertible {
    /// The matches of the tournament grouped by match day.
    public let matches: [[MatchDescription]]
    
    /**
     Creates a new tournament creation description which consists of the provided match descriptions.
     - parameters:
       - matches: The matches of which the tournament consists.
     */
    public init(matches: [[MatchDescription]]) {
        self.matches = matches
    }
    
    public struct MatchDescription: CustomStringConvertible {
        /// The  type of the match.
        public let matchType: MatchType
        
        /// The participations of the match.
        public let participations: [Participation]
        
        /**
         Creates a new match description.
         - parameters:
           - matchType: The match type of the match.
           - participations: The participations of the match.
         */
        public init(matchType: MatchType, participations: [Participation]) {
            self.matchType = matchType
            self.participations = participations
        }
        
        public var description: String {
            return participations.map { $0.name }.joined(separator: " - ")
        }
    }
    
    public var description: String {
        return matches.enumerated().map { (index, matches) in
            return "\(index + 1)\n" + matches.map { "   \($0)" }.joined(separator: "\n")
        }.joined(separator: "\n\n")
    }
}
