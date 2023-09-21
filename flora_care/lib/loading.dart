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


class NoInternet extends StatelessWidget {
  const NoInternet({super.key});


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
          Center(child: Image.asset('assets/connection_lost.jpg',height: 100,)),
          const Center(child: Text("Connection Lost",style: TextStyle(fontSize: 30,color: Colors.black),)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Center(child: Text("Looks like there is an issue with the server connection.Please try again later!",style: TextStyle(fontSize: 20,color: Colors.grey,),textAlign: TextAlign.center,)),
          ),
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



