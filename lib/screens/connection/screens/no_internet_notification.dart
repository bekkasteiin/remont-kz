import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/screens/connection/widgets/app_notification.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';

class NoInternetNotification extends StatelessWidget {
  final VoidCallback? close;

  // final _connectionStore = getIt.get<Stores>().connectionStore;

  const NoInternetNotification({Key? key, this.close}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final l10n = L10n.of(context);

    return AppNotification(
      opacity: AppColors.toastNotificationOpacity,
      onCloseTap: close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'l10n.noConnection',
            // style: context.bodyPrimary.copyWith(
            //   color: MColors.white,
            // ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const HBox(10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(123.w, 26.h),
            ),
            onPressed: () => _onRefreshClick(),
            child: const Text('l10n.refresh'),
          )
        ],
      ),
    );
  }

  void _onRefreshClick() {
    // _connectionStore.updateConnected();
  }
}
