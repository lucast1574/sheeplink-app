import '../../../core/widgets/photo_policy.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../community/view_models/community_view_model.dart';
import '../../../../data/services/photo_service.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../../../core/theme/app_theme.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Future<Uint8List?>? photo;
  String? url, error;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didUpdateWidget(covariant ProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    load();
  }

  void load() {
    final next = widget.model.session?.photoUrl;
    if (next == url && photo != null) return;
    url = next;
    photo = next == null
        ? Future.value(null)
        : widget.model.repository.photo(next);
  }

  Future<void> change() async {
    if (!await acceptPhotoPolicy(context, widget.model.session!.id) ||
        !mounted) {
      return;
    }
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const AppIcon(Symbol.camera),
                title: const Text('Tomar una foto'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const AppIcon(Symbol.user),
                title: const Text('Elegir de galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null || !mounted) return;
    widget.model.photoSelection(true);
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final bytes = await PhotoService().pick(source);
      if (bytes != null && mounted) {
        await widget.model.updateAvatar(bytes);
        if (mounted) {
          setState(() {
            url = widget.model.session?.photoUrl;
            photo = Future.value(bytes);
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'No pudimos cambiar tu foto. Inténtalo de nuevo.',
        );
      }
    } finally {
      widget.model.photoSelection(false);
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.model.session!, roles = widget.model.personal.roles;
    final initials = user.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.forest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 88,
                    height: 88,
                    child: Stack(
                      children: [
                        Semantics(
                          label: 'Foto de perfil de ${user.name}',
                          child: ClipOval(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: FutureBuilder<Uint8List?>(
                                future: photo,
                                builder: (context, snapshot) {
                                  final bytes = snapshot.data;
                                  final fallback = ColoredBox(
                                    color: AppTheme.leaf,
                                    child: Center(
                                      child: Text(
                                        initials,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.forest,
                                        ),
                                      ),
                                    ),
                                  );
                                  return bytes == null
                                      ? fallback
                                      : Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stack) =>
                                                  fallback,
                                        );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton.filled(
                            tooltip: saving
                                ? 'Guardando foto…'
                                : 'Cambiar foto de perfil',
                            onPressed: saving || widget.model.busy
                                ? null
                                : change,
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.leaf,
                              foregroundColor: AppTheme.forest,
                              disabledBackgroundColor: AppTheme.leaf,
                              side: const BorderSide(
                                color: AppTheme.forest,
                                width: 3,
                              ),
                              minimumSize: const Size(44, 44),
                            ),
                            icon: saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const AppIcon(Symbol.edit, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TU ESPACIO',
                          style: TextStyle(
                            color: Color(0xFFCADAAB),
                            fontSize: 11,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mi perfil',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: const TextStyle(color: Color(0xFFDDE7D9), fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const AppIcon(
                    Symbol.people,
                    color: Color(0xFFCADAAB),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      user.churchName,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (roles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final role in roles)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.leaf,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (error != null) FeedbackPanel(error!, error: true),
      ],
    );
  }
}
