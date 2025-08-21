import 'package:expenses/data/model/category_model.dart';
import 'package:expenses/data/model/expense_model.dart';

abstract class MockedNetwork {
  Future<ExpensesWrapper> getExpense(String filter);
}

class MockedNetworkImpl implements MockedNetwork {
  @override
  Future<ExpensesWrapper> getExpense(String filter) async {
    await Future.delayed(Duration(seconds: 2));
    return ExpensesWrapper(
      total: 8,
      limit: 4,
      page: 1,
      message: 'success',
      success: true,
      data: [
        ExpenseModel(
          id: '1',
          amount: '-100',
          date: 'Today 12:00 pm',
          category: CategoryModel(
            color: '#ff1b55f3',
            icon: 'home',
            name: 'Groceries',
          ),
          receipt: '',
        ),
        ExpenseModel(
          id: '2',
          amount: '-100',
          date: 'Today 12:00 pm',
          category: CategoryModel(
            color: '#ffffb74d',
            icon: 'movie',
            name: 'Entertainment',
          ),
          receipt: '',
        ),
        ExpenseModel(
          id: '3',
          amount: '-100',
          date: 'Today 12:00 pm',
          category: CategoryModel(
            color: '#ff5777d1',
            icon: 'directions_car',
            name: 'Transportation',
          ),
          receipt: '',
        ),
        ExpenseModel(
          id: '4',
          amount: '-100',
          date: 'Today 12:00 pm',
          category: CategoryModel(
            color: '#fffad8b8',
            icon: 'shopping_cart',
            name: 'Rent',
          ),
          receipt: '',
        ),
      ],
    );
  }
}
