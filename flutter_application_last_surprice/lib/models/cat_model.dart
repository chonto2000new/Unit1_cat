class Cat {
  final int? id;
  final String price;
  final String name;
  final String console;
  final String genero;
  final String fotos;

  Cat(
      {this.id,
      required this.price,
      required this.name,
      required this.console,
      required this.genero,
      required this.fotos});
  factory Cat.fromMap(Map<String, dynamic> json) => Cat(
      id: json["id"],
      price: json["price"],
      name: json["name"],
      console: json["console"],
      genero: json["genero"],
      fotos: json["fotos"]);
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "price": price,
      "name": name,
      "console": console,
      "genero": genero,
      "fotos": fotos
    };
  }
}
