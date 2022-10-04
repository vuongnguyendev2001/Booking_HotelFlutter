import 'package:app_booking/component/app_large_text.dart';
import 'package:app_booking/component/responsive_button.dart';
import 'package:app_booking/component/text_app.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../component/button.dart';
import 'gegister.dart';
import 'login.dart';

class Welcome extends StatefulWidget{
  const Welcome({Key? key}) :super(key: key);
  static const String id ='welcome_screen';
  @override
  State<Welcome> createState() => _WelComeState();
}

class _WelComeState extends State<Welcome> with SingleTickerProviderStateMixin{
  AnimationController? controller;
  Animation? animation;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = ColorTween(begin: Colors.blue, end: Colors.white).animate(controller!);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose(){
    controller!.dispose();
    super.dispose();
  }
  List images = [
    "img.png",
    "img_2.png",
    "img_1.png",
  ];
  List textName = [
    "Bà Nà Hills",
    "Bãi Sao",
    "Thành phố mộng mơ",
  ];
  List textAddress = [
    "Đà Nẵng",
    "Phú Quốc",
    "Đà Lạt",
  ];
  List textDiscription = [
    "Với kiến trúc thời Pháp thuộc địa, đặc biệt là Cầu Vàng huyền"
        " thoại xuất hiện trên khắp mặt báo quốc tế.",
    "Bãi biển với bờ cát trắng mịn dài, nước trong màu xanh ngọc ở Phú Quốc",
    "Với khí hậu trong lành, mát mẻ quanh năm, Đà Lạt là 1 điểm du lịch lý tưởng không thể bỏ qua trong bất kể các mùa trong năm.",
    ];
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body: PageView.builder(
         scrollDirection: Axis.vertical,
         itemCount: images.length,
         itemBuilder: (_, index){
           return Container(
             width: double.maxFinite,
             height: double.maxFinite,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage(
                   "lib/asset/images_welcome/" + images[index],
                 ),
                 fit: BoxFit.cover,
               )
             ),
             child: Container(
               margin: EdgeInsets.only(top: 110, left: 20, right: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       AppLargeText(text: textName[index]),
                       AppText(text: textAddress[index],color: Colors.black87, size: 25,),
                       SizedBox(height: 18,),
                       Container(
                         width: 250,
                         child: AppText(
                           text: textDiscription[index],
                           color: Colors.black87,
                         ),
                       ),
                       SizedBox(height: 36,),
                       ResponsiveButton(),
                     ],
                   ),

                   Column(
                     children: List.generate(3, (indexDots){
                       return Container(
                         margin: EdgeInsets.only(bottom: 4),
                         width: 10,
                         height: index == indexDots?30:8,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(8),
                           color: index == indexDots ? Colors.white : Colors.white60,
                         ),
                       );
                     }),
                   ),
                 ],
               ),
             ),
           );
         },
       ),
     );
  }
}

