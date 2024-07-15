import 'package:flutter/material.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:provider/provider.dart';

import 'date_time_format.dart';
import 'optimize_route_provider.dart';
import 'time_line_widget.dart';

class StepInfoPage extends StatefulWidget {
  const StepInfoPage({super.key});

  @override
  StepInfoPageState createState() => StepInfoPageState();
}

class StepInfoPageState extends State<StepInfoPage>
    with AutomaticKeepAliveClientMixin {
  double topMargin = 8;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Locale locale = Localizations.localeOf(context);
    return Selector(
      builder: (context, optimizeRoute, _) {
        var steps = optimizeRoute?.steps;
        return Scaffold(
          backgroundColor: Colors.white,
          body: (optimizeRoute != null && steps?.isNotEmpty == true)
              ? Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: steps!.length,
                      itemBuilder: (context, index) {
                        var step = steps[index];
                        return TimeLineWidgetContainer(
                          isFirst: index == 0,
                          isLast: index == steps.length - 1,
                          leftIcon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFBAB7C2), width: 1),
                            ),
                            child: Text(
                              "$index",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 6, top: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        margin: EdgeInsets.only(top: topMargin),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFAFAFA),
                                            border: Border.all(
                                                color: const Color(0xFFE6E7E8),
                                                width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemWidget("ID", step.id ?? "N/A"),
                                            itemWidget("Task Type",
                                                step.type ?? "N/A"),
                                            itemWidget(
                                              "Expected Time",
                                              formatTime(step.arrival, locale),
                                            ),
                                            itemWidget(
                                              "Duration",
                                              step.duration == 0
                                                  ? "0"
                                                  : TimeFormatter.formatSeconds(
                                                      step.duration ?? 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : emptyWidget(),
        );
      },
      selector: (context, OptimizeRouteProvider viewModel) {
        return viewModel.optimizeRoute;
      },
      shouldRebuild: (pre, next) => true,
    );
  }

  String formatTime(int? arrival, Locale locale) {
    DateTime arriveTime = DateTime.now().add(Duration(seconds: arrival ?? 0));
    return DateTimeFormat.formatToHmmWith12Hour(arriveTime, locale, "");
  }

  Widget itemWidget(String title, String value) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Color(0xFFE6E7E8),
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return const Center(
      child: Text("Empty Steps"),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(StepInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
