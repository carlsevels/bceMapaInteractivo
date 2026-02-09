 import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/fullScreenImages.dart';

Widget galeria(List<String> imagenes, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(Get.context!).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagenes.isEmpty ? 1 : imagenes.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => abrirImagenPantallaCompleta(
                  context,
                  imagenes,
                  index,
                  title,
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imagenes.isEmpty
                        ? const Icon(Icons.image_outlined)
                        : Hero(
                            tag: 'img_$index',
                            child: Image.asset(
                              imagenes[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
