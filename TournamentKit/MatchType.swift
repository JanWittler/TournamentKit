//
//  MatchType.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/// An object that identifies the type of a match and contains the type's scoring configuration.
public protocol MatchType {
    /// The associated `MatchTypeReward` type.
    associatedtype Reward: MatchTypeReward
    
    /// The type's scoring configuration. The `TournamentManager` verifies scores and assigns ranks and rewards based on this configuration.
    var scoringConfiguration: MatchTypeScoringConfiguration<Reward> { get }
    
    /// Identifies whether the given match type is a decider match type. There should be at maximum one decider per tournament.
    func isDecider() -> Bool
}
