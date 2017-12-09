const Web3 = require('web3');
const TruffleConfig = require('../truffle');

const SimpleStorage = artifacts.require("./SimpleStorage.sol");
const UsingOraclize = artifacts.require("./usingOraclize.sol");
const BitcoinRate = artifacts.require("./BitcoinRate.sol");

module.exports = function (deployer, network, addresses) {
    const config = TruffleConfig.networks[network];
    deployer.deploy(BitcoinRate, {gas: 4612388, from: config.from});
};
