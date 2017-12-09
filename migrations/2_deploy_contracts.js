const Web3 = require('web3');
const TruffleConfig = require('../truffle');

const SimpleStorage = artifacts.require("./SimpleStorage.sol");
const UsingOraclize = artifacts.require("./usingOraclize.sol");
const BitcoinRate = artifacts.require("./BitcoinRate.sol");

module.exports = function (deployer, network, addresses) {
    const config = TruffleConfig.networks[network];
    if (network == "robsten") {
        if (process.env.ACCOUNT_PASSWORD) {
            const web3 = new Web3(new Web3.providers.HttpProvider('http://' + config.host + ':' + config.port));
            console.log('>> Unlocking account ' + config.from);
            web3.personal.unlockAccount(config.from, process.env.ACCOUNT_PASSWORD, 1000);
            console.log('Unlocking account OK');
        }
    }
    //deployer.deploy(Owner, {gas: 1000000 });
    // deployer.deploy(SimpleStorage, {gas: 5000000 });
    //deployer.deploy(UsingOraclize);
    deployer.deploy(BitcoinRate, {gas: 4612388, from: config.from});
};
