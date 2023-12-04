import 'package:binander/src/common_widgets/crypto_info/crypto_info_widget.dart';
import 'package:binander/src/features/bot/presentation/crypto_info_container/crypto_info_title.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CryptoInfoContainer extends ConsumerWidget {
  const CryptoInfoContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: Text(
        "Funds",
        style: Theme.of(context).textTheme.headlineSmall,
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
                    child: const CryptoInfoWidget(),
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
                    child: const CryptoInfoWidget(),
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
