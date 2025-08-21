import 'package:expenses/core/constants/colors.dart';
import 'package:expenses/core/extensions/string_extension.dart';
import 'package:expenses/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.item, required this.isSelected});
  final CategoryModel item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ((1.sw - 32.w) / 4) - 1,
      child: Column(
        children: [
          item.name == 'Add Category'
              ? Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: kPrimaryColor),
                ),
                child: Icon(Icons.add),
              )
              : CircleAvatar(
                radius: 24.r,
                backgroundColor: item.color.getColorFromHex().withValues(
                  alpha: 0.2,
                ),
                child: Icon(
                  item.icon.getIconFromString(),
                  color: item.color.getColorFromHex(),
                  size: 22,
                ),
              ),
          SizedBox(height: 2.h),
          Text(
            item.name,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
              color:
                  item.name == 'Add Category'
                      ? Theme.of(context).textTheme.labelMedium?.color
                      : isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.labelMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
