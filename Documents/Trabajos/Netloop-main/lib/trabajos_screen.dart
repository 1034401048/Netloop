import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formulario_screen.dart';

class TrabajosScreen extends StatelessWidget {
  const TrabajosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Ofertas de Trabajo",
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("trabajos")
            .orderBy("fecha", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trabajos = snapshot.data!.docs;

          if (trabajos.isEmpty) {
            return const Center(
              child: Text(
                "🚀 No hay ofertas disponibles aún.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: trabajos.length,
            itemBuilder: (context, index) {
              final trabajo = trabajos[index];
              return Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.work, color: Colors.blueAccent, size: 30),
                  ),
                  title: Text(
                    trabajo["titulo"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      trabajo["descripcion"],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormularioScreen(
                          trabajo: trabajo.id,
                          titulo: trabajo["titulo"],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
