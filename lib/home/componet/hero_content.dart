import 'package:dark_matter_page/home/componet/desktop_hero.dart';
import 'package:flutter/material.dart';

class HeroContent extends StatelessWidget {
  final VoidCallback onTapServices;
  const HeroContent({
    Key? key,
    required this.onTapServices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return DesktopHero(
          // <- Cambiar por MobileHero o TabletHero
          onTapServices: onTapServices,
        );
      }),
    );
  }
}
