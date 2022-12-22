import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/ApiServices/Services.dart';
import 'package:movie_app/Models/Geners.dart';
import 'package:movie_app/Models/Movie_Model.dart';
import 'package:movie_app/Screens/DetailPage.dart';
import 'package:movie_app/Screens/Widgets/Gener_List.dart';
import 'package:movie_app/Screens/Widgets/Movies_Crousel.dart';

import 'Widgets/Cottegory_Header.dart';
import 'dart:math' as math;
import 'Widgets/Search_Bar.dart';
import 'Widgets/User_Header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int id = 28;
  final _pageController =
      PageController(viewportFraction: 0.80, initialPage: 1);
  final pageController = PageController(viewportFraction: 0.80, initialPage: 1);
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child:
            SingleChildScrollView(child: Consumer(builder: (context, ref, _) {
          final gener = ref.watch(generProvider);

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserHeader(),
                const SearchBar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                _generList(gener, ref, context),
                MoviesCrousel(
                  id: id,
                ),
                const CotegaroyHeader(),
                Consumer(builder: (context, snapshot, _) {
                  final movies = ref.watch(serviceProvider);
                  return movies.when(
                    data: (data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 0.99,
                          child: PageView.builder(
                            onPageChanged: (value) {
                              setState(() {
                                pageIndex = value;
                              });
                            },
                            controller: _pageController,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              // print(index - _pageController.page!.toInt());
                              return _animateBuilder(index, data);
                            },
                            itemCount: data.length,
                          ),
                        ),
                      );
                    },
                    error: (e, stack) => Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No Internet connection',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const Icon(
                              Icons.signal_wifi_connected_no_internet_4_rounded)
                        ],
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
              ]);
        })),
      )),
    );
  }

  Widget _generList(
      AsyncValue<List<Gener>> gener, WidgetRef ref, BuildContext context) {
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
                        ref.watch(generMovieProvider(data[index].id));
                        id = data[index].id!.toInt();
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
                                      borderRadius: BorderRadius.circular(10)),
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
        error: (erorr, stacktrace) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Internet connection',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Icon(Icons.signal_wifi_connected_no_internet_4_rounded)
                ],
              ),
            ),
        loading: () => const Center(
              child: CupertinoActivityIndicator(),
            ));
  }

  Widget _animateBuilder(int index, List<Result> data) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index - _pageController.page!.toDouble();
            value = (value * 0.038).clamp(-1, 1);
          }

          return Hero(
            tag: data[index].id ?? index,
            child: Material(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0.0,
              child: Transform.rotate(
                angle: math.pi * value,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    intialPage: index,
                                    movies: data,
                                  )));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w780/${data[index].posterPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
