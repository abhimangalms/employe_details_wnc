import 'package:dio/dio.dart';
import 'package:employe_details_wnc/models/employee_model.dart';
import 'package:employe_details_wnc/providers/db_provider.dart';

class EmployeeApiProvider {
  Future<List> getAllEmployees() async {
    var url = "http://www.mocky.io/v2/5d565297300000680030a986";
    Response? response = await Dio().get(url);

    return (response.data as List).map((employee) {
      print('Inserting $employee');
      DBProvider.db.createEmployee(EmployeeModel.fromJson(employee));
    }).toList();
  }

}
