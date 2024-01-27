import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config/constants/hive_table_constant.dart';
import '../../../features/auth/data/model/auth_hive_model.dart';
import '../../../features/home/data/model/home_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register Adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(HomeHiveModelAdapter());
    // Hive.registerAdapter(CourseHiveModelAdapter());

    // Add dummy data
    // await addDummyArt();
    // await addDummyCourse();
  }

  // ======================== Art Queries ========================
  Future<void> addArt(HomeHiveModel art) async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.homeBox);
    await box.put(art.artId, art);
  }

  Future<List<HomeHiveModel>> getAllArt() async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.homeBox);
    var arts = box.values.toList();
    box.close();
    return arts;
  }

  // ======================== User Queries ========================
  Future<void> addUser(AuthHiveModel user) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(user.username, user);
  }

  Future<List<AuthHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var users = box.values.toList();
    box.close();
    return users;
  }

  //Login
  Future<AuthHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere((element) =>
        element.username == username && element.password == password);
    box.close();
    return user;
  }

  // ======================== Delete All Data ========================
  Future<void> deleteAllData() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.clear();
  }

  // ======================== Close Hive ========================
  Future<void> closeHive() async {
    await Hive.close();
  }

  // ======================== Delete Hive ========================
  Future<void> deleteHive() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.homeBox);
    await Hive.deleteFromDisk();
  }

  //   // ======================== Insert Dummy Data ========================
  // // Art Dummy Data
  // Future<void> addDummyArt() async {
  //   // check of art box is empty
  //   var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.homeBox);
  //   if (box.isEmpty) {
  //     final art1 = HomeHiveModel(
  //       artId: '1',
  //       title: 'Art 1',
  //       description: 'Description of Art 1',
  //       creator: 'Creator 1',
  //       image: 'image_url_1',
  //       endingDate: '2023-07-15',
  //       startingBid: 100,
  //       artType: 'Recent',
  //       categories: 'Abstract',
  //     );
  //     final art2 = HomeHiveModel(
  //       artId: '2',
  //       title: 'Art 2',
  //       description: 'Description of Art 2',
  //       creator: 'Creator 2',
  //       image: 'image_url_2',
  //       endingDate: '2023-07-15',
  //       startingBid: 200,
  //       artType: 'Recent',
  //       categories: 'Abstract'
  //     );
  //     final art3 = HomeHiveModel(
  //       artId: '3',
  //       title: 'Art 3',
  //       description: 'Description of Art 3',
  //       creator: 'Creator 3',
  //       image: 'image_url_3',
  //       endingDate: '2023-07-15',
  //       startingBid: 300,
  //       artType: 'Recent',
  //       categories: 'Abstract'
  //     );

  //     List<HomeHiveModel> arts = [art1, art2, art3];

  //     // Insert batch with key
  //     for (var art in arts) {
  //       await addArt(art);
  //     }
  //   }
  // }
}
