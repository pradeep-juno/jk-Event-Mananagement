import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/positions.dart';
// Make sure to import the correct controller

class HRPositionsPage extends StatelessWidget {
  HRPositionsPage({Key? key}) : super(key: key);

  final Positions positions = Get.put(Positions());

  // Function to show the add/edit position dialog
  void _showPositionDialog({String? id, String? existingName}) {
    positions.positionController.text = existingName ?? '';

    Get.defaultDialog(
      title: id == null ? 'Add Position' : 'Edit Position',
      content: TextField(
        controller: positions.positionController,
        decoration: const InputDecoration(labelText: 'Position Name'),
        onChanged: (value) {
          if (value.isNotEmpty) {
            String capitalized =
                value[0].toUpperCase() + value.substring(1).toLowerCase();
            // Only update if the text has changed
            if (value != capitalized) {
              positions.positionController.text = capitalized;
              // Move the cursor to the end of the text
              positions.positionController.selection =
                  TextSelection.fromPosition(
                TextPosition(offset: capitalized.length),
              );
            }
          }
        },
      ),
      textCancel: 'Cancel',
      textConfirm: 'Submit',
      onConfirm: () {
        if (id == null) {
          positions.addPosition();
        } else {
          positions.updatePosition(id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positions Details'),
      ),
      body: Obx(() {
        if (positions.positions.isEmpty) {
          return const Center(child: Text('No Positions Available'));
        }

        return ListView.builder(
          itemCount: positions.positions.length,
          itemBuilder: (context, index) {
            final doc = positions.positions[index];
            final positionName = doc['name'];
            final dateTime = doc['createdAt']; // Retrieve the createdAt field

            return ListTile(
              title: Text(positionName),
              subtitle: Text(dateTime), // Directly show the date-time
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showPositionDialog(
                        id: doc.id, existingName: positionName),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => positions.deletePosition(doc.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPositionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
