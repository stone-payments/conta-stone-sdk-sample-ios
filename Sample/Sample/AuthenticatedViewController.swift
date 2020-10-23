//
//  AuthenticatedViewController.swift
//  Sample
//
//  Created by Vini Soares on 13/10/20.
//  Copyright © 2020 Stone Co. All rights reserved.
//

import ContaStoneSDK
import UIKit

struct BalanceResponse: Decodable {
    let balance: Int64
}

class AuthenticatedViewController: UIViewController {

    private var approverCoordinator: ApproverCoordinator?

    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "-"
        label.textColor = .darkGray
        return label
    }()

    private lazy var balanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Atualizar saldo", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(updateBalance), for: .touchUpInside)
        button.height(56)
        return button
    }()

    private lazy var selectAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecionar Conta", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(selectAccount), for: .touchUpInside)
        button.height(56)
        return button
    }()

    private lazy var approverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Aprovador", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(showApprover), for: .touchUpInside)
        button.height(56)
        return button
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sair", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.height(56)
        return button
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(balanceLabel)
        stackView.addArrangedSubview(balanceButton)
        stackView.addArrangedSubview(selectAccountButton)
        stackView.addArrangedSubview(approverButton)
        stackView.addArrangedSubview(logoutButton)

        view.addSubview(stackView)
        stackView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInfo()
    }

    private func updateUserInfo() {
        let account = ContaStone.currentAcount
        userLabel.text = "id: \(account.id) \n name: \(account.name)"

        updateBalance()
    }

    @objc private func updateBalance() {
        let id = ContaStone.currentAcount.id
        let endpoint = Endpoint<BalanceResponse>(method: .get, path: "/api/v1/accounts/\(id)/balance")

        ContaStone.performRequest(endpoint) { [weak self] result in
            switch result {
            case .success(let response):
                self?.balanceLabel.text = "Value: \(response.balance)"

            case .failure(let error):
                self?.balanceLabel.text = error.localizedDescription
            }
        }
    }

    @objc private func selectAccount() {
        ContaStone.selectAccount(checkKYC: true) { _ in
            self.updateUserInfo()
        }
    }

    @objc private func showApprover() {
        let coordiantor = ApproverCoordinator() { _ in
            self.approverCoordinator = nil
        }
        approverCoordinator = coordiantor

        present(coordiantor.rootViewController, animated: true, completion: nil)
    }

    @objc private func logout() {
        ContaStone.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
