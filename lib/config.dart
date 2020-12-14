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

/// Declares [Config] object.
class Config {
  /// Whether the dealer must hit on soft 17. Default is `false`.
  bool dealerMustHitOnSoft17 = false;

  /// Number of decks.
  ///
  /// The card will be generated dinamically if 0.
  int numberOfDecks = 8;

  /// Whether the card should be drawn from the deck.
  ///
  /// Cards will be generated as random if `false`.
  bool get shouldDrawFromDeck => numberOfDecks > 0;
}
