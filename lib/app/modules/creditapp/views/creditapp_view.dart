import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/creditapp_controller.dart';

class CreditappView extends GetView<CreditappController> {
  const CreditappView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreditappView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreditappView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
