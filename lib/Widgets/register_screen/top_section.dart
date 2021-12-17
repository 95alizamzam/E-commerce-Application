import 'package:flutter/material.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';

class topSection extends StatelessWidget {
  const topSection({Key? key, required this.cubit}) : super(key: key);
  final userCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: primaryColor,
          )),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Online Shop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Register Your Account and discover our Products',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: primaryColor,
                  backgroundImage: cubit.image == null
                      ? null
                      : Image.file(cubit.image!).image,
                ),
                Positioned(
                  bottom: 5,
                  right: -10,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text('From Gallery'),
                                  onTap: () {
                                    cubit.pickUserImage(
                                        src: ImageSource.gallery);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text('From Camera'),
                                  onTap: () {
                                    cubit.pickUserImage(
                                        src: ImageSource.camera);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add_a_photo,
                      color: secondaryColor,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
