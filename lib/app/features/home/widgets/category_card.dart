import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/app/routes/app_routes.dart';
import '/app/features/home/model/CategoryModel.dart';
import '/utils/end_points.dart';
import 'package:google_fonts/google_fonts.dart';

Widget categoryCard(CategoryData data) {
  return InkWell(
    onTap: () => Get.toNamed(AppRoutes.categoryProductScreen, arguments: data),
    child: SizedBox(
      width: Get.width * 0.26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Elegant circle image wrapper with custom background and shadow
          Container(
            height: Get.width * 0.25,
            width: Get.width * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: CachedNetworkImage(
                  imageUrl: EndPoints.mediaUrl(
                    data.categoryPictureId.toString(),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(radius: 8),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${data.categoryTitle}",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (data.categoryInfo != null &&
              data.categoryInfo!.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              "${data.categoryInfo}",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );
}
