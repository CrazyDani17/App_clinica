import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Calendario de Citas',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Citas programadas'),
          actions: [
            IconButton(icon: Icon(Icons.add_outlined ), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },),
          ]
          ),
          
        body: JsonListView(),
      ),
    );
  }
}

class EditRoute extends StatelessWidget {
  final int cita_id;
  final String schedule_date;
  final String schedule_time;
  final String patient_name;
  final String patient_lastname;
  final String patient_phonenumber;
  final String matter;
  EditRoute (this.cita_id,this.schedule_date,this.schedule_time, this.patient_name, this.patient_lastname,
  this.patient_phonenumber, this.matter);
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Editar Cita';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomEditForm(cita_id,schedule_date,schedule_time,patient_name, patient_lastname, patient_phonenumber, matter),
      ),
    );
  }
}

// Crea un Widget Form
class MyCustomEditForm extends StatefulWidget {
  final int cita_id;
  final String schedule_date;
  final String schedule_time;
  final String patient_name;
  final String patient_lastname;
  final String patient_phonenumber;
  final String matter;
  MyCustomEditForm (this.cita_id,this.schedule_date,this.schedule_time, this.patient_name, this.patient_lastname,
  this.patient_phonenumber, this.matter);
  @override
  MyCustomEditFormState createState() {
    return MyCustomEditFormState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class MyCustomEditFormState extends State<MyCustomEditForm> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schedule_date;
  late TextEditingController _schedule_time;
  late TextEditingController _patient_name;
  late TextEditingController _patient_lastname;
  late TextEditingController _patient_phonenumber;
  late TextEditingController _matter;

  @override
  void initState(){
    _schedule_date = TextEditingController(text: widget.schedule_date);
    _schedule_time = TextEditingController(text: widget.schedule_time);
    _patient_name = TextEditingController(text: widget.patient_name);
    _patient_lastname = TextEditingController(text: widget.patient_lastname);
    _patient_phonenumber = TextEditingController(text: widget.patient_phonenumber);
    _matter = TextEditingController(text: widget.matter);
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _schedule_date,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: 'Fecha'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna fecha';
              }
            },
          ),
          TextFormField(
            controller: _schedule_time,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time),
              labelText: 'Hora'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna hora';
              }
            },
          ),
          TextFormField(
            controller: _patient_name,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Nombre del paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun nombre';
              }
            },
          ),
          TextFormField(
            controller: _patient_lastname,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Apellido del paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun apellido';
              }
            },
          ),
          TextFormField(
            controller: _patient_phonenumber,
            decoration: const InputDecoration(
              icon: Icon(Icons.contact_phone),
              labelText: 'Número telefónico del Paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun número telefónico';
              }
            },
          ),
          TextFormField(
            controller: _matter,
            decoration: const InputDecoration(
              icon: Icon(Icons.medical_services_outlined),
              labelText: 'Asunto de la cita'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna descripción';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // devolverá true si el formulario es válido, o falso si
                // el formulario no es válido.
                  if (_formKey.currentState!.validate()) {
                    // Si el formulario es válido, queremos mostrar un Snackbar
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    editCita(widget.cita_id, _schedule_date.text, _schedule_time.text, 
                    _patient_name.text, _patient_lastname.text, _patient_phonenumber.text, _matter.text );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }
              },
              child: Text('Aceptar'),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Programar nueva cita';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Crea un Widget Form
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class MyCustomFormState extends State<MyCustomForm> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schedule_date = TextEditingController();
  final TextEditingController _schedule_time = TextEditingController();
  final TextEditingController _patient_name = TextEditingController();
  final TextEditingController _patient_lastname = TextEditingController();
  final TextEditingController _patient_phonenumber = TextEditingController();
  final TextEditingController _matter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _schedule_date,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: 'Fecha'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna fecha';
              }
            },
          ),
          TextFormField(
            controller: _schedule_time,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time),
              labelText: 'Hora'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna hora';
              }
            },
          ),
          TextFormField(
            controller: _patient_name,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Nombre del paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun nombre';
              }
            },
          ),
          TextFormField(
            controller: _patient_lastname,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Apellido del paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun apellido';
              }
            },
          ),
          TextFormField(
            controller: _patient_phonenumber,
            decoration: const InputDecoration(
              icon: Icon(Icons.contact_phone),
              labelText: 'Número telefónico del Paciente'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa algun número telefónico';
              }
            },
          ),
          TextFormField(
            controller: _matter,
            decoration: const InputDecoration(
              icon: Icon(Icons.medical_services_outlined),
              labelText: 'Asunto de la cita'
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Por favor ingresa alguna descripción';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // devolverá true si el formulario es válido, o falso si
                // el formulario no es válido.
                  if (_formKey.currentState!.validate()) {
                    // Si el formulario es válido, queremos mostrar un Snackbar
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    createCita(_schedule_date.text, _schedule_time.text, 
                    _patient_name.text, _patient_lastname.text, _patient_phonenumber.text, _matter.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }
              },
              child: Text('Aceptar'),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

Future<Cita> createCita(String schedule_date, String schedule_time, String patient_name, String patient_lastname, String patient_phonenumber, String matter) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.205/cita/create_cita'),
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Token' : 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
    },
    body: jsonEncode(<String, String>{
      'schedule_date': schedule_date,
      'schedule_time': schedule_time,
      'patient_name': patient_name,
      'patient_lastname': patient_lastname,
      'patient_phonenumber':patient_phonenumber,
      'matter': matter,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    return Cita.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Cita> editCita(int cita_id,String schedule_date, String schedule_time, String patient_name, String patient_lastname, String patient_phonenumber, String matter ) async {
  final response = await http.put(
    Uri.parse('http://192.168.0.205/cita/update_cita/' + cita_id.toString()),
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Token' : 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
    },
    body: jsonEncode(<String, String>{
      'schedule_date': schedule_date,
      'schedule_time': schedule_time,
      'patient_name': patient_name,
      'patient_lastname': patient_lastname,
      'patient_phonenumber':patient_phonenumber,
      'matter': matter,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    return Cita.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Cita> deleteCita(int cita_id) async {
  final response = await http.delete(
      Uri.parse('http://192.168.0.205/cita/delete_cita/' + cita_id.toString()),
      headers: {
        'Token' : 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
      },
    );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    return Cita.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Cita {
  final int id;
  final String schedule_date;
  final String schedule_time;
  final String patient_name;
  final String patient_lastname;
  final String patient_phonenumber;
  final String matter;
  final int doctor_id;

  Cita({
    required this.id,
    required this.schedule_date,
    required this.schedule_time,
    required this.patient_name,
    required this.patient_lastname,
    required this.patient_phonenumber,
    required this.matter,
    required this.doctor_id,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      schedule_date: json['schedule_date'],
      schedule_time: json['schedule_time'],
      patient_name: json['patient_name'],
      patient_lastname: json['patient_lastname'],
      patient_phonenumber: json['patient_phonenumber'],
      matter: json['matter'],
      doctor_id: json['doctor_id'],
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.schedule_date,
    required this.schedule_time,
    required this.patient_name,
    required this.patient_lastname,
    required this.patient_phonenumber,
    required this.matter,
    required this.cita_id,
  }) : super(key: key);

  final String schedule_date;
  final String schedule_time;
  final String patient_name;
  final String patient_lastname;
  final String patient_phonenumber;
  final String matter;
  final int cita_id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: _CitaDescription(
              schedule_date: schedule_date,
              schedule_time: schedule_time,
              patient_name: patient_name,
              patient_lastname: patient_lastname,
              patient_phonenumber: patient_phonenumber,
              matter: matter,
            ),
          ),
          IconButton(icon: Icon(Icons.edit ), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditRoute(cita_id,schedule_date,schedule_time,patient_name, patient_lastname, patient_phonenumber, matter)),
            );
          }),
        ],
      ),
    );
  }
}

