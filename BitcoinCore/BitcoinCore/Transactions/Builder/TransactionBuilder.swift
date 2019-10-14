import HSCryptoKit

class TransactionBuilder {
    private let outputSetter: OutputSetter
    private let inputSetter: InputSetter
    private let lockTimeSetter: LockTimeSetter
    private let signer: TransactionSigner

    init(outputSetter: OutputSetter, inputSetter: InputSetter, lockTimeSetter: LockTimeSetter, signer: TransactionSigner) {
        self.outputSetter = outputSetter
        self.inputSetter = inputSetter
        self.lockTimeSetter = lockTimeSetter
        self.signer = signer
    }

}

extension TransactionBuilder: ITransactionBuilder {

    func buildTransaction(toAddress: String, value: Int, feeRate: Int, senderPay: Bool, pluginData: [String: [String: Any]]) throws -> FullTransaction {
        let mutableTransaction = MutableTransaction()

        try outputSetter.setOutputs(to: mutableTransaction, toAddress: toAddress, value: value, pluginData: pluginData)
        try inputSetter.setInputs(to: mutableTransaction, feeRate: feeRate, senderPay: senderPay)
        try lockTimeSetter.setLockTime(to: mutableTransaction)
        try signer.sign(mutableTransaction: mutableTransaction)

        return mutableTransaction.build()
    }

    func buildTransaction(from unspentOutput: UnspentOutput, toAddress: String, feeRate: Int) throws -> FullTransaction {
        let mutableTransaction = MutableTransaction(outgoing: false)

        try outputSetter.setOutputs(to: mutableTransaction, toAddress: toAddress, value: unspentOutput.output.value, pluginData: [:])
        try inputSetter.setInputs(to: mutableTransaction, fromUnspentOutput: unspentOutput, feeRate: feeRate)
        try lockTimeSetter.setLockTime(to: mutableTransaction)
        try signer.sign(mutableTransaction: mutableTransaction)

        return mutableTransaction.build()
    }

}
