import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';

class FullScreenImage extends StatefulWidget {
  List<FileDescriptor> files;
  FullScreenImage({Key? key, required this.files}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int itemIndexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: ()=>Navigator.pop(context),
          child: Icon(Icons.cancel_outlined, color: AppColors.white,),
        ),
        centerTitle: true,
        title: Text(
          "${itemIndexPage + 1}/${widget.files.length.toString()}",
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: Center(
        child: CarouselSlider.builder(
          itemCount: widget.files.length,
          itemBuilder: (BuildContext context, int itemIndex,
              int pageViewIndex) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 360.h,
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.files[itemIndex].url,
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          },
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              onPageChanged: (index, reason) {
                setState(() {
                  itemIndexPage = index;
                });
              },
              enlargeCenterPage: true,
              enlargeStrategy:
              CenterPageEnlargeStrategy.height,
              autoPlay: false,
              enableInfiniteScroll: false,
              initialPage: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1),
        ),
      ),
    );
  }
}
