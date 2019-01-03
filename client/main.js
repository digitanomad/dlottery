import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import BigNumber from 'bignumber.js';
import './main.html';

Template.lottery.helpers({
  getEntryCount() {
    Meteor.call('getEntryCount', function (error, result) {
      if (error) {
        return;

      } else {
        console.log(result);
        Session.set('getEntryCount', result);
      }
    });

    return Session.get('getEntryCount');
  },

  getEntryAddresses() {
    Meteor.call('getEntryAddresses', function (error, result) {
      console.log(result);
      Session.set('getEntryAddresses', result);
    });

    return Session.get('getEntryAddresses');
  },

  getFundsAmount() {
    Meteor.call('getFundsAmount', function (error, result) {
      console.log(result);
      Session.set('getFundsAmount', result);
    });

    return Session.get('getFundsAmount');
  }
});

Template.lottery.events({
  'click #entry'(event, instance) {
    event.preventDefault();

    var data = {
      account: $('input[name=account]').val(),
      password: $('input[name=password').val(),
      number: $('input[name=number]').val()
    }
    
    if (window.confirm('응모하시겠습니까?')) {
      Meteor.call('entry', data, function (error, result) {
        if (error) {
          alert('실패');
        } else {
          alert('성공');
        }
      });
    }
  },

  'click #draw'(event, instance) {
    event.preventDefault();

    var data = {
      account: $('input[name=account]').val(),
      password: $('input[name=password').val(),
    }

    Meteor.call('draw', data, function(error, result) {
      if (error) {
        console.log(error);
        alert('실패');
      } else {
        alert('성공');
      }
    });
  }
});
