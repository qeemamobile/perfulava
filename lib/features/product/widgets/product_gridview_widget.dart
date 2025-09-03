import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/product_item_gridview_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:provider/provider.dart';

class ProductGridviewWidget extends StatelessWidget {
  final bool isHomePage;
  final ProductType productType;

  const ProductGridviewWidget({super.key, required this.isHomePage, required this.productType});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = [];

        if (productType == ProductType.latestProduct) {
          productList = prodProvider.lProductList;
        } else if (productType == ProductType.featuredProduct) {
          productList = prodProvider.featuredProductList;
        } else if (productType == ProductType.topProduct) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.bestSelling) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.newArrival) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.justForYou) {
          productList = prodProvider.justForYouProduct;
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter == 0 &&
                !prodProvider.filterIsLoading) {
              _loadMoreProducts(context, prodProvider);
            }
            return false;
          },
          child: Stack(
            children: [
              !prodProvider.filterFirstLoading
                  ? (productList != null && productList.isNotEmpty)
                  ? SizedBox(
                height: MediaQuery.sizeOf(context).width * 0.6,
                child: GridView.builder(
                  itemCount: isHomePage
                      ? productList.length > 4
                      ? 4
                      : productList.length
                      : productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isDesktop(context)
                        ? 4
                        : ResponsiveHelper.isTab(context)
                        ? 3
                        : 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return FittedBox(
                      child: ProductItemGridviewWidget(
                        productModel: productList![index],
                      ),
                    );
                  },
                ),
              )
                  : const NoInternetOrDataScreenWidget(isNoInternet: false)
                  : ProductShimmer(
                  isHomePage: isHomePage, isEnabled: prodProvider.firstLoading),

              prodProvider.filterIsLoading
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void _loadMoreProducts(BuildContext context, ProductController prodProvider) {
    late int pageSize;
    int offset = 1;

    if (productType == ProductType.bestSelling ||
        productType == ProductType.topProduct ||
        productType == ProductType.newArrival ||
        productType == ProductType.discountedProduct ||
        productType == ProductType.featuredProduct) {
      if (productType == ProductType.featuredProduct) {
        pageSize = (prodProvider.featuredPageSize! / 10).ceil();
        offset = prodProvider.lOffsetFeatured;
      } else {
        pageSize = (prodProvider.latestPageSize! / 10).ceil();
        offset = prodProvider.lOffset;
      }
    } else if (productType == ProductType.justForYou) {

    }

    if (offset < pageSize) {
      offset++;
      prodProvider.showBottomLoader();
      if (productType == ProductType.featuredProduct) {
        prodProvider.getFeaturedProductList(offset.toString());
      } else {
        prodProvider.getLatestProductList(offset);
      }
    }
  }
}