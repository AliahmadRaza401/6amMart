import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/text_hover.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final bool visibility;
  const FooterView({Key key, @required this.child, this.minHeight = 0.65, this.visibility = true}) : super(key: key);

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> {
  TextEditingController _newsLetterController = TextEditingController();
  Color _color = Colors.white;
  ConfigModel _config = Get.find<SplashController>().configModel;

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      ConstrainedBox(
        constraints: BoxConstraints(minHeight: (widget.visibility && ResponsiveHelper.isDesktop(context)) ? MediaQuery.of(context).size.height * widget.minHeight : MediaQuery.of(context).size.height *0.7) ,
        child: widget.child,
      ),

      (widget.visibility && ResponsiveHelper.isDesktop(context)) ? Container(
        color: Color(0xFF42514A),
        width: context.width,
        margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
        child: Center(child: Column(children: [

          SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),

                Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    AppConstants.APP_NAME,
                    style: robotoBold.copyWith(fontSize: 40, color: _color),
                  ),
                ]),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text('news_letter'.tr, style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Text('subscribe_to_out_new_channel_to_get_latest_updates'.tr, style: robotoRegular.copyWith(color: _color, fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                  ),
                  child: Row(children: [
                    SizedBox(width: 20),
                    Expanded(child: TextField(
                      controller: _newsLetterController,
                      style: robotoMedium.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'your_email_address'.tr,
                        hintStyle: robotoRegular.copyWith(color: Colors.grey,fontSize: Dimensions.fontSizeSmall),
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                    )),
                    GetBuilder<SplashController>(builder: (splashController) {
                      return !splashController.isLoading ? InkWell(
                        onTap: () {
                          String _email = _newsLetterController.text.trim().toString();
                          if (_email.isEmpty) {
                            showCustomSnackBar('enter_email_address'.tr);
                          }else if (!GetUtils.isEmail(_email)) {
                            showCustomSnackBar('enter_a_valid_email_address'.tr);
                          }else{
                            Get.find<SplashController>().subscribeMail(_email).then((value) {
                              if(value) {
                                _newsLetterController.clear();
                              }
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Text('subscribe'.tr, style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
                        ),
                      ) : Center(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: CircularProgressIndicator(),
                      ));
                    }),
                  ]),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              ])),

              Expanded(flex: 4, child: Column(children: [
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),

                (_config.landingPageLinks.appUrlAndroidStatus == '1' || _config.landingPageLinks.appUrlIosStatus == '1') ? Text(
                  'download_our_apps'.tr, style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeExtraLarge),
                ) : SizedBox(),
                SizedBox(height: (_config.landingPageLinks.appUrlAndroidStatus == '1' || _config.landingPageLinks.appUrlIosStatus == '1')
                    ? Dimensions.PADDING_SIZE_LARGE : 0),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _config.landingPageLinks.appUrlAndroidStatus == '1' ? InkWell(
                    onTap: () => _launchURL(_config.landingPageLinks.appUrlAndroid ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Image.asset(Images.landing_google_play, height: 40, fit: BoxFit.contain),
                    ),
                  ) : SizedBox(),
                  _config.landingPageLinks.appUrlIosStatus == '1' ? InkWell(
                    onTap: () => _launchURL(_config.landingPageLinks.appUrlIos ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Image.asset(Images.landing_app_store, height: 40, fit: BoxFit.contain),
                    ),
                  ) : SizedBox(),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                if(_config.socialMedia.length != null
                && _config.socialMedia.length > 0)  GetBuilder<SplashController>(builder: (splashController) {
                  return Column(children: [

                    Text(
                      'follow_us_on'.tr,
                      style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    SizedBox(height: 50, child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: splashController.configModel.socialMedia.length,
                      itemBuilder: (context, index) {
                        String name = splashController.configModel.socialMedia[index].name;
                        String icon;
                        if(name == 'facebook'){
                          icon = Images.facebook;
                        }else if(name == 'linkedin'){
                          icon = Images.linkedin;
                        } else if(name == 'youtube'){
                          icon = Images.youtube;
                        }else if(name == 'twitter'){
                          icon = Images.twitter;
                        }else if(name == 'instagram'){
                          icon = Images.instagram;
                        }else if(name == 'pinterest'){
                          icon = Images.pinterest;
                        }
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: InkWell(
                            onTap: () async {
                              String _url = splashController.configModel.socialMedia[index].link;
                              if(!_url.startsWith('https://')) {
                                _url = 'https://' + _url;
                              }
                              _url = _url.replaceFirst('www.', '');
                              if(await canLaunch(_url)) {
                                _launchURL(_url);
                              }
                            },
                            child: Image.asset(icon, height: 30, width: 30, fit: BoxFit.contain),
                          ),
                        );

                      },
                    )),

                  ]);
                }),
              ])) ,

              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),

                Text('my_account'.tr, style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                FooterButton(title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                FooterButton(title: 'address'.tr, route: RouteHelper.getAddressRoute()),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                FooterButton(title: 'my_orders'.tr, route: RouteHelper.getOrderRoute()),

                SizedBox(height: _config.toggleStoreRegistration ? Dimensions.PADDING_SIZE_SMALL : 0),
                _config.toggleStoreRegistration ? FooterButton(
                  title: 'become_a_seller'.tr, url: true, route: '${AppConstants.BASE_URL}/store/apply',
                ) : SizedBox(),

                SizedBox(height: _config.toggleDmRegistration ? Dimensions.PADDING_SIZE_SMALL : 0),
                _config.toggleDmRegistration ? FooterButton(
                  title: 'become_a_delivery_man'.tr, url: true, route: '${AppConstants.BASE_URL}/deliveryman/apply',
                ) : SizedBox(),

              ])),

              Expanded(flex: 2,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),

                Text('quick_links'.tr, style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                FooterButton(title: 'contact_us'.tr, route: RouteHelper.getSupportRoute()),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                FooterButton(title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                FooterButton(title: 'terms_and_condition'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                FooterButton(title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),

              ])),
            ],
            ),
          ),
          Divider(thickness: 0.5, color: Theme.of(context).disabledColor),

          Text(
            _config.footerText ?? '',
            style: robotoRegular.copyWith(color: _color, fontSize: Dimensions.fontSizeExtraSmall),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        ])),
      ) : SizedBox.shrink(),

    ]);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FooterButton extends StatelessWidget {
  final String title;
  final String route;
  final bool url;
  const FooterButton({@required this.title, @required this.route, this.url = false});

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return InkWell(
        hoverColor: Colors.transparent,
        onTap: route.isNotEmpty ? () async {
          if(url) {
            if(await canLaunch(route)) {
              launch(route);
            }
          }else {
            Get.toNamed(route);
          }
        } : null,
        child: Text(title, style: hovered ? robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)
            : robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall)),
      );
    });
  }
}
