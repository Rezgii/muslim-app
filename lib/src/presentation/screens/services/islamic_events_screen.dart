import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:muslim/src/data/models/islamic_event_model.dart';
import 'package:muslim/src/presentation/controllers/islamic_events_controller.dart';

class IslamicEventsScreen extends StatefulWidget {
  const IslamicEventsScreen({super.key});

  @override
  State<IslamicEventsScreen> createState() => IslamicEventsScreenState();
}

class IslamicEventsScreenState extends State<IslamicEventsScreen> {
  final IslamicEventsController _controller = Get.put(
    IslamicEventsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Islamic Events'.tr),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.events.length,
            itemBuilder: (context, index) {
              var event = _controller.events[index];
              var gregorianDate = _controller.hijriToGregorian(
                event.hijriMonth,
                event.hijriDay,
              );
              // Ensure we get the correct Gregorian date (next year if passed)

              if (gregorianDate.isBefore(DateTime.now())) {
                gregorianDate = _controller.hijriToGregorian(
                  event.hijriMonth,
                  event.hijriDay,
                );
                gregorianDate = _controller
                    .hijriToGregorian(event.hijriMonth, event.hijriDay)
                    .add(
                      const Duration(days: 354),
                    ); // Approximate Hijri year shift
              }
              return EventItem(
                event: event,
                gregorianDate: _controller.formateGregorianDate(gregorianDate),
                daysLeft: _controller.getDaysLeft(
                  gregorianDate,
                  event.hijriMonth,
                  event.hijriDay,
                ),
                isNextEvent: index == 0 ? true : false,
              );
            },
          ),
        ),
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.event,
    required this.gregorianDate,
    required this.daysLeft,
    required this.isNextEvent,
  });

  final IslamicEventModel event;
  final String gregorianDate;
  final String daysLeft;
  final bool isNextEvent;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isNextEvent ? AppColors.primaryColor.withAlpha(100) : AppColors.boxBlackBg,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              gregorianDate,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        title: Text(event.event.tr),
        subtitle: Text('${event.hijriDay} ${event.monthName.tr}'),
        trailing: Text(daysLeft, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
