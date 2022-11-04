import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:over_engineered/components/todo_tile.dart';
import 'package:over_engineered/hidden_drawer.dart';
import 'package:over_engineered/screens/completed_tasks.dart';
import 'package:over_engineered/screens/profile_screen.dart';
import 'package:over_engineered/screens/rewards_screen.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:slider_captcha/slider_capchar.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.coins, required this.email})
      : super(key: key);
  late final int coins;
  final String email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formkey = GlobalKey<FormState>();
  late String task;
  late String modifiedTask;
  late String emoji;
  final taskController = TextEditingController();
  final modifyController = TextEditingController();
  final emojiController = TextEditingController();
  bool emojiShowing = false;
  DateTime _dateCreated = DateTime.now();
  final SliderController controller = SliderController();
  late String taskId;
  // final String baseUrl =
  //     kIsWeb ? "http://localhost:4000" : "http://10.0.2.2:4000";
  final String baseUrl = "https://block-to-do.vercel.app";
  late DateTime datecreated;

  clearText() {
    taskController.clear();
    emojiController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskController.dispose();
    emojiController.dispose();
  }

  var uuid = Uuid();

  @override
  void addTask(double h, double w) {
    taskId = uuid.v4();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: h / 1.5,
          child: Form(
            key: _formkey,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: h / 30,
                  ),
                  const Text(
                    'Add Task',
                    style: TextStyle(
                      fontFamily: 'SSPBold',
                      fontSize: 40,
                      color: kPrimary,
                    ),
                  ),
                  SizedBox(
                    height: h / 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: w / 1.2,
                        height: h / 10,
                        child: TextFormField(
                          style: const TextStyle(
                            color: kPrimary,
                            fontSize: 16,
                            fontFamily: 'SSPRegular',
                            height: 1.2,
                          ),
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kBlack,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                  2,
                                ),
                                bottomRight: Radius.circular(
                                  2,
                                ),
                              ),
                            ),
                            hintText: 'Write a new task...',
                            hintStyle: TextStyle(
                              fontFamily: 'SSPRegular',
                              fontSize: 16,
                              color: kSecondary,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                          controller: taskController,
                          onChanged: (value) {
                            task = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Task';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h / 100,
                  ),
                  const Text(
                    'Select a Deadline',
                    style: TextStyle(
                      fontFamily: 'SSPBold',
                      fontSize: 20,
                      color: kPrimary,
                    ),
                  ),
                  SizedBox(
                    height: h / 100,
                  ),
                  SizedBox(
                    height: h / 6,
                    child: ScrollDatePicker(
                      minimumDate: DateTime(2000),
                      maximumDate: DateTime(2100),
                      selectedDate: _dateCreated,
                      locale: const Locale('en'),
                      onDateTimeChanged: (DateTime value) {
                        setState(() {
                          _dateCreated = value;
                          print(_dateCreated);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: h / 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {});
                        // Navigator.pop(context);
                        datecreated = DateTime.now();
                        showCaptcha(true, '');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 50,
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontFamily: 'SSPBold',
                          fontSize: 30,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void modifytask(double h, double w, String id) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: h / 2.5,
          child: Form(
            key: _formkey,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: h / 30,
                  ),
                  const Text(
                    'Modify Task',
                    style: TextStyle(
                      fontFamily: 'SSPBold',
                      fontSize: 40,
                      color: kPrimary,
                    ),
                  ),
                  SizedBox(
                    height: h / 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: w / 1.2,
                        height: h / 10,
                        child: TextFormField(
                          style: const TextStyle(
                            color: kPrimary,
                            fontSize: 16,
                            fontFamily: 'SSPRegular',
                            height: 1.2,
                          ),
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kBlack,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                  2,
                                ),
                                bottomRight: Radius.circular(
                                  2,
                                ),
                              ),
                            ),
                            hintText: 'Modify the task...',
                            hintStyle: TextStyle(
                              fontFamily: 'SSPRegular',
                              fontSize: 16,
                              color: kSecondary,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                          controller: modifyController,
                          onChanged: (value) {
                            modifiedTask = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Task';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h / 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {});
                        // Navigator.pop(context);
                        showCaptcha(false, id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 50,
                      ),
                      child: Text(
                        'Modify',
                        style: TextStyle(
                          fontFamily: 'SSPBold',
                          fontSize: 30,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future getTask() async {
    final Dio dio = Dio();
    Map<String, dynamic> mp = {
      'email': widget.email.toString(),
    };
    print(mp);
    var response = await dio.get('$baseUrl/gettask', queryParameters: mp);
    return response;
  }

  void deleteTask(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: kPrimary,
        titlePadding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        title: const Center(
          child: Text(
            'Delete Task',
            style: TextStyle(
              color: kWhite,
              fontFamily: 'SSPBold',
              fontSize: 32,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        content: const Text(
          'Are you sure you want to delete\nthis task?',
          style: TextStyle(
            color: kWhite,
            fontSize: 18,
            fontFamily: 'SSPRegular',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SSPRegular',
                color: kWhite,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                deletetask(id);
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: kWhite,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SSPBold',
                  color: kPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List todoList = [
    [
      '🔥',
      'Play cricket',
      false,
    ],
    [
      '🎯',
      'Code an app',
      true,
    ],
  ];

  void checkBoxChanged(int index, List<dynamic> tasks) {
    setState(() {
      print(!tasks[index]['iscompleted']);
      tasks[index]['iscompleted'] = !tasks[index]['iscompleted'];
    });
  }

  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        floatingActionButton: Container(
          width: 75,
          height: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => addTask(h, w),
              backgroundColor: kPrimary,
              child: const Icon(
                Icons.add,
                color: kWhite,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                kIsWeb
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        child: Row(
                          children: [
                            const Text(
                              'ToDo',
                              style: TextStyle(
                                  color: kPrimary,
                                  fontFamily: 'SSPBold',
                                  fontSize: 40),
                            ),
                            SizedBox(
                              width: w / 1.9,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(
                                        coins: widget.coins,
                                        email: widget.email),
                                  ),
                                );
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontSize: 20,
                                  fontFamily: 'SSPRegular',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileScreen(email: widget.email,),
                                  ),
                                );
                              },
                              child: const Text(
                                'Profile',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontSize: 20,
                                  fontFamily: 'SSPRegular',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompletedTasks(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Completed Tasks',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontSize: 20,
                                  fontFamily: 'SSPRegular',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RewardsScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Rewards',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontSize: 20,
                                  fontFamily: 'SSPRegular',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: h / 40,
                ),
                Container(
                  width: kIsWeb ? w/2.5 : w / 1.2,
                  height: h / 10,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: kShadow,
                      ),
                    ],
                    color: kWhite,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Completed Tasks 🎯',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SSPBold',
                              color: kPrimary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kPrimary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h / 50,
                ),
                // ListView.builder(
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   itemCount: todoList.length,
                //   itemBuilder: (context, index) {
                //     return Slidable(
                //       endActionPane: ActionPane(
                //         motion: const StretchMotion(),
                //         children: [
                //           SlidableAction(
                //             onPressed: (context) {},
                //             icon: Icons.edit,
                //             backgroundColor: Colors.blue,
                //             label: 'Edit',
                //           ),
                //           SlidableAction(
                //             onPressed: (context) {
                //               deleteTask();
                //             },
                //             icon: Icons.delete,
                //             backgroundColor: Colors.red,
                //             label: 'Delete',
                //           ),
                //         ],
                //       ),
                //       child: ToDoTile(
                //         emoji: todoList[index][0],
                //         task: todoList[index][1],
                //         isCompleted: todoList[index][2],
                //         onChanged: (value) => checkBoxChanged(value!, index),
                //       ),
                //     );
                //   },
                // ),
                FutureBuilder(
                    future: getTask(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {}

                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            jsonDecode(snapshot.data.toString());
                        List<dynamic> tasks = data.values.first;

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              // bool value = tasks[index]['iscompleted'];
                              print(tasks);
                              return Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          modifytask(h, w, tasks[index]['id']);
                                        },
                                        icon: Icons.edit,
                                        backgroundColor: Colors.blue,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          deleteTask(tasks[index]['id']);
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: Colors.red,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: ToDoTile(
                                    task: tasks[index]['task'],
                                    isCompleted: tasks[index]['iscompleted'],
                                    onChanged: (value) {
                                      setState(() {
                                        complete(tasks[index]['id']);
                                      });
                                    },
                                  ));
                            });
                      }

                      return const Center(
                        child: SizedBox(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendingTask() async {
    final Dio dio = Dio();
    print(datecreated.toIso8601String());
    final data = {
      "email": widget.email,
      "id": taskId,
      "task": task,
      "deadline": _dateCreated.toIso8601String(),
    };
    final String jsonString = jsonEncode(data);
    try {
      var response = await dio.post('$baseUrl/addtask', data: jsonString);
      if (response.statusCode == 201) {
        print('success');
      } else {
        print('error');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void complete(String id) async {
    final Dio dio = Dio();
    final data = {"email": widget.email, "id": id};
    final String jsonString = jsonEncode(data);
    try {
      var response = await dio.put('$baseUrl/complete', data: jsonString);
      if (response.statusCode == 202) {
        print('success');
        setState(() {
          // HiddenDrawer();
        });
      } else {
        print('error');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void modifyTask(String id) async {
    final Dio dio = Dio();
    final data = {
      'email': widget.email,
      'id': id,
      'task': modifiedTask,
    };
    final String jsonString = jsonEncode(data);
    try {
      var response = await dio.put('$baseUrl/modifytask', data: jsonString);
      if (response.statusCode == 202) {
        print('success');
      } else {
        print('error');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void deletetask(String id) async {
    final Dio dio = Dio();
    final data = {
      'email': widget.email,
      'id': id,
    };
    final String jsonString = jsonEncode(data);
    try {
      var response = await dio.delete('$baseUrl/deletetask', data: jsonString);
      if (response.statusCode == 202) {
        print('success');
        Navigator.pop(context);
      } else {
        print('error');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void showCaptcha(bool addTask, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: SliderCaptcha(
          controller: controller,
          image: Image.asset(
            'assets/splash_screen.png',
            fit: BoxFit.fitWidth,
          ),
          colorBar: Colors.blue,
          colorCaptChar: Colors.blue,
          onConfirm: (value) async {
            debugPrint(value.toString());
            return await Future.delayed(const Duration(seconds: 2)).then(
              (value) {
                controller.create.call();
                setState(() {
                  addTask ? sendingTask() : modifyTask(id);
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HiddenDrawer(
                      email: widget.email,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
