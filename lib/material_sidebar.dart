import 'package:draft/features/appointment/presentation/screens/appointment_screen.dart';
import 'package:draft/time_table_screen.dart';
import 'package:flutter/material.dart';

import 'calendar.dart';
import 'colored_calendar.dart';


class MaterialSidebar extends StatefulWidget {
  const MaterialSidebar({Key? key}) : super(key: key);

  @override
  State<MaterialSidebar> createState() => _MaterialSidebarState();
}

class _MaterialSidebarState extends State<MaterialSidebar> {
  int _selectedIndex = 0;
  bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Using NavigationRail for desktop/tablet
            NavigationRail(
              extended: _isExtended,
              minWidth: 60,
              minExtendedWidth: 150,
              leading: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        _isExtended ? Icons.chevron_left : Icons.chevron_right,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExtended = !_isExtended;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.medical_services,
                      size: 32,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ],
              ),
              destinations: [
                NavigationRailDestination(
                  icon: _isExtended
                      ? const Icon(Icons.calendar_today)
                      : Tooltip(
                    message: 'Calendar',
                    preferBelow: false,
                    verticalOffset: 10,
                    waitDuration: Duration(milliseconds: 500),
                    showDuration: Duration(seconds: 2),
                    child: const Icon(Icons.calendar_today),
                  ),
                  label: const Text('Calendar'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Patients',
                    preferBelow: false,
                    verticalOffset: 10,
                    waitDuration: Duration(milliseconds: 500),
                    showDuration: Duration(seconds: 2),
                    child: Icon(Icons.people),
                  ),
                  label: Text('Patients'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Reports',
                    preferBelow: false,
                    verticalOffset: 10,
                    waitDuration: Duration(milliseconds: 500),
                    showDuration: Duration(seconds: 2),
                    child: Icon(Icons.assessment),
                  ),
                  label: Text('Reports'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Settings',
                    preferBelow: false,
                    verticalOffset: 10,
                    waitDuration: Duration(milliseconds: 500),
                    showDuration: Duration(seconds: 2),
                    child: Icon(Icons.settings),
                  ),
                  label: Text('Settings'),
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            // Vertical divider
            const VerticalDivider(thickness: 1, width: 1),
            // Main content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      // Using Drawer for mobile
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Medical App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              selected: _selectedIndex == 0,
              onTap: () => _selectItem(0, context),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Patients'),
              selected: _selectedIndex == 1,
              onTap: () => _selectItem(1, context),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Reports'),
              selected: _selectedIndex == 2,
              onTap: () => _selectItem(2, context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              selected: _selectedIndex == 3,
              onTap: () => _selectItem(3, context),
            ),
          ],
        ),
      ),
    );
  }

  void _selectItem(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    // Close drawer on mobile
    if (Scaffold
        .of(context)
        .hasDrawer) {
      Navigator.pop(context);
    }
  }

  Widget _buildContent() {
    final List<Widget> pages = [

      MultiSelectCalendar(),
      ColoredCalendar(),
      ClinicSchedulerScreen(),
      TimetableScreen(),
      // MultiColumnDayView(
      //   doctors: [
      //     DoctorSchedule(
      //       doctorName: 'Верстакова А. Г.',
      //       chairNumber: '#1',
      //       columnColor: Colors.green,
      //     ),
      //     DoctorSchedule(
      //       doctorName: 'Иванова Е. В.',
      //       chairNumber: '#2',
      //       columnColor: Colors.pink,
      //     ),
      //     DoctorSchedule(
      //       doctorName: 'Брантова Г. К.',
      //       chairNumber: '#3',
      //       columnColor: Colors.purple,
      //     ),
      //   ],
      // ),

    ];

    return pages[_selectedIndex];
  }

}