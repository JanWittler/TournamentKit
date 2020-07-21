//
//  MatchDay.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation
import TournamentKit

struct MatchDay: TournamentKit.MatchDay, Equatable {
    let name: String?
    var matches: [Match]
    
    init(name: String? = nil, matches: [Match]) {
        self.name = name
        self.matches = matches
    }
}
