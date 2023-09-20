import 'package:book_a_bite_user/modules/all_orders/view.dart';
import 'package:book_a_bite_user/modules/cart/view.dart';
import 'package:book_a_bite_user/modules/coupons/view.dart';
import 'package:book_a_bite_user/modules/edit_profile/view.dart';
import 'package:book_a_bite_user/modules/favourites/view.dart';
import 'package:book_a_bite_user/modules/help/view.dart';
import 'package:book_a_bite_user/modules/home/view.dart';
import 'package:book_a_bite_user/modules/login/view.dart';
import 'package:book_a_bite_user/modules/login/view_phone_login.dart';
import 'package:book_a_bite_user/modules/map/view.dart';
import 'package:book_a_bite_user/modules/notifactions/view.dart';
import 'package:book_a_bite_user/modules/on_board/view.dart';
import 'package:book_a_bite_user/modules/payment/view.dart';
import 'package:book_a_bite_user/modules/pending_review/view.dart';
import 'package:book_a_bite_user/modules/preferences/view.dart';
import 'package:book_a_bite_user/modules/product_detail/view.dart';
import 'package:book_a_bite_user/modules/profile/view.dart';
import 'package:book_a_bite_user/modules/restaurant_detail/view.dart';
import 'package:book_a_bite_user/modules/saved_cards/view.dart';
import 'package:book_a_bite_user/modules/sign_up/view.dart';
import 'package:book_a_bite_user/modules/splash/view.dart';
import 'package:book_a_bite_user/modules/useful_links/view.dart';
import 'package:book_a_bite_user/modules/zero_heroes/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/forgot_password.dart/view.dart';

routes() => [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/phoneLogin", page: () => const PhoneLoginView()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/home", page: () => const HomePage()),
      GetPage(name: "/productDetail", page: () => const ProductDetailPage()),
      GetPage(
          name: "/restaurantDetail", page: () => const RestaurantDetailPage()),
      GetPage(name: "/cart", page: () => const CartPage()),
      GetPage(name: "/payment", page: () {return const PaymentPage();}),
      GetPage(name: "/allOrders", page: () => const AllOrdersPage()),
      GetPage(name: "/profile", page: () => const ProfilePage()),
      GetPage(name: "/editProfile", page: () => const EditProfilePage()),
      GetPage(name: "/pendingReview", page: () => const PendingReviewPage()),
      GetPage(name: "/help", page: () => const HelpPage()),
      GetPage(name: "/coupons", page: () => const CouponsPage()),
      GetPage(name: "/privacyPolicy", page: () => const PrivacyPolicyPage()),
      GetPage(name: "/zeroHeroes", page: () => const ZeroHeroesPage()),
      GetPage(name: "/favourites", page: () => const FavouritesPage()),
      GetPage(name: "/savedCards", page: () => const SavedCardsPage()),
      GetPage(name: "/notifications", page: () => const NotificationsPage()),
      GetPage(name: "/onBoard", page: () => const OnBoardPage()),
      GetPage(name: "/map", page: () => const MapPage()),
      GetPage(name: "/preferences", page: () => const PreferencesPage()),
      GetPage(name: "/forgetPassword", page: () => const ForgotPassword()),

    ];

class PageRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String phoneLogin = '/phoneLogin';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String restaurantDetail = '/restaurantDetail';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String allOrders = '/allOrders';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String pendingReview = '/pendingReview';
  static const String help = '/help';
  static const String coupons = '/coupons';
  static const String privacyPolicy = '/privacyPolicy';
  static const String zeroHeroes = '/zeroHeroes';
  static const String favourites = '/favourites';
  static const String savedCards = '/savedCards';
  static const String notifications = '/notifications';
  static const String onBoard = '/onBoard';
  static const String map = '/map';
  static const String preferences = '/preferences';
  static const String forgetPassword = '/forgetPassword';

  //not used in entire project
  Map<String, WidgetBuilder> routes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      phoneLogin: (context) => const PhoneLoginView(),
      signUp: (context) => const SignUpPage(),
      home: (context) => const HomePage(),
      productDetail: (context) => const ProductDetailPage(),
      restaurantDetail: (context) => const RestaurantDetailPage(),
      cart: (context) => const CartPage(),
      payment: (context) => const PaymentPage(),
      allOrders: (context) => const AllOrdersPage(),
      profile: (context) => const ProfilePage(),
      editProfile: (context) => const EditProfilePage(),
      pendingReview: (context) => const PendingReviewPage(),
      help: (context) => const HelpPage(),
      coupons: (context) => const CouponsPage(),
      privacyPolicy: (context) => const PrivacyPolicyPage(),
      zeroHeroes: (context) => const ZeroHeroesPage(),
      favourites: (context) => const FavouritesPage(),
      savedCards: (context) => const SavedCardsPage(),
      notifications: (context) => const NotificationsPage(),
      onBoard: (context) => const OnBoardPage(),
      map: (context) => const MapPage(),
      preferences: (context) => const PreferencesPage(),
      forgetPassword: (context) => const ForgotPassword(),

    };
  }
}
