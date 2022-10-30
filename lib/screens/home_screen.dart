import 'package:docs_clone/models/document.dart';
import 'package:docs_clone/models/error.dart';
import 'package:docs_clone/providers/auth_provider.dart';
import 'package:docs_clone/providers/document_provider.dart';
import 'package:docs_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref.watch(documentServiceProvider).getDocuments(
              ref.watch(userProvider)!.token,
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Document> documents = snapshot.data!.data;
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 18),
                width: 600,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () {
                          Routemaster.of(context).push('/document/${documents[index].id}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black26,
                            width: 1.0,
                          )),
                          height: 50,
                          width: 400,
                          child: Center(
                            child: Text(
                              documents[index].title,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: documents.length,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  snapshot.error.toString(),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitChasingDots(
              color: Colors.blue,
              size: 20.0,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void signOut(WidgetRef ref) {
    ref.read(authenticationProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final sMessenger = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(documentServiceProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }
}
