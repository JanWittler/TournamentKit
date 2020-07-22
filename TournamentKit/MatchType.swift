//
//  MatchType.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol MatchType {
    associatedtype Reward: MatchTypeReward
    
    var scoringOptions: MatchTypeScoringOptions<Reward> { get }
    
    func isDecider() -> Bool
}
