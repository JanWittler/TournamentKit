//
//  MatchDayBasedRoundRobinTournamentCreatorTests.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 02.11.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import XCTest
@testable import TournamentKit

class MatchDayBasedRoundRobinTournamentCreatorTests: XCTestCase {
    var tournaments: [[Player] : TournamentCreationDescription<MatchType, Player>]!
    
    override func setUp() {
        let availablePlayers = (1...32).map { Player(stringLiteral: "\($0)") }
        tournaments = (2..<availablePlayers.count).reduce(into: [:]) { (result, playerCount) in
            let players = Array(availablePlayers[..<availablePlayers.index(availablePlayers.startIndex, offsetBy: playerCount)])
            let creator = MatchDayBasedRoundRobinTournamentGenerator(matchType: MatchType.highestScore)
            result![players] = creator.generateTournament(participations: players)
        }
    }
    
    func testMatchDaysComplete() {
        tournaments.forEach { (players, tournament) in
            tournament.matches.forEach { matches in
                XCTAssert(matches.count == players.count / 2, "missing match")
            }
        }
    }
    
    func testEachPlayerMaxOncePerMatchDay() {
        tournaments.forEach { (players, tournament) in
            tournament.matches.forEach { matches in
                let allPlayers = matches.map { $0.participations }.joined()
                XCTAssert(Set(allPlayers).count == allPlayers.count)
            }
        }
    }
    
    func testEachPlayerAgainstEachOther() {
        tournaments.forEach { (players, tournament) in
            players.forEach { player in
                let opponents = tournament.matches.joined().map { $0.participations }.filter { $0.contains(player) }.joined().filter { $0 != player }
                XCTAssert(opponents.count == players.count - 1, "missing opponent")
                XCTAssert(Set(opponents).count == opponents.count, "duplicated opponent")
                XCTAssert(Set(players).intersection(opponents) == Set(opponents), "invalid opponent")
            }
        }
    }
    
    //TODO: not yet implemented
    func testEachPlayerEquallyHomeAndAway() {
        tournaments.forEach { (players, tournament) in
            players.forEach { player in
                let ownMatchIndexes = tournament.matches.joined().compactMap { $0.participations.firstIndex(of: player) }
                let groupedIndexCounts = Dictionary(grouping: ownMatchIndexes, by: { $0 }).mapValues { $0.count }
                let homeCount = groupedIndexCounts[0] ?? 0
                let awayCount = groupedIndexCounts[1] ?? 0
                XCTAssert(abs(homeCount - awayCount) <= (players.count % 2 == 0 ? 0 : 1), "invalid home / away balance")
            }
        }
    }
}

extension MatchDayBasedRoundRobinTournamentCreatorTests {
    static var allTests = [
        ("testMatchDaysComplete", testMatchDaysComplete),
        ("testEachPlayerMaxOncePerMatchDay", testEachPlayerMaxOncePerMatchDay),
        ("testEachPlayerAgainstEachOther", testEachPlayerAgainstEachOther),
        ("testEachPlayerEquallyHomeAndAway", testEachPlayerEquallyHomeAndAway)
    ]
}
