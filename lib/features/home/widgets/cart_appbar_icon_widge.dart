import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/widgets/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CartAppbarIconWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;
  final bool isWallet;
  final double? balance;
  final bool isLoyalty;
  final String? subTitle;

  const CartAppbarIconWidget({
    super.key,
    required this.image,
    required this.title,
    required this.navigateTo,
    required this.count,
    required this.hasCount,
    this.isWallet = false,
    this.balance,
    this.subTitle,
    this.isLoyalty = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(

            ///⭐ change the color of the container
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Provider.of<ThemeController>(context).darkTheme
                    ? Theme.of(context).primaryColor.withValues(alpha: .30)
                    : Colors.white),
            child: Stack(children: [
              Container(
                  height: 120,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withValues(alpha: .07),
                          width: 15),
                      borderRadius: BorderRadius.circular(100))),

              ///⭐  add image icon
              isWallet
                  ? CustomImageView(
                      imagePath: image,
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                    )
                  : Center(
                      child: Image.asset(image, color: ColorResources.white)),
              if (isWallet)
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            getTranslated(subTitle, context) ?? '',
                            style: textRegular.copyWith(color: Colors.white),
                          ),
                          isLoyalty
                              ? Text(
                                  balance != null
                                      ? balance!.toStringAsFixed(0)
                                      : '0',
                                  style:
                                      textMedium.copyWith(color: Colors.white))
                              : Text(
                                  balance != null
                                      ? PriceConverter.convertPrice(
                                          context, balance)
                                      : '0',
                                  style:
                                      textMedium.copyWith(color: Colors.white))
                        ])),
              hasCount
                  ? Positioned(
                      top: 5,
                      right: 5,
                      child: count.toString() != '0' ? Consumer<CartController>(
                          builder: (context, cart, child) {
                        return CircleAvatar(
                            radius:15,
                            backgroundColor: ColorResources.red,

                            ///TODO: ⭐  count of items in the cart
                            child: FittedBox(
                              child: Text(count.toString(),
                                  style: titilliumSemiBold.copyWith(
                                      color: Theme.of(context).cardColor,
                                      fontSize: Dimensions.fontSizeExtraSmall)),
                            ));
                      }): const SizedBox())
                  : const SizedBox(),
            ])),
      ]),
    );
  }
}
