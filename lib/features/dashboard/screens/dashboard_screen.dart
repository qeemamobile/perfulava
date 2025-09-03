import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/models/navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/dashboard_menu_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/app_exit_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/more_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    Provider.of<FlashDealController>(context, listen: false)
        .getFlashDealList(true, true);
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListController>(context, listen: false).getWishList();
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 0);
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 1);
      Provider.of<RestockController>(context, listen: false)
          .getRestockProductList(1, getAll: true);
    }

    final SplashController splashController =
        Provider.of<SplashController>(context, listen: false);
    singleVendor = splashController.configModel?.businessMode == "single";
    Provider.of<SearchProductController>(context, listen: false)
        .getAuthorList(null);
    Provider.of<SearchProductController>(context, listen: false)
        .getPublishingHouseList(null);

    if (splashController.configModel!.activeTheme == "default") {
      HomePage.loadData(false);
    } else if (splashController.configModel!.activeTheme == "theme_aster") {
      AsterThemeHomeScreen.loadData(false);
    } else {
      FashionThemeHomePage.loadData(false);
    }

    ///todo:  //⭐  NavigationModel
    _screens = [
      NavigationModel(
        name: 'home',
        icon: Images.homeImage,
        screen: (splashController.configModel!.activeTheme == "default")
            ? const HomePage()
            : (splashController.configModel!.activeTheme == "theme_aster")
                ? const AsterThemeHomeScreen()
                : const FashionThemeHomePage(),
      ),
      NavigationModel(
          name: 'categories',
          icon: Images.category,
          screen: const CategoryScreen(
            showBackButton: false,
          )),
      NavigationModel(
          name: 'orders',
          icon: Images.orderIcon,
          screen: const OrderScreen(isBacButtonExist: false)),
      NavigationModel(
        name: 'My Fav',
        icon: Images.wishImage,
        screen: const WishListScreen(
          isBacButtonExist: false,
        ),
      ),
      NavigationModel(
          name: 'My Account', icon: Images.myAcc, screen: const MoreScreen()),
    ];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (_pageIndex != 0) {
            _setPage(0);
            return;
          } else {
            await Future.delayed(const Duration(milliseconds: 150));
            if (context.mounted) {
              if (!Navigator.of(context).canPop()) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: Get.context!,
                    builder: (_) => const AppExitCard());
              }
            }
          }
          return;
        },
        child: Scaffold(
            key: _scaffoldKey,
            body:
                PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
            bottomNavigationBar: CurvedNavigationBar(
              index: _pageIndex,
              height: 65.0,
              items: _getCurvedNavigationItems(),
              color: Theme.of(context).cardColor,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 50),
              onTap: (index) => _setPage(index),
              letIndexChange: (index) => true,
            )));
  }

  void _setPage(int pageIndex) {
    setState(() {
      if (pageIndex == 1 && _pageIndex != 1) {
        Provider.of<ChatController>(context, listen: false)
            .setUserTypeIndex(context, 0);
        Provider.of<ChatController>(context, listen: false)
            .resetIsSearchComplete();
      }
      _pageIndex = pageIndex;
    });
  }

  List<CurvedNavigationBarItem> _getCurvedNavigationItems() {
    List<CurvedNavigationBarItem> items = [];

    for (int index = 0; index < _screens.length; index++) {
      items.add(
        CurvedNavigationBarItem(
          child: Image.asset(
            _screens[index].icon,
            height: 24,
            width: 24,
            color: _pageIndex == index
                ? Theme.of(context).primaryColor
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
          ),
          label: _screens[index].name,
          labelStyle: TextStyle(
            color: _pageIndex == index
                ? Theme.of(context).primaryColor
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
            fontSize: 12,
            fontWeight:
                _pageIndex == index ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      );
    }

    return items;
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for (int index = 0; index < _screens.length; index++) {
      list.add(Expanded(
          child: CustomMenuWidget(
              isSelected: _pageIndex == index,
              name: _screens[index].name,
              icon: _screens[index].icon,
              showCartCount: _screens[index].showCartIcon ?? false,
              onTap: () => _setPage(index))));
    }
    return list;
  }
}
