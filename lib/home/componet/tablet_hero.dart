import 'package:dark_matter_page/home/componet/hero_image.dart';
import 'package:dark_matter_page/home/componet/hero_text.dart';
import 'package:dark_matter_page/home/componet/serving_items_list.dart';
import 'package:flutter/material.dart';

class TabletHero extends StatelessWidget {
  const TabletHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Padding(
      // height: mediaQuery.height * 0.6,
      padding: EdgeInsets.symmetric(
          vertical: 20.0, horizontal: mediaQuery.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            Row(
              children: const [
                /*    Expanded(
                  child: HeroText(mediaQuery: medai,),
                ),*/
                Expanded(
                  flex: 2,
                  child: HeroImage(),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: servingItems,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
