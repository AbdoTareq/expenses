import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expenses/bloc/add_expense/add_expense_bloc.dart';
import 'package:expenses/core/constants/colors.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/core/sl/injection_container.dart';
import 'package:expenses/data/model/category_model.dart';
import 'package:expenses/data/model/expense_model.dart';
import 'package:expenses/presentation/add_expense/widgets/text_input.dart';
import 'package:expenses/presentation/add_expense/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late AddExpenseBloc bloc;
  var selectedCategory = ValueNotifier(CategoryModel());
  var selectedCurrency = ValueNotifier('LE');
  var selectedCategoryIcon = ValueNotifier('');
  var selectedImagePath = ValueNotifier('');
  List<CategoryModel> categories = [
    CategoryModel(color: '#ff1b55f3', icon: 'home', name: 'Groceries'),
    CategoryModel(color: '#ffffb74d', icon: 'movie', name: 'Entertainment'),
    CategoryModel(color: '#ffeda6b2', icon: 'Gas', name: 'Gas'),
    CategoryModel(color: '#ff5777d1', icon: 'Shopping', name: 'Shopping'),
    CategoryModel(color: '#fffad8b8', icon: 'news', name: 'News Paper'),
    CategoryModel(
      color: '#ff5777d1',
      icon: 'directions_car',
      name: 'Transportation',
    ),
    CategoryModel(color: '#fffad8b8', icon: 'Rent', name: 'Rent'),
  ];
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    bloc = sl<AddExpenseBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          title: Text(
            'Add Expense',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: kWhiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomDropdown<CategoryModel>(
                    closedHeaderPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 12.w,
                    ),
                    decoration: CustomDropdownDecoration(
                      closedFillColor: kGrey3,
                    ),
                    items: categories,
                    onChanged: (p0) {
                      selectedCategory.value = p0!;
                    },
                  ),
                  Text(
                    'Currency',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomDropdown<String>(
                    closedHeaderPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 12.w,
                    ),
                    decoration: CustomDropdownDecoration(
                      closedFillColor: kGrey3,
                    ),
                    items: ['EGP', 'AED', 'SAR'],
                    onChanged: (p0) {
                      selectedCurrency.value = p0!;
                    },
                  ),
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextInput(
                    controller: amountController,
                    inputType: TextInputType.number,
                    hint: r'LE 50,000',
                  ),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextInput(
                    controller: dateController,
                    hint: '02/01/24',
                    disableInput: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then(
                        (value) =>
                            dateController.text = value.toString().substring(
                              0,
                              9,
                            ),
                      );
                    },
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  Text(
                    'Attach Receipt',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: selectedImagePath,
                    builder: (context, value, child) {
                      return TextInput(
                        autofillHints: const [AutofillHints.name],
                        inputType: TextInputType.name,
                        hint: 'Upload Image',
                        disableInput: true,
                        suffixIcon: const Icon(Icons.camera_alt),
                        prefixIcon:
                            value.isEmpty
                                ? null
                                : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                  ),
                                  child: Image.file(File(value), height: 40.h),
                                ),
                        onTap: () async {
                          var file = await bloc.pickFile();
                          if (file != null) {
                            selectedImagePath.value = file;
                          }
                        },
                        validate:
                            (value) =>
                                (selectedImagePath.value.isNotEmpty)
                                    ? null
                                    : 'Required',
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    runSpacing: 20.h,
                    children:
                        [...categories, CategoryModel(name: 'Add Category')]
                            .map(
                              (e) => ValueListenableBuilder<String>(
                                valueListenable: selectedCategoryIcon,
                                builder: (context, value, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (e.name != 'Add Category') {
                                        selectedCategoryIcon.value = e.icon;
                                      }
                                    },
                                    child: CategoryChip(
                                      item: e,
                                      isSelected: e.icon == value,
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            height: 52.h,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(kPrimaryColor),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  bloc.add(
                    AddExpenseEvent(
                      ExpenseModel(
                        category: selectedCategory.value.copyWith(
                          icon: selectedCategoryIcon.value,
                        ),
                        currency: selectedCurrency.value,
                        convertedAmount: amountController.text,
                        date: dateController.text,
                        amount: amountController.text,
                        receipt: selectedImagePath.value,
                      ),
                    ),
                  );
                }
              },
              child: BlocConsumer<AddExpenseBloc, AddExpenseState>(
                listener: (context, state) {
                  if (state.status == RxStatus.success) {
                    context.pop('updated');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added expense successfully')),
                    );
                  } else if (state.status == RxStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add expense')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == RxStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(color: kWhiteColor),
                    );
                  } else {
                    return Text(
                      'Save',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
