//
//  APIProvider+Transfer.swift
//  mapper
//
//  Created by Никишин Ибрахим on 3/3/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

public typealias GetFeeResponseCompletion = (Result<FeeResponse, Error>) -> Void
public typealias ValidateTransferResponseCompletion = (Result<ValidateTransferResponse, Error>) -> Void
public typealias TransferResponseCompletion = (Result<TransferResponse, Error>) -> Void

protocol TransferAPI {
    func getFee(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, completion: @escaping GetFeeResponseCompletion)
    func validateTransfer(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, completion: @escaping ValidateTransferResponseCompletion)
    func transfer(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, txId: String, completion: @escaping TransferResponseCompletion)
    func confirmTransfer(senderBank: Bank,
                         txId: String,
                         confirmationCode: String,
                         completion: @escaping EmptyResponseCompletion)
    func checkUserInBank(bankAlias: String, userId: String, completion: @escaping EmptyResponseCompletion) 
}

extension APIProviderImpl {
    func getFee(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, completion: @escaping GetFeeResponseCompletion) {
        let request = FeeRequest(bin: from.bank!.bin, senderAccountNumber: from.accountNumber, sum: amount, receiverId: targetUserId, receiverBankBin: targetBank.bin, mcc: mcc)
        requestManager.send(request: request, completion: completion)
    }
    
    func validateTransfer(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, completion: @escaping ValidateTransferResponseCompletion) {
        let request = TransferValidationRequest(bin: from.bank!.bin, senderAccountNumber: from.accountNumber, sum: amount, receiverId: targetUserId, receiverBankBin: targetBank.bin, mcc: mcc)
        requestManager.send(request: request, completion: completion)
    }
    
    func transfer(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, txId: String, completion: @escaping TransferResponseCompletion) {
        let request = TransferRequest(bin: from.bank!.bin, senderAccountNumber: from.accountNumber, sum: amount, receiverId: targetUserId, receiverBankBin: targetBank.bin, mcc: mcc, txId: txId)
        requestManager.send(request: request, completion: completion)
    }
    
    func confirmTransfer(senderBank: Bank,
                         txId: String,
                         confirmationCode: String,
                         completion: @escaping EmptyResponseCompletion) {
        let request = ConfirmTransferRequest(bin: senderBank.bin,
                                             txId: txId,
                                             confirmationCode: confirmationCode)
        requestManager.send(request: request, completion: completion)
    }

    func checkUserInBank(bankAlias: String, userId: String, completion: @escaping EmptyResponseCompletion) {
        let request = CheckUserInBankRequest(alias: bankAlias, userId: userId)
        requestManager.send(request: request, completion: completion)
    }
}
