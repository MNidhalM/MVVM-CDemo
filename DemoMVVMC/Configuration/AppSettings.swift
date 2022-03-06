//
//  AppSettings.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import Foundation

private enum Constants {
    static let plistFile = "Info"
    static let plistExtension = "plist"
    static let settingsKey = "AppSettings"
    static let sneakerApiKey = "SneakerApiKey"
}

struct AppSettings {
    static var shared: AppSettings = AppSettings()
    
    let sneakerApiKey: String
    
    init() {
        guard let plistURL = Bundle.main.url(forResource: Constants.plistFile, withExtension: Constants.plistExtension),
              let data = try? Data(contentsOf: plistURL),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject],
              let settings = plistDictionary[Constants.settingsKey] as? [String: AnyObject]
        else {
            sneakerApiKey = ""
            
            return
        }
        sneakerApiKey = settings[Constants.sneakerApiKey] as? String ?? ""
    }
}
