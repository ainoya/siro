//
//  SlackService.swift
//  siro
//
//  Created by nainoya on 2019/11/27.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Foundation
import SlackKit
import KeychainAccess

struct SlackService {
    let bot: SlackKit
    let channel: String
    let keychain: Keychain
    static let accessGroup = "9254J5769W.io.ainoya.siro"
    static let service = "io.ainoya.siro"
    let token: String

    init(token: String, channel: String) {
        self.bot = SlackKit()
        self.channel = channel
        bot.addWebAPIAccessWithToken(token)
        self.keychain = Keychain(
            service: SlackService.service,
            accessGroup: SlackService.accessGroup)
        self.token = token
        self.saveConfig(token: token)
    }
    
    static func restore() -> SlackService? {
        let keychain = Keychain(service: service, accessGroup: accessGroup)
        guard let channel = UserDefaults.standard.string(forKey: "channel") else {
            print("userdefault channel not found")
            return nil
        }
        guard let token = keychain["slack-token"] else {
            print("could not find slackToken from keychain")
            return nil
        }

        print("restored")
        return self.init(token: token, channel: channel)
    }

    func saveConfig(token: String) {
        UserDefaults.standard.set(self.channel, forKey: "channel")
        self.keychain["slack-token"] = token
    }

    func postMessage(message: String, success: (((ts: String?, channel: String?)) -> Void)?, failure: WebAPI.FailureClosure?) {
        guard let api = bot.webAPI else {
            print("could not find webAPI")
            return
        }
        api.sendMessage(
            channel: self.channel, text: message, asUser: true,
            success: success,
            failure: failure
        )
    }
}
