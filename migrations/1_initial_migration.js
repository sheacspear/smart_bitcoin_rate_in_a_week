const Web3 = require('web3');

const TruffleConfig = require('../truffle');

const Migrations = artifacts.require("./Migrations.sol");


module.exports = function (deployer, network, addresses) {
    if (network == "robsten") {
        console.log('start');
        const config = TruffleConfig.networks[network];
        console.log('ACCOUNT_PASSWORD :' + process.env.ACCOUNT_PASSWORD);
        if (process.env.ACCOUNT_PASSWORD) {
            const web3 = new Web3(new Web3.providers.HttpProvider('http://' + config.host + ':' + config.port));
            console.log('>> Unlocking account ' + config.from);
            web3.personal.unlockAccount(config.from, process.env.ACCOUNT_PASSWORD, 1000);
            console.log('Unlocking account OK');
        }
        console.log('>> Deploying migration');
    }
    deployer.deploy(Migrations);//, {gas: 500000}
};