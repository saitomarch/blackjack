/*
Copyright 2020 SAITO Tomomi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

library blackjack;

import 'package:playing_card_base/card.dart';

import 'dealer.dart';
import 'hand.dart';

/// Declares [Player] object
class Player {
  /// Hands for the player.
  List<Hand> get hands => _hands;
  List<Hand> _hands = [Hand()];

  /// Credits
  int get credits => _credits;
  int _credits = 0;

  /// Insert credits
  void insertCredits(int credits) {
    _credits += credits;
  }

  /// Payout credits
  int payoutCredits() {
    var payout = _credits;
    _credits = 0;
    return payout;
  }

  /// Wager
  int get wager => _wager;
  int _wager = 0;

  /// Whether has bought insurance
  bool get hasBoughtInsurance => _hasBoughtInsurance;
  bool _hasBoughtInsurance = false;

  /// Buy insurance
  void buyInsurance() {
    if (!canBuyInsurance) {
      throw Exception('Unable to buy insurance because not enough credits');
    }
    _credits -= (wager / 2) as int;
    _hasBoughtInsurance = true;
  }

  /// Whether can buy insurance
  bool get canBuyInsurance {
    return (wager / 2) < credits;
  }

  /// Bet coins.
  void bet(int wager) {
    if (!canBet(wager)) {
      throw Exception('Unable to bet lager than credits');
    }
    _credits -= wager;
    _wager += wager;
  }

  /// Can double down a hand.
  bool canDoubleDown(Hand hand) {
    if (!hands.contains(hand)) {
      throw ArgumentError('The hand which matched not found.');
    }
    return hand.canDoubleDown && canBet(wager);
  }

  /// Double down a hand
  void doubleDown(Hand hand, Card card) {
    if (!canDoubleDown(hand)) {
      throw Exception('Unable to double down.');
    }
    _credits -= wager;
    hand.doubleDown(card);
  }

  /// Can surrender a [hand]
  bool canSurrender(Hand hand) {
    if (!hands.contains(hand)) {
      throw ArgumentError('The hand which matched not found.');
    }
    return hand.canSurrender;
  }

  /// Surrender a [hand]
  void surrender(Hand hand) {
    if (!canSurrender(hand)) {
      throw Exception('Unable to surrender.');
    }
    hand.surrender();
  }

  /// Whether can bet chips.
  bool canBet(int wager) => wager <= credits;

  /// Result
  void result(Dealer dealer) {
    for (final hand in hands) {
      if (hand.hasBusted) {
        _lose(false);
      } else if (dealer.hand.hasBusted) {
        _win(hand.hasBlackjack);
      } else if (dealer.hand.hasBlackjack) {
        _lose(true);
      } else {
        if (hand.score < dealer.hand.score) {
          _lose(false);
        } else if (hand.score > dealer.hand.score) {
          _win(hand.hasBlackjack);
        } else {
          _push();
        }
      }
    }
  }

  /// Whether can split
  bool get canSplit => hands.length == 1 && hands.first.canSplit;

  /// [split] hands.
  void split() {
    if (!canSplit) {
      throw Exception('Unable to split a hand.');
    }
    _hands = hands.first.split();
  }

  void _win(bool isBlackjack) {
    _credits += (wager * (isBlackjack ? 2.5 : 2));
  }

  void _push() {
    _credits += wager;
  }

  void _lose(bool isBlackjack) {
    if (isBlackjack && hasBoughtInsurance) {
      _credits += (wager * 1.5) as int;
    }
  }

  /// Reset status
  void reset() {
    _wager = 0;
    _hasBoughtInsurance = false;
    _hands = [Hand()];
  }
}
