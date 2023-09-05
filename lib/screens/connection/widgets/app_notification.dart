import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';

class AppNotification extends StatelessWidget {
  final Widget child;
  final double opacity;
  final VoidCallback? onCloseTap;

  const AppNotification({Key? key, required this.child, this.opacity = 1, this.onCloseTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.fromLTRB(10.w, 12.h, 14.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child),
          if (onCloseTap != null) ...[
            WBox(10.w),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const Text('Assets.icons.whiteCross.svg()'),
              onTap: onCloseTap,
            ),
          ],
        ],
      ),
    );
  }
}
