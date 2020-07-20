//
//  MatchType.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol MatchType: Equatable {
    associatedtype Reward: MatchTypeReward
    /// The decider match type.
    static var decider: Self { get }
    
    var scoringOptions: MatchTypeScoringOptions<Reward> { get }
}
