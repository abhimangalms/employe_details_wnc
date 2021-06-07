import 'dart:async';

import 'package:employe_details_wnc/models/employee_model.dart';
import 'package:employe_details_wnc/providers/db_provider.dart';
import 'package:employe_details_wnc/providers/employee_api_provider.dart';
import 'package:employe_details_wnc/screens/employee_details.dart';
import 'package:employe_details_wnc/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  List<EmployeeModel> employeeList = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    _loadFromApi();
    final employeeListData = await DBProvider.db.getSearchEmployees(query);

    setState(() => this.employeeList = employeeListData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee info'),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  await _loadFromApi();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _deleteData();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            buildSearch(), //search view
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildEmployeeListView(), //build listview
            )
          ],
        ));
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    await Future.delayed(const Duration(seconds: 1)); //deleting eployees

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(
                  snapshot.data[index].profileImage ??
                      "https://homepages.cae.wisc.edu/~ece533/images/baboon.png",
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
                title: Text(snapshot.data[index].name),
                subtitle: Text(snapshot.data[index].email),
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new EmployeeDetail(
                          name: snapshot.data[index].name,
                          username: snapshot.data[index].username,
                          email: snapshot.data[index].email,
                          profile_image: snapshot.data[index].profileImage,
                          phone: snapshot.data[index].phone,
                          website: snapshot.data[index].website,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search employee here',
        onChanged: searchEmployee,
      );

  //getting employee data from SqFlite
  Future searchEmployee(String query) async => debounce(() async {
        final books = await DBProvider.db.getSearchEmployees(query);

        if (!mounted) return;
        setState(() {
          this.query = query;
          this.employeeList = books;
        });
      });
}
