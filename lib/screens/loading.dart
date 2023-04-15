import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatefulWidget{

  final RouteSettings startingRoute;
  final CDR cdr;

  const LoadingScreen({super.key, required this.startingRoute, required this.cdr});

  @override
  State<LoadingScreen> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  bool started = false;
  String _loadingText = "";
  set loadingText(String s) => setState(() => _loadingText = s);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadingText = AppLocalizations.of(context)!.loading;
  }

  void driveFail(){
    //TODO:
  }

  @override
  Widget build(BuildContext context) {
    if(!started){
      started = true;
      widget.cdr.postInit(context, this).then(
        (_) => widget.cdr.nav?.pushNamedAndRemoveUntil(widget.startingRoute.name ?? "/", (_) => false, arguments: widget.startingRoute.arguments)
      );
    }
    return FrameContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Container(height: 10),
            Text(
              _loadingText,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      )
    );
  }
}