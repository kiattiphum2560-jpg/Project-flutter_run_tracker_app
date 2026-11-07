import 'package:flutter/material.dart';
import 'add_run_ui.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 1, 80),
        centerTitle: true,
        title: const Text('Run Tracker', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const AddRunUi(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 5, 1, 80),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: const Color(0xFFFFF8FF),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 44),
            Image.asset('assets/icon/speed.png',
              width: MediaQuery.of(context).size.width * 0.355,
              height: MediaQuery.of(context).size.width * 0.355,
            ),
            const SizedBox(height: 18),
            const Text(
              'วิ่งกันเถอะ',
              style: TextStyle(
                color: Color(0xFF25232A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
