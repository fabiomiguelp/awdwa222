import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:go_router/go_router.dart';

class CategoryHoverWidget extends StatelessWidget {
  final List<CategoryModel>? categoryList;
  const CategoryHoverWidget({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(
        children: categoryList!.map((category) => InkWell(
          onTap: () async {
            Future.delayed(const Duration(milliseconds: 100)).then((value) async{
              if(context.mounted){
                RouterHelper.getCategoryRoute(category);
                context.pop();
                RouterHelper.getCategoryRoute(category);
              }
            });
          },
          child: OnHoverWidget(
            builder: (isHover) {
              String? name = '';
              category.name!.length > 25 ? name = '${category.name!.substring(0, 25)} ...' : name = category.name;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: isHover ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(name!, overflow: TextOverflow.ellipsis),
                    ),
                    const Icon(Icons.chevron_right, size: Dimensions.paddingSizeDefault),
                  ],
                ),
              );
            },
          ),
        )).toList()
        // [
        //   Text(_categoryList[5].name),
        // ],
      ),
    );
  }
}
