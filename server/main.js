import { Meteor } from 'meteor/meteor';

import Web3 from 'web3';
import './lottery-abi.js'

Meteor.startup(() => {
  // code to run on server at startup
});

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var contractAddress = "0x2cb7f6d9ac23a478e837c714cf7a46540a175206";
var smartContract = web3.eth.contract(abi).at(contractAddress);

Meteor.methods({
  'getEntryCount':function() {
    var count = smartContract.getEntryCount();
    return count.toNumber();
  },

  'getEntryAddresses':function() {
    return smartContract.getEntryAddresses();
  },

  'getFundsAmount': function() {
    var balance = parseFloat(web3.fromWei(web3.eth.getBalance(contractAddress), "ether"));
    return balance;
  },

  'entry': function(data) {
    if (web3.personal.unlockAccount(data.account, data.password)) {
      var coin = web3.toWei(1, "ether");
      smartContract.entry(data.number, { from: data.account, gas: 200000, value: coin });
    }
  },

  'draw': function(data) {
    if (web3.personal.unlockAccount(data.account, data.password)) {
      smartContract.draw({ from: data.account, gas: 200000 });
    }
  }  

});
