import 'dart:io';

import 'package:excel/excel.dart';

class ExcelParser{
  final String filePath;
  ExcelParser(this.filePath);
  Map<String,Map<String,List<String>>> parse(){
    final file=File(filePath);
    if(!file.existsSync()){
      throw Exception('Файл $filePath не найден');
    }
    final bytes=file.readAsBytesSync();
    final excel=Excel.decodeBytes(bytes);
    final Map<String,Map<String,List<String>>> data={};
    for(final sheetName in excel.tables.keys){
      final sheet=excel.tables[sheetName];
      if(sheet==null) continue;
      final parts=sheetName.split('|');
      if(parts.length!=2)continue;
      final groupName=parts[0].trim();
      final disciplineName=parts[1].trim();
      if(!data.containsKey(disciplineName)){
        data[disciplineName]={};
      }
      data[disciplineName]![groupName]=[];
      for(var row in sheet.rows){
        final cell=row[0];
        if(cell?.value!=null){
          final studentName=cell!.value.toString().trim();
          if(studentName.isNotEmpty){
            data[disciplineName]![groupName]!.add(studentName);
          }
        }
      }
    }
    return data;
  }
}