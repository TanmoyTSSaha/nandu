// import 'dart:async';
// import 'package:get/get.dart';

// class TimerController extends GetxController {
//   Timer? countDownTimer;
//   Rx<Duration> timerDuration = Duration(seconds: 31).obs;

//   void startTimer() {
//     countDownTimer =
//         Timer.periodic(const Duration(seconds: 1), (_) => setTimer());
//   }

//   void stopTimer() {
//     countDownTimer!.cancel();
//     update();
//   }

//   void resetTimer() {
//     if (countDownTimer == null || countDownTimer!.isActive) {
//       stopTimer();
//     }
//     update();
//   }

//   void setTimer() {
//     final seconds = timerDuration.value.inSeconds - 1;
//     if (seconds < 0) {
//       countDownTimer!.cancel();
//     } else {
//       timerDuration.value = Duration(seconds: seconds);
//     }
//     update();
//   }
// }
