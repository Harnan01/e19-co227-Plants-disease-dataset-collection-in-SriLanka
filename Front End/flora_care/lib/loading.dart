
import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text("Disease"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child:Padding(padding:EdgeInsets.all(20.0),child: CircularProgressIndicator(color: Colors.grey,))),
          Center(child: Text("Processing...",style: TextStyle(fontSize: 30,color: Colors.grey,fontStyle: FontStyle.italic),))
        ]
        ,
      ),
    );

  }
}


class Disease extends StatefulWidget {
  const Disease({super.key});

  @override
  State<Disease> createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



