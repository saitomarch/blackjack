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

/// Declares [Hand] object.
class Hand {
  /// [cards]
  List<Card> get cards => _cards;
  final List<Card> _cards = [];

  /// Whether the hand has [standed].
  bool get standed => _standed;
  bool _standed = false;

  /// Stand the hand
  void stand() {
    _standed = true;
  }

  /// Whether the hand [hasAce].
  bool get hasAce {
    for (final card in cards) {
      if (card.number == 1) {
        return true;
      }
    }
    return false;
  }

  /// The [limit] of score. The hand will be busted if overs 21.
  static const int limit = 21;

  /// The [score] of the hand.
  int get score {
    var retVal = 0;
    for (final card in cards) {
      retVal += _score(card);
    }
    if (hasAce && retVal + 10 <= limit) {
      retVal += 10;
    }
    return retVal;
  }

  int get _hardScore {
    var retVal = 0;
    for (final card in cards) {
      retVal += _score(card);
    }
    return retVal;
  }

  int _score(Card card) {
    if (card.number > 10) {
      return 10;
    } else {
      return card.number;
    }
  }

  /// Whether the hand [hasBusted].
  bool get hasBusted => score > limit;

  /// Whether the score [isSoft] score.
  bool get isSoft => score != _hardScore;

  /// Hits from a [card].
  ///
  /// Throws an [ArgumentError] if [card] is joker.
  ///
  /// Throws an [Exception] if the [score] is 21 or more.
  void hit(Card card) {
    if (card.isJoker) {
      throw ArgumentError('Joker is not accepted.');
    }
    if (score >= limit) {
      throw Exception('The hand cannot hit if 21 or more.');
    }
    cards.add(card);
  }

  /// Whether the hand has blackjack.
  bool get hasBlackjack => score == limit && cards.length == 2;
}
