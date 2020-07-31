//
//  TournamentKitWrongResultsTests.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 21.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import XCTest
@testable import TournamentKit

class TournamentKitWrongResultsTests: XCTestCase {
    let tournamentManager = TournamentManager()
    
    func testWrongResultsHighestScore() {
        var match = Match(matchType: .highestScore, players: ["A", "B"])
        XCTAssertThrowsError(try tournamentManager.applyTestScores([3, 3], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([3, 0], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyScores([(match.results[0], 0), (MatchResult(player: "C"), 3)], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidResultsProvided)
        }
    }
    
    func testWrongResultsLowestScore() {
        var match = Match(matchType: .lowestScore, players: ["A", "B"])
        XCTAssertThrowsError(try tournamentManager.applyTestScores([3, 3], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([3, 0], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyScores([(match.results[0], 0), (MatchResult(player: "C"), 3)], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidResultsProvided)
        }
    }
    
    func testWrongResultsFixedScore() {
        var match = Match(matchType: .fixedScore5, players: ["A", "B"])
        XCTAssertThrowsError(try tournamentManager.applyTestScores([4, 0], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([5, 5], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([7, 5], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyScores([(match.results[0], 5), (MatchResult(player: "C"), 3)], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidResultsProvided)
        }
    }
    
    func testWrongResultsFlexibleScore() {
        var match = Match(matchType: .flexibleScore5Difference2, players: ["A", "B"])
        XCTAssertThrowsError(try tournamentManager.applyTestScores([5, 4], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([5, 5], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([7, 4], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyTestScores([7, 6], for: &match, overtimeSuffix: "A")) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidScores)
        }
        
        XCTAssertThrowsError(try tournamentManager.applyScores([(match.results[0], 5), (MatchResult(player: "C"), 3)], for: &match, overtimeSuffix: nil)) { (error) in
            XCTAssert((error as? TournamentManager.ResultError) == .invalidResultsProvided)
        }
    }
}

extension TournamentKitWrongResultsTests {
    static var allTests = [
        ("testWrongResultsHighestScore", testWrongResultsHighestScore),
        ("testWrongResultsLowestScore", testWrongResultsLowestScore),
        ("testWrongResultsFixedScore", testWrongResultsFixedScore),
        ("testWrongResultsFlexibleScore", testWrongResultsFlexibleScore)
    ]
}
