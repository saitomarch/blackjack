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
  ///
  /// Returns hard score if [hard] is `true` (always ace is treated as 1).
  /// Otherwise soft score.
  int score({bool hard = false}) {
    var retVal = 0;
    for (final card in cards) {
      if (card.number > 10) {
        retVal += 10;
      } else {
        retVal += card.number;
      }
    }
    if (!hard && hasAce && retVal + 10 <= limit) {
      retVal += 10;
    }
    return retVal;
  }

  /// Whether the hand [hasBusted].
  bool get hasBusted => score() > limit;

  /// Whether the score [isSoft] score.
  bool get isSoft => score(hard: false) != score(hard: true);

  /// Hits from a [card].
  void hit(Card card) {
    if (score(hard: false) >= limit) {
      throw Exception('The hand cannot hit if busted.');
    }
    cards.add(card);
  }

  /// Whether the hand is blackjack.
  bool get isBlackjack => score(hard: false) == limit && cards.length == 2;
}
