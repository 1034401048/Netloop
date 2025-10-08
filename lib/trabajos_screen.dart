import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

          final trabajos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: trabajos.length,
            itemBuilder: (context, index) {
              final trabajo = trabajos[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del trabajo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.work, color: Colors.blueAccent, size: 30),
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

                      // Descripción breve
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

                      // Info adicional
                      Wrap(
                        runSpacing: 8,
                        spacing: 12,
                        children: [
                          if (trabajo["experiencia"] != null)
                            _buildInfo(Icons.school, "Exp: ${trabajo["experiencia"]}"),
                          if (trabajo["ciudad"] != null)
                            _buildInfo(Icons.location_on, trabajo["ciudad"]),
                          if (trabajo["salario"] != null && trabajo["salario"].toString().isNotEmpty)
                            _buildInfo(Icons.attach_money, trabajo["salario"]),
                          if (trabajo["jornada"] != null)
                            _buildInfo(Icons.schedule, trabajo["jornada"]),
                          if (trabajo["contrato"] != null)
                            _buildInfo(Icons.assignment, trabajo["contrato"]),
                          if (trabajo["tipo"] != null)
                            _buildInfo(Icons.home_work, trabajo["tipo"]),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
