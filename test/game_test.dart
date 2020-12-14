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

import 'package:blackjack/command.dart';
import 'package:blackjack/game.dart';
import 'package:blackjack/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Common game test.', () {
    final game = Game();
    game.onAskBuyInsurance = (player, completion) {
      completion(false);
    };
    game.onAskCommand = (player, hand, completion) {
      if (hand.score < 17) {
        completion(Command.hit);
      } else {
        completion(Command.stand);
      }
    };
    game.onFinish = () {
      game.resetPlayers();
    };
    final player = Player();
    player.insertCredits(100);
    game.addPlayer(player);
    player.bet(10);
    game.reset();
    game.begin();
  });
}
