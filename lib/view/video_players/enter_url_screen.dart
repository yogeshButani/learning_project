import 'package:flutter/material.dart';
import 'package:learning_project/utils/app_colors.dart';

import 'package:learning_project/view/video_players/init_video_player.dart';

class EnterUrlScreen extends StatefulWidget {
  const EnterUrlScreen({super.key});

  @override
  State<EnterUrlScreen> createState() => _EnterUrlScreenState();
}

class _EnterUrlScreenState extends State<EnterUrlScreen> {
  var urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [
            TextFormField(
              controller: urlController,
              maxLines: 3,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Paste Url',
                labelStyle: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitVideoScreen(
                      videoUrl: urlController.text.trim().toString(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Start Video Player',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
