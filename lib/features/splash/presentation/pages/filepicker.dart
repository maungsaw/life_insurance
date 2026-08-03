import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show FilePickerNotifier;

class FilePickerPage extends StatefulWidget {
  const FilePickerPage({super.key});

  @override
  State<FilePickerPage> createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  final FilePickerNotifier _controller = FilePickerNotifier();

  // Selected file types configuration
  List<String> _selectedExtensions = ['jpg', 'png', 'pdf', 'docx'];
  bool _allowMultiple = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexible File Picker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _controller.clearAllFiles(),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Column(
            children: [
              // Picker Settings Options
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text("Allow Multiple Files"),
                        value: _allowMultiple,
                        onChanged: (val) =>
                            setState(() => _allowMultiple = val),
                      ),
                      const Divider(),
                      const Text(
                        "Allowed File Types:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text("Images (jpg, png)"),
                            selected: _selectedExtensions.contains('jpg'),
                            onSelected: (_) => setState(
                              () =>
                                  _selectedExtensions = ['jpg', 'jpeg', 'png'],
                            ),
                          ),
                          ChoiceChip(
                            label: const Text("Docs (pdf, docx)"),
                            selected: _selectedExtensions.contains('pdf'),
                            onSelected: (_) => setState(
                              () => _selectedExtensions = ['pdf', 'docx'],
                            ),
                          ),
                          ChoiceChip(
                            label: const Text("Any File"),
                            selected: _selectedExtensions.isEmpty,
                            onSelected: (_) =>
                                setState(() => _selectedExtensions = []),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // File List Display
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : !_controller.hasFiles
                    ? const Center(child: Text("No files selected yet."))
                    : ListView.builder(
                        itemCount: _controller.selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _controller.selectedFiles[index];
                          final fileName = file.path.split('/').last;

                          return ListTile(
                            leading: Icon(_getFileIcon(fileName)),
                            title: Text(
                              fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              file.path,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _controller.removeFileAt(index),
                            ),
                          );
                        },
                      ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Re-pick'),
                        onPressed: () => _controller.repickFiles(
                          extensions: _selectedExtensions,
                          allowMultiple: _allowMultiple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Pick File(s)'),
                        onPressed: () => _controller.pickFiles(
                          extensions: _selectedExtensions,
                          allowMultiple: _allowMultiple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper for rendering icons dynamically
  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) return Icons.image;
    if (['pdf'].contains(ext)) return Icons.picture_as_pdf;
    if (['doc', 'docx', 'txt'].contains(ext)) return Icons.description;
    if (['mp3', 'wav', 'aac'].contains(ext)) return Icons.audiotrack;
    if (['mp4', 'mkv', 'avi'].contains(ext)) return Icons.video_file;
    return Icons.insert_drive_file;
  }
}
