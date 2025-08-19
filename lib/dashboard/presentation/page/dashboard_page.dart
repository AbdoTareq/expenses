import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expenses/core/constants/colors.dart';
import 'package:expenses/dashboard/presentation/widgets/balance_card.dart';
import 'package:expenses/dashboard/presentation/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 324.h,
                width: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: CircleAvatar(
                          radius: 30.h,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=4",
                          ),
                        ),
                        title: Text(
                          "Good Morning",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .8),
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Shihab Rahman",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: SizedBox(
                          width: 160,
                          child: CustomDropdown(
                            closedHeaderPadding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 12.w,
                            ),
                            initialItem: 'This month',
                            items: ['This month', 'Last month', 'Last year'],
                            onChanged: (p0) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(children: [SizedBox(height: 150.h), BalanceCard()]),
            ],
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Expenses',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'See all',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
