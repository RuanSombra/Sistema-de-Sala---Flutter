class Reservas {
  String id;
  String bloco;
  String sala;

  Reservas({required this.id, required this.bloco, required this.sala});

  Reservas.fromMap(Map<String, dynamic> map)
    : id = map["id"],
      bloco = map["bloco"],
      sala = map["sala"];

  Map<String, dynamic> toMap() {
    return {"id": id, "bloco": bloco, "sala": sala};
  }
}
