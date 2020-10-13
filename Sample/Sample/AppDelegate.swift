//
//  AppDelegate.swift
//  Sample
//
//  Created by Vini Soares on 13/10/20.
//  Copyright © 2020 Stone Co. All rights reserved.
//

import ContaStoneSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ContaStone.configure(
            id: "homebanking@openbank.stone.com.br",
            scopes: ["offline_access"],
            environmentType: .sandbox,
            delegate: self
        )

        return true
    }

}

extension AppDelegate: ContaStoneDelegate {
    func refreshApp() {
    }

    func sessionRevoked() {
    }

    func loggedOut() {
    }

    func showHelpCenter() {
    }

    func showChat() {
    }

    func showFrequentlyAskedQuestions() {
    }
}
