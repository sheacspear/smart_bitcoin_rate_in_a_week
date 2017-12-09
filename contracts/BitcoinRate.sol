pragma solidity ^0.4.18;

import "./Owner.sol";
import "./usingOraclize.sol";

contract BitcoinRate is Owner, usingOraclize {

    struct Subscriber {
        string email;
    }

    mapping(address => Subscriber) subscribers;

    string currentPriceBitcoin;

    mapping(bytes32 => bool) validIds;


    event newBitcoinPrice(string price);

    event newOraclizeQuery(string msg);

    function BitcoinRate() {
        //oraclize_setProof(proofType_Ledger);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        updatePrice();
    }

    function registerNewSubscriber(string email) public {
        subscribers[msg.sender].email = email;

    }

    function updatePrice() public payable {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId = oraclize_query(60, "URL", "https://api.coindesk.com/v1/bpi/currentprice.json).bpi.USD.rate");
            validIds[queryId] = true;
        }
    }

    function __callback(bytes32 myid, string result) public {
        require(validIds[myid]);
        require(msg.sender == oraclize_cbAddress());
        if (compare(result, currentPriceBitcoin)) {
            currentPriceBitcoin = result;
            newBitcoinPrice(result);
        }
        delete validIds[myid];
        updatePrice();
    }

    function compare(string result1, string result2) public returns (bool biggest) {
        return true;
    }


    function close() public onlyOwner {
        selfdestruct(owner);
    }
}

