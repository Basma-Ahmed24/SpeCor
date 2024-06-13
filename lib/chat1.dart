import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/const.dart';
import 'package:specor/message_model.dart';
import 'package:specor/model_chat.dart';
import 'package:specor/user_model.dart';
import 'specor_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class Chat_1  extends StatefulWidget{
  @override
  SpeCor_model chat_data;
  Chat_1(this.chat_data);
  State<Chat_1> createState() => _Chat_1State(chat_data);
}

class _Chat_1State extends State<Chat_1> {
  @override
  TextEditingController text=TextEditingController();
  SpeCor_model chat_data;
  List chat=[];
  User_model? x;
  final record = AudioRecorder();
  bool is_record=false;
  String path='';
  String url='';
  bool is_uploaded=false;
  bool is_player=false;
  late AudioPlayer audioPlayer;
  String auth=FirebaseAuth.instance.currentUser!.uid;
_Chat_1State(this.chat_data);
@override
  void initState() {
    // TODO: implement initState
  text.addListener(() {
    setState(() {

    });
  });
  get_x_user();

  Stream_chat();
audioPlayer=AudioPlayer();
    super.initState();
  }
  int? currentlyPlayingIndex;

  void dispose(){
  super.dispose();
  audioPlayer.dispose();
  }
  Widget build(BuildContext context) {
    // TODO: implement build
  return Scaffold(

    appBar:AppBar(


      backgroundColor: Colors.black87,
      elevation: 0,
      title: Row(
        children: [
          x!.image==""?CircleAvatar(backgroundImage: AssetImage("assets/avatar.png",) ,):CircleAvatar(backgroundImage:NetworkImage( x!.image),)
          ,SizedBox(width: 10.w,), Text(x!.name??''),
        ],
      ),
    )
        ,body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/OIP.jpg",),fit: BoxFit.fill)),
    child:Column(
      children: [
        Expanded(
          child: ListView.builder(itemCount: chat.length,
        reverse:true ,itemBuilder:(_,index)=> message_item(message_model.from_json(chat[chat.length-(index+1)]),index)

          ,),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.black87,
          height: 80.h,child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: text,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
SizedBox(width: 10.w,),
           text.text.isEmpty?CircleAvatar(
             backgroundColor:is_uploaded==false? Colors.blue:Colors.grey,
             child: IconButton(onPressed:is_uploaded==false? (){
               if(!is_record){
                 start_record();
               }
               else{
                 stop_record();
               }
             }:(){},
             icon: is_record==true&&is_uploaded==false?Icon(Icons.stop):is_record==false &&is_uploaded==false? Icon(Icons.mic):Icon(Icons.upload,color: Colors.black54,),),
           ):   IconButton(onPressed: () async {
              await  add_message("text");
                setState(() {
                  text.text='';

                });
              }, icon: Icon(Icons.send,color: Colors.blue,))
            ],
          ),)
      ],
    )
  ),
  );
  }
  get_x_user(){
  setState(() {
    x=chat_data.users[chat_data.users.indexWhere((element) => element.id!=auth)];

  });
  }
  Stream_chat()async{
    
    await FirebaseFirestore.instance.collection('chats').doc(chat_data.id).snapshots().listen((event) {
chat=SpeCor_model.from_json(event.data()).chat.toList();
    });
    setState(() {

    });
  }
  add_message(kind)async{
  CollectionReference ref=FirebaseFirestore.instance.collection('chats');
  await ref.doc(chat_data.id).update({'chat':FieldValue.arrayUnion([message_model(id: 'id', text:  text.text, sender_id: auth, time: Timestamp.now(),show_time: false,audio: url,kind: kind).to_json()])});
  }
 Widget message_item(message_model message,int indexx){
   bool isCurrentlyPlaying = currentlyPlayingIndex == indexx;

   int index=chat.indexWhere((element) => element['time']==message.time);
return  InkWell(
  splashColor: Colors.transparent,
  hoverColor: Colors.transparent,
  highlightColor: Colors.transparent,
  onTap: (){
setState(() {
  chat[index]['show_time']=!chat[index]['show_time'];
});

  },
  child:   Column(
    children: [
   message.kind=='text'?   BubbleSpecialThree(

        isSender:message.sender_id==auth,

        text: message.text,

        color:message.sender_id==auth? Color(0xFF1B97F3):Colors.black54,

        tail: true,
        seen:message.sender_id==auth? true:false,
        textStyle: TextStyle(

            color: Colors.white,

            fontSize: 16.sp

        ),

      ):
   BubbleNormalAudio(
     onSeekChanged: (e) {},
     isPlaying: isCurrentlyPlaying && is_player,
     isLoading: false,
     isSender:message.sender_id==auth ,
     onPlayPauseButtonClick: () {
       if (isCurrentlyPlaying) {
         stop();
       } else {
         play(message.audio);
         setState(() {
           currentlyPlayingIndex = indexx;
         });
       }
     },
   ),

      message.show_time? Text(message.time.toDate().toString(),style: TextStyle(color: Colors.white),):SizedBox()
    ],
  ),
);

 }
 start_record()async{


   final location=await getApplicationDocumentsDirectory();
  String name=Uuid().v1();
  if(await record.hasPermission()){
    await record.start(RecordConfig(), path: location.path+name+'.m4a');
    setState(() {
      is_record=true;
    });
  }
  print("start record");
 }
 stop_record()async{
  String? final_path= await record.stop();
  setState(() {
    path=final_path!;
    is_record=false;

  });
  print('stop record');
  upload();
 }
 upload()async{
  setState(() {
    is_uploaded=true;
  });
  String name=basename(path);
  final ref= FirebaseStorage.instance.ref("voice/"+name);
  await ref.putFile(File(path));
  String download_url= await ref.getDownloadURL();
  setState(() {
    url=download_url;
    is_uploaded=false;
  });

  print("uploaded");
  add_message('audio');
 }
  Future<void> play(url) async {
    // Stop currently playing audio if any


    await audioPlayer.play(UrlSource(url));
    setState(() {
      is_player = true;
    });
  }

  stop() async {
    await audioPlayer.stop();
    setState(() {
      is_player = false;
      currentlyPlayingIndex = null;
    });
  }

}