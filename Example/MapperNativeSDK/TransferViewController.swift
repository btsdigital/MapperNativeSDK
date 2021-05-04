//
//  TransferViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 4/5/21.
//

import UIKit
import MapperNativeSDK

class TransferViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var numberInput: UITextField!
    @IBOutlet weak var sumInput: UITextField!
    @IBOutlet weak var confirmationCodeInput: UITextField!
    @IBOutlet weak var toBankTableView: UITableView!
    @IBOutlet weak var fromAccountTableView: UITableView!
    
    private var allBanks: [Bank] = []
    private var selectedToBank: Bank?
    
    private var accounts: [BankAccountVM] = []
    private var selectedFromAccount: BankAccountVM?
    
    override func viewDidLoad() {
        loadUserFinInstitutes()
        loadAllBanks()
        numberInput.delegate = self
        sumInput.delegate = self
        confirmationCodeInput.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func loadAllBanks() {
        getMapperSDK().getAllFinInstitutes { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case let .success(banks):
                self?.allBanks = banks
                self?.toBankTableView.dataSource = self
                self?.toBankTableView.delegate = self
                self?.toBankTableView.reloadData()
            }
        }
    }
    
    private func loadUserFinInstitutes() {
        getMapperSDK().getUserFinInstitutes { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case let .success(userFinInstitutes):
                userFinInstitutes.filter {
                    $0 is BoundUserFinInstitute
                }.map {
                    $0 as! BoundUserFinInstitute
                }.forEach { userFinIntitute in
                    userFinIntitute.accounts.forEach { account in
                        self?.accounts.append(BankAccountVM(bank: userFinIntitute.bank, account: account))
                    }
                }
                self?.fromAccountTableView.dataSource = self
                self?.fromAccountTableView.delegate = self
                self?.fromAccountTableView.reloadData()
            }
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let userId = numberInput.text
        getMapperSDK().getUserById(userId: userId!) { result in
            switch result {
            case let .failure(error):
                self.showMessage(error.localizedDescription)
            case let .success(user):
                self.showMessage(user.fullName)
            }
        }
    }
    
    @IBAction func requestFeeButtonClicked(_ sender: Any) {
        let targetUserId = numberInput.text!
        let amount = Money(amount: sumInput.text!)
        if selectedFromAccount == nil ||  selectedToBank == nil || amount == nil {
            showMessage("Не хватает информации для запроса комиссии")
            return
        }
        getMapperSDK().requestFee(from: selectedFromAccount!.account, amount: amount!, targetUserId: targetUserId, targetBank: selectedToBank!, mcc: nil) { result in
            switch result {
            case let .failure(error):
                self.showMessage(error.localizedDescription)
            case let .success(fee):
                self.showMessage("Fee = \(fee.amount.getFormattedString())")
            }
        }
    }
    
    private var txId: String?
    
    @IBAction func validateButtonClicked(_ sender: Any) {
        let targetUserId = numberInput.text!
        let amount = Money(amount: sumInput.text!)
        if selectedFromAccount == nil ||  selectedToBank == nil || amount == nil {
            showMessage("Не хватает информации для запроса комиссии")
            return
        }
        getMapperSDK().validate(from: selectedFromAccount!.account, amount: amount!, targetUserId: targetUserId, targetBank: selectedToBank!, mcc: nil) { result in
            switch result {
            case let .failure(error):
                self.showMessage(error.localizedDescription)
            case let .success(res):
                self.txId = res.txId
                self.showMessage("Fee = \(res.amount.getFormattedString())\nTxId = \(res.txId)")
            }
        }
    }
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        let targetUserId = numberInput.text!
        let amount = Money(amount: sumInput.text!)
        if selectedFromAccount == nil ||  selectedToBank == nil || amount == nil || txId == nil {
            showMessage("Не хватает информации для запроса комиссии")
            return
        }
        getMapperSDK().transfer(from: selectedFromAccount!.account, amount: amount!, targetUserId: targetUserId, targetBank: selectedToBank!, mcc: nil, txId: txId!) { result in
            switch result {
            case let .failure(error):
                self.showMessage(error.localizedDescription)
            case let .success(res):
                if res.confirmationScheme != nil {
                    self.showMessage("Данная транзакция требует подтвержения, код 1234")
                } else {
                    self.showMessage("transferId = \(res.txId)")
                }
            }
        }
    }
    
    @IBAction func confirmTransferButtonClicked(_ sender: Any) {
        let code = confirmationCodeInput.text!
        if selectedFromAccount == nil {
            showMessage("Не хватает информации для подтверждения перевода")
            return
        }
        getMapperSDK().confirmTransfer(senderBank: selectedFromAccount!.bank, code: code, txId: txId!) { result in
            switch result {
            case let .failure(error):
                self.showMessage(error.localizedDescription)
            case .success:
                self.showMessage("Перевод выполнен успешно")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == fromAccountTableView {
            return accounts.count
        } else if tableView == toBankTableView {
            return allBanks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell")!
        if tableView == fromAccountTableView {
            cell.textLabel?.text = accounts[indexPath.row].bank.name + " | " + accounts[indexPath.row].account.accountNumber
        } else if tableView == toBankTableView {
            cell.textLabel?.text = allBanks[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if tableView == fromAccountTableView {
            selectedFromAccount = accounts[index]
        } else if tableView == toBankTableView {
            selectedToBank = allBanks[index]
        }
    }
}

struct BankAccountVM {
    let bank: Bank
    let account: BankAccount
}
