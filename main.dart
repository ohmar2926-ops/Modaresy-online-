
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MadrasatyApp());
}

class MadrasatyApp extends StatelessWidget {
  const MadrasatyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'مدرستي أون لاين',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    ),
    home: const AuthGate(),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: AuthService().authState,
    builder: (_, snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return snap.data == null ? const LoginPage() : const HomePage();
    },
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email=TextEditingController(), password=TextEditingController(), name=TextEditingController();
  bool register=false, teacher=false, loading=false;
  String? error;

  Future<void> submit() async {
    setState(() {loading=true; error=null;});
    try {
      if (register) {
        await AuthService().register(name:name.text,email:email.text,password:password.text,
          role:teacher?'teacher':'student');
      } else {
        await AuthService().login(email.text,password.text);
      }
    } on FirebaseAuthException catch(e) {
      setState(() => error = e.message ?? e.code);
    } catch(e) { setState(() => error=e.toString()); }
    if (mounted) setState(() => loading=false);
  }

  @override Widget build(BuildContext context) => Scaffold(
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth:480),
        child: Column(children:[
          const Icon(Icons.school_rounded,size:70,color:Color(0xFF2563EB)),
          const SizedBox(height:12),
          const Text('مدرستي أون لاين',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),
          const SizedBox(height:30),
          if(register) TextField(controller:name,decoration:const InputDecoration(
            labelText:'الاسم',border:OutlineInputBorder())),
          if(register) const SizedBox(height:12),
          TextField(controller:email,decoration:const InputDecoration(
            labelText:'البريد الإلكتروني',border:OutlineInputBorder())),
          const SizedBox(height:12),
          TextField(controller:password,obscureText:true,decoration:const InputDecoration(
            labelText:'كلمة المرور',border:OutlineInputBorder())),
          if(register) SwitchListTile(title:const Text('حساب مدرس'),
            value:teacher,onChanged:(v)=>setState(()=>teacher=v)),
          if(error!=null) Padding(padding:const EdgeInsets.all(8),
            child:Text(error!,style:const TextStyle(color:Colors.red))),
          const SizedBox(height:12),
          SizedBox(width:double.infinity,child:FilledButton(
            onPressed:loading?null:submit,
            child:Text(loading?'جارٍ التنفيذ...':register?'إنشاء حساب':'دخول'))),
          TextButton(onPressed:()=>setState(()=>register=!register),
            child:Text(register?'لدي حساب بالفعل':'إنشاء حساب جديد')),
        ]))),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar:AppBar(title:const Text('مدرستي أون لاين'),actions:[
        IconButton(onPressed:()=>AuthService().logout(),icon:const Icon(Icons.logout))
      ]),
      body:FutureBuilder(future:AuthService().profile(uid),builder:(context,snap){
        if(!snap.hasData)return const Center(child:CircularProgressIndicator());
        final data=snap.data!.data()??{};
        final teacher=data['role']=='teacher';
        return ListView(padding:const EdgeInsets.all(20),children:[
          Text('مرحبًا ${data['name']??''} 👋',
            style:const TextStyle(fontSize:26,fontWeight:FontWeight.bold)),
          const SizedBox(height:8),
          Text(teacher?'لوحة المدرس':'لوحة الطالب',
            style:const TextStyle(color:Colors.black54)),
          const SizedBox(height:24),
          if(teacher) ...[
            const ListTile(leading:Icon(Icons.add_circle),title:Text('إنشاء حصة'),
              subtitle:Text('سيتم ربطها بقاعدة Firestore')),
            const ListTile(leading:Icon(Icons.groups),title:Text('الطلاب'),
              subtitle:Text('إدارة طلاب كل حصة')),
            const ListTile(leading:Icon(Icons.assignment),title:Text('الواجبات')),
          ] else ...[
            const ListTile(leading:Icon(Icons.school),title:Text('حصصي')),
            const ListTile(leading:Icon(Icons.assignment),title:Text('واجباتي')),
          ],
        ]);
      }),
    );
  }
}
