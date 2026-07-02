import 'package:flutter/material.dart';
import '../../controllers/cliente_controller.dart';
import '../../data/model/clientes.dart';

/// Formulario único para crear y editar clientes.
/// Si [cliente] es null, se crea uno nuevo; si no, se edita el existente.
class FormularioClienteScreen extends StatefulWidget {
  final Cliente? cliente;

  const FormularioClienteScreen({super.key, this.cliente});

  @override
  State<FormularioClienteScreen> createState() => _FormularioClienteScreenState();
}

class _FormularioClienteScreenState extends State<FormularioClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final ClienteController _controller = ClienteController();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _identificacionCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _emailCtrl;
  bool _guardando = false;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _identificacionCtrl = TextEditingController(text: c?.identificacion ?? '');
    _telefonoCtrl = TextEditingController(text: c?.telefono ?? '');
    _direccionCtrl = TextEditingController(text: c?.direccion ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _identificacionCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _validarNombre(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'El nombre es obligatorio';
    if (v.length < 3) return 'El nombre debe tener al menos 3 caracteres';
    if (v.length > 100) return 'El nombre es demasiado largo';
    return null;
  }

  String? _validarIdentificacion(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'La identificación es obligatoria';
    final regex = RegExp(r'^[a-zA-Z0-9]{5,15}$');
    if (!regex.hasMatch(v)) {
      return 'Debe tener entre 5 y 15 caracteres alfanuméricos';
    }
    return null;
  }

  String? _validarTelefono(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'El teléfono es obligatorio';
    final regex = RegExp(r'^[0-9]{7,10}$');
    if (!regex.hasMatch(v)) {
      return 'Ingresa un teléfono válido (7 a 10 dígitos, sin espacios)';
    }
    return null;
  }

  String? _validarDireccion(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'La dirección es obligatoria';
    if (v.length < 5) return 'La dirección es demasiado corta';
    return null;
  }

  String? _validarEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'El email es obligatorio';
    final regex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(v)) return 'Ingresa un email válido';
    return null;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    // El backend exige que la clave "email" siempre venga presente,
    // aunque en creación puede ir vacía. En edición debe ir con valor.
    final data = {
      'nombre': _nombreCtrl.text.trim(),
      'identificacion': _identificacionCtrl.text.trim(),
      'telefono': _telefonoCtrl.text.trim(),
      'direccion': _direccionCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
    };

    try {
      if (_esEdicion) {
        await _controller.actualizarCliente(widget.cliente!.id, data);
      } else {
        await _controller.crearCliente(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_esEdicion ? 'Cliente actualizado' : 'Cliente creado')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: _validarNombre,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _identificacionCtrl,
              decoration: const InputDecoration(
                labelText: 'Identificación',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: _validarIdentificacion,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefonoCtrl,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: _validarTelefono,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _direccionCtrl,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              validator: _validarDireccion,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validarEmail,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardando ? null : _guardar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_esEdicion ? 'Guardar cambios' : 'Crear cliente'),
            ),
          ],
        ),
      ),
    );
  }
}