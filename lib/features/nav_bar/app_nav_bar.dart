import 'package:movie_app/core/helpers/imports_helper.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieController>(
        builder: (context, dashboardProvider, __) {
      return PopScope(
        canPop: dashboardProvider.selectBtmIndex != 0 ? false : true,
        onPopInvokedWithResult: (canPop, __) {
          if (dashboardProvider.selectBtmIndex != 0) {
            dashboardProvider.setSelectedBtmIndex(0);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              // Main body content with bottom padding
              Padding(
                padding: EdgeInsets.only(bottom: 75.h),
                child: dashboardProvider.bodies[dashboardProvider.selectBtmIndex],
              ),
              
              // Custom bottom navigation bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 75.h,
                  decoration: BoxDecoration(
                    color: context.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      dashboardProvider.icons.length,
                      (index) => Expanded(
                        child: InkWell(
                          onTap: () => dashboardProvider.setSelectedBtmIndex(index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0.h),
                                child: SvgPicture.asset(
                                  dashboardProvider.icons[index],
                                  color: dashboardProvider.selectBtmIndex == index
                                      ? context.onSecondaryColor
                                      : context.darkGrey,
                                ),
                              ),
                              Text(
                                dashboardProvider.labels[index],
                                style: dashboardProvider.selectBtmIndex == index
                                    ? context.labelSmall!.copyWith(
                                        color: context.onSecondaryColor,
                                      )
                                    : context.labelSmall?.copyWith(
                                        color: context.darkGrey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
