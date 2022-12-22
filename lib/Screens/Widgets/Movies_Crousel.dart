import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ApiServices/Services.dart';

class MoviesCrousel extends StatelessWidget {
  const MoviesCrousel({Key? key, this.id}) : super(key: key);

  final int? id;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final movie = ref.watch(generMovieProvider(id));
      return movie.when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                                height: 200,
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w780/${data[index].posterPath}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    data[index].title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: data.length,
                ),
              ),
            );
          },
          error: (erorr, stacktrace) => const Center(
                child: Text(
                  'Oops! Check your Connection Please',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          loading: () => const Center(
                child: CupertinoActivityIndicator(),
              ));
    });
  }
}
