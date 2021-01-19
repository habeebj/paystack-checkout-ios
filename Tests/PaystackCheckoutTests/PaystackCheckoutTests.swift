import XCTest
@testable import PaystackCheckout

final class PaystackCheckoutTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PaystackCheckout().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
