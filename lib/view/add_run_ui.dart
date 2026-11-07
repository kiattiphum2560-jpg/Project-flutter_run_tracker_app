// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_client/storage_client.dart' show StorageException;
import 'package:flutter_run_tracker_app/services/supabese_service.dart';
import 'package:flutter_run_tracker_app/model/run.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUIState();
}

class _AddRunUIState extends State<AddRunUi> {
  final ImagePicker _imagePicker = ImagePicker();
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _runWhereController = TextEditingController();
  final TextEditingController _runPersonController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  XFile? _selectedImage;
  String? _selectedImageName;
  Uint8List? _selectedImageBytes;
  String? _imageError;
  bool _isUploadingImage = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _runWhereController.dispose();
    _runPersonController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนของ appBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 1, 80),
        title: Text(
          'Run Tracker (เพิ่ม)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      // ส่วนของ body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 50,
            bottom: 50,
            left: 45,
            right: 45,
          ),
          child: Center(
            child: Column(
              children: [
                Tooltip(
                  message: 'เลือกรูปหรือถ่ายภาพ',
                  child: InkWell(
                    onTap: _isUploadingImage || _isSaving
                        ? null
                        : _showImageSourceOptions,
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.width * 0.50,
                        child: _selectedImageBytes == null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 96,
                                color: Colors.grey,
                              )
                            : Image.memory(
                                _selectedImageBytes!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                if (_isUploadingImage) const CircularProgressIndicator(),
                if (_selectedImageName != null)
                  Text('เลือกรูปแล้ว: $_selectedImageName'),
                if (_selectedImage != null)
                  const Text('รูปจะถูกอัปโหลดเมื่อกดบันทึกข้อมูล'),
                if (_imageError != null) Text(_imageError!),
                SizedBox(
                  height: 30,
                ),
                _buildRunField(
                  label: 'วิ่งที่ไหน',
                  controller: _runWhereController,
                  hintText: 'เช่น สวนสาธารณะ, สนามกีฬา หรือ อื่นๆ',
                ),
                SizedBox(
                  height: 20,
                ),
                _buildRunField(
                  label: 'วิ่งกับใคร',
                  controller: _runPersonController,
                  hintText: 'เช่น เพื่อน 3 คน, แฟน หรือ อื่นๆ',
                ),
                SizedBox(
                  height: 20,
                ),
                _buildRunField(
                  label: 'ระยะทาง (กิโลเมตร)',
                  controller: _distanceController,
                  hintText: 'เช่น 1, 5, 11 หรือ อื่นๆ',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving || _isUploadingImage ? null : _saveRun,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      _isSaving ? 'กำลังอัปโหลดและบันทึก...' : 'บันทึกข้อมูล',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('ยกเลิก'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRunField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image == null || !mounted) return;

      setState(() {
        _isUploadingImage = true;
        _selectedImage = image;
        _selectedImageName = image.name;
        _selectedImageBytes = null;
        _imageError = null;
      });

      final imageBytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImageBytes = imageBytes;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      setState(() {
        _imageError =
            'เปิดกล้องหรือรูปภาพไม่สำเร็จ: ${error.message ?? error.code}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _openCamera() => _pickImage(ImageSource.camera);

  Future<void> _openGallery() => _pickImage(ImageSource.gallery);

  Future<void> _saveRun() async {
    final runWhere = _runWhereController.text.trim();
    final runPerson = _runPersonController.text.trim();
    final distanceText = _distanceController.text.trim();
    final distance = int.tryParse(distanceText);

    if (runWhere.isEmpty || runPerson.isEmpty || distanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade100,
          content: Text(
            'กรุณากรอกข้อมูลให้ครบ',
            style: TextStyle(color: Colors.red.shade900),
          ),
        ),
      );
      return;
    }

    if (distance == null || distance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade100,
          content: Text(
            'ระยะทางต้องเป็นตัวเลขที่มากกว่า 0',
            style: TextStyle(color: Colors.red.shade900),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _isUploadingImage = _selectedImage != null;
    });

    try {
      await _supabaseService.uploadAndSaveRun(
        Run(
          runWhere: runWhere,
          runPerson: runPerson,
          rundistance: distance,
        ),
        image: _selectedImage,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } on StorageException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อัปโหลดรูปไม่สำเร็จ: ${error.message}')),
      );
    } on PostgrestException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกข้อมูลไม่สำเร็จ: ${error.message}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _showImageSourceOptions() async {
    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('เลือกรูปจากแกลเลอรี'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            title: const Text('ถ่ายภาพ'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    if (selectedSource == ImageSource.gallery) {
      await _openGallery();
    } else if (selectedSource == ImageSource.camera) {
      await _openCamera();
    }
  }
}
