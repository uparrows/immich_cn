import 'package:flutter/material.dart';
import 'package:immich_mobile/shared/ui/confirm_dialog.dart';

class UploadDialog extends ConfirmDialog {
  final Function onUpload;

  const UploadDialog({Key? key, required this.onUpload})
      : super(
          key: key,
          title: 'upload_dialog_title',
          content: 'upload_dialog_info',
          cancel: 'upload_dialog_cancel',
          ok: 'upload_dialog_ok',
          onOk: onUpload,
        );
}
