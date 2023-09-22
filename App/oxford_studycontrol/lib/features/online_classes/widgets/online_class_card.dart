import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/helpers/utils/date_utils.dart';
import 'package:oxford_studycontrol/models/online_classes.dart';
import 'package:oxford_studycontrol/providers/online_class_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineClassCard extends ConsumerStatefulWidget {
  final OnlineClass onlineClass;
  const OnlineClassCard({super.key, required this.onlineClass});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnlineClassCardState();
}

class _OnlineClassCardState extends ConsumerState<OnlineClassCard> {
  late bool isLoading;
  late final Uri url;

  Future<void> _launchUrl() async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    url = Uri.parse(widget.onlineClass.url);
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onlineClass = widget.onlineClass;
    String startTimeString = getHoursMinuteFormat(onlineClass.startTime);
    String endTimeString = getHoursMinuteFormat(onlineClass.endTime);

    return Card(
        child: isLoading
            ? const Center(child: Expanded(child: CircularProgressIndicator()))
            : ListTile(
                textColor: seedColor,
                title: Text(
                  onlineClass.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: seedColor,
                      ),
                ),
                subtitle: Text.rich(
                  style: const TextStyle(color: Colors.grey),
                  TextSpan(children: [
                    const TextSpan(text: 'Esta clase empieza  a las '),
                    TextSpan(
                        text: startTimeString,
                        style: const TextStyle(
                            color: seedColor, fontWeight: FontWeight.w700)),
                    const TextSpan(text: ' y finaliza a las '),
                    TextSpan(
                        text: endTimeString,
                        style: const TextStyle(
                            color: seedColor, fontWeight: FontWeight.w700)),
                  ]),
                ),
                onTap: () {
                  final reservedOnlineClass =
                      ref.read(reservedOnlineClassesStateNotifierProvider);
                  if (reservedOnlineClass.contains(widget.onlineClass.name)) {
                    _launchUrl();
                  } else {
                    context.loaderOverlay.show();
                    ref
                        .read(makeReservationFetcher(onlineClass).future)
                        .then((value) {
                      context.loaderOverlay.hide();
                      String text;
                      if (value == 1) {
                        text = 'Se ha reservado exitosamente';
                      } else if (value == 0) {
                        text = 'No hay puestos disponibles en esta clase';
                      } else {
                        text = 'Error al reservar, intente mas tarde';
                      }
                      return showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(text),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK',
                                        style: TextStyle(color: seedColor)),
                                  ),
                                ],
                              ));
                    });
                  }
                }));
  }
}
/*
class OnlineClassCard extends ConsumerWidget {
  final OnlineClass onlineClass;
  const OnlineClassCard({super.key, required this.onlineClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String startTimeString = getHoursMinuteFormat(onlineClass.startTime);
    String endTimeString = getHoursMinuteFormat(onlineClass.endTime);

    return Card(
      child: isLoading
          ? Container()
          : ListTile(
              textColor: seedColor,
              title: Text(
                onlineClass.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: seedColor,
                    ),
              ),
              subtitle: Text.rich(
                style: const TextStyle(color: Colors.grey),
                TextSpan(children: [
                  const TextSpan(text: 'Esta clase empieza  a las '),
                  TextSpan(
                      text: startTimeString,
                      style: const TextStyle(
                          color: seedColor, fontWeight: FontWeight.w700)),
                  const TextSpan(text: ' y finaliza a las '),
                  TextSpan(
                      text: endTimeString,
                      style: const TextStyle(
                          color: seedColor, fontWeight: FontWeight.w700)),
                ]),
              ),
              onTap: () {
                final reservationAsync =
                    ref.read(makeReservationFetcher(onlineClass.name));

                /*reservationAsync.when(
            data: (_) {
            return showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Se cargo'),
                      content: const Text('AlertDialog description'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          }, error: (_, __) {
            return showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('No se cargo'),
                      content: const Text('AlertDialog description'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          }, loading: () {
            return showDialog<String>(
                context: context,
                builder: (BuildContext context) => const AlertDialog(
                      content: CircularProgressIndicator(),
                    ));
          });*/
              },
            ),
    );
  }
}*/
