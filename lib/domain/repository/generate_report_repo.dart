import '../entity/expense_details_entity.dart';

abstract class GenerateReportRepo {
  Future<(List<ExpenseDetailsEntity>?, String?)> getDailyReport();

  Future<(List<ExpenseDetailsEntity>?, String?)> getMonthlyReport();

  Future<(List<ExpenseDetailsEntity>?, String?)> getYearlyReport();
}
