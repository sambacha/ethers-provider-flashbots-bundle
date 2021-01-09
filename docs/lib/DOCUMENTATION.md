@flashbots/ethers-provider-bundle / [Exports](modules.md)

# ethers-provider-flashbots-bundle

![nodejs](https://github.com/sambacha/ethers-provider-flashbots-bundle/workflows/nodejs/badge.svg)
![lint](https://github.com/sambacha/ethers-provider-flashbots-bundle/workflows/lint/badge.svg)
![typedoc](https://github.com/sambacha/ethers-provider-flashbots-bundle/workflows/typedoc/badge.svg)

Contains the `FlashbotsBundleProvider` ethers.js provider to provide high-level access to eth_sendBundle rpc endpoint.

Flashbots-enabled relays and miners will expose a single jsonrpc endpoint: `eth_sendBundle`. Since this is a brand-new, non-standard endpoint, ethers.js and other libraries do not natively support these requests (like `getTransactionCount`). In order to interact with `eth_sendBundle`, you will also need access to another full-featured endpoint for nonce-calculation, gas estimation, and transaction status.

This library is not a fully functional ethers.js implementation, just a simple provider class, designed to interact with your existing ethers.js v5 module.

You can pass in a generic ethers.js provider to the flashbots provider in the constructor:

```
const NETWORK_INFO = {chainId: 1, ensAddress: '', name: 'mainnet'}

// Standard json rpc provider directly from ethers.js
const provider = new providers.JsonRpcProvider({url: ETHEREUM_RPC_URL}, NETWORK_INFO)

// flashbots provider requires passing in a standard provider
const flashbotsProvider = await FlashbotsBundleProvider.create(provider, flashbotsApiKey, flashbotsSecret)
```

The flashbotsProvider provides the sendBundle function:

```
flashbotsProvider.sendBundle(bundledTransactions: Array<FlashbotsBundleTransaction | FlashbotsBundleRawTransaction>, targetBlockNumber: number)
    => Promise<FlashbotsTransactionResponse>
```

## Example

```
// Using the map below ships two different bundles, targeting the next two blocks
const blockNumber = await provider.getBlockNumber()
const minTimestamp = (await provider.getBlock(blockNumber)).timestamp
const maxTimestamp = minTimestamp + 120
const bundlePromises = _.map([blockNumber + 1, blockNumber + 2], targetBlockNumber =>
  this.flashbotsProvider.sendBundle(
    [
      {
        signedTransaction: SIGNED_ORACLE_UPDATE_FROM_PENDING_POOL // serialized signed transaction hex
      },
      {
        signer: wallet, // ethers signer
        transaction: transaction // ethers populated transaction object
      }
    ],
    targetBlockNumber, // block number at which this bundle is valid
    {
      minTimestamp, // optional minimum timestamp at which this bundle is valid (inclusive)
      maxTimestamp // optional maximum timestamp at which this bundle is valid (inclusive)
    }
  )
)
```

## bundledTransactions

A Flashbots bundle consists of one or more transactions in strict order to be relayed to the miner directly. While the miner requires signed transaction, `sendBundle()` can receive a mix of pre-signed transaction and `TransactionRequest` + `Signer` (wallet) objects

These bundles can pay the miner either via gas fees _OR_ via `block.coinbase.transfer(minerReward)`

## targetBlockNumber

The only block number for which the bundle is to be considered valid. If you would like more than one block to be targeted, submit multiple rpc calls targeting each specific block. This value should be higher than the value of getBlockNumber(). Submitting a bundle with a target block number of the current block, or earlier, is a no-op.

## FlashbotsTransactionResponse

A high-level object which contains metadata available at transaction submission time, as well as the following functions which can wait, track, and simulate the bundle's behavior

- receipts() - Returns promise of an array of transaction receipts corresponding to the transaction hashes that were relayed as part of the bundle. Will not wait for block to be mined; could return incomplete information
- wait() - Returns a promise which will wait for target block number to be reched _OR_ one of the transactions to become invalid due to nonce-issues (including, but not limited to, one of the transactions from you bundle being included too early). Returns the wait resolution as a status enum
- simulate() - Returns a promise of the transaction simulation, once the proper block height has been reached. Use this function to troubleshoot failing bundles and verify miner profitability

## How to run demo.ts

Included is a simple demo of how to construct the FlashbotsProvider with api key authentication and submit a [non-functional] bundle. This will not yield any mev, but could serve as a sample initialization to help integrate into your own functional searcher.
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / [index](../modules/index.md) / FlashbotsBundleProvider

# Class: FlashbotsBundleProvider

[index](../modules/index.md).FlashbotsBundleProvider

## Hierarchy

- _JsonRpcProvider_

  ↳ **FlashbotsBundleProvider**

## Table of contents

### Constructors

- [constructor](index.flashbotsbundleprovider.md#constructor)

### Properties

- [\_bootstrapPoll](index.flashbotsbundleprovider.md#_bootstrappoll)
- [\_emitted](index.flashbotsbundleprovider.md#_emitted)
- [\_events](index.flashbotsbundleprovider.md#_events)
- [\_fastBlockNumber](index.flashbotsbundleprovider.md#_fastblocknumber)
- [\_fastBlockNumberPromise](index.flashbotsbundleprovider.md#_fastblocknumberpromise)
- [\_fastQueryDate](index.flashbotsbundleprovider.md#_fastquerydate)
- [\_internalBlockNumber](index.flashbotsbundleprovider.md#_internalblocknumber)
- [\_isProvider](index.flashbotsbundleprovider.md#_isprovider)
- [\_lastBlockNumber](index.flashbotsbundleprovider.md#_lastblocknumber)
- [\_maxInternalBlockNumber](index.flashbotsbundleprovider.md#_maxinternalblocknumber)
- [\_network](index.flashbotsbundleprovider.md#_network)
- [\_networkPromise](index.flashbotsbundleprovider.md#_networkpromise)
- [\_nextId](index.flashbotsbundleprovider.md#_nextid)
- [\_pendingFilter](index.flashbotsbundleprovider.md#_pendingfilter)
- [\_poller](index.flashbotsbundleprovider.md#_poller)
- [\_pollingInterval](index.flashbotsbundleprovider.md#_pollinginterval)
- [anyNetwork](index.flashbotsbundleprovider.md#anynetwork)
- [connection](index.flashbotsbundleprovider.md#connection)
- [formatter](index.flashbotsbundleprovider.md#formatter)
- [genericProvider](index.flashbotsbundleprovider.md#genericprovider)

### Accessors

- [blockNumber](index.flashbotsbundleprovider.md#blocknumber)
- [network](index.flashbotsbundleprovider.md#network)
- [polling](index.flashbotsbundleprovider.md#polling)
- [pollingInterval](index.flashbotsbundleprovider.md#pollinginterval)
- [ready](index.flashbotsbundleprovider.md#ready)

### Methods

- [\_addEventListener](index.flashbotsbundleprovider.md#_addeventlistener)
- [\_getAddress](index.flashbotsbundleprovider.md#_getaddress)
- [\_getBlock](index.flashbotsbundleprovider.md#_getblock)
- [\_getBlockTag](index.flashbotsbundleprovider.md#_getblocktag)
- [\_getFastBlockNumber](index.flashbotsbundleprovider.md#_getfastblocknumber)
- [\_getFilter](index.flashbotsbundleprovider.md#_getfilter)
- [\_getInternalBlockNumber](index.flashbotsbundleprovider.md#_getinternalblocknumber)
- [\_getResolver](index.flashbotsbundleprovider.md#_getresolver)
- [\_getTransactionRequest](index.flashbotsbundleprovider.md#_gettransactionrequest)
- [\_ready](index.flashbotsbundleprovider.md#_ready)
- [\_setFastBlockNumber](index.flashbotsbundleprovider.md#_setfastblocknumber)
- [\_startEvent](index.flashbotsbundleprovider.md#_startevent)
- [\_startPending](index.flashbotsbundleprovider.md#_startpending)
- [\_stopEvent](index.flashbotsbundleprovider.md#_stopevent)
- [\_wrapTransaction](index.flashbotsbundleprovider.md#_wraptransaction)
- [addListener](index.flashbotsbundleprovider.md#addlistener)
- [call](index.flashbotsbundleprovider.md#call)
- [detectNetwork](index.flashbotsbundleprovider.md#detectnetwork)
- [emit](index.flashbotsbundleprovider.md#emit)
- [estimateGas](index.flashbotsbundleprovider.md#estimategas)
- [fetchReceipts](index.flashbotsbundleprovider.md#fetchreceipts)
- [getBalance](index.flashbotsbundleprovider.md#getbalance)
- [getBlock](index.flashbotsbundleprovider.md#getblock)
- [getBlockNumber](index.flashbotsbundleprovider.md#getblocknumber)
- [getBlockWithTransactions](index.flashbotsbundleprovider.md#getblockwithtransactions)
- [getCode](index.flashbotsbundleprovider.md#getcode)
- [getEtherPrice](index.flashbotsbundleprovider.md#getetherprice)
- [getGasPrice](index.flashbotsbundleprovider.md#getgasprice)
- [getLogs](index.flashbotsbundleprovider.md#getlogs)
- [getNetwork](index.flashbotsbundleprovider.md#getnetwork)
- [getResolver](index.flashbotsbundleprovider.md#getresolver)
- [getSigner](index.flashbotsbundleprovider.md#getsigner)
- [getStorageAt](index.flashbotsbundleprovider.md#getstorageat)
- [getTransaction](index.flashbotsbundleprovider.md#gettransaction)
- [getTransactionCount](index.flashbotsbundleprovider.md#gettransactioncount)
- [getTransactionReceipt](index.flashbotsbundleprovider.md#gettransactionreceipt)
- [getUncheckedSigner](index.flashbotsbundleprovider.md#getuncheckedsigner)
- [listAccounts](index.flashbotsbundleprovider.md#listaccounts)
- [listenerCount](index.flashbotsbundleprovider.md#listenercount)
- [listeners](index.flashbotsbundleprovider.md#listeners)
- [lookupAddress](index.flashbotsbundleprovider.md#lookupaddress)
- [off](index.flashbotsbundleprovider.md#off)
- [on](index.flashbotsbundleprovider.md#on)
- [once](index.flashbotsbundleprovider.md#once)
- [perform](index.flashbotsbundleprovider.md#perform)
- [poll](index.flashbotsbundleprovider.md#poll)
- [prepareRequest](index.flashbotsbundleprovider.md#preparerequest)
- [removeAllListeners](index.flashbotsbundleprovider.md#removealllisteners)
- [removeListener](index.flashbotsbundleprovider.md#removelistener)
- [resetEventsBlock](index.flashbotsbundleprovider.md#reseteventsblock)
- [resolveName](index.flashbotsbundleprovider.md#resolvename)
- [send](index.flashbotsbundleprovider.md#send)
- [sendBundle](index.flashbotsbundleprovider.md#sendbundle)
- [sendRawBundle](index.flashbotsbundleprovider.md#sendrawbundle)
- [sendTransaction](index.flashbotsbundleprovider.md#sendtransaction)
- [simulate](index.flashbotsbundleprovider.md#simulate)
- [wait](index.flashbotsbundleprovider.md#wait)
- [waitForTransaction](index.flashbotsbundleprovider.md#waitfortransaction)
- [create](index.flashbotsbundleprovider.md#create)
- [defaultUrl](index.flashbotsbundleprovider.md#defaulturl)
- [getFormatter](index.flashbotsbundleprovider.md#getformatter)
- [getNetwork](index.flashbotsbundleprovider.md#getnetwork)
- [hexlifyTransaction](index.flashbotsbundleprovider.md#hexlifytransaction)
- [isProvider](index.flashbotsbundleprovider.md#isprovider)

## Constructors

### constructor

\+ **new FlashbotsBundleProvider**(`genericProvider`: _BaseProvider_, `connectionInfoOrUrl`: ConnectionInfo, `network`: Networkish): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name                  | Type           |
| --------------------- | -------------- |
| `genericProvider`     | _BaseProvider_ |
| `connectionInfoOrUrl` | ConnectionInfo |
| `network`             | Networkish     |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: [src/index.ts:54](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L54)

## Properties

### \_bootstrapPoll

• **\_bootstrapPoll**: _Timer_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:52

---

### \_emitted

• **\_emitted**: { [eventName: string]: _number_ \| _pending_; }

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:47

---

### \_events

• **\_events**: _Event_[]

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:45

---

### \_fastBlockNumber

• **\_fastBlockNumber**: _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:54

---

### \_fastBlockNumberPromise

• **\_fastBlockNumberPromise**: _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:55

---

### \_fastQueryDate

• **\_fastQueryDate**: _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:56

---

### \_internalBlockNumber

• **\_internalBlockNumber**: _Promise_<{ `blockNumber`: _number_ ; `reqTime`: _number_ ; `respTime`: _number_ }\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:58

---

### \_isProvider

• `Readonly` **\_isProvider**: _boolean_

Defined in: node_modules/@ethersproject/abstract-provider/lib/index.d.ts:135

---

### \_lastBlockNumber

• **\_lastBlockNumber**: _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:53

---

### \_maxInternalBlockNumber

• **\_maxInternalBlockNumber**: _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:57

---

### \_network

• **\_network**: Network

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:44

---

### \_networkPromise

• **\_networkPromise**: _Promise_<Network\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:43

---

### \_nextId

• **\_nextId**: _number_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:29

---

### \_pendingFilter

• **\_pendingFilter**: _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:28

---

### \_poller

• **\_poller**: _Timer_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:51

---

### \_pollingInterval

• **\_pollingInterval**: _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:50

---

### anyNetwork

• `Readonly` **anyNetwork**: _boolean_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:63

---

### connection

• `Readonly` **connection**: ConnectionInfo

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:27

---

### formatter

• **formatter**: _Formatter_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:46

---

### genericProvider

• `Private` **genericProvider**: _BaseProvider_

Defined in: [src/index.ts:54](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L54)

## Accessors

### blockNumber

• **blockNumber**(): _number_

**Returns:** _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:84

---

### network

• **network**(): Network

**Returns:** Network

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:81

---

### polling

• **polling**(): _boolean_

**Returns:** _boolean_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:85

• **polling**(`value`: _boolean_): _any_

#### Parameters:

| Name    | Type      |
| ------- | --------- |
| `value` | _boolean_ |

**Returns:** _any_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:86

---

### pollingInterval

• **pollingInterval**(): _number_

**Returns:** _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:87

• **pollingInterval**(`value`: _number_): _any_

#### Parameters:

| Name    | Type     |
| ------- | -------- |
| `value` | _number_ |

**Returns:** _any_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:88

---

### ready

• **ready**(): _Promise_<Network\>

**Returns:** _Promise_<Network\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:75

## Methods

### \_addEventListener

▸ **\_addEventListener**(`eventName`: EventType, `listener`: Listener, `once`: _boolean_): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener`  | Listener  |
| `once`      | _boolean_ |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:120

---

### \_getAddress

▸ **\_getAddress**(`addressOrName`: _string_ \| _Promise_<_string_\>): _Promise_<_string_\>

#### Parameters:

| Name            | Type                             |
| --------------- | -------------------------------- |
| `addressOrName` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:104

---

### \_getBlock

▸ **\_getBlock**(`blockHashOrBlockTag`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>, `includeTransactions?`: _boolean_): _Promise_<Block \| BlockWithTransactions\>

#### Parameters:

| Name                   | Type                                                     |
| ---------------------- | -------------------------------------------------------- |
| `blockHashOrBlockTag`  | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |
| `includeTransactions?` | _boolean_                                                |

**Returns:** _Promise_<Block \| BlockWithTransactions\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:105

---

### \_getBlockTag

▸ **\_getBlockTag**(`blockTag`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_string_ \| _number_\>

#### Parameters:

| Name       | Type                                                     |
| ---------- | -------------------------------------------------------- |
| `blockTag` | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<_string_ \| _number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:112

---

### \_getFastBlockNumber

▸ **\_getFastBlockNumber**(): _Promise_<_number_\>

**Returns:** _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:89

---

### \_getFilter

▸ **\_getFilter**(`filter`: Filter \| FilterByBlockHash \| _Promise_<Filter \| FilterByBlockHash\>): _Promise_<Filter \| FilterByBlockHash\>

#### Parameters:

| Name     | Type                                                                   |
| -------- | ---------------------------------------------------------------------- |
| `filter` | Filter \| FilterByBlockHash \| _Promise_<Filter \| FilterByBlockHash\> |

**Returns:** _Promise_<Filter \| FilterByBlockHash\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:101

---

### \_getInternalBlockNumber

▸ **\_getInternalBlockNumber**(`maxAge`: _number_): _Promise_<_number_\>

#### Parameters:

| Name     | Type     |
| -------- | -------- |
| `maxAge` | _number_ |

**Returns:** _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:78

---

### \_getResolver

▸ **\_getResolver**(`name`: _string_): _Promise_<_string_\>

#### Parameters:

| Name   | Type     |
| ------ | -------- |
| `name` | _string_ |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:114

---

### \_getTransactionRequest

▸ **\_getTransactionRequest**(`transaction`: _Deferrable_<TransactionRequest\>): _Promise_<Transaction\>

#### Parameters:

| Name          | Type                              |
| ------------- | --------------------------------- |
| `transaction` | _Deferrable_<TransactionRequest\> |

**Returns:** _Promise_<Transaction\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:100

---

### \_ready

▸ **\_ready**(): _Promise_<Network\>

**Returns:** _Promise_<Network\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:74

---

### \_setFastBlockNumber

▸ **\_setFastBlockNumber**(`blockNumber`: _number_): _void_

#### Parameters:

| Name          | Type     |
| ------------- | -------- |
| `blockNumber` | _number_ |

**Returns:** _void_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:90

---

### \_startEvent

▸ **\_startEvent**(`event`: _Event_): _void_

#### Parameters:

| Name    | Type    |
| ------- | ------- |
| `event` | _Event_ |

**Returns:** _void_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:39

---

### \_startPending

▸ **\_startPending**(): _void_

**Returns:** _void_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:40

---

### \_stopEvent

▸ **\_stopEvent**(`event`: _Event_): _void_

#### Parameters:

| Name    | Type    |
| ------- | ------- |
| `event` | _Event_ |

**Returns:** _void_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:41

---

### \_wrapTransaction

▸ **\_wrapTransaction**(`tx`: Transaction, `hash?`: _string_): TransactionResponse

#### Parameters:

| Name    | Type        |
| ------- | ----------- |
| `tx`    | Transaction |
| `hash?` | _string_    |

**Returns:** TransactionResponse

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:98

---

### addListener

▸ **addListener**(`eventName`: EventType, `listener`: Listener): _Provider_

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener`  | Listener  |

**Returns:** _Provider_

Defined in: node_modules/@ethersproject/abstract-provider/lib/index.d.ts:132

---

### call

▸ **call**(`transaction`: _Deferrable_<TransactionRequest\>, `blockTag?`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_string_\>

#### Parameters:

| Name          | Type                                                     |
| ------------- | -------------------------------------------------------- |
| `transaction` | _Deferrable_<TransactionRequest\>                        |
| `blockTag?`   | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:102

---

### detectNetwork

▸ **detectNetwork**(): _Promise_<Network\>

**Returns:** _Promise_<Network\>

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:32

---

### emit

▸ **emit**(`eventName`: EventType, ...`args`: _any_[]): _boolean_

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `...args`   | _any_[]   |

**Returns:** _boolean_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:123

---

### estimateGas

▸ **estimateGas**(`transaction`: _Deferrable_<TransactionRequest\>): _Promise_<_BigNumber_\>

#### Parameters:

| Name          | Type                              |
| ------------- | --------------------------------- |
| `transaction` | _Deferrable_<TransactionRequest\> |

**Returns:** _Promise_<_BigNumber_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:103

---

### fetchReceipts

▸ `Private`**fetchReceipts**(`bundledTransactions`: TransactionAccountNonce[]): _Promise_<TransactionReceipt[]\>

#### Parameters:

| Name                  | Type                      |
| --------------------- | ------------------------- |
| `bundledTransactions` | TransactionAccountNonce[] |

**Returns:** _Promise_<TransactionReceipt[]\>

Defined in: [src/index.ts:285](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L285)

---

### getBalance

▸ **getBalance**(`addressOrName`: _string_ \| _Promise_<_string_\>, `blockTag?`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_BigNumber_\>

#### Parameters:

| Name            | Type                                                     |
| --------------- | -------------------------------------------------------- |
| `addressOrName` | _string_ \| _Promise_<_string_\>                         |
| `blockTag?`     | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<_BigNumber_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:94

---

### getBlock

▸ **getBlock**(`blockHashOrBlockTag`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<Block\>

#### Parameters:

| Name                  | Type                                                     |
| --------------------- | -------------------------------------------------------- |
| `blockHashOrBlockTag` | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<Block\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:106

---

### getBlockNumber

▸ **getBlockNumber**(): _Promise_<_number_\>

**Returns:** _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:92

---

### getBlockWithTransactions

▸ **getBlockWithTransactions**(`blockHashOrBlockTag`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<BlockWithTransactions\>

#### Parameters:

| Name                  | Type                                                     |
| --------------------- | -------------------------------------------------------- |
| `blockHashOrBlockTag` | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<BlockWithTransactions\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:107

---

### getCode

▸ **getCode**(`addressOrName`: _string_ \| _Promise_<_string_\>, `blockTag?`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_string_\>

#### Parameters:

| Name            | Type                                                     |
| --------------- | -------------------------------------------------------- |
| `addressOrName` | _string_ \| _Promise_<_string_\>                         |
| `blockTag?`     | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:96

---

### getEtherPrice

▸ **getEtherPrice**(): _Promise_<_number_\>

**Returns:** _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:111

---

### getGasPrice

▸ **getGasPrice**(): _Promise_<_BigNumber_\>

**Returns:** _Promise_<_BigNumber_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:93

---

### getLogs

▸ **getLogs**(`filter`: Filter \| FilterByBlockHash \| _Promise_<Filter \| FilterByBlockHash\>): _Promise_<Log[]\>

#### Parameters:

| Name     | Type                                                                   |
| -------- | ---------------------------------------------------------------------- |
| `filter` | Filter \| FilterByBlockHash \| _Promise_<Filter \| FilterByBlockHash\> |

**Returns:** _Promise_<Log[]\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:110

---

### getNetwork

▸ **getNetwork**(): _Promise_<Network\>

**Returns:** _Promise_<Network\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:83

---

### getResolver

▸ **getResolver**(`name`: _string_): _Promise_<_Resolver_\>

#### Parameters:

| Name   | Type     |
| ------ | -------- |
| `name` | _string_ |

**Returns:** _Promise_<_Resolver_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:113

---

### getSigner

▸ **getSigner**(`addressOrIndex?`: _string_ \| _number_): _JsonRpcSigner_

#### Parameters:

| Name              | Type                 |
| ----------------- | -------------------- |
| `addressOrIndex?` | _string_ \| _number_ |

**Returns:** _JsonRpcSigner_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:33

---

### getStorageAt

▸ **getStorageAt**(`addressOrName`: _string_ \| _Promise_<_string_\>, `position`: _string_ \| _number_ \| _BigNumber_ \| Bytes \| _Promise_<BigNumberish\>, `blockTag?`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_string_\>

#### Parameters:

| Name            | Type                                                                     |
| --------------- | ------------------------------------------------------------------------ |
| `addressOrName` | _string_ \| _Promise_<_string_\>                                         |
| `position`      | _string_ \| _number_ \| _BigNumber_ \| Bytes \| _Promise_<BigNumberish\> |
| `blockTag?`     | _string_ \| _number_ \| _Promise_<_string_ \| _number_\>                 |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:97

---

### getTransaction

▸ **getTransaction**(`transactionHash`: _string_ \| _Promise_<_string_\>): _Promise_<TransactionResponse\>

#### Parameters:

| Name              | Type                             |
| ----------------- | -------------------------------- |
| `transactionHash` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<TransactionResponse\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:108

---

### getTransactionCount

▸ **getTransactionCount**(`addressOrName`: _string_ \| _Promise_<_string_\>, `blockTag?`: _string_ \| _number_ \| _Promise_<_string_ \| _number_\>): _Promise_<_number_\>

#### Parameters:

| Name            | Type                                                     |
| --------------- | -------------------------------------------------------- |
| `addressOrName` | _string_ \| _Promise_<_string_\>                         |
| `blockTag?`     | _string_ \| _number_ \| _Promise_<_string_ \| _number_\> |

**Returns:** _Promise_<_number_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:95

---

### getTransactionReceipt

▸ **getTransactionReceipt**(`transactionHash`: _string_ \| _Promise_<_string_\>): _Promise_<TransactionReceipt\>

#### Parameters:

| Name              | Type                             |
| ----------------- | -------------------------------- |
| `transactionHash` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<TransactionReceipt\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:109

---

### getUncheckedSigner

▸ **getUncheckedSigner**(`addressOrIndex?`: _string_ \| _number_): _UncheckedJsonRpcSigner_

#### Parameters:

| Name              | Type                 |
| ----------------- | -------------------- |
| `addressOrIndex?` | _string_ \| _number_ |

**Returns:** _UncheckedJsonRpcSigner_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:34

---

### listAccounts

▸ **listAccounts**(): _Promise_<_string_[]\>

**Returns:** _Promise_<_string_[]\>

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:35

---

### listenerCount

▸ **listenerCount**(`eventName?`: _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_): _number_

#### Parameters:

| Name         | Type                                                                 |
| ------------ | -------------------------------------------------------------------- |
| `eventName?` | _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_ |

**Returns:** _number_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:124

---

### listeners

▸ **listeners**(`eventName?`: _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_): Listener[]

#### Parameters:

| Name         | Type                                                                 |
| ------------ | -------------------------------------------------------------------- |
| `eventName?` | _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_ |

**Returns:** Listener[]

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:125

---

### lookupAddress

▸ **lookupAddress**(`address`: _string_ \| _Promise_<_string_\>): _Promise_<_string_\>

#### Parameters:

| Name      | Type                             |
| --------- | -------------------------------- |
| `address` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:116

---

### off

▸ **off**(`eventName`: EventType, `listener?`: Listener): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener?` | Listener  |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:126

---

### on

▸ **on**(`eventName`: EventType, `listener`: Listener): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener`  | Listener  |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:121

---

### once

▸ **once**(`eventName`: EventType, `listener`: Listener): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener`  | Listener  |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:122

---

### perform

▸ **perform**(`method`: _string_, `params`: _any_): _Promise_<_any_\>

#### Parameters:

| Name     | Type     |
| -------- | -------- |
| `method` | _string_ |
| `params` | _any_    |

**Returns:** _Promise_<_any_\>

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:38

---

### poll

▸ **poll**(): _Promise_<_void_\>

**Returns:** _Promise_<_void_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:79

---

### prepareRequest

▸ **prepareRequest**(`method`: _string_, `params`: _any_): [_string_, _any_[]]

#### Parameters:

| Name     | Type     |
| -------- | -------- |
| `method` | _string_ |
| `params` | _any_    |

**Returns:** [_string_, _any_[]]

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:37

---

### removeAllListeners

▸ **removeAllListeners**(`eventName?`: _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_): [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

#### Parameters:

| Name         | Type                                                                 |
| ------------ | -------------------------------------------------------------------- |
| `eventName?` | _string_ \| EventFilter \| (_string_ \| _string_[])[] \| _ForkEvent_ |

**Returns:** [_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:127

---

### removeListener

▸ **removeListener**(`eventName`: EventType, `listener`: Listener): _Provider_

#### Parameters:

| Name        | Type      |
| ----------- | --------- |
| `eventName` | EventType |
| `listener`  | Listener  |

**Returns:** _Provider_

Defined in: node_modules/@ethersproject/abstract-provider/lib/index.d.ts:133

---

### resetEventsBlock

▸ **resetEventsBlock**(`blockNumber`: _number_): _void_

#### Parameters:

| Name          | Type     |
| ------------- | -------- |
| `blockNumber` | _number_ |

**Returns:** _void_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:80

---

### resolveName

▸ **resolveName**(`name`: _string_ \| _Promise_<_string_\>): _Promise_<_string_\>

#### Parameters:

| Name   | Type                             |
| ------ | -------------------------------- |
| `name` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<_string_\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:115

---

### send

▸ **send**(`method`: _string_, `params`: _any_[]): _Promise_<_any_\>

#### Parameters:

| Name     | Type     |
| -------- | -------- |
| `method` | _string_ |
| `params` | _any_[]  |

**Returns:** _Promise_<_any_\>

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:36

---

### sendBundle

▸ **sendBundle**(`bundledTransactions`: ([_FlashbotsBundleRawTransaction_](../interfaces/index.flashbotsbundlerawtransaction.md) \| [_FlashbotsBundleTransaction_](../interfaces/index.flashbotsbundletransaction.md))[], `targetBlockNumber`: _number_, `opts?`: [_FlashbotsOptions_](../interfaces/index.flashbotsoptions.md)): _Promise_<FlashbotsTransactionResponse\>

#### Parameters:

| Name                  | Type                                                                                                                                                                             |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bundledTransactions` | ([_FlashbotsBundleRawTransaction_](../interfaces/index.flashbotsbundlerawtransaction.md) \| [_FlashbotsBundleTransaction_](../interfaces/index.flashbotsbundletransaction.md))[] |
| `targetBlockNumber`   | _number_                                                                                                                                                                         |
| `opts?`               | [_FlashbotsOptions_](../interfaces/index.flashbotsoptions.md)                                                                                                                    |

**Returns:** _Promise_<FlashbotsTransactionResponse\>

Defined in: [src/index.ts:140](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L140)

---

### sendRawBundle

▸ **sendRawBundle**(`signedBundledTransactions`: _string_[], `targetBlockNumber`: _number_, `opts?`: [_FlashbotsOptions_](../interfaces/index.flashbotsoptions.md)): _Promise_<FlashbotsTransactionResponse\>

#### Parameters:

| Name                        | Type                                                          |
| --------------------------- | ------------------------------------------------------------- |
| `signedBundledTransactions` | _string_[]                                                    |
| `targetBlockNumber`         | _number_                                                      |
| `opts?`                     | [_FlashbotsOptions_](../interfaces/index.flashbotsoptions.md) |

**Returns:** _Promise_<FlashbotsTransactionResponse\>

Defined in: [src/index.ts:107](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L107)

---

### sendTransaction

▸ **sendTransaction**(`signedTransaction`: _string_ \| _Promise_<_string_\>): _Promise_<TransactionResponse\>

#### Parameters:

| Name                | Type                             |
| ------------------- | -------------------------------- |
| `signedTransaction` | _string_ \| _Promise_<_string_\> |

**Returns:** _Promise_<TransactionResponse\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:99

---

### simulate

▸ **simulate**(`bundledTransactions`: ([_FlashbotsBundleRawTransaction_](../interfaces/index.flashbotsbundlerawtransaction.md) \| [_FlashbotsBundleTransaction_](../interfaces/index.flashbotsbundletransaction.md))[], `targetBlockNumber`: _number_): _Promise_<SimulationResponse[]\>

#### Parameters:

| Name                  | Type                                                                                                                                                                             |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bundledTransactions` | ([_FlashbotsBundleRawTransaction_](../interfaces/index.flashbotsbundlerawtransaction.md) \| [_FlashbotsBundleTransaction_](../interfaces/index.flashbotsbundletransaction.md))[] |
| `targetBlockNumber`   | _number_                                                                                                                                                                         |

**Returns:** _Promise_<SimulationResponse[]\>

Defined in: [src/index.ts:269](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L269)

---

### wait

▸ `Private`**wait**(`transactionAccountNonces`: TransactionAccountNonce[], `targetBlockNumber`: _number_, `timeout`: _number_): _Promise_<[_FlashbotsBundleResolution_](../enums/index.flashbotsbundleresolution.md)\>

#### Parameters:

| Name                       | Type                      |
| -------------------------- | ------------------------- |
| `transactionAccountNonces` | TransactionAccountNonce[] |
| `targetBlockNumber`        | _number_                  |
| `timeout`                  | _number_                  |

**Returns:** _Promise_<[_FlashbotsBundleResolution_](../enums/index.flashbotsbundleresolution.md)\>

Defined in: [src/index.ts:184](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L184)

---

### waitForTransaction

▸ **waitForTransaction**(`transactionHash`: _string_, `confirmations?`: _number_, `timeout?`: _number_): _Promise_<TransactionReceipt\>

#### Parameters:

| Name              | Type     |
| ----------------- | -------- |
| `transactionHash` | _string_ |
| `confirmations?`  | _number_ |
| `timeout?`        | _number_ |

**Returns:** _Promise_<TransactionReceipt\>

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:91

---

### create

▸ `Static`**create**(`genericProvider`: _BaseProvider_, `flashbotsKeyId`: _string_, `flashbotsSecret`: _string_, `connectionInfoOrUrl?`: _string_ \| ConnectionInfo, `network?`: _string_ \| _number_ \| Network): _Promise_<[_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)\>

#### Parameters:

| Name                   | Type                            |
| ---------------------- | ------------------------------- |
| `genericProvider`      | _BaseProvider_                  |
| `flashbotsKeyId`       | _string_                        |
| `flashbotsSecret`      | _string_                        |
| `connectionInfoOrUrl?` | _string_ \| ConnectionInfo      |
| `network?`             | _string_ \| _number_ \| Network |

**Returns:** _Promise_<[_FlashbotsBundleProvider_](index.flashbotsbundleprovider.md)\>

Defined in: [src/index.ts:65](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L65)

---

### defaultUrl

▸ `Static`**defaultUrl**(): _string_

**Returns:** _string_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:31

---

### getFormatter

▸ `Static`**getFormatter**(): _Formatter_

**Returns:** _Formatter_

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:76

---

### getNetwork

▸ `Static`**getNetwork**(`network`: Networkish): Network

#### Parameters:

| Name      | Type       |
| --------- | ---------- |
| `network` | Networkish |

**Returns:** Network

Defined in: node_modules/@ethersproject/providers/lib/base-provider.d.ts:77

---

### hexlifyTransaction

▸ `Static`**hexlifyTransaction**(`transaction`: TransactionRequest, `allowExtra?`: { [key: string]: _boolean_; }): _object_

#### Parameters:

| Name          | Type                          |
| ------------- | ----------------------------- |
| `transaction` | TransactionRequest            |
| `allowExtra?` | { [key: string]: _boolean_; } |

**Returns:** _object_

Defined in: node_modules/@ethersproject/providers/lib/json-rpc-provider.d.ts:42

---

### isProvider

▸ `Static`**isProvider**(`value`: _any_): value is Provider

#### Parameters:

| Name    | Type  |
| ------- | ----- |
| `value` | _any_ |

**Returns:** value is Provider

Defined in: node_modules/@ethersproject/abstract-provider/lib/index.d.ts:137
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / [index](../modules/index.md) / FlashbotsBundleResolution

# Enumeration: FlashbotsBundleResolution

[index](../modules/index.md).FlashbotsBundleResolution

## Table of contents

### Enumeration members

- [AccountNonceTooHigh](index.flashbotsbundleresolution.md#accountnoncetoohigh)
- [BlockPassedWithoutInclusion](index.flashbotsbundleresolution.md#blockpassedwithoutinclusion)
- [BundleIncluded](index.flashbotsbundleresolution.md#bundleincluded)

## Enumeration members

### AccountNonceTooHigh

• **AccountNonceTooHigh**: = 2

Defined in: [src/index.ts:15](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L15)

---

### BlockPassedWithoutInclusion

• **BlockPassedWithoutInclusion**: = 1

Defined in: [src/index.ts:14](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L14)

---

### BundleIncluded

• **BundleIncluded**: = 0

Defined in: [src/index.ts:13](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L13)
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / [index](../modules/index.md) / FlashbotsBundleRawTransaction

# Interface: FlashbotsBundleRawTransaction

[index](../modules/index.md).FlashbotsBundleRawTransaction

## Hierarchy

- **FlashbotsBundleRawTransaction**

## Table of contents

### Properties

- [signedTransaction](index.flashbotsbundlerawtransaction.md#signedtransaction)

## Properties

### signedTransaction

• **signedTransaction**: _string_

Defined in: [src/index.ts:19](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L19)
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / [index](../modules/index.md) / FlashbotsBundleTransaction

# Interface: FlashbotsBundleTransaction

[index](../modules/index.md).FlashbotsBundleTransaction

## Hierarchy

- **FlashbotsBundleTransaction**

## Table of contents

### Properties

- [signer](index.flashbotsbundletransaction.md#signer)
- [transaction](index.flashbotsbundletransaction.md#transaction)

## Properties

### signer

• **signer**: _Signer_

Defined in: [src/index.ts:24](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L24)

---

### transaction

• **transaction**: TransactionRequest

Defined in: [src/index.ts:23](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L23)
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / [index](../modules/index.md) / FlashbotsOptions

# Interface: FlashbotsOptions

[index](../modules/index.md).FlashbotsOptions

## Hierarchy

- **FlashbotsOptions**

## Table of contents

### Properties

- [maxTimestamp](index.flashbotsoptions.md#maxtimestamp)
- [minTimestamp](index.flashbotsoptions.md#mintimestamp)

## Properties

### maxTimestamp

• `Optional` **maxTimestamp**: _undefined_ \| _number_

Defined in: [src/index.ts:29](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L29)

---

### minTimestamp

• `Optional` **minTimestamp**: _undefined_ \| _number_

Defined in: [src/index.ts:28](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L28)
[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / demo

# Module: demo

## Table of contents

[@flashbots/ethers-provider-bundle](../README.md) / [Exports](../modules.md) / index

# Module: index

## Table of contents

### Enumerations

- [FlashbotsBundleResolution](../enums/index.flashbotsbundleresolution.md)

### Classes

- [FlashbotsBundleProvider](../classes/index.flashbotsbundleprovider.md)

### Interfaces

- [FlashbotsBundleRawTransaction](../interfaces/index.flashbotsbundlerawtransaction.md)
- [FlashbotsBundleTransaction](../interfaces/index.flashbotsbundletransaction.md)
- [FlashbotsOptions](../interfaces/index.flashbotsoptions.md)

### Variables

- [DEFAULT_FLASHBOTS_RELAY](index.md#default_flashbots_relay)

## Variables

### DEFAULT_FLASHBOTS_RELAY

• `Const` **DEFAULT_FLASHBOTS_RELAY**: _https://relay.flashbots.net_= "https://relay.flashbots.net"

Defined in: [src/index.ts:10](https://github.com/flashbots/ethers-provider-flashbots-bundle/blob/fc76dfa/src/index.ts#L10)
[@flashbots/ethers-provider-bundle](README.md) / Exports

# @flashbots/ethers-provider-bundle

## Table of contents

### Modules

- [demo](modules/demo.md)
- [index](modules/index.md)
