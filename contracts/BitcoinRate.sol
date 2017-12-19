pragma solidity ^0.4.18;

import "./Ownable.sol";
import "./usingOraclize.sol";

/**
 * @title Smart contract, allows you to get the actual price of bitcoin once a week.
 * @dev Subscribe for BTC price, update even every week, user Oracle by Oraclize for get BTC price
 * @dev see https://github.com/sheacspear/smart_bitcoin_rate_in_a_week
 */
contract BitcoinRate is Ownable, usingOraclize {

    /**
     * Subscribes
     */
    string[] private subscribers;

    /**
     * Last BTC price 10^5 $
     */
    uint private currentPriceBitcoin = 0;

    /**
     * Request ids for BTC price
     */
    mapping(bytes32 => bool) private validIds;

    /**
     * Push event log
     */
    event log(string msg);

    /**
     * Push event Bitcoin Price
     */
    event newBitcoinPrice(uint price);

    /**
     * Push event Bitcoin Price Less than last price
     */
    event newBitcoinPriceLess(uint price);

    /**
     * Push event Bitcoin Price Equals than last price
     */
    event newBitcoinPriceEquals(uint price);

    /**
     * Push event Bitcoin Price More than last price
     */
    event newBitcoinPriceMore(uint price);

    /**
     * Push event log Oraclize request
     */
    event newOraclizeQuery(string msg);

    /**
     *  Push event with new price & subscriber
     */
    event newBTCPrice(string email, uint cost);

    /**
     * Fallback Function
     * A contract can have exactly one unnamed function.
     * This function cannot have arguments and cannot return anything.
     * It is executed on a call to the contract if none of the other functions match the given function identifier (or if no data was supplied at all).
     */
    function() public payable {
        log("new balance");
    }

    /**
     * Create Smart contract and Scheduler for update BTC Price
     */
    function BitcoinRate() {
        //Authenticity proofs
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        //updatePrice();
    }

    /**
     * Subscribe for BTC price
     */
    function registerNewSubscriber(string email) public payable {
        //get your money for subscribe
        require(msg.value > 0);
        subscribers.push(email);
    }

    /**
     * Get Balance for Smart contract, every request into Oraclize use gas
     */
    function getBalance() public constant returns (uint){
        return this.balance;
    }

    /**
     * Get last Bitcoin Price
     */
    function getBTC() public constant returns (uint){
        return currentPriceBitcoin;
    }

    /**
     *  Send new price for all Subscriber
     *  TODO delete it
     */
    function getAllSubscribers() payable public {////constant
        //newBTCPrice("test1", "test2");
        newOraclizeQuery('getAllSubscribers');
        log('getAllSubscribers');
        log(strConcat('getAllSubscribers size:', uint2str(subscribers.length)));
        for (uint i = 0; i < subscribers.length; i++) {
            newBTCPrice(subscribers[i], currentPriceBitcoin);
        }
    }

    /**
    *
    * Send request for BTC price with week delay
    * todo add modificator onlyOwner
    */
    function updatePrice() public payable {
        if (oraclize_getPrice("URL") > this.balance) {
            //Oraclize query was NOT sent, please add some ETH to cover for the query fee
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            //Oraclize query was sent, standing by for the answer..
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            //60 * 24 * 7 = 10080
            //for test 3600 sec
            bytes32 queryId = oraclize_query(3600, "URL", "json(https://api.coindesk.com/v1/bpi/currentprice.json).bpi.USD.rate");
            //
            validIds[queryId] = true;
        }
    }


    /**
     * Response from oraclized with BTC price
     */
    function __callback(bytes32 myid, string result, bytes proof) public {
        //check sender price
        require(msg.sender == oraclize_cbAddress());
        //check check request ids
        require(validIds[myid]);
        //get
        uint newPrice = parseInt(result, 5);
        //BTC price * 10 000
        if (newPrice > currentPriceBitcoin) {
            //Push event Bitcoin Price More than last price
            newBitcoinPriceMore(newPrice);
        } else if (newPrice < currentPriceBitcoin) {
            //Push event Bitcoin Price Less than last price
            newBitcoinPriceLess(newPrice);
        } else {
            //Push event Bitcoin Price Equals than last price
            newBitcoinPriceEquals(newPrice);
        }
        newBitcoinPrice(newPrice);
        currentPriceBitcoin = newPrice;
        //delete valid request id
        delete validIds[myid];
        updatePrice();
    }

    /**
     * Destroy Smart contract
     */
    function close() public onlyOwner {
        selfdestruct(owner);
    }
}

