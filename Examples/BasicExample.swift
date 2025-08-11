import Foundation
import iOS-Testing-Automation-Framework

/// Basic example demonstrating the core functionality of iOS-Testing-Automation-Framework
@main
struct BasicExample {
    static func main() {
        print("🚀 iOS-Testing-Automation-Framework Basic Example")
        
        // Initialize the framework
        let framework = iOS-Testing-Automation-Framework()
        
        // Configure with default settings
        framework.configure()
        
        print("✅ Framework configured successfully")
        
        // Demonstrate basic functionality
        demonstrateBasicFeatures(framework)
    }
    
    static func demonstrateBasicFeatures(_ framework: iOS-Testing-Automation-Framework) {
        print("\n📱 Demonstrating basic features...")
        
        // Add your example code here
        print("🎯 Feature 1: Core functionality")
        print("🎯 Feature 2: Configuration")
        print("🎯 Feature 3: Error handling")
        
        print("\n✨ Basic example completed successfully!")
    }
}
