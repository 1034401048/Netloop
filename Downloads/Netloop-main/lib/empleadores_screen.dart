import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpleadoresScreen extends StatefulWidget {
  const EmpleadoresScreen({super.key});

  @override
  State<EmpleadoresScreen> createState() => _EmpleadoresScreenState();
}

class _EmpleadoresScreenState extends State<EmpleadoresScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();

  final List<String> tiposTrabajo = ["Remoto", "Presencial", "Híbrido"];
  final List<String> experiencia = ["6 meses", "1 año", "2 años", "3 años+", "No requiere"];
  final List<String> jornada = ["Tiempo completo", "Medio tiempo", "Prácticas", "Por horas"];
  final List<String> contratos = ["Término fijo", "Indefinido", "Prestación de servicios", "Aprendizaje"];
  final List<String> ciudades = [
    "Bogotá", "Medellín", "Cali", "Barranquilla", "Cartagena",
    "Bucaramanga", "Cúcuta", "Pereira", "Manizales", "Otras"
  ];

  String? tipoSeleccionado;
  String? experienciaSeleccionada;
  String? jornadaSeleccionada;
  String? contratoSeleccionado;
  String? ciudadSeleccionada;

  void publicarTrabajo() async {
    if (tituloController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        tipoSeleccionado == null ||
        experienciaSeleccionada == null ||
        jornadaSeleccionada == null ||
        contratoSeleccionado == null ||
        ciudadSeleccionada == null ||
        salarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Completa todos los campos")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("trabajos").add({
      "titulo": tituloController.text,
      "descripcion": descripcionController.text,
      "tipo": tipoSeleccionado,
      "experiencia": experienciaSeleccionada,
      "jornada": jornadaSeleccionada,
      "contrato": contratoSeleccionado,
      "ciudad": ciudadSeleccionada,
      "salario": salarioController.text,
      "fecha": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Trabajo publicado con éxito!")),
    );
    tituloController.clear();
    descripcionController.clear();
    salarioController.clear();
    setState(() {
      tipoSeleccionado = null;
      experienciaSeleccionada = null;
      jornadaSeleccionada = null;
      contratoSeleccionado = null;
      ciudadSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Publicar Oferta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Crea una nueva oferta de empleo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // 🔹 Título
            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: "Título del trabajo",
                prefixIcon: const Icon(Icons.work, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),

            // 🔹 Descripción
            TextField(
              controller: descripcionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Descripción",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),

            // 🔹 Salario
            TextField(
              controller: salarioController,
              decoration: InputDecoration(
                labelText: "Salario (ej: 2.000.000 COP)",
                prefixIcon: const Icon(Icons.monetization_on, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Tipo de trabajo:", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: tiposTrabajo.map((tipo) {
                return ChoiceChip(
                  label: Text(tipo),
                  selected: tipoSeleccionado == tipo,
                  onSelected: (value) {
                    setState(() {
                      tipoSeleccionado = value ? tipo : null;
                    });
                  },
                  selectedColor: Colors.blueAccent,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Text("Tiempo de experiencia:", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: experiencia.map((exp) {
                return ChoiceChip(
                  label: Text(exp),
                  selected: experienciaSeleccionada == exp,
                  onSelected: (value) {
                    setState(() {
                      experienciaSeleccionada = value ? exp : null;
                    });
                  },
                  selectedColor: Colors.blueAccent,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Text("Ciudad/Lugar:", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: ciudadSeleccionada,
              items: ciudades.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) => setState(() => ciudadSeleccionada = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Jornada:", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: jornada.map((j) {
                return ChoiceChip(
                  label: Text(j),
                  selected: jornadaSeleccionada == j,
                  onSelected: (value) {
                    setState(() {
                      jornadaSeleccionada = value ? j : null;
                    });
                  },
                  selectedColor: Colors.blueAccent,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Text("Tipo de contrato:", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: contratos.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: contratoSeleccionado == c,
                  onSelected: (value) {
                    setState(() {
                      contratoSeleccionado = value ? c : null;
                    });
                  },
                  selectedColor: Colors.blueAccent,
                );
              }).toList(),
            ),

            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: publicarTrabajo,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Publicar Trabajo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
