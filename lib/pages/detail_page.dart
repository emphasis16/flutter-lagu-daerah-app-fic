import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/models/province.dart';

class DetailPage extends StatefulWidget {
  final Province province;
  const DetailPage({super.key, required this.province});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _opacityNotifier;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _opacityNotifier = ValueNotifier(0.0);

    _scrollController.addListener(() {
      double opacity = _scrollController.offset / 200;
      if (opacity > 1) opacity = 1;
      _opacityNotifier.value = opacity;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _opacityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ValueListenableBuilder<double>(
                valueListenable: _opacityNotifier,
                builder: (context, opacity, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      widget.province.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.lerp(Colors.white, Colors.black, opacity),
                      ),
                    ),
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.province.id,
                    child: Image.network(
                      widget.province.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100, // Adjust height as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.all(16),
              collapseMode: CollapseMode.pin,
            ),
            leading: ValueListenableBuilder<double>(
              valueListenable: _opacityNotifier,
              builder: (context, opacity, child) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Color.lerp(Colors.white, Colors.black, opacity),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.province.laguDaerah,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.province.nama} - ${widget.province.ibuKota}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.province.photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.province.lirikLaguDaerah,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Action untuk berbagi lirik atau lagu
                        },
                        icon: const Icon(Icons.share),
                        label: const Text("Bagikan"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
