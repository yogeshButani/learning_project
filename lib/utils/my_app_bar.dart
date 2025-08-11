import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? backgroundcolor;
  final double? toolbarheight;
  final bool automaticallyImplyLeading;
  final TextStyle? titleTextStyle;
  final VoidCallback? onBackTap;
  final Widget? leading;
  final Widget? action;

  const MyAppbar(
      {super.key,
      this.title,
      this.backgroundcolor,
      this.titleTextStyle,
      this.toolbarheight,
      this.onBackTap,
      this.leading,
      this.action,
      this.automaticallyImplyLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundcolor ?? Colors.transparent,
      toolbarHeight: toolbarheight ?? 73,
      actions: [action ?? const SizedBox.shrink()],
      leading: leading ??
          Visibility(
            visible: automaticallyImplyLeading,
            replacement: const SizedBox.shrink(),
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: Colors.white,
                  splashFactory: InkRipple.splashFactory,
                  onTap: onBackTap ??
                      () =>
                          Future.delayed(const Duration(milliseconds: 180), () {
                            Navigator.pop(context);
                          }),
                  borderRadius: BorderRadius.circular(20),
                  child: const SizedBox(
                    height: 35,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(title ?? "",
          style: titleTextStyle ??
              TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
