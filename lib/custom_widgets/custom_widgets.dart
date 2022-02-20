import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/image_model.dart';

class ImageTile extends StatelessWidget {
  final dynamic imagepath;
  final List<ImagePath> imagebox;
  final int index;
  const ImageTile({Key? key, required this.imagepath,required this.index, required this.imagebox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
        child:  GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HeroImage(imagepathhero: imagepath,)));
              },
              onLongPress: (){
                showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text("Delete"),
                        content: const Text("Do you want to delete?"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text("No")),
                          TextButton(onPressed: () async{
                            File file = File(imagebox[index].imagepath);
                            if(await file.exists()){
                              await file.delete();
                            }
                            imagebox[index].delete();
                            Navigator.pop(context);
                          }, child: const Text("Yes")),
                        ],
                      );
                    });
              },
              child: Hero(
                  tag: Text(imagepath!),
                  child: ClipRRect(child: Image.file(File(imagepath),fit: BoxFit.fill,),))),);
  }
}

class HeroImage extends StatelessWidget {
  final dynamic imagepathhero;
  const HeroImage({Key? key, required this.imagepathhero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: IconButton(icon: const Icon(Icons.close,color: Colors.white,), onPressed: () { Navigator.pop(context);},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Center(
        child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Hero(
                tag: Text(imagepathhero!),
                child: Image.file(File(imagepathhero)))),
      ),
    );
  }
}

class FloatingCustom extends StatelessWidget {
  VoidCallback onpressed;
   FloatingCustom({Key? key,required this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: onpressed,
    );
  }
}
