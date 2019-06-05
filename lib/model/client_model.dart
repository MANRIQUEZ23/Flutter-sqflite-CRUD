

class Client{

  int id;
  String name;
  String phone;

  Client ( { this.id  , this.name , this.phone } );


  // metodo para insertar a nuestra BD, hay que convertirlo en un MAP
  Map<String, dynamic> toMap() => {
    "id": id ,
    "name": name ,
    "phone": phone ,
  };

  // para recibir los datos, pasar de un Map a un json
  factory Client.fromMap(Map<String, dynamic>  json ) => new Client(
    id: json["id"] ,
    name: json["name"] ,
    phone: json["phone"]
  );





}