class Reservas {
  String categoria;
  String id;
  String bloco;

  Reservas({required this.categoria, required this.bloco, required this.id});

  Reservas.fromMap(Map<String, dynamic> map)
    : categoria = map["categoria"],
      bloco = map["bloco"],
      id = map["id"];

  Map<String, dynamic> toMap() {
    return {"categoria": categoria, "bloco": bloco, "id": id};
  }
}
