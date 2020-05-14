import XCTest
@testable import DiePackage

extension XCTestCase {
    func assertThrows<T, E: Error & Equatable>(
        _ expression: @autoclosure () throws -> T,
        throws error: E,
        in file: StaticString = #file,
        line: UInt = #line
    ) {
        var thrownError: Error?

        XCTAssertThrowsError(try expression(),
                             file: file, line: line) {
            thrownError = $0
        }

        XCTAssertTrue(
            thrownError is E,
            "Unexpected error type: \(type(of: thrownError))",
            file: file, line: line
        )

        XCTAssertEqual(
            thrownError as? E, error,
            file: file, line: line
        )
    }
}

final class DiePackageTests: XCTestCase {
    func testInsufficientNumberOfFaces() {
        assertThrows(try DiePackage.Die(faces: [Int]()), throws: DiePackage.DieCreationError.insufficientNumberOfFaces)
    }
    
    func testOddNumberOfFaces() {
        assertThrows(try DiePackage.Die(faces: Array(repeating: 1, count: 7)), throws: DiePackage.DieCreationError.oddNumberOfFaces)
    }
    
    func testTooManyNumberFaces() {
        assertThrows(try DiePackage.Die(faces: Array(repeating: 1, count: 120_000)), throws: DiePackage.DieCreationError.tooManyNumberFaces)
    }
    
    func testRoll() {
        do {
            let die = try DiePackage.Die(faces: Array(1...6))
            
            var results = [Int]()
            for _ in 1...150 {
                if results.count == 6 {
                    break
                }
                
                let roll = die.roll()
                
                if results.contains(roll) == false {
                    results.append(roll)
                }
            }
            
            XCTAssertTrue(results.sorted() == Array(1...6), "Dice could not roll all its faces.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    static var allTests = [
        ("testInsufficientNumberOfFaces", testInsufficientNumberOfFaces),
        ("testOddNumberOfFaces", testOddNumberOfFaces),
        ("testTooManyNumberFaces", testTooManyNumberFaces),
        ("testRoll", testRoll),
    ]
}
