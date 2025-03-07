import 'dart:math';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IgnoreEditorSelectionGesture extends StatefulWidget {
  const IgnoreEditorSelectionGesture({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<IgnoreEditorSelectionGesture> createState() =>
      _IgnoreEditorSelectionGestureState();
}

class _IgnoreEditorSelectionGestureState
    extends State<IgnoreEditorSelectionGesture> {
  final key = Random(10000).toString();
  final FocusNode _focusNode = FocusNode();
  late final SelectionGestureInterceptor interceptor;
  late final EditorState editorState = context.read<EditorState>();

  @override
  void initState() {
    super.initState();

    interceptor = SelectionGestureInterceptor(
      key: key,
      canTap: (details) {
        final renderObject = context.findRenderObject();
        if (renderObject != null && renderObject is RenderBox) {
          final offset = renderObject.globalToLocal(details.globalPosition);
          return !renderObject.paintBounds.contains(offset);
        }
        return true;
      },
    );
    editorState.selectionService.registerGestureInterceptor(interceptor);
  }

  @override
  void dispose() {
    editorState.selectionService.unregisterGestureInterceptor(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: (value) {
        // current has focus ，close editor
        if (value) {
          editorState.selection = null;
        }
      },
      child: widget.child,
    );
  }
}
