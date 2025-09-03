import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class ImageProfileAppbarWidget extends StatelessWidget {
  const ImageProfileAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isGuestMode =
    !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return Consumer<ProfileController>(builder: (context, profile, _) {
      return  InkWell(
        onTap: () {
          if (isGuestMode) {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) =>
                const NotLoggedInBottomSheetWidget());
          } else {
            if (profile.userInfoModel != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen1()));
            }
          }
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.white, width: 3),
                shape: BoxShape.circle,
              ),
              child: Provider.of<AuthController>(context,
                  listen: false)
                  .isLoggedIn()
                  ? CustomImageWidget(
                  image:
                  '${profile.userInfoModel?.imageFullUrl?.path}',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: Images.guestProfile)
                  : Image.asset(Images.guestProfile),
            )),
      );
    });
  }
}
