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
          bottomNavigationBar: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: context.secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  25.r,
                ),
                topRight: Radius.circular(
                  25.r,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              showSelectedLabels: true,
              currentIndex: dashboardProvider.selectBtmIndex,
              showUnselectedLabels: true,
              selectedItemColor: context.onSecondaryColor,
              selectedLabelStyle:
                  context.labelSmall!.copyWith(color: context.onSecondaryColor),
              unselectedLabelStyle:
                  context.labelSmall?.copyWith(color: context.darkGrey),
              unselectedItemColor: context.darkGrey,
              onTap: dashboardProvider.setSelectedBtmIndex,
              type: BottomNavigationBarType.fixed,
              items: List.generate(
                dashboardProvider.icons.length,
                (index) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.0.h),
                    child: SvgPicture.asset(
                      dashboardProvider.icons[index],
                      color: dashboardProvider.selectBtmIndex == index
                          ? context.onSecondaryColor
                          : context.darkGrey,
                    ),
                  ),
                  label: dashboardProvider.labels[index],
                ),
              ),
            ),
          ),
          body: dashboardProvider.bodies[dashboardProvider.selectBtmIndex],
        ),
      );
    });
  }
}
