import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SignOutDialogWidget extends StatelessWidget {
  const SignOutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      return Column(mainAxisSize: MainAxisSize.min, children: [

        const SizedBox(height: 20),
        Icon(Icons.contact_support, size: 50, color: Theme.of(context).primaryColor),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Text(getTranslated('want_to_sign_out', context)!, style: rubikBold, textAlign: TextAlign.center),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Container(height: 0.5, color: Theme.of(context).hintColor),

        !auth.isLoading ? Row(children: [

          Expanded(child: InkWell(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).clearSharedData(context).then((condition) {
               if(context.mounted){
                 if(ResponsiveHelper.isWeb()) {
                   RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
                 }else {
                   context.pop();
                   RouterHelper.getMainRoute();
                 }
               }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
              ),
              child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
            ),
          )),

        ]) : Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        ),
      ]);
    });
  }
}
