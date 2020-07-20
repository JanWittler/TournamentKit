//
//  Player.swift
//  TournamentKit
//
//  Created by Jan Wittler on 17.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import Foundation

public protocol Player: Hashable {
    var firstName: String? { get }
    var nickName: String? { get }
    var lastName: String? { get }
}

public extension Player {
    var players: [Self] { return [self] }
    var name: String { return [firstName, nickName, lastName].compactMap { $0 }.joined() }
}
