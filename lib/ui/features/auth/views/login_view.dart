import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../../community/view_models/community_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void submit() {
    if (_form.currentState!.validate()) {
      widget.model.login(_email.text.trim(), _password.text);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AutofillGroup(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/brand/mark.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF164F3B),
                        BlendMode.srcIn,
                      ),
                      width: 48,
                      height: 48,
                      semanticsLabel: 'SheepLink',
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Tu comunidad,\nmás cerca.',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Un espacio sencillo para acompañar a tu célula.',
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF203C31),
                          side: const BorderSide(color: Color(0xFFD8DED4)),
                        ),
                        onPressed: widget.model.busy
                            ? null
                            : widget.model.loginGoogle,
                        icon: SvgPicture.asset(
                          'assets/brand/google.svg',
                          width: 20,
                          height: 20,
                          excludeFromSemantics: true,
                        ),
                        label: const Text('Continuar con Google'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: Text('o entra con tu correo')),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _email,
                      enabled: !widget.model.busy,
                      autofillHints: const [AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                      validator: (v) =>
                          v != null &&
                              RegExp(r'^\S+@\S+\.\S+$').hasMatch(v.trim())
                          ? null
                          : 'Escribe tu correo electrónico.',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      enabled: !widget.model.busy,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => submit(),
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      validator: (v) => (v?.isNotEmpty ?? false)
                          ? null
                          : 'Escribe tu contraseña.',
                    ),
                    const SizedBox(height: 24),
                    if (widget.model.error != null) ...[
                      FeedbackPanel(widget.model.error!, error: true),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: widget.model.busy ? null : submit,
                        child: Text(
                          widget.model.busy
                              ? 'Ingresando…'
                              : 'Entrar a mi comunidad',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ingresa con la misma cuenta que usas en SheepLink.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
