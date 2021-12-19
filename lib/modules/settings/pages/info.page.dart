part of settings_module;

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100 * 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Non c\'è un cazzo da fare',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 100 * 7,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              '0.0.1',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
