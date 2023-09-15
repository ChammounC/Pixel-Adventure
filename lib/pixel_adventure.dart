import 'dart:async';

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure/components/level.dart';

import 'components/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;
  Player player = Player(character: 'Virtual Guy');
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(levelName: 'Level-01', player: player);

    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if(showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 30,
          paint: BasicPalette.gray.withAlpha(90).paint()
      ),
      background: CircleComponent(
          radius: 60,
          paint: BasicPalette.black.withAlpha(100).paint()
      ),
      margin: const EdgeInsets.only(bottom: 40, left: 50),
    );
    add(joystick);
  }

  void updateJoystick() {
    player.horizontalMovement = switch (joystick.direction) {
      JoystickDirection.left ||
      JoystickDirection.upLeft ||
      JoystickDirection.downLeft =>
        -1,
      JoystickDirection.right ||
      JoystickDirection.upRight ||
      JoystickDirection.downRight =>
        1,
      _ => 0
    };
  }
}
