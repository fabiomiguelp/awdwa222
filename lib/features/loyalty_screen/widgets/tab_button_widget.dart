import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/features/wallet/screens/wallet_screen.dart';
import 'package:provider/provider.dart';

class TabButtonWidget extends StatelessWidget {
  final TabButtonModel? tabButtonModel;
  const TabButtonWidget({
    super.key, this.tabButtonModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          return InkWell(
            hoverColor: Colors.transparent,
            radius: 10,
            highlightColor: Colors.transparent,
            onTap: ()=> walletProvider.setCurrentTabButton(tabButtonList.indexOf(tabButtonModel)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                  color: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? [BoxShadow(
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.1),
                    blurRadius: 15, offset: const Offset(0, 4),
                  )] : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Image.asset(
                  tabButtonModel!.buttonIcon, height: 20, width: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall,),

                Text(tabButtonModel!.buttonText!,
                  style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
            ),
          );
        }
    );
  }
}