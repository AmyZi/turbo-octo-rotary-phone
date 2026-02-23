import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class SliderItemWidget extends StatefulWidget {
  final List<String> imageList;
  final double height;
  final bool fromNetwork;
  final Function(int) onClick;
  final BoxFit fit;
  final AlignmentGeometry dotsAlignment;
  final Color dotsColorActive;
  final Color dotsColorInactive;
  final double dotsMarginBottom;
  final bool useDots;
  final bool autoSlide;
  final Duration slideChangeDuration;
  final int initIndex;
  final bool showDownloadButton;
  final bool useArrowButton;

  const SliderItemWidget({
    super.key,
    required this.imageList,
    this.height = 180,
    required this.onClick,
    this.fromNetwork = true,
    this.fit = BoxFit.cover,
    this.dotsAlignment = Alignment.bottomLeft,
    this.dotsColorActive = Colors.green,
    this.dotsColorInactive = Colors.grey,
    this.dotsMarginBottom = 10,
    this.useDots = true,
    this.autoSlide = true,
    this.slideChangeDuration = const Duration(seconds: 6),
    required this.initIndex,
    required this.showDownloadButton,
    this.useArrowButton = false
  });

  @override
  State<SliderItemWidget> createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItemWidget> {
  PageController? controller;
  int currentIndex = 0;
  Timer? timer;

  void incrementCurrent(int position) {
    setState(() {
      if (currentIndex <= widget.imageList.length - 1) {
        currentIndex = position;
      } else {
        currentIndex = 0;
      }
    });
  }

  void onChange(int? position) {
    if (position != null) {
      incrementCurrent(position);
    }
  }

  void initializeTimer() async {
    timer = Timer.periodic(widget.slideChangeDuration, (timer) {
      if (currentIndex <= widget.imageList.length - 2) {
        controller?.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        controller?.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.initIndex;
    });
    controller = PageController(
      initialPage: widget.initIndex,
    );
    if (widget.autoSlide) {
      initializeTimer();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(children: <Widget>[
        PageView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.imageList.length,
          onPageChanged: (position) => onChange(position),
          itemBuilder: (context, index) {
            return GestureDetector(
              //  onTap: () => widget.onClick(index),
              child: Stack(children: [
                checkFileType(widget.imageList[index]) ?
                widget.fromNetwork ?
                Center(child: ImageWidget(image: widget.imageList[index],fit: widget.fit)) :
                Center(child: Image.asset(widget.imageList[index], fit: widget.fit)) :
                Center(child: Text(widget.imageList[index].split('/').last)),

                if(widget.showDownloadButton)
                  Positioned(
                      right: 30,bottom: 30,
                      child: InkWell(
                        onTap: ()=> widget.onClick(index),
                        child: Container(
                          height: 40, width: 40 ,
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                          child: Image.asset(Images.downloadIcon),
                        ),
                      )
                  )
              ]),
            );
          },
        ),

        if(widget.useArrowButton)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                currentIndex == 0 ?
                const SizedBox() :
                InkWell(
                  onTap: ()=> _changePage(false),
                  child: Image.asset(Images.backwardIcon,height: 40,width: 40,color: Theme.of(context).textTheme.bodyMedium!.color),
                ),

                currentIndex == widget.imageList.length -1 ?
                const SizedBox() :
                InkWell(
                  onTap: ()=> _changePage(true),
                  child: Image.asset(Images.forwardIcon,height: 40,width: 40,color: Theme.of(context).textTheme.bodyMedium!.color),
                ),
              ]),
            ),
          ),

        widget.useDots ?
        Align(
          alignment: widget.dotsAlignment,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
            child: Container(
              height: 8,
              margin: EdgeInsets.only(bottom: widget.dotsMarginBottom),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.imageList.length,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 12,
                    width: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: currentIndex == index ?
                    BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.dotsColorActive) :
                    BoxDecoration(shape: BoxShape.circle, color: widget.dotsColorInactive),
                  );
                },
              ),
            ),
          ),
        ) :
        const SizedBox()
      ]),
    );
  }

  void _changePage(bool isNextPage){
    if(isNextPage){
      controller?.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }else{
      controller?.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  bool checkFileType(String item){
    if(item.contains('png')){
      return true;
    }else if(item.contains('jpg')){
      return true;
    } else if(item.contains('jpeg')){
      return true;
    }else{
      return false;
    }
  }
}
