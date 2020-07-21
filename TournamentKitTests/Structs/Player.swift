//
//  Player.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct Player: TournamentKit.Player, ExpressibleByStringLiteral {
    let name: String
    
    init(stringLiteral value: StringLiteralType) {
        self.name = String(value)
    }
}
