import 'package:movie_app/core/helpers/imports_helper.dart';

class MovieListScreen extends BasePageStatefulScreen {
  const MovieListScreen({super.key});

  @override
  BaseStateful<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends BaseStateful<MovieListScreen> {
  final IndicatorController controller = IndicatorController();

  @override
  void initState() {
    callAfterFrame(() {
      if (readProvider<MovieController>().movieListModel == null) {
        MovieServices.getMoviesList();
      }
      readProvider<MovieController>().initializeScrollController();
    });
    super.initState();
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.onPrimaryColor,
        actions: [
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesPaths.moviesSearch);
              },
              child: const Icon(Icons.search)),
          width15,
        ],
        title: Text(
          "Watch",
          style: context.headlineLarge,
        ),
      ),
      body: Consumer<MovieController>(
        builder: (context, movieController, __) {
          return CustomSmartRefresher(
            onRefresh: () async {
              readProvider<LoaderProvider>().enableRefresher();
              await MovieServices.getMoviesList(isRefresh: true);
            },
            indicatorController: controller,
            child: ListView.builder(
              controller: movieController.scrollController,
              padding: EdgeInsets.all(20.h),
              itemCount: movieController.result.length,
              itemBuilder: (context, index) {
                var data = movieController.result[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        MovieServices.movieDetails((data.id ?? -1).toString())
                            .then((value) {
                          if (value) {
                            Navigator.pushNamed(
                                context, RoutesPaths.movieDetails);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(
                          bottom: padding15,
                        ),
                        child: Stack(
                          children: [
                            CommonCacheNetworkImageWidget(
                              imagePath:
                                  "${Constants.networkImageBaseUrl}${data.posterPath.toString() ?? ""}",
                              width: screenWidth,
                              height: containerWidth180,
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: screenWidth,
                                  decoration:
                                      BoxDecoration(boxShadow: bottomShadow),
                                  padding: EdgeInsets.all(padding15),
                                  child: TitleMediumText(
                                    text: data.title ?? "",
                                    textColor: context.onPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (movieController.result.length >=
                            (movieController.movieListModel?.page ?? 1) &&
                        index == movieController.result.length - 1) ...{
                      LoadMoreButton(
                        btnText: "Load more tasks",
                        onClick: () async {
                          await movieController.loadMoreTasks();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    },
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
