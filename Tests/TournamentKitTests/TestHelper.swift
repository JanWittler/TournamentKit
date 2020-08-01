//
//  TestHelper.swift
//  TournamentKitTests
//
//  Created by Jan Wittler on 21.07.20.
//  Copyright © 2020 Jan Wittler. All rights reserved.
//

import XCTest
@testable import TournamentKit

func XCTAssertScores(_ match: Match, scores: [Int], _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    zip(match.results, scores).forEach { (result, score) in
        XCTAssertEqual(result.score, score, message(), file: file, line: line)
    }
}

func XCTAssertResults(_ match: Match, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    match.results.forEach {
        let reward = match.overtimeResult == .noOvertime ? match.matchType.scoringConfiguration.rewards(for: $0.rank!) : match.matchType.scoringConfiguration.overtimeConfiguration!.rewards(for: $0.rank!)
        XCTAssertEqual($0.reward, reward, message(), file: file, line: line)
    }
}

extension TournamentKit.TournamentManager {
    func validateTestScores(_ scores: [Int?], for match: Match, overtimeSuffix: String?) throws {
        try validateScores(Array(zip(match.results, scores)), for: match, overtimeSuffix: overtimeSuffix)
    }
    
    func applyTestScores(_ scores: [Int], for match: inout Match, overtimeSuffix: String?) throws {
        try applyScores(Array(zip(match.results, scores)), for: &match, overtimeSuffix: overtimeSuffix)
    }
}
