import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: {
        '/new-contact':(context) => const NewContactView(),
      },
    );
  }
}

class Contacts {
  final String name;
  final String id;
  Contacts({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contacts>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  
  int get length => value.length;

  void add({required Contacts contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contacts contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
    }
    notifyListeners();
  }

  Contacts? contact({required int index}) {
    Contacts? contact = value.length > index ? value[index] : null;
    return contact;
  }

}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          return ListView.builder(
          itemCount: contactBook.length,
          itemBuilder: (context, index) {
            final contact = ContactBook().contact(index: index)!;
            return ListTile(
              title: Text(contact.name),
            );
          },);
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await Navigator.of(context).pushNamed('/new-contact');
      }, 
      child: const Icon(Icons.add),),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new contact"),
      ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Enter a new contact name...",
            ),
          ),
          TextButton(onPressed: () {
            final contact = Contacts(name: _controller.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          }, 
          child: const Text("Add contact")),
      ],),
    );
  }
}