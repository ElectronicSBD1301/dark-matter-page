import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ServingItem extends StatelessWidget {
  const ServingItem({
    Key? key,
    this.title,
    this.text,
    required this.imgUrl,
    this.isTab = false,
    this.showText = true,
    this.useOriginalColor = true,
  }) : super(key: key);

  final String? title;
  final String? text;
  final String imgUrl;
  final bool isTab;
  final bool showText;
  final bool useOriginalColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ColorFiltered(
          colorFilter: useOriginalColor
              ? const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.multiply,
                )
              : const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
          child: Image.asset(
            imgUrl,
            height: 90.0,
            width: 90.0,
          ),
        ),
        const SizedBox(width: 20.0),
        if (showText)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (title != null) const SizedBox(height: 5.0),
              if (text != null)
                SizedBox(
                  width: ((width >= 600 && width <= 700) ||
                          (width >= 850 && width <= 1000))
                      ? 75
                      : 130,
                  child: AutoSizeText(
                    text!,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 14.0,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
