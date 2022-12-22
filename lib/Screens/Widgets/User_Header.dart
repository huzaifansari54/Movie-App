import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Hello',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.redAccent)),
                TextSpan(
                    text: ' Huzaifa!',
                    style: Theme.of(context).textTheme.subtitle1)
              ])),
              const SizedBox(
                height: 5,
              ),
              Text('Book your favoiret Movie',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpeg'),
          )
        ],
      ),
    );
  }
}
