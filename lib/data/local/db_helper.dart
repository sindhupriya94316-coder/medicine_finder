
// import 'package:sqflite/sqflite.dart';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
//
//
// class DbHelper {
//   DbHelper._();
//   static final DbHelper getInstance=DbHelper._();
//   /// TABLE
// static const String tableName='medicine_name';
// static const String COLOUMN_MEDICINE_ID='id';
// static const String COLUMN_MEDICINE_NAME='name';
// static const String COLUMN_MEDICINE_COMAPNY='company';
// static const String COLUMN_MEDICINE_POWER='power';
// static const String COLUMN_EXPAIRY_DATE='expairy_date';
// static const String COLUMN_HOUSE_NAME='HOUSE_NAME';
// static const String COLUMN_RACK_NUMBER='RACK_NUMBER';
// static const String COLUMN_ROW_NUMBER='row_number';
// static const String COLUMN_COLUMN_NUMBER='column_number';
// static const String COULUMN_MEDICINE_QUANTITY='quantity';
//
// Database? myDb;
// Future<Database> getDb() async{
//   if(myDb!=null){
//     return myDb!;
//   }
//   else{
//     myDb=await openDb();
//     return myDb!;
//   }
//
// }
// Future<Database>openDb()async{
//   Directory dir=await getApplicationDocumentsDirectory();
//   String dbpath=join(dir.path,'medicine.db');
//   return await openDatabase(
//     dbpath,
//     version:1,
//     onCreate: (db,version) async{
//       await db.execute(
//         '''CREATE TABLE $tableName(
//         $COLOUMN_MEDICINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
//         $COLUMN_MEDICINE_NAME TEXT,
//         $COLUMN_MEDICINE_COMAPNY TEXT,
//         $COLUMN_MEDICINE_POWER TEXT,
//         $COLUMN_EXPAIRY_DATE TEXT,
//         $COLUMN_HOUSE_NAME TEXT,
//         $COLUMN_RACK_NUMBER TEXT,
//         $COLUMN_ROW_NUMBER INTEGER,
//         $COLUMN_COLUMN_NUMBER INTEGER,
//         $COULUMN_MEDICINE_QUANTITY INTEGER)'''
//       );
//     },
//   );
// }
// ///INSERT NOTES
// Future<bool>addmedicine_name({
//
//     required String mName,
//     required String mCompany,
//     required String mPower,
//     required String mExpiryDate,
//     required String mHouse_name,
//     required String mRack_number,
//     required String mRow_number,
//     required String mColumn_number,
//     required String mQuantity,
// }) async{
//   var db=await getDb();
//   int rowsEffected=await db.insert(tableName,{
// COLUMN_MEDICINE_NAME:mName,
// COLUMN_MEDICINE_COMAPNY :mCompany,
// COLUMN_MEDICINE_POWER :mPower,
// COLUMN_EXPAIRY_DATE :mExpiryDate,
// COLUMN_HOUSE_NAME :mHouse_name,
// COLUMN_RACK_NUMBER :mRack_number,
// COLUMN_ROW_NUMBER :mRow_number,
// COLUMN_COLUMN_NUMBER :mColumn_number,
// COULUMN_MEDICINE_QUANTITY :mQuantity
//   });
//   return rowsEffected>0;
//
// }
// /// get all note
// Future<List<Map<String,dynamic>>>getALLMedicine()async{
//   var db=await getDb();
//   List<Map<String,dynamic >>mData=await db.query(tableName);
//   return mData;
// }
// /// update data
//  Future<bool>updateMedicine({
//     required int Id,
//    required String mName,
//    required String mCompany,
//    required String mPower,
//    required String mExpiryDate,
//    required String mHouse_name,
//    required String mRack_number,
//    required int mRow_number,
//    required int mColumn_number,
//    required int mQuantity,
// })async{
//   var db=await getDb();
//   int rowsEffected=await db.update(tableName,
//       {
//     COLUMN_MEDICINE_NAME:mName,
//     COLUMN_MEDICINE_COMAPNY :mCompany,
//     COLUMN_MEDICINE_POWER :mPower,
//     COLUMN_EXPAIRY_DATE :mExpiryDate,
//     COLUMN_HOUSE_NAME :mHouse_name,
//     COLUMN_RACK_NUMBER :mRack_number,
//     COLUMN_ROW_NUMBER :mRow_number,
//     COLUMN_COLUMN_NUMBER :mColumn_number,
//     COULUMN_MEDICINE_QUANTITY :mQuantity},
//     where: "$COLOUMN_MEDICINE_ID=?",whereArgs: [Id],
//
//   );
//   return rowsEffected>0;
//  }
//  /// delete data
// Future<bool>deleteMedicine_name({required int id})async{
//   var db=await getDb();
//   int rowsEffected=await db.delete(tableName,where:'$COLOUMN_MEDICINE_ID=?',whereArgs: [id],);
//   return rowsEffected>0;
// }
//
//
//
//}
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper getInstance = DbHelper._();

  Database? myDb;

  // Table Name
  static const String tableName = "medicine_name";

  // Columns
  static const String COLOUMN_MEDICINE_ID = "id";
  static const String COLUMN_MEDICINE_NAME = "name";
  static const String COLUMN_MEDICINE_COMAPNY = "company";
  static const String COLUMN_MEDICINE_POWER = "power";
  static const String COLUMN_EXPAIRY_DATE = "expairy_date";
  static const String COLUMN_HOUSE_NAME = "house_name";
  static const String COLUMN_RACK_NUMBER = "rack_number";
  static const String COLUMN_ROW_NUMBER = "row_number";
  static const String COLUMN_COLUMN_NUMBER = "column_number";
  static const String COULUMN_MEDICINE_QUANTITY = "quantity";

  Future<Database> getDb() async {
    if (myDb != null) {
      return myDb!;
    }
    else{
      myDb=await openDb();
      return myDb!;
    }


  }

  Future<Database> openDb() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String dbPath = join(dir.path, "medicine.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName(
        $COLOUMN_MEDICINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_MEDICINE_NAME TEXT NOT NULL,
        $COLUMN_MEDICINE_COMAPNY TEXT NOT NULL,
        $COLUMN_MEDICINE_POWER TEXT NOT NULL,
        $COLUMN_EXPAIRY_DATE TEXT NOT NULL,
        $COLUMN_HOUSE_NAME TEXT NOT NULL,
        $COLUMN_RACK_NUMBER TEXT NOT NULL,
        $COLUMN_ROW_NUMBER INTEGER NOT NULL,
        $COLUMN_COLUMN_NUMBER INTEGER NOT NULL,
        $COULUMN_MEDICINE_QUANTITY INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  // Add Medicine
  Future<bool> addmedicine_name({
    required String mName,
    required String mCompany,
    required String mPower,
    required String mExpiryDate,
    required String mHouse_name,
    required String mRack_number,
    required int mRow_number,
    required int mColumn_number,
    required int mQuantity,
  }) async {
    final db = await getDb();
    // print("house=$mHouse_name");
    // print("Rack=$mRack_number");

    int rows = await db.insert(
      tableName,
      {
        COLUMN_MEDICINE_NAME: mName,
        COLUMN_MEDICINE_COMAPNY: mCompany,
        COLUMN_MEDICINE_POWER: mPower,
        COLUMN_EXPAIRY_DATE: mExpiryDate,
        COLUMN_HOUSE_NAME: mHouse_name,
        COLUMN_RACK_NUMBER: mRack_number,
        COLUMN_ROW_NUMBER: mRow_number,
        COLUMN_COLUMN_NUMBER: mColumn_number,
        COULUMN_MEDICINE_QUANTITY: mQuantity,
      },
    );

    return rows > 0;
  }

  // Get All Medicines
  Future<List<Map<String, dynamic>>> getALLMedicine() async {
    final db = await getDb();

    return await db.query(
      tableName,
      orderBy: "$COLUMN_MEDICINE_NAME ASC",
    );
  }

  // Update Medicine
  Future<bool> updateMedicine({
    required int Id,
    required String mName,
    required String mCompany,
    required String mPower,
    required String mExpiryDate,
    required String mHouse_name,
    required String mRack_number,
    required int mRow_number,
    required int mColumn_number,
    required int mQuantity,
  }) async {
    final db = await getDb();

    int rows = await db.update(
      tableName,
      {
        COLUMN_MEDICINE_NAME: mName,
        COLUMN_MEDICINE_COMAPNY: mCompany,
        COLUMN_MEDICINE_POWER: mPower,
        COLUMN_EXPAIRY_DATE: mExpiryDate,
        COLUMN_HOUSE_NAME: mHouse_name,
        COLUMN_RACK_NUMBER: mRack_number,
        COLUMN_ROW_NUMBER: mRow_number,
        COLUMN_COLUMN_NUMBER: mColumn_number,
        COULUMN_MEDICINE_QUANTITY: mQuantity,
      },
      where: "$COLOUMN_MEDICINE_ID = ?",
      whereArgs: [Id],
    );

    return rows > 0;
  }

  // Delete Medicine
  Future<bool> deleteMedicine_name({
    required int id,
  }) async {
    final db = await getDb();

    int rows = await db.delete(
      tableName,
      where: "$COLOUMN_MEDICINE_ID = ?",
      whereArgs: [id],
    );

    return rows > 0;
  }
}