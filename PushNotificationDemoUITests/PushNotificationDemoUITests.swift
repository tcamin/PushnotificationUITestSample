import XCTest
import SBTUITestTunnelHost

class PushNotificationDemoUITests: XCTestCase {
    func testPushNotifications() throws {
        let app = XCUIApplication()
        app.launch()
                
        app.buttons["Request notification permission"].tap()
        grantNotificationPermissionsIfNeeded()
                
        let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springBoard.activate()
        wait { springBoard.state == .runningForeground }
        
        let title = "Push title 📣"
        let body = "Body!"
        let customValue1 = "custom value 1"
        let customValue2 = "custom value 2"
        try deliverPushNotification(title: title, body: body, customKey1: customValue1, customKey2: customValue2)
        
        let notification: XCUIElement
        if #available(iOS 14.0, *) {
            notification = springBoard.otherElements.descendants(matching: .any)["NotificationShortLookView"]
        } else {
            notification = springBoard.otherElements["NotificationShortLookView"]
        }
    
        wait { notification.exists }
        
        notification.tap()
        wait { app.alerts[title].exists }
        
        XCTAssert(app.alerts[title].staticTexts["\(body)\n\(customValue1)\n\(customValue2)"].exists)
    }
}

private extension PushNotificationDemoUITests {
    func deviceIdentifier() throws -> String {
        let bundlePathComponents = Bundle.main.bundleURL.pathComponents
        guard let devicesIndex = bundlePathComponents.firstIndex(where: { $0 == "Devices" }),
              let deviceIdentifier = bundlePathComponents.dropFirst(devicesIndex + 1).first else {
            throw Error("Failed retrieving device identifier")
        }
                
        return deviceIdentifier
    }
    
    func deliverPushNotification(title: String, body: String, customKey1: String, customKey2: String) throws {
        let identifier = try deviceIdentifier()
        
        let pushNotification = PushNotification(aps: .init(alert: .init(title: title, body: body),
                                                           badge: 0),
                                                customKey1: customKey1,
                                                customKey2: customKey2)
        let encoder = JSONEncoder()
        let data = try encoder.encode(pushNotification)
        let jsonPayloadUrl = URL(fileURLWithPath: "/tmp/\(UUID().uuidString).json")
        try data.write(to: jsonPayloadUrl)
        
        host.executeCommand("xcrun simctl push \(identifier) com.subito.PushNotificationDemo \(jsonPayloadUrl.path); rm \(jsonPayloadUrl.path)")
    }
}

private extension PushNotificationDemoUITests {
    func grantNotificationPermissionsIfNeeded() {
        // We should use addUIInterruptionMonitor but for the sake of this demo
        // which is dismissing the app immediately after launch we'll recurr to
        // an underoptimized version
        let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        wait(withTimeout: 1.0, assertOnFailure: false) {
            springBoard.alerts.element.exists
        }
        
        if springBoard.alerts.element.exists {
            springBoard.alerts.buttons.element(boundBy: 1).tap()
        }
    }
}

struct PushNotification: Codable {
    struct Payload: Codable {
        struct Alert: Codable {
            let title: String
            let body: String
        }
        
        let alert: Alert
        let badge: Int
    }
    
    let aps: Payload
    
    let customKey1: String
    let customKey2: String
}

struct Error: LocalizedError {
    var errorDescription: String? { return description }
    
    private let description: String

    init(_ description: String) {
        self.description = description
    }
}


extension XCTestCase {
    func wait(withTimeout timeout: TimeInterval = 30, assertOnFailure: Bool = true, for predicateBlock: @escaping () -> Bool) {
        let predicate = NSPredicate { _, _ in predicateBlock() }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: nil)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        
        if assertOnFailure {
            XCTAssert(result == .completed)
        }
    }
}
