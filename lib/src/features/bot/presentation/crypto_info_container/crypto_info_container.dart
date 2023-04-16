import 'package:binander/modules/dashboard/widgets/crypto_info_container/crypto_info_title.dart';
import 'package:binander/widgets/crypto_info/crypto_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CryptoInfoContainer extends ConsumerWidget {
  const CryptoInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: Text(
        "Funds",
        style: Theme.of(context).textTheme.headline5,
      ),
      initiallyExpanded: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProviderScope(
              overrides: [isTestNetProvider.overrideWithValue(false)],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CryptoInfoTitle('Pub Net'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child: const CryptoInfo(),
                  ),
                ],
              ),
            ),
            ProviderScope(
              overrides: [isTestNetProvider.overrideWithValue(true)],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CryptoInfoTitle('Test Net'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child: const CryptoInfo(),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
