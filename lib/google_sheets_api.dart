import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "lista-tarefas-348723",
  "private_key_id": "19eb13231320e4da0d7c0fa4fb6abe4ca9f5723a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDdR449y4XZiZpT\nt+XT4/Xm7NVzvBpWgYqktmwL5U/Hx9nqNAoBZebUpBZyf9FMgWYLKCX5qG1fBNP+\nM9wLP84yHW/1AgeYRIQ1InINbbir8hHgdIiAAfqYlxxIpbgLZujbxcFDJSNKkveR\ndkztt7RpyWT6o7lZDJrWYgrTQJICtxTwmwp/9y/i0Z1/UyBTPVrRp2/lQ+Yde5Rq\nma1Hbvco7tXeEAHkfcDO6CAZ23mOpbXW4Vuk3nyoq1V6wV9ER91n1+OVPgfWmJUl\nYqsFm1ZBOVmpMWGVh306gbh4C7PWLfn5uihI6AGJL9G9V2i7jSipCWvYGEUNY46Z\nU0lKgIe9AgMBAAECggEACPFB2dR2Qc7SSkzVwGTnhKAQlj9FTzan/DUVE7v+J+Q3\nNcRJnTnZhMFm2NS6iB14mr3SHw9D8EGZMZ4158x50EOpSRz+YpRuRVlxg4JqIqTD\nPS9obsflsTH2JidwUyGjCnKo90YycWqUD7BYtoikhVvqtUhVjrg4L67BojzrSam6\nLYPVVj8W6xBLvzzbkSb8e/U766BfVIg4DxpvnS9XRLK84M9JAe7Vz0yC3QPUqaK+\nFo39nZRH/Tk7D3tTcepybarFkb1EFoMERUI5fANsgLzs4vD7a0C37fGe8vehY26N\nNOGDd4eqKyYYMQoj0wqrV509h0yH7flKovinq+zn0QKBgQD8IcrFo05Eyxyu3ecp\nXZpjUw3Z1q302Wp2JbH7cbNSzPw2VJ0CT+zNrqDdm0VxIXsIpLqsoD1QffwZqrl1\nFZp/x5F7Ab9zIbe5oGhgf688f50IxJHLkN8n/kIe/XLq79OecjPkDQ4SakFO5xw6\nilZXP22YKbih6giiV8zS6k/2yQKBgQDgrJhqKhckM/Vr8e2aQ1hI70hbQPb945jR\nZP8ERdx2TDEbA3b6oTIB80C4ONQFrMbzoZc53Hpbh2g15VrnNfxBDW5zWj1/gvGy\ndhe/mhWdJdo2tiSywFrkUpJZe4HkAaovHxBPP6gWYdeeUr5b8UZwiIgL4l6+yC9R\nuNJsEudfVQKBgQDrlNt1DWCNcMbNMTPTd81QrwLLHwcNN7R8zj3d9mAapsOmNCs8\nRNe7W0adqX4Z9bGS4vA1acfAlObgSJ/eoZ/pctwg9gIfnkqfnBzKxaNDwO1Givy7\nGxMXuD+p2yDsGcg+TPDlTblvRW7ePZ0nqaiA/xf0zE7iot0Ma0NLc3nh2QKBgGJe\nbyUcZKFvNmcat6MxFThpu85odTvYKJKVm6otREdvOJjRPYiihxiffpiqGPqbGUiW\nWXX1+ISWlqPyVYih9F4vGUrcGcz4cgZm+iLjvc7eQdpuiUbSPXl2Ral0D/zaVb7n\n5OYtwtR55kPlin8K9oJS5O3/IOh7EWzAdTDoXfE5AoGBAJMBp6hcBgxnDBKBvN2J\nn845DU/AAtTIdCxdGrkiAEUP6IfKIrlUStlOWE4ZbVvmCf2/ZOknAv/tj6YkdU6S\nGmxRZV2SRmnbXcJM5Usc+w4gST27K3FuK/4OPhiZU29S7FfI6E5TEpz0VBDSGM99\nEwsBq+NEW2C2JF2fV/GUsV48\n-----END PRIVATE KEY-----\n",
  "client_email": "lista-de-tarefas@lista-tarefas-348723.iam.gserviceaccount.com",
  "client_id": "106707005434955708062",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/lista-de-tarefas%40lista-tarefas-348723.iam.gserviceaccount.com"
}
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1YbN4RmQjWZbeKM8Tfb9D-fSdIA0u3oqOlPXgC6bE8us';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<List<dynamic>> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add([
          newNote,
          int.parse(await _worksheet!.values.value(column: 2, row: i + 1))
        ]);
      }
    }

    loading = false;
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add([note, 0]);
    await _worksheet!.values.appendRow([note, 0]);
  }

  static Future update(int index, int isTaskCompleted) async {
    _worksheet!.values.insertValue(isTaskCompleted, column: 2, row: index + 1);
  }
}
