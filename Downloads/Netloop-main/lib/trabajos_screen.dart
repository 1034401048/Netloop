import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formulario_screen.dart'; // 👈 importa tu formulario

class TrabajosScreen extends StatefulWidget {
  const TrabajosScreen({super.key});

  @override
  State<TrabajosScreen> createState() => _TrabajosScreenState();
}

class _TrabajosScreenState extends State<TrabajosScreen> {
  String? filtroCiudad;
  String? filtroTipo;
  String? filtroExperiencia;
  String? filtroJornada;
  String? filtroContrato;

  final List<String> tiposTrabajo = ["Remoto", "Presencial", "Híbrido"];
  final List<String> experiencia = ["6 meses", "1 año", "2 años", "3 años+", "No requiere"];
  final List<String> jornada = ["Tiempo completo", "Medio tiempo", "Prácticas", "Por horas"];
  final List<String> contratos = ["Término fijo", "Indefinido", "Prestación de servicios", "Aprendizaje"];
  final List<String> ciudades = [
    "Bogotá", "Medellín", "Cali", "Barranquilla", "Cartagena",
    "Bucaramanga", "Cúcuta", "Pereira", "Manizales", "Otras"
  ];

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("trabajos")
        .orderBy("fecha", descending: true);

    // 🔹 Aplicar filtros
    if (filtroCiudad != null && filtroCiudad!.isNotEmpty) {
      query = query.where("ciudad", isEqualTo: filtroCiudad);
    }
    if (filtroTipo != null && filtroTipo!.isNotEmpty) {
      query = query.where("tipo", isEqualTo: filtroTipo);
    }
    if (filtroExperiencia != null && filtroExperiencia!.isNotEmpty) {
      query = query.where("experiencia", isEqualTo: filtroExperiencia);
    }
    if (filtroJornada != null && filtroJornada!.isNotEmpty) {
      query = query.where("jornada", isEqualTo: filtroJornada);
    }
    if (filtroContrato != null && filtroContrato!.isNotEmpty) {
      query = query.where("contrato", isEqualTo: filtroContrato);
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Ofertas de Trabajo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // 🔹 FILTROS
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDropdown("Ciudad", filtroCiudad, ciudades, (val) {
                    setState(() => filtroCiudad = val);
                  }),
                  const SizedBox(width: 8),
                  _buildDropdown("Tipo", filtroTipo, tiposTrabajo, (val) {
                    setState(() => filtroTipo = val);
                  }),
                  const SizedBox(width: 8),
                  _buildDropdown("Experiencia", filtroExperiencia, experiencia,
                          (val) {
                        setState(() => filtroExperiencia = val);
                      }),
                  const SizedBox(width: 8),
                  _buildDropdown("Jornada", filtroJornada, jornada, (val) {
                    setState(() => filtroJornada = val);
                  }),
                  const SizedBox(width: 8),
                  _buildDropdown("Contrato", filtroContrato, contratos, (val) {
                    setState(() => filtroContrato = val);
                  }),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        filtroCiudad = null;
                        filtroTipo = null;
                        filtroExperiencia = null;
                        filtroJornada = null;
                        filtroContrato = null;
                      });
                    },
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text("Quitar filtros"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 LISTA DE TRABAJOS
          Expanded(
            child: StreamBuilder(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "🚀 No hay ofertas que coincidan con los filtros.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                final trabajos = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: trabajos.length,
                  itemBuilder: (context, index) {
                    final doc = trabajos[index];
                    final trabajo = doc.data();

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        // 👇 Navegar al formulario con los datos del trabajo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioScreen(
                              trabajo: doc.id, // ID del trabajo
                              titulo: trabajo["titulo"] ?? "Sin título",
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.work,
                                        color: Colors.blueAccent, size: 30),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      trabajo["titulo"] ?? "Sin título",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                trabajo["descripcion"] ?? "Sin descripción",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(height: 20, thickness: 1),
                              Wrap(
                                runSpacing: 8,
                                spacing: 12,
                                children: [
                                  if (trabajo["experiencia"] != null)
                                    _buildInfo(Icons.school,
                                        "Exp: ${trabajo["experiencia"]}"),
                                  if (trabajo["ciudad"] != null)
                                    _buildInfo(Icons.location_on,
                                        trabajo["ciudad"].toString()),
                                  if (trabajo["salario"] != null)
                                    _buildInfo(Icons.attach_money,
                                        trabajo["salario"].toString()),
                                  if (trabajo["jornada"] != null)
                                    _buildInfo(Icons.schedule,
                                        trabajo["jornada"].toString()),
                                  if (trabajo["contrato"] != null)
                                    _buildInfo(Icons.assignment,
                                        trabajo["contrato"].toString()),
                                  if (trabajo["tipo"] != null)
                                    _buildInfo(Icons.home_work,
                                        trabajo["tipo"].toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String label, String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blueAccent),
      label: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
