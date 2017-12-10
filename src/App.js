import React, {Component} from 'react'
import BitcoinRate from '../build/contracts/BitcoinRate.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
    constructor(props) {
        super(props)

        this.state = {
            balance: 0,
            web3: null,
            contract: null,
            instance: null
        }
    }

    componentWillMount() {
        // Get network provider and web3 instance.
        // See utils/getWeb3 for more info.
        getWeb3.then(results => {
            this.setState({
                web3: results.web3
            });
            this.instantiateContract()
        }).catch((e) => {
            console.log('Error finding web3.')
            // console.log(e)
        })
    }

    instantiateContract() {
        /*
         * SMART CONTRACT EXAMPLE
         *
         * Normally these functions would be called in the context of a
         * state management library, but for convenience I've placed them here.
         */
        const contract = require('truffle-contract');
        const bitcoinRate = contract(BitcoinRate);
        bitcoinRate.setProvider(this.state.web3.currentProvider);

        // Declaring this for later so we can chain functions on SimpleStorage.
        let bitcoinRateInstance;
        // Get accounts.
        this.state.web3.eth.getAccounts((error, accounts) => {
            bitcoinRate.defaults({
                from: accounts[0]
            });
            this.setState(
                {
                    web3: this.state.web3,
                    contract: bitcoinRate,
                });
            bitcoinRate.deployed().then((instance) => {
                bitcoinRateInstance = instance;
                this.setState({
                    instance: bitcoinRateInstance,
                    web3: this.state.web3,
                    contract: this.state.contract
                });
                // Stores a given value, 5 by default.
                return instance;
            }).then((instance) => {
                // Get the value from the contract to prove it worked.
                return bitcoinRateInstance.getBalance.call(accounts[0])
            }).then((result) => {
                // Update state with the result.
                return this.setState({
                    balance: result.c[0],
                    instance: this.state.instance,
                    web3: this.state.web3,
                    contract: this.state.contract

                })
            })
        })
    }

    sendEth() {
        this.state.instance.send(this.state.web3.toWei(40000000, "gwei")).then(function (result) {
            // Same result object as above.
            console.log(result);
        });
    }

    render() {
        return (
            <div className="App">
                <nav className="navbar pure-menu pure-menu-horizontal">
                    <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
                </nav>
                <main className="container">
                    <div className="pure-g">
                        <div className="pure-u-1-1">
                            <h1>Bitcoin rate in a week</h1>
                            <p>Current price BTC:</p>
                            <h2>Smart Contract Example</h2>
                            <p>If your contracts compiled and migrated successfully, below will show a stored value of 5
                                (by default).</p>
                            <p>Balance is: {this.state.balance}</p>
                            <button onClick={() => this.sendEth()}> Send money for contract</button>
                        </div>
                    </div>
                </main>
            </div>
        );
    }
}

export default App
