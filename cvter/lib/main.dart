import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path; // Renomeando o import para evitar conflito de nome
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _filePaths = ['Nenhum arquivo selecionado'];
  String _destinationDirectory = 'Nenhum diretório selecionado';
  List<String> _ffmpegCommands = [];

  void _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        setState(() {
          _filePaths = result.paths.map((path) => path ?? 'Nenhum arquivo selecionado').toList();
          _ffmpegCommands = List.generate(_filePaths.length, (index) => '');
        });
      }
    } catch (e) {
      print('Erro ao selecionar o arquivo: $e');
    }
  }

  void _selectDestinationDirectory() async {
    try {
      String? directory = await FilePicker.platform.getDirectoryPath();

      if (directory != null) {
        setState(() {
          _destinationDirectory = directory;
        });
      }
    } catch (e) {
      print('Erro ao selecionar o diretório: $e');
    }
  }

  void _generateFFMPEGCommands() {
    setState(() {
      for (int i = 0; i < _filePaths.length; i++) {
        final filename = path.basename(_filePaths[i]); // Usando o método basename do pacote path
        final outputFilepath = path.join(_destinationDirectory, filename + '.wav'); // Usando o método join do pacote path
        _ffmpegCommands[i] = 'ffmpeg -i ${_filePaths[i]} -ar 16000 -ac 1 -c:a pcm_s16le $outputFilepath';
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comando copiado para a área de transferência'),
      ),
    );
  }

  void _executeFFMPEGCommands() {
    for (String command in _ffmpegCommands) {
      _executeCommandInTerminal(command);
    }
  }

  void _executeCommandInTerminal(String command) async {
    try {
      final process = await Process.start('cmd', ['/c', command]);

      process.stdout.transform(utf8.decoder).listen((data) {
        print(data);
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        print(data);
      });

      await process.exitCode; // Esperar pela finalização do processo

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comandos FFMPEG executados com sucesso'),
        ),
      );
    } catch (e) {
      print('Erro ao executar o comando no terminal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao executar comandos FFMPEG'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seletor de Arquivos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _openFilePicker,
              child: Text('Selecionar Arquivos'),
            ),
            SizedBox(height: 20),
            Text(
              'Caminhos dos arquivos selecionados:',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filePaths.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _filePaths[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDestinationDirectory,
              child: Text('Local de Destino'),
            ),
            SizedBox(height: 10),
            Text(
              'Diretório de destino: $_destinationDirectory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateFFMPEGCommands,
              child: Text('Gerar Comandos FFMPEG'),
            ),
            SizedBox(height: 10),
            Text(
              'Comandos FFMPEG:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _ffmpegCommands.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _ffmpegCommands[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        _copyToClipboard(_ffmpegCommands[index]);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _executeFFMPEGCommands,
              child: Text('Executar Comandos FFMPEG no CMD'),
            ),
          ],
        ),
      ),
    );
  }
}
