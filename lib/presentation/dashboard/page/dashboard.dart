import 'package:expense_tracker/presentation/dashboard/bloc/drive_backup_bloc/drive_bloc.dart';
import 'package:expense_tracker/presentation/dashboard/bloc/drive_backup_bloc/drive_event.dart';
import 'package:expense_tracker/presentation/dashboard/bloc/graph_bloc/graph_bloc.dart';
import 'package:expense_tracker/presentation/dashboard/bloc/graph_bloc/graph_event.dart';
import 'package:expense_tracker/presentation/dashboard/bloc/graph_bloc/graph_state.dart';
import 'package:expense_tracker/presentation/dashboard/widgets/line_graph/line_graph.dart';
import 'package:expense_tracker/presentation/items_list/page/item_list_page.dart';
import 'package:expense_tracker/presentation/dashboard/widgets/my_bar_chart/bar_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utilities/utilities.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/application/theme/colors.dart';
import '../../item_details/page/expense_details.dart';
import '../bloc/drive_backup_bloc/drive_state.dart';

enum GraphType { daily, monthly, yearly }

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  static const String path = '';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GraphBloc graphBloc = GraphBloc();
  final DriveBloc driveBloc = DriveBloc();

  final BehaviorSubject<String> _currentDate =
      BehaviorSubject<String>.seeded(DateTime.now().formattedDate());

  DateTime selectedDate = DateTime.now();

  final List<GraphType> graphType = [
    GraphType.daily,
    GraphType.monthly,
    GraphType.yearly,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    graphBloc.add(const GraphEvent(graphType: GraphType.daily));
  }

  @override
  void dispose() {
    super.dispose();
    graphBloc.close();
    driveBloc.close();
    _currentDate.close();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.surface,
      appBar: myAppBar(context),
      floatingActionButton: Stack(
        children: [
          SizedBox(
            width: screenWidth - 30,
            child: ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (selectedDate != null) {
                  _currentDate.add(selectedDate.formattedDate());
                }
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                elevation: const WidgetStatePropertyAll(5),
                minimumSize: WidgetStatePropertyAll(
                  Size(screenWidth, 75),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  // Theme.of(context).colorScheme.primary,
                  MyColors.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_calendar_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder<String>(
                    stream: _currentDate,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'select a date',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
              backgroundColor: MyColors.surface,
              onPressed: () {
                DateTime parsedDate =
                    DateFormat('d MMM, yyyy').parse(_currentDate.value);
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(parsedDate);

                context.push(
                    "/${ItemListPage.path}/${ExpenseDetailsPage.path}/$formattedDate");
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Card(
                elevation: 10,
                color: MyColors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: BlocBuilder<GraphBloc, GraphState>(
                    bloc: graphBloc,
                    builder: (context, state) {
                      if (state is GraphStateSuccess) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _selectGraph(
                                      index,
                                      state.graphType,
                                      context,
                                    ),
                                  );
                                },
                              ),
                            ),
                            BarList(
                              items: state.itemList,
                              graphType: state.graphType,
                            ),
                          ],
                        );
                      } else if (state is GraphStateFailed) {
                        return Text(state.errorMessage);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  context.push(
                    '/${ItemListPage.path}',
                  );
                },
                child: Card(
                  elevation: 10,
                  color: MyColors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BlocBuilder<GraphBloc, GraphState>(
                      bloc: graphBloc,
                      builder: (context, state) {
                        if (state is GraphStateSuccess) {
                          return LineGraph(
                            items: state.itemList,
                            graphType: state.graphType,
                          );
                        } else if (state is GraphStateFailed) {
                          return Text(state.errorMessage);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.push(
                    '/${ItemListPage.path}',
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(MyColors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: MyColors.primaryDeep,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_edu,
                      color: MyColors.tertiary,
                    ),
                    Text(
                      'History',
                      style: TextStyle(
                        color: MyColors.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _selectGraph(
    int index,
    GraphType selectedType,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenWidth * .05,
      width: screenWidth * .25,
      child: ElevatedButton(
        onPressed: () {
          graphBloc.add(
            GraphEvent(
              graphType: graphType[index],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          // backgroundColor: selectedType == graphType[index]
          //     ? Theme.of(context).colorScheme.primary
          //     : Theme.of(context).colorScheme.secondary,
          backgroundColor: selectedType == graphType[index]
              ? MyColors.primary
              : MyColors.secondary,
        ),
        child: Text(
          () {
            switch (index) {
              case 0:
                return 'Daily';
              case 1:
                return 'Monthly';
              default:
                return 'Yearly';
            }
          }(),
          style: TextStyle(
            // color: Theme.of(context).colorScheme.surface,
            color: selectedType == graphType[index]
                ? MyColors.surface
                : MyColors.white,
            fontSize: screenWidth * .025,
          ),
        ),
      ),
    );
  }

  AppBar myAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocListener<DriveBloc, DriveState>(
            bloc: driveBloc,
            listener: (context, state) {
              if (state is DriveUploadFailed) {
                _updateAlert(context, state.errorMessage, Colors.red);
              } else if (state is DriveUploadSuccess) {
                _updateAlert(context, state.successMessage, Colors.green);
              }
            },
            child: BlocBuilder<DriveBloc, DriveState>(
              bloc: driveBloc,
              builder: (context, state) {
                if (state is DriveUploadLoading) {
                  return SpinKitThreeBounce(
                    size: 20,
                    color: MyColors.white,
                  );
                }
                return IconButton(
                  onPressed: () {
                    driveBloc.add(DriveUploadEvent());
                  },
                  icon: Icon(
                    Icons.backup,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                );
              },
            ),
          ),
          Text(
            'Expense Tracker',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocListener<DriveBloc, DriveState>(
            bloc: driveBloc,
            listener: (context, state) {
              if (state is DriveDownloadFailed) {
                _updateAlert(context, state.errorMessage, Colors.red);
              } else if (state is DriveDownloadSuccess) {
                _updateAlert(context, state.successMessage, Colors.green);
                graphBloc.add(const GraphEvent(graphType: GraphType.daily));
              }
            },
            child: BlocBuilder<DriveBloc, DriveState>(
              bloc: driveBloc,
              builder: (context, state) {
                if (state is DriveDownloading) {
                  return SpinKitThreeBounce(
                    size: 20,
                    color: MyColors.white,
                  );
                }
                return IconButton(
                  onPressed: () {
                    driveBloc.add(DriveDownloadEvent());
                  },
                  icon: Icon(
                    Icons.download,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: MyColors.primary,
    );
  }

  void _updateAlert(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
