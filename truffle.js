module.exports = {
    networks: {
        test: {
            host: "localhost",
            port: 8545,
            from: "0x318Bd343a007c9A2091b010091aBa5Cf434fACFB",
            gas: 500000,
            network_id: "*" // Match any network id
        }
    }
};
