import 'dart:io';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderScreen extends StatefulWidget {
  final File bookFile;
  final String bookId;

  const ReaderScreen({super.key, required this.bookFile, required this.bookId});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late EpubController _epubController;
  bool _showControls = true;
  EpubBook? _book;

  double _fontSize = 16.0;
  ReaderTheme _currentTheme = ReaderTheme.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _epubController = EpubController(
      document: EpubDocument.openFile(widget.bookFile),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  Future<String?> _getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'epub_last_location_${widget.bookFile.path}';
    return prefs.getString(key);
  }

  Future<void> _saveProgress(String cfi) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'epub_last_location_${widget.bookFile.path}';
    await prefs.setString(key, cfi);
    await prefs.setString(
      '${key}_lastOpened',
      DateTime.now().toIso8601String(),
    );
    // Save as the globally last read book
    await prefs.setString('last_read_book_path', widget.bookFile.path);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      final cfi = _epubController.generateEpubCfi();
      if (cfi != null) {
        _saveProgress(cfi);
      }
    }
  }

  @override
  void deactivate() {
    final cfi = _epubController.generateEpubCfi();
    if (cfi != null) {
      _saveProgress(cfi);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _epubController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _changeFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 32.0);
    });
  }

  void _changeTheme(ReaderTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  Color get _backgroundColor {
    switch (_currentTheme) {
      case ReaderTheme.light:
        return const Color(0xFFFAF9F6); // Warm paper
      case ReaderTheme.dark:
        return const Color(0xFF1E1E1E);
      case ReaderTheme.sepia:
        return const Color(0xFFF4ECD8);
    }
  }

  Color get _foregroundColor {
    switch (_currentTheme) {
      case ReaderTheme.light:
        return const Color(0xFF2D3436);
      case ReaderTheme.dark:
        return const Color(0xFFE0E0E0);
      case ReaderTheme.sepia:
        return const Color(0xFF5F4B32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      drawer: _buildTableOfContentsDrawer(),
      body: Stack(
        children: [
          // EPUB Viewer
          GestureDetector(
            onTap: _toggleControls,
            child: EpubView(
              controller: _epubController,
              onDocumentLoaded: (document) async {
                if (mounted) {
                  setState(() {
                    _book = document;
                  });

                  // Restore last position
                  final savedCfi = await _getLastLocation();
                  if (savedCfi != null && mounted) {
                    _epubController.gotoEpubCfi(savedCfi);
                  }
                }
              },
              onExternalLinkPressed: (link) {
                print('Link pressed: $link');
              },
              onChapterChanged: (value) {
                final cfi = _epubController.generateEpubCfi();
                if (cfi != null) {
                  _saveProgress(cfi);
                }
              },
              builders: EpubViewBuilders<DefaultBuilderOptions>(
                options: DefaultBuilderOptions(
                  textStyle: TextStyle(
                    height: 1.5,
                    fontSize: _fontSize,
                    color: _foregroundColor,
                  ),
                ),
              ),
            ),
          ),

          // Custom Top Bar (AppBar)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            top: _showControls ? 0 : -80,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),

          // Custom Bottom Bar (Controls)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            bottom: _showControls ? 0 : -180, // Increased height for controls
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: _foregroundColor.withOpacity(0.1)),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: _foregroundColor),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.format_list_bulleted, color: _foregroundColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: _foregroundColor.withOpacity(0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Font Size Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _changeFontSize(-2),
                icon: Icon(Icons.remove, color: _foregroundColor),
              ),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 12,
                  max: 32,
                  divisions: 10,
                  activeColor: _foregroundColor,
                  inactiveColor: _foregroundColor.withOpacity(0.3),
                  onChanged: (val) {
                    setState(() {
                      _fontSize = val;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () => _changeFontSize(2),
                icon: Icon(Icons.add, color: _foregroundColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Theme Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThemeButton(ReaderTheme.light, Icons.light_mode, 'Light'),
              _buildThemeButton(
                ReaderTheme.sepia,
                Icons.chrome_reader_mode,
                'Sepia',
              ),
              _buildThemeButton(ReaderTheme.dark, Icons.dark_mode, 'Dark'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton(ReaderTheme theme, IconData icon, String label) {
    final isSelected = _currentTheme == theme;
    return InkWell(
      onTap: () => _changeTheme(theme),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _foregroundColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _foregroundColor
                : _foregroundColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? _foregroundColor
                  : _foregroundColor.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? _foregroundColor
                    : _foregroundColor.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableOfContentsDrawer() {
    return Drawer(
      backgroundColor: _backgroundColor,
      child: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(24),
            alignment: Alignment.bottomLeft,
            color: _foregroundColor.withOpacity(0.05),
            child: Text(
              'Content',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
                color: _foregroundColor,
              ),
            ),
          ),
          Expanded(
            child: _book == null || _book!.Chapters == null
                ? Center(
                    child: CircularProgressIndicator(color: _foregroundColor),
                  )
                : ListView.builder(
                    itemCount: _book!.Chapters!.length,
                    itemBuilder: (context, index) {
                      final chapter = _book!.Chapters![index];
                      return ListTile(
                        title: Text(
                          chapter.Title?.trim() ?? 'Chapter ${index + 1}',
                          style: TextStyle(
                            color: _foregroundColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          // Using ContentFileName as CFI reference, assuming it works with this controller
                          // or if logic requires conversion, it should be handled here.
                          // Based on previous analysis, gotoEpubCfi accepts strings.
                          if (chapter.ContentFileName != null) {
                            _epubController.gotoEpubCfi(
                              chapter.ContentFileName!,
                            );
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

enum ReaderTheme { light, dark, sepia }
