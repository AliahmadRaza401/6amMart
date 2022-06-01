import 'package:flutter/material.dart';

class OverlayHandler {
  OverlayEntry? overlayEntry;

  insertOverlay(BuildContext context, OverlayEntry overlay) {
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }
    overlayEntry = null;
    Overlay.of(context)?.insert(overlay);
    overlayEntry = overlay;
  }

  removeOverlay(BuildContext context) {
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }
    overlayEntry = null;
  }
}
