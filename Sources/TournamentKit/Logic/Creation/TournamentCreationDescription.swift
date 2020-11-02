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
    
    public struct MatchDescription: CustomStringConvertible {
        /// The  type of the match.
        public let matchType: MatchType
        
        /// The participations of the match.
        public let participations: [Participation]
        
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
