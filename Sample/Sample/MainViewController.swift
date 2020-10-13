//
//  MainViewController.swift
//  Sample
//
//  Created by Vini Soares on 13/10/20.
//  Copyright © 2020 Stone Co. All rights reserved.
//

import ContaStoneSDK
import UIKit
import TinyConstraints

class MainViewController: UIViewController {

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.blue, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginButton)

        loginButton.height(56)
        loginButton.edgesToSuperview(excluding: .top, usingSafeArea: true)

        self.view = view
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHomeIfNeeded()
    }

    @objc private func login() {
        ContaStone.login(checkKYC: true) { [weak self] in
            self?.showHomeIfNeeded()
        }
    }

    private func showHomeIfNeeded() {
        if ContaStone.isAuthenticated == false { return }

        let authenticatedContoller = AuthenticatedViewController()
        authenticatedContoller.modalPresentationStyle = .fullScreen
        present(authenticatedContoller, animated: true, completion: nil)
    }

}
