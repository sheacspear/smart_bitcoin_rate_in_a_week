pragma solidity ^0.4.18;

import "./Owner.sol";
import "./usingOraclize.sol";

//Smart contract
//Subscribe for BTC price, update even every week
//user Oracle by Oraclize for get BTC price
contract BitcoinRate is Owner, usingOraclize {

    //Subscribe
    string[] subscribers;

    //Last BTC price
    uint currentPriceBitcoin = 0;

    //request ids for BTC price
    mapping(bytes32 => bool) validIds;

    //Fallback Function
    //A contract can have exactly one unnamed function.
    //This function cannot have arguments and cannot return anything.
    //It is executed on a call to the contract if none of the other functions match the given function identifier (or if no data was supplied at all).
    function() payable {
        newOraclizeQuery("new balance");
    }

    //Push event Bitcoin Price
    event newBitcoinPrice(uint price);

    //Push event log Oraclize request
    event newOraclizeQuery(string msg);

    //Push event log
    event log(string msg);

    ////Push event Bitcoin Price
    event newBTCPrice(string msg, string email);

    //Create Smart contract and Scheduler for update BTC Price
    function BitcoinRate() {
        //Authenticity proofs
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        //updatePrice();
    }

    //Subscribe for BTC price
    function registerNewSubscriber(string email) public payable {
        //get your money for subscribe
        require(msg.value > 0);
        subscribers.push(email);
    }

    //Get Balance for Smart contract, every request into Oraclize use gas
    function getBalance() public view returns (uint){
        return this.balance;
    }

    //Get last Bitcoin Price
    function getBTC() public view returns (uint){
        return currentPriceBitcoin;
    }

    //todo delete it
    function getAllSubscribers() public {
        //newBTCPrice("test1", "test2");
        for (uint i = 0; i <= subscribers.length; i++) {
            newOraclizeQuery(subscribers[i]);
            //newBTCPrice(subscribers[i], currentPriceBitcoin);

        }
    }

    //send request for BTC price with week deley
    //todo set private
    function updatePrice() public payable {
        //
        if (oraclize_getPrice("URL") > this.balance) {
            //
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            //
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            //60
            bytes32 queryId = oraclize_query(60, "URL", "json(https://api.coindesk.com/v1/bpi/currentprice.json).bpi.USD.rate");
            //
            validIds[queryId] = true;
        }
    }

    //response from oraclized with BTC price
    function __callback(bytes32 myid, string result, bytes proof) public {
        //check sender price
        require(msg.sender == oraclize_cbAddress());
        //check check request ids
        require(validIds[myid]);
        //get
        uint newPrice = parseInt(result, 5);
        //BTC price * 10 000
        if (newPrice > currentPriceBitcoin) {
            //
            newBitcoinPrice(newPrice);
        } else if (newPrice < currentPriceBitcoin) {
            //
            newBitcoinPrice(newPrice);
        } else {
            //
            newBitcoinPrice(newPrice);
        }
        currentPriceBitcoin = newPrice;
        //delete valid request id
        delete validIds[myid];
        //updatePrice();
    }

    //Destroy Smart contract
    function close() public onlyOwner {
        selfdestruct(owner);
    }
}

