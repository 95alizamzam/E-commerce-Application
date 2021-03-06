import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:image_picker/image_picker.dart';

class topSection extends StatelessWidget {
  const topSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = userCubit.get(context);
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
                LocaleKeys.Welcome_to_Online_Shop.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.Register_Your_Account_and_discover_our_Products.tr(),
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
                  clipBehavior: Clip.none,
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
      },
    );
  }
}
