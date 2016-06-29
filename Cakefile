project do |p|
    p.name = "FlatoutWar"
    p.class_prefix = "FW"
    p.organization = "colinta"

    p.debug_configuration.settings["ENABLE_TESTABILITY"] = "YES"
end

application_for :ios, 8.0, :swift do |target|
    target.name = "Flatout War"

    target.debug_configuration.settings["INFOPLIST_FILE"] = "Support/Info.plist"
    target.debug_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"

    target.release_configuration.settings["INFOPLIST_FILE"] = "Support/Info.plist"
    target.release_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Distribution"

    target.all_configurations.each do |config|
        config.supported_devices = :universal
        config.product_bundle_identifier = "com.colinta.FlatoutWar"
        config.settings["SWIFT_OBJC_BRIDGING_HEADER"] = "Support/BridgingHeader.h"
        config.settings["CODE_SIGN_IDENTITY"] = "iPhone Distribution: colinta, LLC (5QDS9Z456R)"
    end

    target.include_files = ["Source/**/*", "Support/*", "ObjectAL/**/*", "Resources/**/*"]

    # target.release_configuration.settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"

    target.system_frameworks << 'SpriteKit'
    target.system_frameworks << 'OpenAL'
    target.system_frameworks << 'AudioToolbox'
    target.system_frameworks << 'AVFoundation'
end
