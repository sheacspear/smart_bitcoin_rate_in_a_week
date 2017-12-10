pragma solidity ^0.4.18;

import "./Owner.sol";
import "./usingOraclize.sol";

contract BitcoinRate is Owner, usingOraclize {

    string[] subscribers;

    string currentPriceBitcoin = "0";

    ufixed test;

    mapping(bytes32 => bool) validIds;
    //Fallback Function
    //A contract can have exactly one unnamed function.
    //This function cannot have arguments and cannot return anything.
    //It is executed on a call to the contract if none of the other functions match the given function identifier (or if no data was supplied at all).

    function() payable {
        newOraclizeQuery("new balance");
    }

    event newBitcoinPrice(string price);

    event newOraclizeQuery(string msg);

    event newBTCPrice(string msg, string email);


    function BitcoinRate() {
        //oraclize_setProof(proofType_Ledger);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        //updatePrice();
    }

    function registerNewSubscriber(string email) public payable{
        subscribers.push(email);
    }

    function getBalance() public view returns (uint){
        return this.balance;
    }

    function getBTC() public view returns (string){
        return currentPriceBitcoin;
    }

    function getAllSubscribers() public {
        //newBTCPrice("test1", "test2");
        for (uint i = 0; i <= subscribers.length; i++) {
            newOraclizeQuery(subscribers[i]);
            //newBTCPrice(subscribers[i], currentPriceBitcoin);

        }
    }

    function updatePrice() public payable {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            //60
            bytes32 queryId = oraclize_query(60, "URL", "json(https://api.coindesk.com/v1/bpi/currentprice.json).bpi.USD.rate");
            validIds[queryId] = true;
        }
    }

    function __callback(bytes32 myid, string result, bytes proof) public {
        require(validIds[myid]);
        require(msg.sender == oraclize_cbAddress());
        if (biggest(result, currentPriceBitcoin)) {
            currentPriceBitcoin = result;
            newBitcoinPrice(result);
        }
        delete validIds[myid];
        //updatePrice();
    }

    function biggest(string result1, string result2) public returns (bool biggest) {
        return true;
    }


    function close() public onlyOwner {
        selfdestruct(owner);
    }
}

