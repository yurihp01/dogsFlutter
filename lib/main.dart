
import 'package:cachorrosapp/DogModel.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'DogsProvider.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Dog> dogs = [
    Dog(name: "Labrador", age: 1, image: "labrador.jpg"),
    Dog(name: "Sharpei", age: 8, image: "sharpei.jpg"),
    Dog(name: "Chow-Chow", age: 5, image: "chowchow.jpeg"),
    Dog(name: "Husky-Siberiano", age: 2, image: "husky.jpg"),
    Dog(name: "Pug", age: 4, image: "pug.jpg"),
    Dog(name: "Dalmata", age: 9, image: "dalmata.jpg"),
    Dog(name: "Pitbull", age: 3, image: "pitbull.jpg"),
    Dog(name: "Beagle", age: 7, image: "beagle.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Dog>>(
        future: DogsProvider.db.getAllDogs(),
        builder: (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Dog item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DogsProvider.db.deleteDog(item.id);
                  },
                  child: Card(
                       child: ListTile(
                          leading: Image.asset(item.image, height: 100, width: 100),
                          title: Text(item.name),
                          subtitle: Text('Idade: ${item.age}')
                       ),
                   )
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Dog rnd = dogs[math.Random().nextInt(dogs.length)];
          await DogsProvider.db.newDog(rnd);
          setState(() {});
        },
      ),
    );
  }
}
