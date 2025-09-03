import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class NotificationAppbarIconWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final bool isNotification;
  final bool isProfile;

  const NotificationAppbarIconWidget(
      {super.key,
        required this.image,
        required this.title,
        required this.navigateTo,
        this.isNotification = false,
        this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      ///TODO Navigate to  Page
      onTap:() => Navigator.push(
          context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: SizedBox(
        height: 40,
          child:  Consumer<NotificationController>(
              builder: (context, notificationController, _) {
                return Stack(
                  children: [
                    ///TODO:NOTIFICATION ICON
                    CustomAssetImageWidget(
                      image,
                      width: 25,
                      height: 25,
                      fit: BoxFit.fill,
                      color: Theme.of(context).primaryColor.withValues(alpha: .6),
                    ),
                    ///TODO:NOTIFICATION COUNT
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: Dimensions.radiusSmall,
                        backgroundColor: ColorResources.red,
                        child: FittedBox(
                          child: Text(
                              notificationController
                                  .notificationModel?.newNotificationItem
                                  .toString() ??
                                  '0',
                              style: titilliumSemiBold.copyWith(
                                  color: Theme.of(context).cardColor,
                                  fontSize: Dimensions.fontSizeExtraSmall)),
                        ),
                      ),
                    ),
                     
                  ],
                );
              }),



          ),
    );
  }
}


/*
istTile(
        trailing:  Consumer<NotificationController>(
            builder: (context, notificationController, _) {
              return CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                    notificationController
                        .notificationModel?.newNotificationItem
                        .toString() ??
                        '0',
                    style: textRegular.copyWith(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeSmall)),
              );
            }),

        leading: CustomAssetImageWidget(
          image,
          width: 25,
          height: 25,
          fit: BoxFit.fill,
          color: Theme.of(context).primaryColor.withValues(alpha: .6),
        ),

        onTap: );
 */
