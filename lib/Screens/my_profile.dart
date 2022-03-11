import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:test_project/Config/validations.dart';
import 'package:test_project/Services/user_service.dart';

import '../models/user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // String email = "";
  // String mobile = "";
  // String firstName = "";
  // String lastName = "";

  bool isEdit = false;
  bool isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  // var netImg;

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     email = USEREMAIL;
  //     mobile = USERMOBILE;
  //     firstName = FIRSTNAME;
  //     lastName = LASTNAME;
  //     netImg = USERIMAGE;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserService>(
        builder: (context, us, child) => isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isEdit
                ? EditProfile(
                    mobile: us.user?.mobile ?? "",
                    email: us.user?.userEmail ?? "",
                    firstName: us.user?.firstName ?? "",
                    lastName: us.user?.lastName ?? "",
                    netImage: us.user?.imageName ?? "",
                    returnToPrevious: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    },
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 18.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //edit the profile
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                },
                                icon: const Icon(Icons.edit),
                              )
                            ],
                          ),
                          //space
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  color: CustomColors.black,
                                  width: 1.3,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://admin.sherkhanril.com/assets/images/user/profile/${us.user?.imageName ?? ""}',
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),

                          const SizedBox(
                            height: 25.0,
                          ),

                          //info
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              us.user?.firstName ?? "",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          //last name
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              us.user?.lastName ?? "",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          //email
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              us.user?.userEmail ?? "",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          //mobile number
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              us.user?.mobile ?? "",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

//   Future<void> getMyProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var auth = prefs.getString('authToken');
//     var header = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $auth'
//     };
//     try {
//       // print(baseURL + 'myprofile?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14');
//       final response = await http.get(
//         Uri.parse(
//           baseURL + 'myprofile?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
//         ),
//         headers: header,
//       );
//       var model = json.decode(response.body);
//       // print('------- ${model['image']}');
//       // print('------- $model');
//       if (response.statusCode == 200) {
//         if (model["status"] == 'fail') {
//           showToast(model["msg"].toString());
//         } else {
//           setState(() {
//             email = model['user_email'];
//             mobile = model['mobile'];
//             firstName = model['firstname'];
//             lastName = model['lastname'];
//             netImg = model['image'];
//           });
//         }
//       } else {
//         showToast(model["msg"].toString());
//       }
//     } catch (error) {
//       showToast(error.toString());
//     }
//   }
// }

class EditProfile extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String netImage;
  final VoidCallback returnToPrevious;

  const EditProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.netImage,
    required this.returnToPrevious,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? _emailController;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _mobileController;
  bool isLoading = false;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var img;
  String netImage = "";

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _mobileController = TextEditingController(text: widget.mobile);
    setState(() {
      netImage = widget.netImage;
    });
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _mobileController?.dispose();
    super.dispose();
  }

  Future<void> updateMyProfile(User userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final header = {'Authorization': 'Bearer $auth'};
    try {
      final request = http.MultipartRequest('POST',
          Uri.parse('https://admin.sherkhanril.com/api/profile-setting'));
      request.fields.addAll({
        'secret': 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        'firstname': _firstNameController!.text,
        'lastname': _lastNameController!.text,
        'user_email': _emailController!.text,
        'mobile': _mobileController!.text,
      });
      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ),
        );
      }
      //add all the headers
      request.headers.addAll(header);

      final response = await request.send();
      final streamData = await response.stream.bytesToString();
      final jsonBody = json.decode(streamData);
      //get the updated user
      final userInfo = User.fromJson(jsonBody["data"]);

      if (response.statusCode == 200) {
        Provider.of<UserService>(context, listen: false).updateValue(userInfo);
        showToast("profile updated succesfully");
      }
    } catch (error) {
      showToast(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxHeight: 300,
      maxWidth: 400,
    );
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        img = _imageFile;
      }
    });
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 300,
      maxWidth: 400,
    );
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        img = _imageFile;
      }
    });
  }

  void _showPicker() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  'Photo Library',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  _imgFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text(
                  'Camera',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _imgFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserService>(context, listen: false).user;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 18.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //exit
                IconButton(
                  onPressed: () {
                    widget.returnToPrevious();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: () {
                _showPicker();
              },
              child: _imageFile != null
                  ? Container(
                      margin: const EdgeInsets.all(2),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            File(img.path ?? ""),
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: CustomColors.black,
                            width: 1.3,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://admin.sherkhanril.com/assets/images/user/profile/$netImage',
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            AllInputDesign(
              controller: _firstNameController,
              labelText: 'First Name',
              keyBoardType: TextInputType.name,
              fillColor: CustomColors.white,
              contentPadding: const EdgeInsets.all(5.0),
              validator: validateName,
            ),
            const SizedBox(height: 15),
            AllInputDesign(
              controller: _lastNameController,
              labelText: 'Last Name',
              keyBoardType: TextInputType.name,
              fillColor: CustomColors.white,
              contentPadding: const EdgeInsets.all(5.0),
              validator: validateLastName,
            ),
            const SizedBox(height: 15),
            AllInputDesign(
              controller: _emailController,
              labelText: 'User Email',
              keyBoardType: TextInputType.emailAddress,
              fillColor: CustomColors.white,
              contentPadding: const EdgeInsets.all(5.0),
              validator: validateEmail,
            ),
            const SizedBox(height: 15),
            AllInputDesign(
              controller: _mobileController,
              labelText: 'Mobile',
              keyBoardType: TextInputType.phone,
              fillColor: CustomColors.white,
              contentPadding: const EdgeInsets.all(5.0),
              validator: validateMobile,
            ),
            const SizedBox(height: 15),
            Container(
              height: 40,
              margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: <Color>[
                    const Color(0xffEA1600).withOpacity(0.7),
                    const Color(0xffEA1600),
                  ],
                ),
              ),
              child: TextButton(
                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: CustomColors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          color: CustomColors.white,
                        ),
                      ),
                onPressed: () async {
                  final userInfo = User(
                    id: user?.id ?? 0,
                    firstName: _firstNameController?.text.toString() ?? "",
                    lastName: _lastNameController?.text.toString() ?? "",
                    userName: user?.userName ?? "",
                    email: user?.email ?? "",
                    userEmail: _emailController?.text.toString() ?? "",
                    mobile: _mobileController?.text.toString() ?? "",
                    panNo: user?.panNo ?? "",
                    aadharNo: user?.aadharNo ?? "",
                    bankName: user?.bankName ?? "",
                    accountNo: user?.accountNo ?? "",
                    ifsc: user?.ifsc ?? "",
                    balance: user?.balance ?? "",
                    refNo: user?.refNo ?? "",
                    totalInvested: user?.totalInvested ?? "",
                    imageName: user?.imageName ?? "",
                    // address: user?.address ?? "",
                    // state: user?.state ?? "",
                    // zip: user?.zip ?? "",
                    // country: user?.country ?? "",
                    paidDate: user?.paidDate ?? "",
                    updatedAt: user?.updatedAt ?? "",
                    kycStatus: user?.kycStatus ?? "",
                    secret: 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
                  );
                  await updateMyProfile(userInfo);
                  widget.returnToPrevious();
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
