import 'dart:io';
import 'package:firstapp/Helpers/deviceSize.dart';
import 'package:firstapp/Models/Friend.dart';
import 'package:firstapp/Providers/FriendsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class addFriendScreen extends StatefulWidget {
  @override
  State<addFriendScreen> createState() => _addFriendScreenState();
}

class _addFriendScreenState extends State<addFriendScreen> {
  Map<String,String> listOfInterests = {};
  TextEditingController? about;
  TextEditingController? addInterest;
  TextEditingController? dob;
  TextEditingController? edu;
  TextEditingController? email;
  TextEditingController? facebook;
  String? gender;
  TextEditingController? instagram;
  TextEditingController? interest;
  bool isMale = true;
  late bool isUploading;
  TextEditingController? linkedin;
  TextEditingController? phone;
  final picker = ImagePicker();
  TextEditingController? profession;
  TextEditingController? snapchat;
  TextEditingController? title;
  TextEditingController? twiiter;
  TextEditingController? youtube;

  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void dispose() {
    addInterest!.dispose();
    twiiter!.dispose();
    title!.dispose();
    about!.dispose();
    edu!.dispose();
    profession!.dispose();
    interest!.dispose();
    dob!.dispose();
    phone!.dispose();
    email!.dispose();
    instagram!.dispose();
    snapchat!.dispose();
    youtube!.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addInterest = TextEditingController();
    phone = TextEditingController();
    title = TextEditingController();
    about = TextEditingController();
    dob = TextEditingController();
    edu = TextEditingController();
    instagram = TextEditingController();
    youtube = TextEditingController();
    facebook = TextEditingController();
    snapchat = TextEditingController();
    interest = TextEditingController();
    profession = TextEditingController();
    email = TextEditingController();
    twiiter = TextEditingController();
    isUploading = false;
    linkedin = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        setState(() {
          _imageFile = File(pickedFile!.path);
        });
      }
    }

   

    clearAllTextField() {
      email!.clear();
      twiiter!.clear();
      linkedin!.clear();
      phone!.clear();
      dob!.clear();
      title!.clear();
      about!.clear();
      youtube!.clear();
      snapchat!.clear();
      facebook!.clear();
      profession!.clear();
      interest!.clear();
      edu!.clear();
      instagram!.clear();
    }

    dpExists() {
      return CircleAvatar(
        backgroundImage: FileImage(_imageFile!),
        radius: displayWidth(context) * 0.2,
      );
    }

    dpNotExist() {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.person,
          size: displayWidth(context) * 0.2,
          color: Colors.black38,
        ),
        radius: displayWidth(context) * 0.2,
      );
    }

    Future<void> addInterestInDialogBox()async{
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: Text("Add more interests"),
            content: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('What is your friend interested in ?'),
                    Opacity(child: Divider(),opacity: 0,),
                    Container(
                      height: displayHeight(context)*0.06,
                      width: displayWidth(context)*0.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                     child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          controller: interest,
                          toolbarOptions: ToolbarOptions(
                              copy: true, cut: true, selectAll: true, paste: true),
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "Dance , Music , etc ...",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          showCursor: true,
                        ),
                      ),
                    ),
                  ],
                ),
            ),

            actions: [
              TextButton(onPressed:  () {
                Navigator.of(context).pop();
              }, child: Text('Close',style: TextStyle(color: Colors.red[300],fontWeight: FontWeight.bold))),
              TextButton(
                onPressed:  () {
                  setState(() {
                    listOfInterests[interest!.text.toString()] = interest!.text.toString();
                  });
                  Navigator.of(context).pop();
              }, child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),style: ButtonStyle(
                elevation: MaterialStateProperty.all(3),
                backgroundColor: MaterialStateProperty.all(Colors.orange[300])
              ),),
            ],
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          );
        },
      );
    }

    void addThisInterestToList(String itr){
      setState(() {
        listOfInterests[itr] = itr;
      });
      print(listOfInterests);
    }

    void removeThisInterstFromList(String itr){
      setState(() {
        listOfInterests.remove(itr);
      });
      print(listOfInterests);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          (isUploading)
              ? CircularProgressIndicator(
                  backgroundColor: Colors.orange[400],
                  color: Colors.indigoAccent,
                )
              : TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isUploading = true;
                      });
                      Provider.of<FriendsManager>(context, listen: false)
                          .addFriend(
                              _imageFile,
                              Friend(
                                about: about!.text.toString(),
                                contactNumber: phone!.text.toString(),
                                dob: dob!.text.toString(),
                                docId: '',
                                dp: '',
                                isBestFriend: false,
                                isCloseFriend: false,
                                education: edu!.text.toString(),
                                facebook: facebook!.text.toString(),
                                gender: (isMale) ? "Male" : "Female",
                                instagram: instagram!.text.toString(),
                                interests: interest!.text.toString(),
                                linkedin: linkedin!.text.toString(),
                                mail: email!.text.toString(),
                                profession: profession!.text.toString(),
                                snapchat: snapchat!.text.toString(),
                                title: title!.text.toString(),
                                twitter: twiiter!.text.toString(),
                                youtube: youtube!.text.toString(),
                              ))
                          .then((value) {
                        setState(() {
                          isUploading = false;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Congratulations !! ${title!.text.toString()} is now your friend")));
                        });
                      });
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: displayWidth(context) * 0.045),
                  )),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  elevation: 8,
                  title: Text('Clear all'),
                  content:
                      Text('Are you sure you want to clear all textfields ?'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close')),
                    TextButton(
                        onPressed: () {
                          clearAllTextField();
                          Navigator.pop(context);
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.red[300],
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 16, right: 16, bottom: 8),
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            )))
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.close),
          color: Colors.red,
        ),
        title: Text(
          'New Friend',
          style: TextStyle(color: Colors.black, letterSpacing: 0.5),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12.0, left: 10, right: 10, bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: (isUploading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: GestureDetector(
                                  onTap: () => pickImage(),
                                  child: (_imageFile != null)
                                      ? dpExists()
                                      : dpNotExist())),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.015,
                              )),
                          Center(
                            child: Text('Display Picture',
                                style: TextStyle(
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.05)),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.03,
                              )),
                          Text(
                            'Basic Detail',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.045,
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Full Name',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: title,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length == 0)
                                      return 'Cannot be empty';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Friend\'s name',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Date of birth',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: dob,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement

                                      setState(() {
                                        dob!.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'dd/mm/yyyy',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Gender',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: displayHeight(context) * 0.06,
                                width: displayWidth(context) * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.grey[300]!)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isMale,
                                      onChanged: (value) {
                                        setState(() {
                                          if (!isMale) {
                                            isMale = !isMale;
                                            gender = "Male";
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: displayHeight(context) * 0.06,
                                width: displayWidth(context) * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.grey[300]!)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: !isMale,
                                      onChanged: (value) {
                                        setState(() {
                                          if (isMale) {
                                            isMale = !isMale;
                                            gender = "Female";
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Education',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: edu,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length == 0)
                                      return 'Cannot be empty';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'School or University name',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Profession',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: profession,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length == 0)
                                      return 'Cannot be empty';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Student , Engineer , Doctor ..',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'About',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.15,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: about,
                                maxLines: 10,
                                validator: (value) {
                                  if (value!.isEmpty || value.length == 0)
                                    return 'Cannot be empty';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Tell us about your new friend',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Divider(
                              height: displayHeight(context) * 0.02,
                            ),
                          ),
                          Text(
                            'Contact Detail',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.045,
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Mobile Number',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.length != 10)
                                      return 'Mobile number should contain 10 digits';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter 10 digit number',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Email Address',
                            style: TextStyle(color: Colors.black),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: email,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.length == 0)
                                      return 'Cannot be empty';
                                    else {
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid)
                                        return 'Provide valid email';
                                      else
                                        return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'friends@gmail.com',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Divider(
                              height: displayHeight(context) * 0.03,
                            ),
                          ),
                          Text(
                            'Social Media',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.045,
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.logo_facebook,
                                color: Colors.blue[700],
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Facebook',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: facebook,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Facebook ID',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.logo_instagram,
                                color: Colors.pinkAccent,
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Instagram',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: instagram,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Instagram ID',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.logo_twitter,
                                color: Colors.blue[700],
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Twitter',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: twiiter,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Twitter ID',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.logo_linkedin,
                                color: Colors.blue[600],
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Linkedin',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: linkedin,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Linkedin ID',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.logo_snapchat,
                                color: Colors.yellow[600],
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Snapchat',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: snapchat,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Twitter ID',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: displayWidth(context) * 0.033,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('images/yt.png'),
                              ),
                              Opacity(
                                  child: VerticalDivider(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  opacity: 0.0),
                              Text(
                                'Youtube',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: 0,
                            child: Divider(
                              height: displayHeight(context) * 0.01,
                            ),
                          ),
                          Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1.1)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 2.0),
                              child: Center(
                                child: TextFormField(
                                  controller: youtube,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'Youtube channel',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.02,
                              )),
                          Text(
                            'Interests',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.045,
                            ),
                          ),
                          Opacity(
                              opacity: 0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Cricket")){
                                    removeThisInterstFromList("Cricket");
                                  }
                                  else{
                                    addThisInterestToList("Cricket");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Cricket',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Dance")){
                                    removeThisInterstFromList("Dance");
                                  }
                                  else{
                                    addThisInterestToList("Dance");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Dance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Singing")){
                                    removeThisInterstFromList("Singing");
                                  }
                                  else{
                                    addThisInterestToList("Singing");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Singing',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Cooking")){
                                    removeThisInterstFromList("Cooking");
                                  }
                                  else{
                                    addThisInterestToList("Cooking");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Cooking',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Anime")){
                                    removeThisInterstFromList("Anime");
                                  }
                                  else{
                                    addThisInterestToList("Anime");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Anime',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Football")){
                                    removeThisInterstFromList("Football");
                                  }
                                  else{
                                    addThisInterestToList("Football");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Football',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(listOfInterests.containsKey("Party")){
                                    removeThisInterstFromList("Party");
                                  }
                                  else{
                                    addThisInterestToList("Party");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Party',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Cartoon")){
                                    removeThisInterstFromList("Cartoon");
                                  }
                                  else{
                                    addThisInterestToList("Cartoon");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Cartoon',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Art")){
                                    removeThisInterstFromList("Art");
                                  }
                                  else{
                                    addThisInterestToList("Art");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Art',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Cricket")){
                                    removeThisInterstFromList("Cricket");
                                  }
                                  else{
                                    addThisInterestToList("Cricket");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Cricket',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Dance")){
                                    removeThisInterstFromList("Dance");
                                  }
                                  else{
                                    addThisInterestToList("Dance");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Dance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Mechanics")){
                                    removeThisInterstFromList("Mechanics");
                                  }
                                  else{
                                    addThisInterestToList("Mechanics");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Mechanics',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Engineering")){
                                    removeThisInterstFromList("Engineering");
                                  }
                                  else{
                                    addThisInterestToList("Engineering");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Engineering',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Coding")){
                                    removeThisInterstFromList("Coding");
                                  }
                                  else{
                                    addThisInterestToList("Coding");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Coding',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Horror")){
                                    removeThisInterstFromList("Horror");
                                  }
                                  else{
                                    addThisInterestToList("Horror");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Horror',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Web Series")){
                                    removeThisInterstFromList("Web Series");
                                  }
                                  else{
                                    addThisInterestToList("Web Series");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Web Series',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Movies")){
                                    removeThisInterstFromList("Movies");
                                  }
                                  else{
                                    addThisInterestToList("Movies");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Movies',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(listOfInterests.containsKey("Simping")){
                                    removeThisInterstFromList("Simping");
                                  }
                                  else{
                                    addThisInterestToList("Simping");
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Simping',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              VerticalDivider(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  addInterestInDialogBox();
                                },
                                child: Card(
                                  color: Colors.deepPurple[300],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '+ Other',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
