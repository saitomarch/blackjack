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

import 'package:blackjack/hand.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playing_card_base/card.dart';
import 'package:playing_card_base/suit.dart';

void main() {
  test('Score is valid (hard score)', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.diamonds, 10));
    expect(hand.score, 20);
    expect(hand.isSoft, false);
  });

  test('Score is valid (soft score)', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 1));
    hand.hit(Card(Suit.diamonds, 9));
    expect(hand.score, 20);
    expect(hand.isSoft, true);
  });

  test('Score will be 20 if both are over 10, such as Jack, Queen or King', () {
    final hand = Hand();
    hand.hit(Card(Suit.hearts, 11));
    hand.hit(Card(Suit.hearts, 12));
    expect(hand.score, isNot(23));
    expect(hand.score, 20);
    hand.hit(Card(Suit.hearts, 13));
    expect(hand.score, isNot(36));
    expect(hand.score, 30);
  });

  test('Treats as blackjack if card are Ace and 10/J/Q/K.', () {
    final hand = Hand();
    hand.hit(Card(Suit.spades, 1));
    hand.hit(Card(Suit.spades, 10));
    expect(hand.score, 21);
    expect(hand.isBlackjack, true);
  });

  test('Not treats as blackjack if not Ace and 10/J/Q/K', () {
    final hand = Hand();
    hand.hit(Card(Suit.spades, 7));
    hand.hit(Card(Suit.spades, 7));
    hand.hit(Card(Suit.spades, 7));
    expect(hand.score, 21);
    expect(hand.isBlackjack, false);
  });
}
