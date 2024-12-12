import 'package:expense_tracker/components/loading_widget.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool loading;
  final double height;

  const RoundButton(
      {Key? key,
      required this.title,
      required this.onPress,
      this.height = 50.0,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: AppColors.primaryGradient,
        ),
        child: loading
            ? const LoadingWidget()
            : Center(
                child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
      ),
    );
  }
}
