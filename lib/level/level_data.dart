import 'package:space_punks/level/story.dart';

class LevelData {
  List<Story> storyData = [
    Story(
        levelId: 'pre_level_1.tmx',
        storyImage: 'assets/images/control_image_half2.png',
        storyText: 'Control your player by touching the screen zones'),
    Story(
        levelId: 'level2.tmx',
        storyImage: 'assets/images/red_planet_arrival_1.gif',
        storyText: 'Welcome to The Red Planet'),
    Story(
        levelId: 'level6.tmx',
        storyImage: 'assets/images/red_planet_departure_1.gif',
        storyText: 'Red Planet Spaceship Voyage to Space Station'),
  ];
}
