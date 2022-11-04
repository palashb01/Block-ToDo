import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:over_engineered/constants.dart';

class ToDoTile extends StatelessWidget {
  ToDoTile({
    Key? key,
    required this.task,
    required this.isCompleted,
    required this.onChanged, this.emoji = "➕",
  }) : super(key: key);
  final String emoji;
  final String task;
  final bool isCompleted;
  Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kIsWeb ? w/3.4 : 32,
        vertical: 15,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   emoji,
            //   style: const TextStyle(
            //     fontSize: 32,
            //   ),
            // ),
            // const SizedBox(
            //   width: 10,
            // ),
            Flexible(
              child: Text(
                task,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SSPRegular',
                  color: isCompleted ? kSecondary : kPrimary,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Checkbox(
              value: isCompleted,
              onChanged: onChanged,
              activeColor: kPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
