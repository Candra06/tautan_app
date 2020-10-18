import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/drawer.dart';
import 'package:tautan_app/helper/input.dart';
import 'package:tautan_app/helper/routes.dart';

class AddLaporan extends StatefulWidget {
  @override
  _AddLaporanState createState() => _AddLaporanState();
}

class _AddLaporanState extends State<AddLaporan> {
  TextEditingController txtlink = new TextEditingController();
  TextEditingController txtAlasan = new TextEditingController();
  List kategori = ['Pilih kategori', 'hoax', 'penipuan'];
  String getKategori;
  String fileName = '';
  Future<File> foto;
  String base64Image;
  File tmpFile;
  Future<File> file;

  getImage(context) async {
    final imgSrc = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Pilih sumber gambar"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Kamera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  // onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galeri"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imgSrc != null) {
      setState(() {
        foto = ImagePicker.pickImage(source: imgSrc);
        String image = foto.toString();
        print('fotonya ' + image);
        print(foto);
      });
    }
  }
  Widget showImage() {
    return Container(
      child: FutureBuilder<File>(
        future: foto,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            tmpFile = snapshot.data;
            fileName = tmpFile.path.split("/").last;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return Column(
              children: [
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 200,
                //   child: Image.file(snapshot.data, fit: BoxFit.contain),
                // ),
                Container(
                  alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      fileName,
                      maxLines: 3,
                    )),
              ],
            );
            // return Container(
            //   margin: EdgeInsets.all(8),
            //   child: Image.file(snapshot.data, fit: BoxFit.fill),
            // );
          } else if (snapshot.error != null) {
            return const Text(
              'Error saat memilih foto!',
              textAlign: TextAlign.center,
            );
          } else {
            return Column(
              children: <Widget>[Text('Pilih foto (Opsional)')],
            );
          }
        },
      ),
    );
  }

  // Widget showImage() {
  //   return Container(
  //     child: FutureBuilder<File>(
  //       future: foto,
  //       builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done &&
  //             snapshot.data != null) {
  //           tmpFile = snapshot.data;
  //           fileName = tmpFile.path.split("/").last;

  //           print("namafile " + fileName);
  //           base64Image = base64Encode(snapshot.data.readAsBytesSync());
  //           print(base64Image);
  //           print("imagenya " + fileName);
  //           return Text(fileName);
  //         } else if (snapshot.error != null) {
  //           return const Text(
  //             'Error saat memilih foto!',
  //             textAlign: TextAlign.center,
  //           );
  //         } else {
  //           return Column(
  //             children: <Widget>[Text('Pilih file bukti')],
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  void simpanLaporan() async {
    Config.loading(context);
    String token = await Config.getToken();
    String id = await Config.getID();
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Accept': 'application/json'
    };
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(Config.ipServerAPI + 'addLink'),
    );
    imageUploadRequest.files
        .add(await http.MultipartFile.fromPath('file_pendukung', tmpFile.path));
    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.fields['create_by'] = id;
    imageUploadRequest.fields['kategori'] = getKategori;
    imageUploadRequest.fields['link'] = txtlink.text;
    imageUploadRequest.fields['alasan'] = txtAlasan.text;
    var res = await imageUploadRequest.send();
    var conf = res.reasonPhrase;
    print("resnya" + conf.toString());

    if (res.statusCode == 200) {
      Navigator.pop(context);
      success(context);
    } else {
      Navigator.pop(context);
      Config.alert(2, 'Gagal melaporkan link');
    }
  }

  void addLaporan() async {
    Config.loading(context);
    String token = await Config.getToken();
    String id = await Config.getID();

    var body = new Map<String, dynamic>();
    body['kategori'] = getKategori;
    body['link'] = txtlink.text;
    body['alasan'] = txtAlasan.text;
    body['file_pendukung'] = fileName.toString();
    body['create_by'] = id;
    print(body);
    var res = await http.post(Config.ipServerAPI + 'addLink',
        body: body,
        headers: {
          'Authorization': 'Bearer ' + token,
          'Accept': 'application/json'
        });
    print(res.body);
    if (res.statusCode == 200) {
      Navigator.pop(context);
      success(context);
    } else {
      print(res.body);
      Navigator.pop(context);
      Config.alert(2, 'Gagal melaporkan link');
    }
  }

  List<DropdownMenuItem<String>> kategoriItem;

  List<DropdownMenuItem<String>> getDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (String ktg in kategori) {
      items.add(new DropdownMenuItem(value: ktg, child: new Text(ktg)));
    }
    return items;
  }

  void changedDropDownItem(String selectedKategori) {
    setState(() {
      getKategori = selectedKategori;
    });
  }

  @override
  void initState() {
    kategoriItem = getDropDown();
    super.initState();
  }

  success(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Laporan berhasil dikirim.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushNamed(context, Routes.HOMEPAGE);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, Routes.HOMEPAGE);
      },
      child: Scaffold(
        drawer: NavDrawer(),
        backgroundColor: Config.textWhite,
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Config.primary),
          title: new Text(
            "Buat Laporan",
            style: TextStyle(color: Config.primary),
          ),
          backgroundColor: Config.textWhite,
        ),
        body: Stack(
          children: [
            Scaffold(
              body: new Container(
                  // color: Colors.red,
                  ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        'Laporkan link berbahaya dan bantu cegah penyebaran link hoax dan penipuan.',
                        style: TextStyle(
                            fontFamily: 'RobotoLight',
                            fontSize: 16,
                            color: Config.textGrey),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: DropdownButtonFormField(
                          items: kategoriItem,
                          onChanged: changedDropDownItem,
                          value: getKategori,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Pilih Kategori',
                              labelText: 'Pilih Kategori',
                              labelStyle: TextStyle(color: Config.textBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Config.textGrey)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Config.primary))),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: inputText(
                            'Link Laporan', TextInputType.text, txtlink)),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: inputTextWithMax(
                            'Alasan', TextInputType.text, txtAlasan, 3)),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              color: Config.boxBlue,
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                'File Pendukung',
                                style: TextStyle(fontFamily: 'RobotoMedium'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: RaisedButton(
                                color: Config.textWhite,
                                onPressed: () {
                                  getImage(context);
                                },
                                child: Text(
                                  'Unggah'.toUpperCase(),
                                  style: TextStyle(
                                      color: Config.primary,
                                      fontSize: 16,
                                      fontFamily: 'RobotoMedium'),
                                ),
                              ),
                            )
                          ],
                        )),
                    showImage(),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                            color: Config.primary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: FlatButton(
                          onPressed: () {
                            if (txtlink.text == '') {
                              Config.alert(2, 'Link harap diisi');
                            } else if (txtAlasan.text == '') {
                              Config.alert(2, 'Alasan harap diisi');
                            } else if (getKategori == 'Pilih Kategori' ||
                                getKategori == null ||
                                getKategori == '') {
                              Config.alert(2, 'Harap memilih kategori');
                            } else if (foto.toString() == '' || foto == null) {
                              addLaporan();
                            } else {
                              simpanLaporan();
                            }
                          },
                          child: Text(
                            'laporkan'.toUpperCase(),
                            style: TextStyle(
                                color: Config.textWhite,
                                fontSize: 16,
                                fontFamily: 'RobotoMedium'),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
