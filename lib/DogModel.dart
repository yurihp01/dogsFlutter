/// DogModel.dart
import 'dart:convert';

Dog dogFromJson(String str) {
  final jsonData = json.decode(str);
  return Dog.fromMap(jsonData);
}

String dogToJson(Dog data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Dog {
  int id;
  String name;
  int age;
  String image;

  Dog({
    this.id,
    this.name,
    this.age,
    this.image
  });

  factory Dog.fromMap(Map<String, dynamic> json) => new Dog(
    id: json["id"],
    name: json["name"],
    age: json["age"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "age": age,
    "image": image
  };
}