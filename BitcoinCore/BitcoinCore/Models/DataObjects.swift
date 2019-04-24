import HSCryptoKit

public struct BlockHeader {

    public let version: Int
    public let headerHash: Data
    public let previousBlockHeaderHash: Data
    public let merkleRoot: Data
    public let timestamp: Int
    public let bits: Int
    public let nonce: Int

    public init(version: Int, headerHash: Data, previousBlockHeaderHash: Data, merkleRoot: Data, timestamp: Int, bits: Int, nonce: Int) {
        self.version = version
        self.headerHash = headerHash
        self.previousBlockHeaderHash = previousBlockHeaderHash
        self.merkleRoot = merkleRoot
        self.timestamp = timestamp
        self.bits = bits
        self.nonce = nonce
    }

}

public struct FullTransaction {

    public let header: Transaction
    public let inputs: [Input]
    public let outputs: [Output]

    public init(header: Transaction, inputs: [Input], outputs: [Output]) {
        self.header = header
        self.inputs = inputs
        self.outputs = outputs

        self.header.dataHash = CryptoKit.sha256sha256(TransactionSerializer.serialize(transaction: self, withoutWitness: true))
        for input in self.inputs {
            input.transactionHash = self.header.dataHash
        }
        for output in self.outputs {
            output.transactionHash = self.header.dataHash
        }
    }

}

public struct InputToSign {

    let input: Input
    let previousOutput: Output
    let previousOutputPublicKey: PublicKey

}

public struct OutputWithPublicKey {

    let output: Output
    let publicKey: PublicKey
    let spendingInput: Input?
    let spendingBlockHeight: Int?

}

struct InputWithPreviousOutput {

    let input: Input
    let previousOutput: Output?

}

public struct TransactionWithBlock {

    let transaction: Transaction
    let blockHeight: Int?

}

public struct UnspentOutput {

    let output: Output
    let publicKey: PublicKey
    let transaction: Transaction
    let blockHeight: Int?

}

public struct FullTransactionForInfo {

    let transactionWithBlock: TransactionWithBlock
    let inputsWithPreviousOutputs: [InputWithPreviousOutput]
    let outputs: [Output]

}

public struct PublicKeyWithUsedState {

    let publicKey: PublicKey
    let used: Bool

}