class _CitaDescription extends StatelessWidget {
  const _CitaDescription({
    Key? key,
    required this.schedule_date,
    required this.schedule_time,
    required this.patient_name,
    required this.patient_lastname,
    required this.patient_phonenumber,
    required this.matter,
  }) : super(key: key);

  final String schedule_date;
  final String schedule_time;
  final String patient_name;
  final String patient_lastname;
  final String patient_phonenumber;
  final String matter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            schedule_date,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "Hora: " + schedule_time,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            "Paciente: "  + patient_name + " " + patient_lastname + " / " + patient_phonenumber,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            "Asunto: " + matter,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}


class JsonListView extends StatefulWidget {

  JsonListViewWidget createState() => JsonListViewWidget();

}

class JsonListViewWidget extends State<JsonListView> {

    Future<Null> refreshList () async{

    await Future.delayed(Duration(seconds: 2));

    setState((){
      future: fetchCitas();
    });

    return null;

  }

  Future<List<Cita>> fetchCitas() async {

    var response = await http.get(
      Uri.parse('http://192.168.0.205/cita/get_citas_medico'),
      headers: {
        'Token' : 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZXhwIjoxNjI1NzM3NjQxfQ.oo9HFIVr3ZhuOSRl1mfabe7PpMmDjxBSOgXlt0Of2RU',
      },
    );

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Cita> listOfCitas = items.map<Cita>((json) {
        return Cita.fromJson(json);
      }).toList();

      return listOfCitas;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cita>>(
        future: fetchCitas(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator()
            );

          return RefreshIndicator(
           child: ListView(
            children: snapshot.data!
                .map((data) => /*ListTile(
                      title: Text(data.schedule_date),
                      subtitle: Text(data.schedule_time),

                      //onTap: (){print(data.schedule_date);},
                    ))*/
                    Dismissible(
                         onDismissed: (_) {// El parámetro no se usa temporalmente, se indica con un guión bajo
                          deleteCita(data.id);
                          print(data.id);
                         }, // monitor
            movementDuration: Duration(milliseconds: 100),
            key: Key(data.id.toString()),
            child:
      CustomListItem(
        schedule_date: data.schedule_date,
        schedule_time: data.schedule_time,
        patient_name: data.patient_name,
        patient_lastname: data.patient_lastname,
        patient_phonenumber: data.patient_phonenumber,
        matter: data.matter,
        cita_id: data.id
      ),
            /*child: ListTile(
            title: Text(data.schedule_date),
            subtitle: Text(data.schedule_time),
            trailing: IconButton(icon: Icon(Icons.edit ), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditRoute(data.id)),
            );
          })
            ),*/
            background: Container(
              color: Color(0xffff0000),
            ),
          )
                ).toList(),
          ),
          onRefresh: refreshList);
        },
    );
  }
}