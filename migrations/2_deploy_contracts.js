const BitcoinRate = artifacts.require("./BitcoinRate.sol");

module.exports = function (deployer, network, addresses) {
    deployer.deploy(BitcoinRate, {gas: 4612388});
};
