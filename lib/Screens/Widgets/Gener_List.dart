import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/ApiServices/Services.dart';

final state = StateProvider<int>(((ref) => 0));

class GenerList extends StatefulWidget {
  const GenerList({Key? key}) : super(key: key);

  @override
  _GenerListState createState() => _GenerListState();
}

class _GenerListState extends State<GenerList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final gener = ref.watch(generProvider);
      return gener.when(
          data: (data) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(data.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          ref.read(generMovieProvider(data[index].id));
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).secondaryHeaderColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index].name ?? 'unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                    fontWeight: _currentIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: _currentIndex == index ? 16 : 15,
                                  ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _currentIndex == index
                                ? Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  );
                })
                  ..insert(
                      0,
                      const SizedBox(
                        width: 30,
                      )),
              ),
            );
          },
          error: (erorr, stacktrace) => Text(erorr.toString()),
          loading: () => const Center(
                child: CupertinoActivityIndicator(),
              ));
    });
  }
}
