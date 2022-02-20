
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gallery_app/custom_widgets/custom_widgets.dart';
import 'package:gallery_app/main.dart';
import 'package:gallery_app/model/image_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var box = Hive.box<ImagePath>(boxName);
  XFile? _image;
  dynamic _imagepath;
   File? directoryFile;

  getPermissionCamera()async{
    var checkStatus =  await Permission.camera.status;
    if(checkStatus.isGranted){
     getPermissionStorage();
    } else if(checkStatus.isDenied){
      await Permission.camera.request();
    }else{
      const SnackBar(content: Text("Please enable camera permission to continue",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
      openAppSettings();
    }
    }

  getPermissionStorage()async{
   var storagePermission = await Permission.storage.status;
   if(storagePermission.isGranted){
     getImage();
   }else if(storagePermission.isDenied){
     await Permission.storage.request();
     await Permission.accessMediaLocation;
     await Permission.manageExternalStorage;
   }else{
     const SnackBar(content: Text("Please enable storage permission to continue",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
     openAppSettings();
   }
 }

  Future getImage() async {
    var externaldir = await getExternalStorageDirectory();
    String newPath = "";
    List<String> directoryList = externaldir!.path.split('/');
    for(int i=1;i<directoryList.length;i++){
      String tempPath = directoryList[i];
      if(directoryList[i]!='Android'){
        newPath += "/"+tempPath;
      }else{break;}
    }
    newPath += "/MyGallery";
    externaldir = Directory(newPath);
    String externaldirPath = externaldir.path;

    Directory? directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;


    ImagePicker _imagePicker = ImagePicker();
    _image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (_image != null) {
      final path = basename(_image!.path);
      if(!await externaldir.exists()){
        await externaldir.create(recursive: true);
      }else{
        directoryFile = await File(_image!.path).copy('$externaldirPath/$path');
      }
      final File file = await File(_image!.path).copy('$directoryPath,$path');
      setState(() {
        _imagepath = directoryFile!.path;
        box.add(ImagePath(imagepath: _imagepath));
      });
    }return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingCustom(
            onpressed: () {
              getPermissionCamera();
            },
          ),
          backgroundColor:
          Colors.black26,
          body: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (BuildContext context,
                  Box<ImagePath> newbox, Widget? child) {
                List key = newbox.keys.toList();
                return key.isEmpty ? const Center(child: Text("Click Images",style: TextStyle(color: Colors.white),),) :
                GridView.builder(
                  padding: const EdgeInsets.all(7),
                  itemCount: key.length,
                  gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5
                  ) , itemBuilder: ( context,index){
                  List<ImagePath> images = newbox.values.toList();
                  return ImageTile(imagepath: images[index].imagepath, index: index, imagebox: images,);
                },);
              }
          )
      ),
    );
  }
}


