import 'package:expense_tracker/domain/repository/generate_report_repo.dart';

import '../entity/expense_details_entity.dart';

class GenerateReportUseCase {
  GenerateReportRepo generateReportRepo;
  GenerateReportUseCase(this.generateReportRepo);
  Future<(List<ExpenseDetailsEntity>?, String?)> getDailyReport() async {
    return await generateReportRepo.getDailyReport();
  }

  Future<(List<ExpenseDetailsEntity>?, String?)> getMonthlyReport() async {
    return await generateReportRepo.getMonthlyReport();
  }

  Future<(List<ExpenseDetailsEntity>?, String?)> getYearlyReport() async {
    return await generateReportRepo.getYearlyReport();
  }
}
