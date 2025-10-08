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

  void publicarTrabajo() async {
    if (tituloController.text.isEmpty || descripcionController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection("trabajos").add({
      "titulo": tituloController.text,
      "descripcion": descripcionController.text,
      "fecha": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Trabajo publicado con éxito!")),
    );

    tituloController.clear();
    descripcionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Publicar Oferta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: "Título del trabajo",
                prefixIcon: const Icon(Icons.work, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: descripcionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Descripción",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: publicarTrabajo,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text(
                "Publicar Trabajo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
