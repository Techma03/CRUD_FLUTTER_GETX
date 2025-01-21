import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payapp_controller.dart';

class PayappView extends GetView<PayappController> {
  const PayappView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayappView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PayappView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
