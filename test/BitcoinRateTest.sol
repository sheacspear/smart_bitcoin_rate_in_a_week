pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BitcoinRate.sol";

contract TestBitcoinRate {

  function testItStoresAValue() public {
    BitcoinRate bitcoinRate = BitcoinRate(DeployedAddresses.BitcoinRate());

    bitcoinRate.registerNewSubscriber('test@lol');

    bitcoinRate.getAllSubscribers();



    Assert.equal(bitcoinRate.subscribers[0], 'test@lol', "It should store the value 89.");
  }

}
