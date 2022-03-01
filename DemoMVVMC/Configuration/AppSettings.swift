//
//  AppSettings.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import Foundation

struct AppSettings {
    static var shared: AppSettings = AppSettings()
    
    let sneakerApiKey: String
    
    init() {
        guard let plistURL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let data = try? Data(contentsOf: plistURL),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject],
              let settings = plistDictionary["AppSettings"] as? [String: AnyObject]
        else {
            sneakerApiKey = ""
            
            return
        }
        sneakerApiKey = settings["SneakerApiKey"] as? String ?? ""
    }
}
