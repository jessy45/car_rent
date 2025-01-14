import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'car_details.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List categories = [];
  List vehicles = [];
  List filteredVehicles = []; // Liste des véhicules filtrés
  bool isLoading = true;
  int? selectedCategoryId; // ID de la catégorie sélectionnée

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchVehicles();
  }

  // Récupère les catégories depuis l'API
  Future<void> fetchCategories() async {
    const String apiUrl = "https://aliceblue-raccoon-312096.hostingersite.com/api/categories";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = [
            {'categorie_id': null, 'nom_categorie': 'All'}, // Ajout de l'option "All"
            ...data
          ];
          if (categories.isNotEmpty) {
            selectedCategoryId = null;
            filterVehiclesByCategory(selectedCategoryId);
          }
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  // Filtrer les véhicules par catégorie
  void filterVehiclesByCategory(int? categoryId) {
    setState(() {
      if (categoryId == null) {
        // Afficher toutes les voitures si la catégorie est "All"
        filteredVehicles = vehicles;
      } else {
        // Filtrer par catégorie
        filteredVehicles = vehicles.where((vehicle) {
          return vehicle['categorie_id'] == categoryId;
        }).toList();
      }
    });
  }


  // Récupérer les véhicules depuis l'API
  Future<void> fetchVehicles() async {
    const String apiUrl = "https://aliceblue-raccoon-312096.hostingersite.com/api/vehicules";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          vehicles = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load vehicles");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  Widget _buildIcon(IconData icon, {required bool isActive}) {
    return Container(
      decoration: isActive
          ? const BoxDecoration(
        color: Color(0xFF7DD3F7), // Couleur de fond pour l'icône active
        shape: BoxShape.circle,
      )
          : null,
      padding: const EdgeInsets.all(4), // Espace autour de l'icône
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.grey, // Couleur selon l'état
        size: 24, // Taille de l'icône
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Localisation (Barre supérieure)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Manchester, UK',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                    radius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Titre "Categories"
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Catégories (scroll horizontal)
              SizedBox(
                height: 40,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryButton(
                      categories[index]['nom_categorie'],
                      categories[index]['categorie_id'],
                      isActive: selectedCategoryId == categories[index]['categorie_id'],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Titre "Popular cars"
              const Text(
                'Popular cars',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Liste des voitures filtrées
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredVehicles.isEmpty
                    ? const Center(
                  child: Text(
                    "No vehicles available in this category",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    return _buildCarCard(
                      image: vehicle['image_url'] ?? 'assets/supra(1).png',
                      name: '${vehicle['marque']} ${vehicle['modele']}',
                      price: '\$${vehicle['prix_journalier']}/day',
                      fuel: vehicle['carburant'] ?? 'N/A',
                      speed: vehicle['vitesse_max'] ?? 'N/A',
                      seats: '${vehicle['nombre_sieges'] ?? 'N/A'} seats',
                      vehicle: vehicle, // Données complètes
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
      // Barre de navigation inférieure
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margin externe
        padding: const EdgeInsets.symmetric(vertical: 0), // Padding interne
        decoration: BoxDecoration(
          color: const Color(0xFF302f34),
          borderRadius: BorderRadius.circular(60), // Arrondi complet
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Géré par le Container
          currentIndex: 0, // Onglet actif
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7DD3F7),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false, // Supprime les labels
          showUnselectedLabels: false, // Supprime les labels
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, isActive: true), // Icône avec effet cercle
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.search, isActive: false),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.calendar_today, isActive: false),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, isActive: false),
              label: '',
            ),
          ],
        ),
      ),


    );
  }

  // Widget pour les boutons de catégorie
  // Modifiez la méthode _buildCategoryButton pour afficher "All"
  Widget _buildCategoryButton(String title, int? categoryId, {required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategoryId = categoryId;
            filterVehiclesByCategory(categoryId);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.black : Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }


  // Widget pour les cartes de voiture
  Widget _buildCarCard({
    required String image,
    required String name,
    required String price,
    required String fuel,
    required String speed,
    required String seats,
    required Map vehicle
  }) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailScreen(vehicle: vehicle),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // Margin en bas
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Image de la voiture
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Icône favorite
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Nom de la voiture et prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Détails de la voiture
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCarSpec(Icons.local_gas_station, fuel),
                const SizedBox(width: 10),
                _buildCarSpec(Icons.speed, speed),
                const SizedBox(width: 10),
                _buildCarSpec(Icons.person, seats),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // Widget pour une spécification de voiture
  Widget _buildCarSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
