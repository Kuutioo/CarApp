// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cars'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          return Stack(
            children: [
              MaterialButton(
                padding: const EdgeInsets.all(10),
                textColor: Theme.of(context).primaryColor,
                elevation: 8.0,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://th.bing.com/th/id/R.6dc536396b87a433c564148840b0c0ce?rik=3m4JykqNyjF2pw&pid=ImgRaw&r=0'),
                        fit: BoxFit.cover),
                  ),
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 30,
                left: 30,
                child: Container(
                  child: const Text(
                    'Turbo Mersu',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  color: Colors.black38,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
