import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readwise/app/theme/text_styles.dart';
import 'package:readwise/presentation/common/marquee.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// default [backgroundColor] [AppTheme.colors.bg.appBar]
  const CustomAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.withLeading = true,
    this.leading,
    this.backgroundColor,
    this.scrolledUnderElevation = 1,
    this.onBackButtonTap,
    this.centerTitle = true,
  });

  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool withLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final double scrolledUnderElevation;
  final bool centerTitle;
  final VoidCallback? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: withLeading ? leading : null,
      elevation: 0,
      scrolledUnderElevation: scrolledUnderElevation,
      leadingWidth: 90,
      automaticallyImplyLeading: false,
      actions: [...actions ?? [], const Gap(16)],
      backgroundColor: backgroundColor ?? Color(0xFFF2F2F2),
      centerTitle: centerTitle,
      titleSpacing: 0,
      title: MarqueeWidget(child: title ?? Text(titleText ?? '', style: TextStyles.ui15SemiBold)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
