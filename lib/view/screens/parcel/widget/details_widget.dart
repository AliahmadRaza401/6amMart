import 'package:flutter/material.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DetailsWidget extends StatelessWidget {
  final String title;
  final AddressModel address;
  const DetailsWidget({Key key, @required this.title, @required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(title, style: robotoMedium),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      Text(
        address.contactPersonName ?? '',
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
      ),

      Text(
        address.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      ),

      Text(
        address.contactPersonNumber ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      ),

    ]);
  }
}
