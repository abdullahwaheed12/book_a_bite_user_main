import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/all_orders/view.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/modules/home/state.dart';
import 'package:book_a_bite_user/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyCustomDrawer extends StatefulWidget {
  const MyCustomDrawer({Key? key}) : super(key: key);

  @override
  _MyCustomDrawerState createState() => _MyCustomDrawerState();
}

class _MyCustomDrawerState extends State<MyCustomDrawer> {
  final HomeLogic logic = Get.find<HomeLogic>();
  final HomeState state = Get.find<HomeLogic>().state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.profile);
            },
            leading: SvgPicture.asset('assets/drawerProfileIcon.svg'),
            title: Text('Profile', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.to(const AllOrdersPage(
                backNormal: true,
              ));
            },
            leading: SvgPicture.asset('assets/drawerCartIcon.svg'),
            title: Text('Orders', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.coupons);
            },
            leading: SvgPicture.asset('assets/drawerOfferIcon.svg'),
            title: Text('Coupons', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.favourites);
            },
            leading: SvgPicture.asset('assets/Favourites.svg'),
            title: Text('Favourites', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.zeroHeroes);
            },
            leading: SvgPicture.asset('assets/drawerZeroHeroIcon.svg'),
            title: Text('Zero Heroes', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.privacyPolicy);
            },
            leading: SvgPicture.asset('assets/drawerPrivacyIcon.svg'),
            title: Text('Useful Links', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.help);
            },
            leading: Image.asset('assets/Chat_bubble.png'),
            title: Text('Contact Us', style: state.drawerTitleTextStyle),
          ),
          const Spacer(),
          ListTile(
            onTap: () {
              Get.find<GeneralController>().firebaseAuthentication.signOut();
            },
            title: Row(
              children: [
                Text('Sign-out', style: state.drawerTitleTextStyle),
                const Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.white,
                  size: 25,
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
        ],
      ),
    );
  }
}
