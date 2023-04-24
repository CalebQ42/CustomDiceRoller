import 'package:customdiceroller/cdr.dart';
import 'package:darkstorm_common/frame_content.dart';
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
  bool _driveFail = false;
  set driveFail(bool b) => setState(() => _driveFail = b);
  String? _loadingText;
  set loadingText(String s) => setState(() => _loadingText = s);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadingText = AppLocalizations.of(context)!.loading;
  }

  @override
  Widget build(BuildContext context) {
    if(!started){
      started = true;
      widget.cdr.postInit(context, this).then(
        (_) {
          if(!_driveFail){
            widget.cdr.nav.pushNamedAndRemoveUntil(widget.startingRoute.name ?? "/", (_) => false, arguments: widget.startingRoute.arguments);
          }
        }
      );
    }
    return FrameContent(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
            duration: widget.cdr.globalDuration,
            child: !_driveFail ? Column(
              key: const Key("loading"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Container(height: 10),
                Text(
                  _loadingText ?? AppLocalizations.of(context)!.loading,
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ) :
            Column(
              key: const Key("driveFail"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.driveError,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Container(height: 20),
                Text(
                  AppLocalizations.of(context)!.driveErrorExplaination,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.retry),
                      onPressed: () {
                        driveFail = false;
                        widget.cdr.initializeDrive().then(
                          (value) {
                            if(!value){
                              driveFail = true;
                            }else{
                              widget.cdr.nav.pushNamedAndRemoveUntil(widget.startingRoute.name ?? "/", (_) => false, arguments: widget.startingRoute.arguments);
                            }
                          }
                        );
                      },
                    ),
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.continueOffline),
                      onPressed: () =>
                        widget.cdr.nav.pushNamedAndRemoveUntil(widget.startingRoute.name ?? "/", (_) => false, arguments: widget.startingRoute.arguments)
                    )
                  ],
                )
              ],
            ),
          )
        )
      )
    );
  }
}