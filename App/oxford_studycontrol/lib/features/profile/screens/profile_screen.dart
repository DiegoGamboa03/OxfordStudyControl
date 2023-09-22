import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/features/profile/widgets/title_subtitle_text.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    user!;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: margin,
          child: Center(
            child: Text(user.getCompleteName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: seedColor)),
          ),
        ),
        Container(
          margin: margin,
          child: Center(
            child: Text(user.id,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey, fontSize: 18)),
          ),
        ),
        TitleSubtitleText(title: 'Direccion:', subtitle: user.address),
        TitleSubtitleText(title: 'Email:', subtitle: user.email),
        TitleSubtitleText(
            title: 'Numero telefonico:', subtitle: user.phoneNumber),
        TextButton(
            onPressed: () {
              debugPrint('Hola');
              ref.read(appRouterProvider).push('/gradesViewer');
            },
            child: const Text('Presiona para revisar notas')),
        TextButton(
            onPressed: () {
              debugPrint('Hola');
            },
            child: const Text('Presina para editar tu informacion'))
      ],
    );
  }
}
/*class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final gradesAsync = ref.watch(gradesFetcher);
    bool update = fa;se
    return Row(
      children: [],
    );
  }
}*/
