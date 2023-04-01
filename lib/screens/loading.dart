import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget{

  final RouteSettings startingRoute;
  final CDR cdr;

  const LoadingScreen({super.key, required this.startingRoute, required this.cdr});

  @override
  Widget build(BuildContext context) {
    cdr.postInit(context).then(
      (_) => cdr.navKey.currentState?.pushNamedAndRemoveUntil(startingRoute.name ?? "/", (_) => false, arguments: startingRoute.arguments)
    );
    return FrameContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Container(height: 10),
            Text(
              AppLocalizations.of(context)!.loading,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      )
    );
  }
}