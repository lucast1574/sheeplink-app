import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Symbol {
  home,
  people,
  user,
  check,
  close,
  arrow,
  bell,
  gift,
  calendar,
  camera,
  edit,
  logout,
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.symbol, {super.key, this.color, this.size = 24});
  final Symbol symbol;
  final Color? color;
  final double size;
  static const paths = {
    Symbol.edit: '<path d="m15 5 4 4M4 20l4-1L20 7a2.8 2.8 0 0 0-4-4L4 15Z"/>',
    Symbol.logout: '<path d="M9 4H4v16h5m6-12 4 4-4 4m-6-4h10"/>',
    Symbol.camera:
        '<path d="M3 7h4l2-3h6l2 3h4v13H3Z"/><circle cx="12" cy="13" r="4"/>',
    Symbol.home:
        '<path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-7H9v7H4a1 1 0 0 1-1-1Z"/>',
    Symbol.people:
        '<circle cx="9" cy="8" r="3"/><path d="M3 21v-3a6 6 0 0 1 12 0v3M16 5a3 3 0 0 1 0 6m2 4a5 5 0 0 1 3 5"/>',
    Symbol.user:
        '<circle cx="12" cy="8" r="4"/><path d="M4 22v-2a8 8 0 0 1 16 0v2"/>',
    Symbol.check: '<path d="m5 12 4 4L19 6"/>',
    Symbol.close: '<path d="m6 6 12 12M6 18 18 6"/>',
    Symbol.arrow: '<path d="M4 12h16m-6-6 6 6-6 6"/>',
    Symbol.bell:
        '<path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4"/>',
    Symbol.gift:
        '<path d="M3 10h18v4H3zM5 14v7h14v-7M12 10v11"/><path d="M12 10C3 10 5 1 9 4c2 1 3 6 3 6Zm0 0c9 0 7-9 3-6-2 1-3 6-3 6Z"/>',
    Symbol.calendar:
        '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4m10-4v4M3 11h18"/>',
  };
  @override
  Widget build(BuildContext context) {
    final ink = color ?? IconTheme.of(context).color ?? const Color(0xFF203C31);
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">${paths[symbol]}</svg>',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(ink, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
