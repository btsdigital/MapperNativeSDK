//
//  FinInstitutesViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/16/21.
//

import UIKit
import MapperNativeSDK

class FinInstitutesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userBanksTableView: UITableView!
    @IBOutlet weak var notBoundBanksTableView: UITableView!
    @IBOutlet weak var allBanksTableView: UITableView!
    @IBOutlet weak var smsCodeInput: UITextField!

    @IBAction func confirmClick(_ sender: Any) {
        guard createdMasterPublicKey != nil else {
            showMessage("Сначала выберите финансовую организацию")
            return
        }
        getMapperSDK().confirmFinInstitute(masterPublicKey: createdMasterPublicKey!, smsCode: smsCodeInput.text!) { [weak self] result in
            switch result {
            case let .success(userFinInstitutes):
                self?.showMessage("successful confirmation")
                self?.showUserFinInstitutes(userFinInstitutes)
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }

    private var boundUserFinInstitutes: [BoundUserFinInstitute] = []
    private var notBoundUserFinInstitutes: [NotBoundUserFinInstitute] = []
    private var allBanks: [Bank] = []

    override func viewDidLoad() {
        loadAllFinInstitutes()
        loadUserFinInstitutes()
    }

    private func loadUserFinInstitutes() {
        getMapperSDK().getUserFinInstitutes { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case let .success(userFinInstitutes):
                self?.showUserFinInstitutes(userFinInstitutes)
            }
        }
    }

    private func showUserFinInstitutes(_ userFinInstitutes: [UserFinInstitute]) {
        boundUserFinInstitutes = userFinInstitutes.filter {
            $0 is BoundUserFinInstitute
        }.map {
            $0 as! BoundUserFinInstitute
        }
        userBanksTableView.dataSource = self
        userBanksTableView.delegate = self
        userBanksTableView.reloadData()

        notBoundUserFinInstitutes = userFinInstitutes.filter {
            $0 is NotBoundUserFinInstitute
        }.map {
            $0 as! NotBoundUserFinInstitute
        }
        notBoundBanksTableView.dataSource = self
        notBoundBanksTableView.delegate = self
        notBoundBanksTableView.reloadData()
    }

    private func loadAllFinInstitutes() {
        getMapperSDK().getAllFinInstitutes { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case let .success(banks):
                self?.allBanks = banks
                self?.allBanksTableView.dataSource = self
                self?.allBanksTableView.delegate = self
                self?.allBanksTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allBanksTableView {
            return allBanks.count
        } else if tableView == notBoundBanksTableView {
            return notBoundUserFinInstitutes.count
        } else if tableView == userBanksTableView {
            return boundUserFinInstitutes.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell")!
        if tableView == allBanksTableView {
            cell.textLabel?.text = allBanks[indexPath.row].name
        } else if tableView == notBoundBanksTableView {
            cell.textLabel?.text = notBoundUserFinInstitutes[indexPath.row].bank.name
        } else if tableView == userBanksTableView {
            let userFinInstitute = boundUserFinInstitutes[indexPath.row]
            cell.textLabel?.text = "\(userFinInstitute.bank.name) [Click to remove]"
        }
        return cell
    }

    private var createdMasterPublicKey: CreatedMasterPublicKey?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if tableView == allBanksTableView {
            bindFinInstitute(allBanks[index])
        } else if tableView == notBoundBanksTableView {
            bindFinInstitute(notBoundUserFinInstitutes[index].bank)
        } else if tableView == userBanksTableView {
            removeFinInstitute(boundUserFinInstitutes[index])
        }
    }

    func bindFinInstitute(_ bank: Bank) {
        getMapperSDK().bindFinInstitute(bank: bank) { [weak self] result in
            switch result {
            case let .success(value):
                self?.createdMasterPublicKey = value
                self?.showMessage("Confirm binding with SMS code")
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }

    func removeFinInstitute(_ finInstitute: BoundUserFinInstitute) {
        getMapperSDK().removeFinInstitute(finInstitute: finInstitute) { [weak self] result in
            switch result {
            case let .success(userFinInstitutes):
                self?.loadAllFinInstitutes()
                self?.showUserFinInstitutes(userFinInstitutes)
            case let .failure(error):
                self?.showMessage(error.localizedDescription)

            }
        }
    }
}
