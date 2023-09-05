import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/connectivity_service.dart';
import 'package:remont_kz/generated/l10n.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

bool isCurrentScreenConnection = true;
class ConnectionErrorScreen extends StatelessWidget {
  // final VoidCallback onRefresh;
  const ConnectionErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final l10n = L10n.of(context);

    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE600),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Center(
                          child: Text('Assets.icons.exclamationMark.svg(width: 4, height: 16)'),
                        ),
                      ),
                      const WBox(10),
                      Expanded(
                        child: Text(S.current.noInternet, style: context.h2),
                      )
                    ],
                  ),
                  const HBox(20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      isCurrentScreenConnection = false;
                      ConnectivityService().init();
                      },
                    child: Text(S.current.refresh),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
