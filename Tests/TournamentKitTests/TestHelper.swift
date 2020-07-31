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
    func applyScores<Match: TournamentKit.Match>(_ scores: [Int], for match: inout Match, overtimeSuffix: String?) throws {
        try applyScores(zip(match.results, scores).map { ($0.0, $0.1) }, for: &match, overtimeSuffix: overtimeSuffix)
    }
}
