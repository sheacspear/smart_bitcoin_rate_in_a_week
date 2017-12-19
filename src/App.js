import React, {Component} from 'react'
import BitcoinRate from '../build/contracts/BitcoinRate.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

/**
 * App for Smart contract
 *
 * Subscribe for BTC price, update even every week.
 * User Oracle by Oraclize for get BTC price.
 */
class App extends Component {
    constructor(props) {
        super(props)

        this.state = {
            balance: 0,
            btc: 0,
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
                web3: results.web3,
                btc: this.state.btc
            });
            this.instantiateContract()
        }).catch((e) => {
            console.log('Error finding web3.')
            console.log(e)
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
                        btc: this.state.btc
                    });
                bitcoinRate.deployed().then((instance) => {
                    bitcoinRateInstance = instance;
                    this.setState({
                        instance: bitcoinRateInstance,
                        web3: this.state.web3,
                        contract: this.state.contract,
                        btc: this.state.btc
                    });
                }).then(() => {

                   // this.state.instance.log((error, result) => {
                      //  console.log('log');
                      //  console.log(result);
                      //  console.log(error);
                       // console.log(result.args);
                  //  });

                    this.state.instance.newBitcoinPrice((error, result) => {
                        console.log('newBitcoinPrice');
                        console.log(result);
                        console.log(error);
                        console.log(result.args.price);
                    });

                    this.state.instance.newBitcoinPriceLess((error, result) => {
                        console.log('newBitcoinPriceLess');
                        console.log(result);
                        console.log(error);
                        console.log('Меньше чем раньше, новая цена:');
                        console.log(result.args.price.c[0]);

                    });

                    this.state.instance.newBitcoinPriceEquals((error, result) => {
                        //console.log('newBitcoinPriceEquals');
                        //console.log(result);
                        //console.log(error);
                        console.log('Вы везунчик, цена не изменилась: ');
                        console.log(result.args.price.c[0]);

                    });

                    this.state.instance.newBitcoinPriceMore((error, result) => {
                        console.log('newBitcoinPriceMore');
                        //console.log(result);
                        //console.log(error);
                        console.log('Больше чем раньше, новая цена: ');
                        console.log(result.args.price.c[0]);
                    });

                    this.state.instance.newOraclizeQuery((error, result) => {
                        //console.log('newOraclizeQuery');
                        //console.log(result);
                        //console.log(error);
                        console.log(result.args.msg);
                    });

                    this.state.instance.newBTCPrice((error, result, zz) => {
                        console.log('newBTCPrice');
                        //console.log(result);
                        //console.log(error);
                        console.log(result.args.email);
                        console.log(result.args.cost.c[0]);
                    });
                }).then((instance) => {
                    // Get the value from the contract to prove it worked.
                    bitcoinRateInstance.getBalance().then((result) => {
                        // Update state with the result.
                        return this.setState({
                            balance: result.c[0],
                            instance: this.state.instance,
                            web3: this.state.web3,
                            contract: this.state.contract,
                            btc: this.state.btc
                        })
                    });

                    // Get the value from the contract to prove it worked.
                    bitcoinRateInstance.getBTC().then((result) => {
                        // Update state with the result.
                        return this.setState({
                            balance: this.state.balance,
                            instance: this.state.instance,
                            web3: this.state.web3,
                            contract: this.state.contract,
                            btc: result.c[0],
                        })
                    });
                })
            }
        )
    }

    /**
     *  Register New User and send yours money
     */
    registerUser() {
        console.log('registerNewSubscriber: ' + this.textInput.value)
        this.state.instance.registerNewSubscriber.sendTransaction(this.textInput.value, {value: this.state.web3.toWei(0.01, "ether")}).then(function (result) {
            // Same result object as above.
            console.log(result);
        });
    }

    getSubscribers() {
        this.state.instance.getAllSubscribers();
    }

    updatePrice() {
        this.state.instance.updatePrice();
    }

    render() {
        return (
            <div className="App">
                <nav className="navbar pure-menu pure-menu-horizontal">
                    <h1>Bitcoin rate in a week</h1>
                </nav>
                <main className="container">
                    <div className="pure-g">
                        <div className="pure-u-1-1">
                            <p>Test Smart Contract </p>
                            <p>Current price BTC: {this.state.btc}</p>
                            <p>Balance is: {this.state.balance}</p>
                            <button onClick={() => this.registerUser()}> Register New User and send yours money</button>
                            <input type="text" name="e-mail" ref={(input) => {
                                this.textInput = input;
                            }}/>
                            <br/>
                            <button onClick={() => this.updatePrice()}>Start update price</button>
                            <br/>
                            <button onClick={() => this.getSubscribers()}> Get all Subscribers</button>
                        </div>
                    </div>
                </main>
            </div>
        );
    }
}

export default App
