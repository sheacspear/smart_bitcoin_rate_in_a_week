pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BitcoinRate.sol";

contract TestBitcoinRate {

  function testItStoresAValue() public {
    BitcoinRate bitcoinRate = SimpleStorage(DeployedAddresses.BitcoinRate());

    bitcoinRate.set(89);

    uint expected = 89;

    Assert.equal(bitcoinRate.get(), expected, "It should store the value 89.");
  }

}
