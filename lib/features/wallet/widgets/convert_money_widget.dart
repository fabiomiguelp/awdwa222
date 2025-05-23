import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ConvertMoneyWidget extends StatefulWidget {
  const ConvertMoneyWidget({super.key});

  @override
  State<ConvertMoneyWidget> createState() => _ConvertMoneyWidgetState();
}

class _ConvertMoneyWidgetState extends State<ConvertMoneyWidget> {
  final TextEditingController _pointController = TextEditingController();


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    final List<String?>  noteList = [
      getTranslated('only_earning_point_can_converted', context),

      '${Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointExchangeRate
      } ${getTranslated('point', context)} ${getTranslated('remain', context)} ${PriceConverterHelper.convertPrice(1)}',
      getTranslated('once_you_convert_the_point', context),
      getTranslated('point_can_use_for_get_bonus_money', context),

    ];
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Text(
            getTranslated('enters_point_amount', context)!,
            style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),

          Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge).copyWith(bottom: Dimensions.paddingSizeLarge),
            width: Dimensions.webScreenWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(
                color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.1),
                offset: const Offset(-1, 1),
                blurRadius: 10,
                spreadRadius: -3,
              )]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(getTranslated('convert_point_to_wallet_money', context)!,style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor,
                )),

                Container( width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    controller: _pointController,

                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    style: rubikSemiBold.copyWith(fontSize: 34, color: Theme.of(context).textTheme.titleLarge!.color),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], //
                    decoration: InputDecoration(
                      isCollapsed : true,
                      hintText:'ex: 300',
                      border : InputBorder.none, focusedBorder: const UnderlineInputBorder(),
                      hintStyle: rubikSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.titleLarge!.color!.withValues(alpha:0.4),
                      ),

                    ),

                  ),
                ),


              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${getTranslated('note', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: noteList.map((note) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle,  size: 6, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.5)),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),

                  Flexible(
                    child: Text(note!, style: rubikRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.5),
                      fontSize: Dimensions.fontSizeDefault,
                    ), maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                ],)).toList()),
              )
            ]),
            
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),




          Consumer<WalletProvider>(
            builder: (context, walletProvider, _) {
              return walletProvider.isLoading ? const Center(child: CircularProgressIndicator()) : CustomButtonWidget(
                borderRadius: 30,
                btnTxt: getTranslated('convert_point', context), onTap: (){
                if(_pointController.text.isEmpty) {
                  showCustomSnackBarHelper(getTranslated('please_enter_your_point', context));
                }
                else{
                  double point = double.parse(_pointController.text.trim());

                  if(point < configModel!.loyaltyPointMinimumPoint!){
                    showCustomSnackBarHelper('${getTranslated('please_exchange_more_then', context)!} ${configModel.loyaltyPointMinimumPoint} ${getTranslated('points', context)!}');
                  } else {
                    walletProvider.pointToWallet(point, false).then((isSuccess) =>
                        openDialog(
                        ConvertPointDialogBox(size: size, pointController: _pointController, isSuccess: isSuccess, ),
                        isDismissible: false,
                        willPop: false)
                    );
                  }
                }

              },
              );
            }
          ),
        ],),
      ),
    );
  }
}

class ConvertPointDialogBox extends StatelessWidget {
  const ConvertPointDialogBox({
    super.key,
    required this.size,
    required this.isSuccess,
    required TextEditingController pointController,
  }) : _pointController = pointController;

  final Size size;
  final bool isSuccess;
  final TextEditingController _pointController;

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          //width: ResponsiveHelper.isDesktop(context) ? 600 : size.width * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            const SizedBox(height: Dimensions.paddingSizeExtraLarge ),
            Image.asset(Images.convertedImage, scale: 3.5),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: RichText(textAlign : TextAlign.center, text: TextSpan(children: [
                TextSpan(text: getTranslated('loyalty_point_converted_to', context)!, style: rubikSemiBold.copyWith(
                  color: Colors.black
                )),
                const TextSpan(text: ' '),

                TextSpan(text:  getTranslated(isSuccess ? 'successfully': 'failed', context
                )!,
                  style: rubikSemiBold.copyWith(
                      color: Colors.black
                  ),),
              ])),
            ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              TextButton(
                onPressed: () {
                  if(isSuccess) {
                    walletProvider.setCurrentTabButton(2);
                  }
                  context.pop();
                },
                child: Text(getTranslated(isSuccess ?
                    'check_history': 'go_back'
                    , context)!
                    , style: rubikRegular.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.error,
                  color:
                  //isSuccess ?
                  Theme.of(context).colorScheme.error
                      //: Theme.of(context).colorScheme.error,
                )),
              ),

            ],
          ),
        ),

        Positioned.fill(child: Align(alignment: Alignment.topRight,child: InkWell(
          onTap: (){
            _pointController.clear();
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.close, color: Theme.of(context).hintColor.withValues(alpha:0.7)),
          ),
        ))),
      ],
    );
  }
}
