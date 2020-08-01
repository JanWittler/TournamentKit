//
//  MatchResult.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct MatchResult: TournamentKit.MatchResult, Equatable {
    struct Reward: TournamentKit.MatchTypeReward {
        let points: Int
        
        static var zero: Reward = 0
        
        init(points: Int) {
            self.points = points
        }
        
        static func < (lhs: MatchResult.Reward, rhs: MatchResult.Reward) -> Bool {
            return lhs.points < rhs.points
        }
    }
    
    let player: Player
    var participation: Player { return player }
    var score: Int? = nil
    var rank: UInt? = nil
    var reward: Reward? = nil
    
    init(player: Player) {
        self.player = player
    }
}

extension MatchResult.Reward: ExpressibleByIntegerLiteral, AdditiveArithmetic {
    init(integerLiteral value: IntegerLiteralType) {
        self.points = Int(value)
    }
    
    static func + (lhs: MatchResult.Reward, rhs: MatchResult.Reward) -> MatchResult.Reward {
        return MatchResult.Reward(points: lhs.points + rhs.points)
    }
    
    static func - (lhs: MatchResult.Reward, rhs: MatchResult.Reward) -> MatchResult.Reward {
        return MatchResult.Reward(points: lhs.points - rhs.points)
    }
}
