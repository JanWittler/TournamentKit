//
//  TournamentGenerator.swift
//  
//
//  Created by Jan Wittler on 02.11.20.
//

import Foundation

/// A tournament generator generates tournament descriptions using the provided participations.
public protocol TournamentGenerator {
    /**
     The associated `MatchType` type.
     - note: If possible, the implementing class should be generic over this type to support any provided match type.
     */
    associatedtype MatchType: TournamentKit.MatchType
    
    /**
     Generates a tournament description using the generator's strategy.
     - precondition: `\participations.count >= 2`
     - parameters:
       - participations: The participations to participate in the newly generated tournament description.
     - returns: Returns a newly generated tournament description.
     */
    func generateTournament<Participation: MatchParticipation>(participations: [Participation]) -> TournamentCreationDescription<MatchType, Participation>
}
