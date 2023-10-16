import 'dart:convert';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:isar/isar.dart';
import 'package:stupid/stupid.dart';
import 'package:uuid/uuid.dart';

class CDRStupid extends Stupid{
  CDR cdr;

  CDRStupid(this.cdr, String apiKey, String uuid) : super(
    baseUrl: Uri.parse("https://api.darkstorm.tech"),
    deviceId: uuid,
    apiKey: apiKey,
    internetCheckAddress: Uri.parse("https://darkstorm.tech")
  );

  Future<UploadResponse> uploadProfile(Id id) async{
    try{
      var json = (await cdr.db.dies.where().idEqualTo(id).exportJson())[0];
      json.remove("id");
      var outBod = const JsonEncoder().convert(json);
      if(outBod.codeUnits.length > 1048576){
        return UploadResponse(statusCode: 413);
      }
      var resp = await post(
        baseUrl.resolveUri(
          Uri(
            path: "/upload",
            queryParameters: {
              "key": apiKey,
            }
          )
        ),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: outBod
      );
      var out = UploadResponse(
        statusCode: resp.statusCode,
      );
      if(resp.statusCode != 201) return out;
      Map<String, dynamic> body = const JsonDecoder().convert(resp.body);
      out.id = body["id"];
      out.expiration = DateTime.fromMillisecondsSinceEpoch(body["expiration"]*1000);
      return out;
    }catch(e, stack){
      if(FlutterError.onError != null){
        FlutterError.onError!(FlutterErrorDetails(exception: e, stack: stack));
      }
    }
    return UploadResponse(statusCode: 404);
  }

  Future<bool> downloadProfile(String id) async{
    try{
      var resp = await get(
        baseUrl.resolveUri(
          Uri(
            path: "/die/$id",
            queryParameters: <String, String>{
              "key": apiKey,
            }
          )
        )
      );
      if(resp.statusCode != 200 || resp.body.isEmpty) return false;
      Map<String, dynamic> values = const JsonDecoder().convert(resp.body);
      if(values["uuid"] == null) values["uuid"] = const Uuid().v4();
      if(await cdr.db.dies.getByTitle(values["title"]) != null){
        for(var i = 2;; i++){
          if(await cdr.db.dies.getByTitle(values["title"]+" "+i.toString()) == null){
            values["title"] += " $i";
            break;
          }
        }
      }
      await cdr.db.writeTxn(() async => await cdr.db.dies.importJson([values]));
      (await cdr.db.dies.getByUuid(values["uuid"]))!.cloudSave(cdr);
      return true;
    }catch(e, stack){
      if(FlutterError.onError != null){
        FlutterError.onError!(FlutterErrorDetails(exception: e, stack: stack));
      }
    }
    return false;
  }
}

class UploadResponse{
  String? id;
  int statusCode;
  DateTime? expiration;

  UploadResponse({
    this.id,
    required this.statusCode
  });

  UploadResponse.timeout() : statusCode = 408;

  bool isTooLarge() => statusCode == 413;
  bool isSuccess() => statusCode == 201;
  bool isServerError() => statusCode == 500;
  bool isNotFound() => statusCode == 404;
  bool isTimeout() => statusCode == 408;
}