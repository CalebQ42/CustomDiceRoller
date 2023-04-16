import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:customdiceroller/utils/driver/query.dart';
import 'package:stupid/stupid.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';

class Driver{

  String scope;

  String wd;
  DriveApi? api;
  GoogleSignIn? gsi;

  StreamSubscription? sub;
  bool internetAvailable = true;

  Stupid? stupid;

  Driver(this.scope, [this.stupid]) : wd = scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";

  Future<bool> changeScope(String scope) async {
    this.scope = scope;
    if(gsi != null && !gsi!.scopes.contains(scope)){
      if((await gsi!.requestScopes([scope]))) return false;
    }
    wd = this.scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";
    return true;
  }

  //ready returns whether the driver is ready to use. If the driver is not ready, it tries to initialize it.
  Future<bool> ready() async {
    if(sub == null){
      var checker = UniversalInternetChecker();
      sub = checker.onConnectionChange.listen((event) {
        internetAvailable = event == ConnectionStatus.online;
      });
      internetAvailable = await UniversalInternetChecker.checkInternet() == ConnectionStatus.online;
    }
    if(!internetAvailable) return false;
    if(gsi != null && gsi!.currentUser != null && api != null){
      if(!(await gsi!.isSignedIn())){
        if(gsi!.currentUser == null || !(await gsi!.isSignedIn())){
          await gsi!.signInSilently();
          if(gsi!.currentUser == null) await gsi!.signIn();
        }
        if(gsi!.currentUser == null || !(await gsi!.isSignedIn())) return false;
      }
    }else{
      try{
        gsi ??= GoogleSignIn(scopes: [scope]);
        if(gsi!.currentUser == null || !(await gsi!.isSignedIn())){
          await gsi!.signInSilently();
          if(gsi!.currentUser == null) await gsi!.signIn();
        }
        if(gsi!.currentUser == null) return false;
      } catch(e, stack) {
        if(kDebugMode){
          print("ready:");
          print(e);
        }else{
          stupid?.crash(Crash(
            error: e.toString(),
            stack: stack.toString()
          ));
        }
        return false;
      }
    }
    api = DriveApi((await gsi!.authenticatedClient())!);
    return true;
  }

  //readySync is similar to ready, except does NOT try to initialize the driver and can be used syncronysly. Use ready when possible.
  bool readySync() =>
    internetAvailable && gsi != null && gsi!.currentUser != null && api != null;

