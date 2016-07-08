project do |proj|
    proj.name = "FlatoutWar"
    proj.class_prefix = "FW"
    proj.organization = "colinta"

    proj.debug_configuration.settings["ENABLE_TESTABILITY"] = "YES"
    # proj.debug_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"
    # proj.debug_configuration.settings["CODE_SIGN_IDENTITY"] = "iPhone Distribution: colinta, LLC (5QDS9Z456R)"
    # proj.debug_configuration.settings["PROVISIONING_PROFILE"] = "136b4d2c-3bc1-45be-8768-731f31bf10ca"

    # proj.release_configuration.settings["CODE_SIGN_IDENTITY"] = "iPhone Distribution: colinta, LLC (5QDS9Z456R)"
    # proj.release_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Distribution"
    # proj.release_configuration.settings["PROVISIONING_PROFILE"] = "ccc270a4-c0be-441a-86a0-edebb98cb60a"
end

application_for :ios, 8.0, :swift do |target|
    target.name = "2Dim: Flatout War"

    target.debug_configuration.settings["INFOPLIST_FILE"] = "Support/Info.plist"
    # target.debug_configuration.settings["PROVISIONING_PROFILE"] = "136b4d2c-3bc1-45be-8768-731f31bf10ca"
    # target.debug_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"

    target.release_configuration.settings["INFOPLIST_FILE"] = "Support/Info.plist"
    # target.release_configuration.settings["PROVISIONING_PROFILE"] = "ccc270a4-c0be-441a-86a0-edebb98cb60a"
    # target.release_configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Distribution"

    target.all_configurations.each do |config|
        config.supported_devices = :universal
        config.product_bundle_identifier = "com.colinta.FlatoutWar"
        config.settings["SWIFT_OBJC_BRIDGING_HEADER"] = "Support/BridgingHeader.h"
        # config.settings["CODE_SIGN_IDENTITY"] = "iPhone Distribution: colinta, LLC (5QDS9Z456R)"
    end

    target.include_files = ["Source/**/*", "Support/*", "ObjectAL/**/*", "Resources/**/*"]
    target.exclude_files = ["Source/**/PREV_UpgradeWorld.swift"]

    # target.release_configuration.settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"

    target.system_frameworks << 'SpriteKit'
    target.system_frameworks << 'OpenAL'
    target.system_frameworks << 'AudioToolbox'
    target.system_frameworks << 'AVFoundation'
end
