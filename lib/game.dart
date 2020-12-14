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

import 'package:blackjack/command.dart';
import 'package:playing_card_base/card.dart';
import 'package:playing_card_base/deck.dart';

import 'config.dart';
import 'dealer.dart';
import 'hand.dart';
import 'player.dart';

/// Declares [Game] object
class Game {
  /// Constructor
  Game({Config config}) {
    _config = config ??= Config();
  }

  /// The deck for the game.
  Deck get deck => _deck;
  Deck _deck;

  /// Dealer
  Dealer get dealer => _dealer;
  final Dealer _dealer = Dealer();

  /// Players
  List<Player> get players => _players;
  final List<Player> _players = [];

  /// Config of the game
  Config get config => _config;
  Config _config;

  /// Whether the game initialized
  bool get initialized => _initialized;
  bool _initialized = false;

  /// Whether the game is playing.
  bool get isPlaying => _isPlaying;
  bool _isPlaying = false;

  /// Called whenever asked whether the player buy insurance.
  Function(Player, Function(bool)) onAskBuyInsurance;

  /// Called whenever asked what the player do such as hit, stand.
  Function(Player, Hand, Function(Command)) onAskCommand;

  /// Called whenever the game finished.
  Function() onFinish;

  /// Adds an [player]
  ///
  /// Throws an [Exception] if the [player] is already exist in [players].
  void addPlayer(Player player) {
    if (players.contains(player)) {
      throw Exception('The player already exists.');
    }
    players.add(player);
  }

  /// Removes an [player]
  ///
  /// Throws an [Exception] if the [player] is not found in [players].
  void removePlayer(Player player) {
    if (!players.contains(player)) {
      throw Exception('The player is not found in players.');
    }
    players.remove(player);
  }

  /// Reset the game
  void reset() {
    resetDeck();
    resetPlayers();
    _initialized = true;
  }

  /// Reset the deck
  void resetDeck() {
    if (_config.numberOfDecks > 0) {
      _deck = Deck(multiplier: _config.numberOfDecks);
    } else {
      _deck = null;
    }
  }

  /// Reset the game.
  void resetPlayers() {
    if (onAskBuyInsurance == null || onAskCommand == null || onFinish == null) {
      Exception('Closures are required to implement.');
    }
    if (_isPlaying) {
      Exception('Unable to reset while the game is active');
    }
    dealer.reset();
    for (final player in players) {
      player.reset();
    }
  }

  /// Begin the game
  void begin() {
    if (!initialized) {
      throw Exception('Cannot begin the game until initialized.');
    }
    if (_isPlaying) {
      Exception('Unable to begin the game while the game is active');
    }
    _initialized = false;
    for (var i = 0; i < 2; i++) {
      for (final player in players) {
        _hitHand(player.hands.first);
      }
      _hitHand(dealer.hand);
    }
    if (dealer.upCard.number == 1) {
      _checkBuyInsurance();
    } else {
      _checkDealerBlackjack();
    }
  }

  void _checkBuyInsurance() {
    var checkInsuranceCount = 0;
    for (final player in players) {
      if (player.canBuyInsurance) {
        onAskBuyInsurance(player, (shouldBuy) {
          if (shouldBuy) {
            player.buyInsurance();
          }
          checkInsuranceCount++;
          if (checkInsuranceCount >= players.length) {
            _checkDealerBlackjack();
          }
        });
      }
    }
  }

  void _checkDealerBlackjack() {
    if (dealer.hand.hasBlackjack) {
      _resultGame();
    } else {
      _checkUserHand();
    }
  }

  void _hitHand(Hand hand) {
    if (config.shouldDrawFromDeck) {
      hand.hit(deck.draw());
    } else {
      hand.hit(Card.random(allowsJoker: false));
    }
  }

  void _doubleDownHand(Player player, Hand hand) {
    if (config.shouldDrawFromDeck) {
      player.doubleDown(hand, deck.draw());
    } else {
      player.doubleDown(hand, Card.random(allowsJoker: false));
    }
  }

  void _checkUserHand() {
    for (final player in players) {
      for (final hand in player.hands) {
        if (!hand.hasStanded) {
          onAskCommand(player, hand, (command) {
            switch (command) {
              case Command.hit:
                _hitHand(hand);
                break;
              case Command.stand:
                hand.stand();
                break;
              case Command.doubleDown:
                _doubleDownHand(player, hand);
                break;
              case Command.split:
                player.split();
                break;
              case Command.surrender:
                player.surrender(hand);
                break;
            }
            _checkUserHand();
          });
          return;
        }
      }
    }
    _resultGame();
  }

  void _resultGame() {
    while (dealer.hand.score < 17 ||
        (config.dealerMustHitOnSoft17 &&
            dealer.hand.score == 17 &&
            dealer.hand.isSoft)) {
      _hitHand(dealer.hand);
    }
    for (final player in players) {
      player.result(dealer);
    }
    _isPlaying = false;
    onFinish();
  }
}
