import 'package:documents_collector/api/hx_doctor.dart';
import 'package:documents_collector/api/hx_user.dart';
import 'package:documents_collector/providers/px_doctor.dart';
import 'package:documents_collector/providers/px_user_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => PxUserModel(
      usersService: const HxUser(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxDoctor(
      doctorsService: const HxDoctor(),
    ),
  ),
];
