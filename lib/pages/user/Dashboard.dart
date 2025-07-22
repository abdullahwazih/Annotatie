import 'package:annotatiev02/pages/user/completed_projects.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? completedProjectsCount;
  int? pendingProjectsCount;
  bool isLoading = true;
  String? errorMessage;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    initializeUserAndFetchData();
  }

  Future<void> initializeUserAndFetchData() async {
    try {
      currentUser = _auth.currentUser;

      if (currentUser == null) {
        setState(() {
          errorMessage = "User not logged in.";
          isLoading = false;
        });
        return;
      }

      await fetchCompletedProjectsCountByUser(currentUser!.uid);
      await fetchPendingProjectsCountByUser(currentUser!.uid);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> fetchPendingProjectsCountByUser(String userId) async {
    try {
      final result = await supabase.rpc(
        'get_pending_projects_count_by_user',
        params: {'p_user_id': userId},
      );

      setState(() {
        pendingProjectsCount = int.tryParse(result.toString()) ?? 0;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchCompletedProjectsCountByUser(String userId) async {
    try {
      final result = await supabase.rpc(
        'get_completed_projects_count_by_user',
        params: {'p_user_id': userId},
      );

      setState(() {
        completedProjectsCount = int.tryParse(result.toString()) ?? 0;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlueTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A2342),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF90CAF9),
        tertiary: const Color(0xFF102C57),
        background: const Color(0xFF0A2342),
        surface: const Color(0xFF102C57),
      ),
      cardColor: const Color(0xFF102C57),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );

    return Theme(
      data: darkBlueTheme,
      child: Scaffold(
        backgroundColor: darkBlueTheme.scaffoldBackgroundColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logout & Welcome
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome 👋',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.white30),
                    const SizedBox(height: 20),

                    // Pending Projects
                    SizedBox(
                      height: 150,
                      child: Card(
                        color: darkBlueTheme.colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.pending_actions,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Pending Projects',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${pendingProjectsCount ?? 0}",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("View"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Completed Projects
                    SizedBox(
                      height: 150,
                      child: Card(
                        color: darkBlueTheme.colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.task_alt, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Completed Projects',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${completedProjectsCount ?? 0}",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CompletedProjects(
                                        userId: currentUser?.uid ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("View"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Divider(color: Colors.white30),
                    const SizedBox(height: 20),

                    // Add project section
                    Text(
                      'Add Project',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: darkBlueTheme.colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addTextProject');
                      },
                      icon: const Icon(Icons.text_fields),
                      label: const Text('Text Project'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addProject');
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Image Project'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
