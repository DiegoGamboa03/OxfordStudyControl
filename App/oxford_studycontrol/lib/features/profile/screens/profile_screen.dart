import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late bool update;
  late TextEditingController _controller;
  @override
  void initState() {
    update = false;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !update
            ? const Text('Diego')
            : TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Email",
                )),
        IconButton(
          iconSize: 72,
          icon: const Icon(Icons.favorite),
          onPressed: () {
            setState(() {
              update = !update;
            });
          },
        ),
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
