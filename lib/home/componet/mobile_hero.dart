import 'package:dark_matter_page/home/componet/hero_image.dart';
import 'package:dark_matter_page/home/componet/hero_text.dart';
import 'package:dark_matter_page/home/componet/serving_items_list.dart';
import 'package:flutter/material.dart';

class MobileHero extends StatelessWidget {
  const MobileHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final width = mediaQuery.width;
    final height = mediaQuery.height;
    final double baseFontSize =
        width * 0.05; // Ajusta el tamaño base según el ancho de la pantalla

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            SizedBox(
              height: height * 0.6,
              child: HeroImage(
                circleRadius: width * 0.35,
                bottom: 50,
              ),
            ),
            TitleDark(fontSize: baseFontSize),
            const SizedBox(height: 20.0),
            About(fontSize: baseFontSize),
            const SizedBox(height: 20.0),
            Button(
              fontSize: baseFontSize,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Only At",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    // fontFamily: 'Santana',
                  ),
                ),
                SizedBox(width: 10.0),
                //     Subtitle(),
              ],
            ),
            const SizedBox(height: 20.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 0,
                crossAxisCount: width ~/ 270,
                mainAxisExtent: 100.0,
              ),
              itemBuilder: (context, index) {
                return Center(child: servingItems[index]);
              },
              itemCount: servingItems.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
