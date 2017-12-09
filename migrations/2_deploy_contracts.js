var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Owner = artifacts.require("./Owner.sol");

module.exports = function (deployer) {
    //deployer.deploy(Owner);
    deployer.deploy(SimpleStorage);
};
