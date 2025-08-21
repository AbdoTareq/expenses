import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expenses/core/constants/colors.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/core/router/app_routes.dart';
import 'package:expenses/core/sl/injection_container.dart';
import 'package:expenses/bloc/dashboard/dashboard_bloc.dart';
import 'package:expenses/data/model/expense_model.dart';
import 'package:expenses/presentation/dashboard/widgets/balance_card.dart';
import 'package:expenses/presentation/dashboard/widgets/custom_paged_list_view.dart';
import 'package:expenses/presentation/dashboard/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/web.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc bloc;
  final PagingController<int, ExpenseModel> pagingController = PagingController(
    firstPageKey: 1,
  );
  int page = 1;

  @override
  void initState() {
    bloc = sl<DashboardBloc>();
    pagingController.addPageRequestListener((pageKey) {
      page = pageKey;
      bloc.add(GetExpenses(page: page));
    });
    super.initState();
  }

  onSuccess(context, DashboardState state) {
    if (state.status == RxStatus.success) {
      final wrapper = state.expenses!;
      num? lastPage = (wrapper.total ?? 1) / (wrapper.limit ?? 1);
      int currentPage = pagingController.nextPageKey ?? 1;
      if (currentPage >= lastPage) {
        pagingController.appendLastPage(wrapper.data ?? []);
      } else {
        pagingController.appendPage(wrapper.data ?? [], currentPage + 1);
      }
    } else if (state.status == RxStatus.error) {
      Logger().i(state.errorMessage);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add expense')));
      pagingController.error = state.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: kBGColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final res = await context.pushNamed(Routes.addExpense);
            if (res == 'updated') {
              pagingController.refresh();
            }
          },
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.add, color: kWhiteColor),
        ),
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
              child: BlocListener<DashboardBloc, DashboardState>(
                listener: (context, state) => onSuccess(context, state),
                child: CustomPagedListView(
                  pagingController: pagingController,
                  padding: EdgeInsets.only(bottom: 100.h),
                  itemBuilder: (context, item, index) {
                    return ExpenseItem(item: item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
