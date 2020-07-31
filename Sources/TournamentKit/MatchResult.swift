//
//  MatchResult.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

/**
 An object to encapsulate a match participation and associated values like score or reward for some match.
 
 - important: Most of the required values are used to track tournament related statistics and should not be set directly but rather by using the `TournamentManager`.
 */
public protocol MatchResult: Equatable {
    /// The associated `MatchTypeReward` type.
    associatedtype Reward: MatchTypeReward
    /// The associated `MatchParticipation` type.
    associatedtype MatchParticipation: TournamentKit.MatchParticipation
    
    /// The participation associated with this result.
    var participation: MatchParticipation { get }
    
    /**
     The achieved score.
     If the match is not yet finished, the score is `nil`.
     
     - important: Do not set this value directly but rather by using `TournamentManager.applyScores(_:for:overtimeSuffix:)`.
    */
    var score: Int? { get set }
    /**
     The rank achieved in the match compared to other results. The winner has rank 0.
     If the match is not yet finished, the rank is `nil`.
     
     - important: Do not set this value directly but rather by using `TournamentManager.applyScores(_:for:overtimeSuffix:)`.
     */
    var rank: Int? { get set }
    
    /**
     The reward gained for the achieved rank in the match.
     If the match is not yet finished, the reward is `nil`.
     
     - important: Do not set this value directly but rather by using `TournamentManager.applyScores(_:for:overtimeSuffix:)`.
    */
    var reward: Reward? { get set }
}
