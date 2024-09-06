import 'package:expense_tracker/data/data_source/generate_report.dart';
import 'package:expense_tracker/domain/repository/generate_report_repo.dart';

import '../../domain/entity/expense_details_entity.dart';

class GenerateReportRepoImp implements GenerateReportRepo {
  GenerateReportDataSource reportGenerate = GenerateReportDataSource();

  @override
  Future<(List<ExpenseDetailsEntity>?, String?)> getDailyReport() async {
    return await reportGenerate.readDailyItems();
  }

  @override
  Future<(List<ExpenseDetailsEntity>?, String?)> getMonthlyReport() async {
    return await reportGenerate.readMonthlyItems();
  }

  @override
  Future<(List<ExpenseDetailsEntity>?, String?)> getYearlyReport() async {
    return await reportGenerate.readYearlyItems();
  }
}
