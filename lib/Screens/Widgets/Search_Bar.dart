import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: Axis.vertical,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.05),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  'assets/icons/search.svg',
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, isCollapsed: true),
                )),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.redAccent,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  Icons.mic,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
