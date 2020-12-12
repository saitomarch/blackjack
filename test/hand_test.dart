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
    expect(hand.hasBlackjack, true);
  });

  test('Not treats as blackjack if not Ace and 10/J/Q/K', () {
    final hand = Hand();
    hand.hit(Card(Suit.spades, 7));
    hand.hit(Card(Suit.spades, 7));
    hand.hit(Card(Suit.spades, 7));
    expect(hand.score, 21);
    expect(hand.hasBlackjack, false);
  });

  test('Busts if overs 21', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    expect(hand.score, 30);
    expect(hand.hasBusted, true);
  });

  test('Not busts if 21', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 1));
    expect(hand.score, 21);
    expect(hand.hasBusted, false);
  });

  test('Throws exception if score is 21', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 1));
    expect(hand.score, 21);
    expect(() => hand.hit(Card.random(allowsJoker: false)), throwsException);
  });

  test('Throws exception if busted', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 2));
    expect(hand.score, 22);
    expect(() => hand.hit(Card.random(allowsJoker: false)), throwsException);
  });

  test('Throws ArgumentError if card is joker', () {
    final hand = Hand();
    expect(() => hand.hit(Card(Suit.joker, 1)), throwsArgumentError);
  });

  test('Throws Exception when the hand will hit even standed', () {
    final hand = Hand();
    hand.hit(Card.random(allowsJoker: false));
    hand.hit(Card.random(allowsJoker: false));
    hand.stand();
    expect(() => hand.hit(Card.random(allowsJoker: false)), throwsException);
  });

  test('hasStanded is true if standed explicitly', () {
    final hand = Hand();
    hand.hit(Card.random(allowsJoker: false));
    hand.hit(Card.random(allowsJoker: false));
    hand.stand();
    expect(hand.hasStanded, true);
  });

  test('hasStanded is true if 21', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 1));
    expect(hand.score, 21);
    expect(hand.hasStanded, true);
  });

  test('hasStanded is true if busted', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.clubs, 2));
    expect(hand.score, 22);
    expect(hand.hasStanded, true);
  });

  test('throw Exception when stand if the has no cards', () {
    final hand = Hand();
    expect(() => hand.stand(), throwsException);
  });

  test('throw Exception when stand if the has no cards', () {
    final hand = Hand();
    hand.hit(Card.random(allowsJoker: false));
    expect(() => hand.stand(), throwsException);
  });

  test('Able to split if same number cards.', () {
    final hand = Hand();
    hand.hit(Card(Suit.hearts, 10));
    hand.hit(Card(Suit.spades, 10));
    expect(hand.canSplit, true);
  });

  test('Unable to split if not same number cards.', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.diamonds, 11));
    expect(hand.canSplit, false);
  });

  test('Unable to split if not 2 cards.', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 5));
    hand.hit(Card(Suit.spades, 5));
    hand.hit(Card(Suit.hearts, 5));
    expect(hand.canSplit, false);
  });

  test('Splits successfylly if same number 2 cards', () {
    final hand = Hand();
    hand.hit(Card(Suit.hearts, 10));
    hand.hit(Card(Suit.spades, 10));
    final hands = hand.split();
    expect(hands[0].cards.first, hand.cards[0]);
    expect(hands[1].cards.first, hand.cards[1]);
  });

  test('Throws exception when trying to split if not same number cards.', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 10));
    hand.hit(Card(Suit.diamonds, 11));
    expect(() => hand.split(), throwsException);
  });

  test('Throws exception when trying to split if not 2 cards.', () {
    final hand = Hand();
    hand.hit(Card(Suit.clubs, 5));
    hand.hit(Card(Suit.spades, 5));
    hand.hit(Card(Suit.hearts, 5));
    expect(() => hand.split(), throwsException);
  });
}
