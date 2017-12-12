var BitcoinRate = artifacts.require("./BitcoinRate.sol");

contract('BitcoinRate', function(accounts) {

  it("...should store the value 89.", function() {
    return BitcoinRate.deployed().then(function(instance) {
      bitcoinRateInstance = instance;

      return bitcoinRateInstance.set(89, {from: accounts[0]});
    }).then(function() {
      return bitcoinRateInstance.get.call();
    }).then(function(storedData) {
      assert.equal(storedData, 89, "The value 89 was not stored.");
    });
  });

});
