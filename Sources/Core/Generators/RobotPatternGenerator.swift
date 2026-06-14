import Foundation

/// iOS-Testing-Automation-Framework: Robot Pattern Code Generator
public struct RobotPatternGenerator {
    public static func generate(for viewName: String) -> String {
        return "public class \(viewName)Robot {}"
    }
}
