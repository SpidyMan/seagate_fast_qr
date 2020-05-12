 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
 // Explocit
  final formKey = GlobalKey<FormState>();
  String gid,emailString,passwordString;
  SharedPreferences prefs;

  @override
  void initState() { 
    super.initState(); 
    getGID();
  }
  void saveGID() async{
    prefs =await SharedPreferences.getInstance();  
    prefs.setString('GID', gid);
    gid =prefs.getString('GID');
    
  }
  void getGID() async{
     prefs =await SharedPreferences.getInstance();  
    
    setState(() {
      gid = prefs.getString('GID') ?? "";
    print('gidget = $gid');
    }
    );
  
  }
  //Method
  Widget registerButton()  {
    return IconButton(
      icon: Icon(Icons.save_alt),
      iconSize: 50.0,
      color: Colors.blue,
      onPressed: () {
        print(' You click upload ');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
    
          print('you enter gid = $gid');
          saveGID();
        }
      },
    );
  }

  Widget enterGID() {  
    return TextFormField(
      initialValue: gid,
      style: TextStyle(
        color: Colors.blue,
        
      ),
      decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            color: Colors.blue,
            size: 48.0,
          ),
          labelText: 'GID:',
          labelStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          helperText: 'type in your GID'),
          validator: (String value){
            if (value.isEmpty) {
              return 'Please check your GID';
            } else {
              return null;
            }
          },onSaved: (String value){
            gid = value.trim();
          },
    );
  }
   Widget showSaved(){
    return Text(
      gid,
      
      style: TextStyle(
          
          fontSize: 0.1,
          color: Colors.white, 
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: Text('Register'),
  
      ),
      body: Form(key: formKey,
              child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            showSaved(),
            enterGID(), 
            registerButton(),
            
          ],
        ),
      ),
    );
  }
 
}