//
//  Player.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct Player: TournamentKit.Player, ExpressibleByStringLiteral, Equatable, Hashable {
    let name: String
    
    init(stringLiteral value: StringLiteralType) {
        self.name = String(value)
    }
}

extension Player: CustomStringConvertible {
    var description: String { return "Player \(name)"}
}