  Future<bool> setWD(String folder) async {
    if(!await ready()) return false;
    try{
      if(folder == "" || folder == "/"){
        wd = scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";
        return true;
      }
      var foldId = await getIDFromRoot(folder, mimeType: DriveQueryBuilder.folderMime, createIfMissing: true);
      if (foldId == null) return false;
      wd = foldId;
      return true;
    }catch(e, stack){
      if(kDebugMode){
        print("setWD:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return false;
    }
  }

  Future<List<File>?> listFilesFromRoot(String folder) async{
    if(!await ready()) return null;
    try{
      var foldID = await getIDFromRoot(folder, mimeType: DriveQueryBuilder.folderMime);
      if(foldID == null) return null;
      return (await api!.files.list(
        spaces: (scope == DriveApi.driveAppdataScope) ? "appDataFolder" : "drive",
        q: "'$foldID' in parents"
      )).files;
    }catch(e, stack){
      if(kDebugMode){
        print("listFilesFromRoot:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<List<File>?> listFiles(String folder) async {
    if(!await ready()) return null;
    try{
      var foldID = await getID(folder, mimeType: DriveQueryBuilder.folderMime);
      if(foldID == null) return null;
      return (await api!.files.list(
        spaces: (scope == DriveApi.driveAppdataScope) ? "appDataFolder" : "drive",
        q: "'$foldID' in parents"
      )).files;
    }catch(e, stack){
      if(kDebugMode){
        print("listFiles:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<String?> getIDFromRoot(String filename, {String? mimeType, bool createIfMissing = false}) async {
    if(!await ready()) return null;
    try{
      if(filename == "" || filename == "/") return scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";
      var parentID = scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";
      var split = filename.split("/");
      List<File>? out;
      for(int i = 0; i< split.length; i++){
        var fold = split[i];
        if(fold == "") continue;
        var query = DriveQueryBuilder();
        if(i != split.length -1){
          query.mime = DriveQueryBuilder.folderMime;
        }else{
          query.mime = mimeType;
        }
        query.name = fold;
        query.parent = parentID;
        out = (await api!.files.list(
          spaces: (scope == DriveApi.driveAppdataScope) ? "appDataFolder" : "drive",
          q: query.getQuery()
        )).files;
        if (out == null || out.isEmpty) {
          if (!createIfMissing) return null;
          var id = await createFileWithParent(fold, parentID, mimeType: query.mime);
          if (id == null) return null;
          parentID = id;
          var fil = await getFile(id);
          if(fil == null) return null;
          out = [fil];
          continue;
        }
        if(out[0].id == null) {
          if (!createIfMissing) return null;
          var id = await createFileWithParent(fold, parentID, mimeType: query.mime);
          if (id == null) return null;
          parentID = id;
          var fil = await getFile(id);
          if(fil == null) return null;
          out = [fil];
          continue;
        }
        parentID = out[0].id!;
      }
      return out![0].id!;
    }catch(e, stack){
      if(kDebugMode){
        print("getIDFromRoot:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<String?> getID(String filename, {String? mimeType, bool createIfMissing = false}) async {
    if(!await ready()) return null;
    try{
      if(filename == "" || filename == "/") return wd;
      var parentID = wd;
      var split = filename.split("/");
      List<File>? out;
      for(int i = 0; i< split.length; i++){
        var fold = split[i];
        if(fold == "") continue;
        var query = DriveQueryBuilder();
        if(i != split.length -1){
          query.mime = DriveQueryBuilder.folderMime;
        }else{
          query.mime = mimeType;
        }
        query.name = fold;
        query.parent = parentID;
        out = (await api!.files.list(
          spaces: (scope == DriveApi.driveAppdataScope) ? "appDataFolder" : "drive",
          q: query.getQuery()
        )).files;
        if (out == null || out.isEmpty) {
          if (!createIfMissing) return null;
          var id = await createFileWithParent(fold, parentID);
          if (id == null) return null;
          parentID = id;
          continue;
        }
        if(out[0].id == null) {
          if (!createIfMissing) return null;
          var id = await createFileWithParent(fold, parentID);
          if (id == null) return null;
          parentID = id;
          continue;
        }
        parentID = out[0].id!;
      }
      return out![0].id;
    }catch(e, stack){
      if(kDebugMode){
        print("getID:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<String?> createFolderFromRoot(String filename, {String? description}) async =>
    createFileFromRoot(filename, description: description, mimeType: DriveQueryBuilder.folderMime);

  Future<String?> createFolder(String filename, {String? description}) async =>
    createFile(filename, description: description, mimeType: DriveQueryBuilder.folderMime);

  Future<String?> createFileFromRoot(String filename, {String? mimeType, Map<String, String?>? appProperties, String? description}) async{
    if(!await ready()) return null;
    try{
      String? parent = scope == DriveApi.driveAppdataScope ? "appDataFolder" : "root";
      var lastInd = filename.lastIndexOf("/");
      if(lastInd != -1){
        parent = await getIDFromRoot(filename.substring(0,lastInd));
        if(parent == null) return null;
      }
      var fil = File(
        modifiedTime: DateTime.now(),
        appProperties: appProperties,
        description: description,
        parents: [parent],
        name: filename.substring(lastInd+1),
        mimeType: mimeType,
      );
      fil = await api!.files.create(fil);
      return fil.id;
    }catch(e, stack){
      if(kDebugMode){
        print("createFileFromRoot:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<String?> createFileWithParent(String filename, String parentId, {String? mimeType, Map<String, String?>? appProperties, String? description}) async {
    if(!await ready()) return null;
    try{
      var fil = File(
        modifiedTime: DateTime.now(),
        appProperties: appProperties,
        description: description,
        parents: [parentId],
        name: filename,
        mimeType: mimeType,
      );
      fil = await api!.files.create(fil);
      return fil.id;
    }catch(e, stack){
      if(kDebugMode){
        print("createFileWithParent:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<String?> createFile(String filename, {String? mimeType, Map<String, String?>? appProperties, String? description, Stream<List<int>>? data, int? dataLength}) async{
    if(!await ready()) return null;
    try{
      String? parent = wd;
      var lastInd = filename.lastIndexOf("/");
      if(lastInd != -1){
        parent = await getID(filename.substring(0,lastInd));
        if(parent == null) return null;
      }
      var fil = File(
        // spaces: [(scope == DriveApi.driveAppdataScope) ? "appDataFolder" : "drive"],
        modifiedTime: DateTime.now(),
        appProperties: appProperties,
        description: description,
        parents: [parent],
        name: filename.substring(lastInd+1),
        mimeType: mimeType,
      );
      fil = await api!.files.create(
        fil,
        uploadMedia: (data != null) ? Media(data, dataLength) : null
      );
      return fil.id;
    }catch(e, stack){
      if(kDebugMode){
        print("createFile:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<File?> getFile(String id) async {
    if(!await ready()) return null;
    try{
      return (await api!.files.get(id)) as File;
    }catch(e, stack){
      if(kDebugMode){
        print("getFile:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<Media?> getContents(String id) async {
    if(!await ready()) return null;
    try{
      return (await api!.files.get(id, downloadOptions: DownloadOptions.fullMedia)) as Media;
    }catch(e, stack){
      if(kDebugMode){
        print("getContents:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return null;
    }
  }

  Future<bool> updateContents(String id, Stream<List<int>> data, {Map<String, String?>? appProperties, int? dataLength}) async{
    if(!await ready()) return false;
    try{
      var fil = await api!.files.update(
        File(
          modifiedTime: DateTime.now(),
          appProperties: appProperties,
        ),
        id,
        uploadMedia: Media(data, dataLength)
      );
      return fil.id != null;
    }catch(e, stack){
      if(kDebugMode){
        print("updateContents:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return false;
    }
  }

  Future<void> delete(String id) async {
    if(!await ready()) return Future.value();
    try{
      return await api!.files.delete(id);
    }catch(e, stack){
      if(kDebugMode){
        print("delete:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return;
    }
  }

  Future<bool> trash(String id) async {
    if(!await ready()) return false;
    try{
      return (await api!.files.update(File(trashed: true), id)).trashed ?? false;
    }catch(e, stack){
      if(kDebugMode){
        print("trash:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return false;
    }
  }

  Future<bool> unTrash(String id) async {
    if(!await ready()) return false;
    try{
      return !((await api!.files.update(File(trashed: false), id)).trashed ?? false);
    }catch(e, stack){
      if(kDebugMode){
        print("untrash:");
        print(e);
      }else{
        stupid?.crash(Crash(
          error: e.toString(),
          stack: stack.toString()
        ));
      }
      return false;
    }
  }
}