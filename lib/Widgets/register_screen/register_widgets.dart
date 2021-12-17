import 'package:flutter/material.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';

class textField extends StatelessWidget {
  const textField({
    Key? key,
    required this.type,
    required this.hint,
    required this.label,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.controller,
    required this.validate,
    required this.cubit,
    required this.isSecure,
  }) : super(key: key);

  final TextInputType type;
  final String hint;
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final Function validate;
  final userCubit cubit;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: primaryColor,
        ),
      ),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        obscureText: isSecure,
        style: TextStyle(
          color: primaryColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: primaryColor),
          labelText: label,
          labelStyle: TextStyle(color: primaryColor),
          prefixIcon: Icon(
            prefixIcon,
            color: primaryColor,
          ),
          border: InputBorder.none,
          suffixIcon: Icon(suffixIcon) == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    cubit.changeSecure();
                  },
                  icon: Icon(
                    suffixIcon,
                    color: primaryColor,
                  ),
                ),
        ),
        validator: (String? value) => validate(value),
      ),
    );
  }
}
