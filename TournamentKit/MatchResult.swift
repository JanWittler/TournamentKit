//
//  MatchResult.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol MatchResult: Equatable {
    associatedtype Reward: MatchTypeReward
    associatedtype MatchParticipation: TournamentKit.MatchParticipation
    
    var participation: MatchParticipation { get }
    var score: Int? { get set }
    var rank: Int? { get set }
    var reward: Reward? { get set }
}
