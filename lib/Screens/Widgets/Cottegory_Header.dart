import 'package:flutter/material.dart';

class CotegaroyHeader extends StatelessWidget {
  const CotegaroyHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: ' Features ',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
            TextSpan(
                text: 'Movies', style: Theme.of(context).textTheme.subtitle1)
          ])),
          Text('See All',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.red, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
