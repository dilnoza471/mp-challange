import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final post = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. ListTile
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(post["username"] ?? "Unknown"),
                      subtitle: const Text("2 hours ago"), // 2. Text (subtitle)
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert), // 3. IconButton
                        onPressed: () {},
                      ),
                    ),
                    // 4. Padding + 5. Text
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(post["text"] ?? ""),
                    ),
                    // 6. Image (if exists)
                    if (post["image"] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(post["image"]),
                        ),
                      ),
                    const SizedBox(height: 8), // 7. SizedBox
                    // 8. ButtonBar with TextButtons
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up),
                          label: const Text("Like"),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.comment),
                          label: const Text("Comment"),
                        ),
                      ],
                    ),
                    const Divider(), // 9. Divider
                    // 10. Row with likes/comments
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.thumb_up, size: 16),
                          SizedBox(width: 4),
                          Text("12 likes"),
                          SizedBox(width: 16),
                          Icon(Icons.comment, size: 16),
                          SizedBox(width: 4),
                          Text("4 comments"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12), // 11. SizedBox
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
