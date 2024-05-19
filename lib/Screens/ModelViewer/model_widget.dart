import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../varsiables.dart';

class ModelWidget extends StatelessWidget {
  late String poster;
  late Map<String, dynamic> item;
  late bool ar;
  ModelWidget(
      {Key? key, required this.item, required this.poster, this.ar = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ModelViewer(
        backgroundColor: Colors.transparent,
        poster: poster,
        src: "${url}models/${item['model']}",
        alt: item['alternativeModelText'],
        ar: ar,
        arPlacement:
            item['placement'] == "wall" ? ArPlacement.wall : ArPlacement.floor,
        arModes: const ['scene-viewer'],
        autoRotate: false,
        cameraControls: true,
        disableZoom: true,
      ),
    );
  }
}
