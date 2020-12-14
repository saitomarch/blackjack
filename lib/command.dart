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

/// Declares [Command] enum.
enum Command {
  /// Stand the hand
  stand,

  /// Hit a card
  hit,

  /// Double down
  doubleDown,

  /// Split hands
  split,

  /// Surrender the hand.
  surrender,
}
