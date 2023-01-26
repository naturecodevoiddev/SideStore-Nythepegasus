//
//  AnisetteManager.swift
//  SideStore
//
//  Created by Joseph Mattiello on 11/16/22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import Foundation

struct PublicAnisetteServer {
    let label: String
    let urlString: String
}

public struct AnisetteManager {
    
    static var publicServers: [PublicAnisetteServer] {
        // TODO: Pull these servers from somewhere, also let users edit list
        return [
            PublicAnisetteServer(label: "Jawshoedan", urlString: "https://anisette.jawshoeadan.me"),
            PublicAnisetteServer(label: "Buh", urlString: "http://191.101.206.188:6969"),
            PublicAnisetteServer(label: "Macley (US)", urlString: "http://us1.sternserv.tech"),
            PublicAnisetteServer(label: "Macley (DE)", urlString: "http://de1.sternserv.tech"),
            PublicAnisetteServer(label: "DrPudding", urlString: "https://sign.rheaa.xyz"),
            PublicAnisetteServer(label: "jkcoxson (AltServer)", urlString: "http://jkcoxson.com:2095"),
            PublicAnisetteServer(label: "jkcoxson (Provision)", urlString: "http://jkcoxson.com:2052"),
            PublicAnisetteServer(label: "Sideloadly", urlString: "https://sideloadly.io/anisette/irGb3Quww8zrhgqnzmrx"),
            PublicAnisetteServer(label: "Nythepegasus", urlString: "http://45.33.29.114"),
            PublicAnisetteServer(label: "crystall1nedev", urlString: "https://anisette.crystall1ne.software/")
        ]
    }
    
    /// User defined URL from Settings/UserDefaults
    static var userURL: String? {
        var urlString: String?
        
        if UserDefaults.standard.textServer == false {
            urlString = UserDefaults.standard.textInputAnisetteURL
        }
        else {
            urlString = UserDefaults.standard.customAnisetteURL
        }
            
        
        // guard let urlString = UserDefaults.standard.customAnisetteURL, !urlString.isEmpty else { return nil }
        
        // Test it's a valid URL
        
        if let urlString = urlString {
            guard URL(string: urlString) != nil else {
            ELOG("UserDefaults has invalid `customAnisetteURL`")
            assertionFailure("UserDefaults has invalid `customAnisetteURL`")
            return nil
            }
        }
        return urlString
    }
    static var defaultURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "ALTAnisetteURL") as? String else {
            assertionFailure("Info.plist has invalid `ALTAnisetteURL`")
            abort()
        }
        return url
    }
    static var currentURLString: String { userURL ?? defaultURL }
    // Force unwrap is safe here since we check validity before hand -- @JoeMatt
    
    /// User url or default from plist if none specified
    static var currentURL: URL { URL(string: currentURLString)! }
}
