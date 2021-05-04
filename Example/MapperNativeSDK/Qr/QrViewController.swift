//
//  QrViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/31/21.
//

import UIKit
import MapperNativeSDK

class QrViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var accountsTableView: UITableView!
    
    private var accounts: [BankAccountVM] = []
    private var selectedFromAccount: BankAccountVM?
    
    private var boundUserFinInstitutes: [BoundUserFinInstitute] = []
    
    override func viewDidLoad() {
        loadUserFinInstitutes()
    }
    
    @IBAction func onGenerateQrClicked(_ sender: Any) {
        if selectedFromAccount == nil {
            showMessage("Сначала загрузите профиль и выберите счет в списке")
            return
        }
        getMapperSDK().generateQrCode(account: selectedFromAccount!.account, bank: selectedFromAccount!.bank, amount: Money(amount: 1000.0), comment: "optional comment", mcc: nil) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case let .success(qrData):
                guard let image = UIImage.createQrImage(from: qrData.data.base64Decoded() ?? qrData.data,
                                                        qrImageSide: 600)
                else {
                    return
                }
                self?.qrImageView.image = image
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
                self?.accountsTableView.dataSource = self
                self?.accountsTableView.delegate = self
                self?.accountsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell")!
        cell.textLabel?.text = accounts[indexPath.row].bank.name + " | " + accounts[indexPath.row].account.accountNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFromAccount = accounts[indexPath.row]
    }
}

extension UIImage {
    static func createQrImage(from serializedString: String, qrImageSide: CGFloat) -> UIImage? {
        let data = serializedString.data(using: String.Encoding.utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let qrImage = qrFilter.outputImage else {
            return nil
        }
        
        let colorParameters = ["inputColor0": CIColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ),
                               "inputColor1": CIColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )]
        let coloredImage = qrImage.applyingFilter("CIFalseColor", parameters: colorParameters)
        
        guard coloredImage.extent.width > 0 else {
            return nil
        }
        
        let scaleFactor = qrImageSide / coloredImage.extent.width
        let scaledImage = coloredImage.transformed(by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        let topImage = UIImage(ciImage: scaledImage, scale: UIScreen.main.scale, orientation: .up)
        let size = CGSize(width: 3 * qrImageSide, height: 3 * qrImageSide)
        UIGraphicsBeginImageContext(size)
        let bottomImageSide: CGFloat = 25.0
        let areaSize = CGRect(x: bottomImageSide / 2,
                              y: 0,
                              width: size.width - bottomImageSide,
                              height: size.height - bottomImageSide)
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1)
        
        let resultOfCombiningWithAituLogoImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultOfCombiningWithAituLogoImage
    }
}

extension String {
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
