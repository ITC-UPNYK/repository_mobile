import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import '../../models/discussion/discussion_by_course_id_model.dart';
import '../widgets/delete_overlay_widget.dart';
import 'add_question_screen.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscussionListScreen extends StatefulWidget {
  const DiscussionListScreen({super.key});

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();
}

class _DiscussionListScreenState extends State<DiscussionListScreen> {
  final appController = Get.put(AppController());
  final courseid = Get.arguments['courseId'];
  final title = Get.arguments['judul'];
  var idUser;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        idUser = value.getInt('id-user');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('courseid : $courseid');
    debugPrint('title : $title');
    return Scaffold(
      backgroundColor: hexToColor(ColorsRepo.lightGray),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: Text('$title'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchDiscussionScreen(courseId: courseid),
              );
            },
            icon: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: appController.fetchAllDiscussionByidCourse(courseid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == 'Tidak ada data' ||
                snapshot.data == null) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Center(
                  heightFactor: MediaQuery.of(context).size.height / 38,
                  child: const Text(
                    'Belum ada diskusi',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Diskusi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.21,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutesRepo.pertanyaan,arguments: {
                                'courseId' : courseid,
                                'discussionId' : snapshot.data![index].id
                            });
                            },
                            child: Container(
                              height: 178,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(12, 6, 8, 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: CachedNetworkImage(
                                              imageUrl: '',
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 32,
                                                width: 32,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(
                                                alignment: Alignment.center,
                                                color: Colors.grey.shade200,
                                                height: 32,
                                                width: 32,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.grey.shade200,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.grey.shade400,
                                                  size: 32,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data![index].user.fullName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(snapshot
                                                        .data![index]
                                                        .createdAt)),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: hexToColor(
                                                      ColorsRepo.darkGray),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton(
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (BuildContext context) =>
                                            idUser ==
                                                    snapshot.data![index].idUser
                                                ? [
                                                    PopupMenuItem(
                                                      value: '',
                                                      child: const Text(
                                                          'Laporkan Pertanyaan'),
                                                      onTap: () {
                                                        print(
                                                            'Laporkan Pertanyaan');
                                                      },
                                                    ),
                                                    PopupMenuItem(
                                                      value: '',
                                                      child:
                                                          const Text('Hapus'),
                                                      onTap: () {
                                                        print(courseid);
                                                        Future.delayed(
                                                          const Duration(
                                                              seconds: 0),
                                                          () => showAlertDialog(
                                                            context,
                                                            courseid,
                                                            snapshot
                                                                .data[index].id,
                                                            title,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ]
                                                : [
                                                    PopupMenuItem(
                                                      value: '',
                                                      child: const Text(
                                                          'Laporkan Pertanyaan'),
                                                      onTap: () {
                                                        print(
                                                            'Laporkan Pertanyaan');
                                                      },
                                                    ),
                                                  ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    snapshot.data![index].title,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    snapshot.data![index].body,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Get.to(() => const AddQuestionScreen());
          Get.to(
            () => const AddQuestionScreen(),
            arguments: {'idCourse': courseid, 'title': title},
          );
        },
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchDiscussionScreen extends SearchDelegate {
  int? courseId;

  SearchDiscussionScreen({
    this.courseId,
  });

  final appController = Get.put(AppController());
  var allData = <DiscussionResponse>[];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: appController.searchDiscussionTitle(courseId!, query),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title!),
                onTap: () {
                  Get.toNamed(AppRoutesRepo.pertanyaan);
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Nothing Here'),
    );
  }
}
