//
//  TournamentKitTests.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 20.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import XCTest
import TournamentKit

class TournamentKitTests: XCTestCase {
    private var tournament: RoundRobinTournament!
    let tournamentManager = TournamentManager()

    override func setUpWithError() throws {
        let match1_1 = Match(matchType: .highestScore, players: ["A", "B"])
        let match1_2 = Match(matchType: .overtimeSuffix, players: ["C", "D"])
        let matchDay1 = MatchDay(matches: [match1_1, match1_2])
        
        let match2_1 = Match(matchType: .overtimeScore, players: ["A", "C"])
        let matchDay2 = MatchDay(matches: [match2_1])
        tournament = RoundRobinTournament(name: "Test 1", date: Date(), matchDays: [matchDay1, matchDay2])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let manager = TournamentManager()
        var match1_1 = tournament.matchDays[0].matches[0]
        let scores1_1 = [0, 1]
        try manager.applyScores(scores1_1, for: &match1_1, overtimeSuffix: nil)
        XCTAssert(match1_1.overtimeResult == .noOvertime)
        XCTAssertScores(match1_1, scores: scores1_1)
        XCTAssert(match1_1.results[0].rank == 1)
        XCTAssert(match1_1.results[1].rank == 0)
        XCTAssertResults(match1_1)
        
        var match1_2 = tournament.matchDays[0].matches[1]
        let scores1_2 = [0, 1]
        try manager.applyScores(scores1_2, for: &match1_2, overtimeSuffix: "OT")
        XCTAssert(match1_2.overtimeResult == .overtime(suffix: "OT"))
        XCTAssertScores(match1_2, scores: scores1_2)
        XCTAssert(match1_2.results[0].rank == 1)
        XCTAssert(match1_2.results[1].rank == 0)
        XCTAssertResults(match1_2)
        
        var match2_1 = tournament.matchDays[1].matches[0]
        let scores2_1_1 = [1, 2]
        try manager.applyScores(scores2_1_1, for: &match2_1, overtimeSuffix: nil)
        XCTAssert(match2_1.overtimeResult == .overtime(suffix: nil))
        XCTAssertScores(match2_1, scores: scores2_1_1)
        XCTAssert(match2_1.results[0].rank == 1)
        XCTAssert(match2_1.results[1].rank == 0)
        XCTAssertResults(match2_1)
        
        let scores2_1_2 = [0, 2]
        try manager.applyScores(scores2_1_2, for: &match2_1, overtimeSuffix: nil)
        XCTAssert(match2_1.overtimeResult == .noOvertime)
        XCTAssertScores(match2_1, scores: scores2_1_2)
        XCTAssert(match2_1.results[0].rank == 1)
        XCTAssert(match2_1.results[1].rank == 0)
        XCTAssertResults(match2_1)
        
        tournament.matchDays[0].matches[0] = match1_1
        tournament.matchDays[0].matches[1] = match1_2
        tournament.matchDays[1].matches[0] = match2_1
        XCTAssert(tournament.isFinished)
        
        let ranking = tournament.ranking()
        XCTAssert(ranking.map { $0.participation } == ["C", "B", "D", "A"])
        XCTAssert(ranking.map { $0.rank } == [0, 1, 2, 3])
        XCTAssert(ranking.map { $0.reward } == [4, 3, 2, .zero])
    }
}
