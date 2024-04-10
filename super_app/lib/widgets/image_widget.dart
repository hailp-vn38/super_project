import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:string_validator/string_validator.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/widgets/widgets.dart';

import '../app/constants/assets.dart';

enum ImageType { file, network, base64, none }

class ImageWidget extends StatefulWidget {
  const ImageWidget(
      {super.key, this.image, this.httpHeaders, this.loading = false});
  final String? image;
  final Map<String, String>? httpHeaders;
  final bool loading;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late String? _image;
  ImageType _type = ImageType.none;
  Uint8List? _bytes;
  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    try {
      _image = widget.image;
      if (_image == null || _image == "") {
        _type = ImageType.none;
      } else if (isURL(_image)) {
        _type = ImageType.network;
      } else if (isBase64(_image!)) {
        _type = ImageType.base64;
        _bytes = base64Decode(_image!);
      } else if (File(_image!).existsSync()) {
        _type = ImageType.file;
      } else {
        _type = ImageType.none;
      }
      setState(() {});
    } catch (err) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_type) {
      ImageType.none => _noneWidget(),
      ImageType.network => CachedNetworkImage(
          imageUrl: _image!,
          placeholder: (context, url) => _loadingWidget(),
          errorWidget: (context, url, error) => _loadingWidget(),
          fit: BoxFit.cover,
          httpHeaders: widget.httpHeaders,
        ),
      ImageType.base64 => Image.memory(
          _bytes!,
          fit: BoxFit.cover,
        ),
      ImageType.file => Image.file(File(_image!)),
    };
  }

  Widget _loadingWidget() {
    if (widget.loading) {
      return SizedBox(
        width: context.width,
        height: 300,
        child: const LoadingWidget(
          radius: 10,
        ),
        // child: const SpinKitFadingCircle(
        //   color: Colors.grey,
        // ),
      );
    }
    return Image.asset(
      AppAssets.backgroundBook,
      fit: BoxFit.cover,
    );
  }

  Widget _noneWidget() {
    return Image.asset(
      AppAssets.backgroundBook,
      fit: BoxFit.cover,
    );
  }
}
