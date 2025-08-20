import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expenses/core/constants/colors.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/core/sl/injection_container.dart';
import 'package:expenses/bloc/dashboard/dashboard_bloc.dart';
import 'package:expenses/presentation/dashboard/widgets/balance_card.dart';
import 'package:expenses/presentation/dashboard/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc bloc;

  @override
  void initState() {
    bloc = sl<DashboardBloc>()..add(GetExpenses());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: kBGColor,
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
                              onChanged: (p0) {
                                bloc.add(GetExpenses(filter: p0!));
                              },
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See all',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state.status == RxStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.status == RxStatus.empty) {
                    return Center(child: Text('No expenses found'));
                  } else if (state.status == RxStatus.error) {
                    return Center(child: Text(state.errorMessage.toString()));
                  } else {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: state.expenses?.length ?? 0,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10.h);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ExpenseItem(item: state.expenses![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
