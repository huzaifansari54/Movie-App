import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/ApiServices/Services.dart';

import 'package:movie_app/Models/Movie_Model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.movies, required this.intialPage})
      : super(key: key);
  final List<Result> movies;
  final int intialPage;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final PageController pageController;
  late ScrollController scrollController;
  int currentIndex = 1;
  double stars = 1;
  List<Result> results = [];
  Result result = Result();

  @override
  void initState() {
    scrollController = ScrollController();
    pageController =
        PageController(initialPage: widget.intialPage, viewportFraction: 0.9);
    currentIndex = widget.intialPage;
    results = widget.movies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPersistentHeader(
          delegate: MovieHeader(size.height, (percent) {
            final toppercent = ((1 - percent) / .7).clamp(0.0, 1.0);
            final bottompercent = ((percent) / .3).clamp(0.0, 1.0);
            return Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: (topPad + 10.toDouble()) * (1 - bottompercent),
                  bottom: 80.toDouble() * (1 - bottompercent),
                  child: Transform.scale(
                    scale: lerpDouble(1, 1.3, bottompercent)!,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              onPageChanged: (value) {
                                setState(() {
                                  currentIndex = value;
                                });
                              },
                              controller: pageController,
                              itemCount: widget.movies.length,
                              itemBuilder: (context, index) {
                                result = results[index];

                                stars =
                                    (results[index].voteAverage)!.toDouble() /
                                        2.0;
                                return Hero(
                                  tag: result.id ?? index,
                                  child: Material(
                                    color: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w1280/${results[index].backdropPath}',
                                            fit: BoxFit.cover,
                                            colorBlendMode: BlendMode.darken,
                                            placeholder: (context, url) {
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              widget.movies.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      height: 4,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          color: currentIndex == index
                                              ? Colors.red
                                              : Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 120),
                    top: 15,
                    left: toppercent < 1.0 ? 10 : -10,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 120),
                      opacity: toppercent < 1.0 ? 1 : 0,
                      child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )),
                Positioned.fill(
                    top: null,
                    bottom: -80,
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                      stars.toInt(),
                                      (index) => SvgPicture.asset(
                                            'assets/icons/star_fill.svg',
                                            color: Colors.red,
                                            height: 20,
                                          )),
                                  ...List.generate(
                                      (5 - stars.toInt()),
                                      (index) => SvgPicture.asset(
                                            'assets/icons/star.svg',
                                            height: 20,
                                          )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      result.voteAverage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            results[currentIndex].title.toString(),
                            style: GoogleFonts.poppins().copyWith(
                                fontSize: 19, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          boxShadow: toppercent < 0.9
                              ? const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 100,
                                      spreadRadius: 25,
                                      offset: Offset(-1.0, -150)),
                                ]
                              : [],
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40))),
                    )),
                AnimatedPositioned(
                    curve: Curves.bounceOut,
                    //widget.size.width * 0.5 - 30
                    duration: const Duration(milliseconds: 120),
                    top: size.height * .20,
                    right: toppercent < 1.0 ? size.width * 0.5 - 35 : -10,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: toppercent < 1.0 ? 1 : 0,
                      child: GestureDetector(
                        onTap: () async {
                          final id = await Services.getVideo(
                              results[currentIndex].id!.toInt());
                          final _youUrl = 'https://www.youtube.com/embed/$id';
                          if (id.isNotEmpty) {
                            await launch(_youUrl);
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              child: const Icon(
                                Icons.play_circle_fill_rounded,
                                size: 60,
                                color: Colors.red,
                              ),
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                // boxShadow: const [
                                //   BoxShadow(
                                //       color: Colors.black26, spreadRadius: 5, blurRadius: 8)
                                // ],
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              'Play Now',
                              style: GoogleFonts.poppins().copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            );
          }),
          pinned: false,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  'Story Line'.toUpperCase(),
                  style: GoogleFonts.poppins().copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(results[currentIndex].overview ?? '',
                            overflow: TextOverflow.fade,
                            maxLines: 5,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    wordSpacing: 1.2,
                                    fontSize: 15,
                                    color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  'Realese Date'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  result.releaseDate.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Cast '.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.red, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 120,
                child: Consumer(builder: (context, ref, _) {
                  final cast =
                      ref.watch(generCastProvider(results[currentIndex].id));

                  return cast.when(
                      data: (data) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: List.generate(data.length, (index) {
                              final isnull = data[index].profilePath != null;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                          errorWidget: (context, url, error) {
                                            return const Text('data');
                                          },
                                          height: 70,
                                          width: 70,
                                          imageUrl: isnull
                                              ? 'https://image.tmdb.org/t/p/w780/${data[index].profilePath}'
                                              : 'https://image.tmdb.org/t/p/w780//5XBzD5WuTyVQZeS4VI25z2moMeY.jpg',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return const Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data[index].name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: Colors.white60),
                                    )
                                  ],
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
                      error: (e, s) => Center(child: Text(e.toString())),
                      loading: () => const Center(
                            child: CupertinoActivityIndicator(),
                          ));
                }),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class MovieHeader extends SliverPersistentHeaderDelegate {
  const MovieHeader(this._max, this.builder);

  final _max;
  final _min = 330.0;
  final Widget Function(double percent) builder;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset / _max);
  }

  @override
  double get maxExtent => _max;

  @override
  double get minExtent => _min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
