import 'package:dark_matter_page/home/componet/desktop_hero.dart';
import 'package:dark_matter_page/home/componet/mobile_hero.dart';
import 'package:dark_matter_page/home/componet/tablet_hero.dart';
import 'package:flutter/material.dart';

class HeroContent extends StatelessWidget {
  const HeroContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return const DesktopHero();
        /* if (constraints.maxWidth >= 850) {
         
        } else if (constraints.maxWidth >= 600) {
          return const TabletHero();
        }
        return const MobileHero();*/
      }),
    );
  }
}
