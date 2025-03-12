// ignore_for_file: unused_element

import 'package:animate_do/animate_do.dart';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/VideoPlayerScreen.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/AssetGroupModel.dart';
import 'package:auscurator/screens/assets/widgets/pdf_view_screen.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class Assets extends ConsumerStatefulWidget {
  const Assets({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AssetsState();
  }
}

class _AssetsState extends ConsumerState {
  TextEditingController searchController = TextEditingController();
  List<AssetLists> filteredItems = [];

  // Separate expanded states for asset groups and asset lists
  List<bool> expandedGroupState = [];
  Map<int, List<bool>> expandedAssetState =
      {}; // Map to store expanded state for each asset list

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    searchController.addListener(() {
      filterItems();
    });
  }

  // Function to launch the URL
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // Try to launch the URL
    if (await canLaunchUrl(uri)) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showError(context, 'Could not launch $url');
      }
    } else {
      _showError(context, 'Invalid URL: $url');
    }
  }

  // Function to show an error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  void toggleGroupExpansion(int index) {
    setState(() {
      expandedGroupState[index] = !expandedGroupState[index];
    });
  }

  void toggleAssetExpansion(int groupIndex, int assetIndex) {
    setState(() {
      expandedAssetState[groupIndex]![assetIndex] =
          !expandedAssetState[groupIndex]![assetIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    final assetGroup = ref.watch(apiServiceProvider).getListOfEquipmentGroup();

    return ListView(
      // physics: NeverScrollableScrollPhysics(),
      // mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Asset',
                  labelStyle: TextStyle(
                    fontFamily: "Mulish",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
        const SizedBox(height: 5),
        FutureBuilder(
          future: assetGroup,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                child: const Center(
                    child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ShimmerLists(
                    count: 6,
                    width: double.infinity,
                    height: 100,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                )),
              );
            }

            if (snapshot.data == null ||
                snapshot.data!.assetGroupLists == null ||
                snapshot.data!.assetGroupLists!.isEmpty) {
              return Center(
                child: NoDataScreen(),
              );
            }
            // Apply search filter to the asset group list
            List<AssetGroupLists> assetGroupList =
                snapshot.data!.assetGroupLists!;
            if (searchController.text.isNotEmpty) {
              assetGroupList = assetGroupList.where((asset) {
                return asset.assetGroupName != null &&
                        asset.assetGroupCode!
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) ||
                    asset.assetGroupName!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
              }).toList();
            }

            // Initialize the expanded state list for asset groups
            if (expandedGroupState.length != assetGroupList.length) {
              expandedGroupState = List.filled(assetGroupList.length, false);
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 12),
              physics: ClampingScrollPhysics(),
              itemCount: assetGroupList.length,
              itemBuilder: (context, groupIndex) {
                double isTab() {
                  if (isTablet) {
                    return expandedGroupState[groupIndex] ? 340 : 114;
                  } else {
                    return expandedGroupState[groupIndex] ? 280 : 90;
                  }
                }

                return Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => toggleGroupExpansion(groupIndex),
                      child: FadeInRight(
                        delay: Duration(milliseconds: groupIndex * 100),
                        child: AnimatedContainer(
                          padding: const EdgeInsets.all(12.0),
                          height: isTab(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assetGroupList[groupIndex]
                                                .assetGroupName
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: "Mulish",
                                              fontWeight: FontWeight.bold,
                                              color: Palette.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${assetGroupList[groupIndex].assetGroupCode.toString()}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () =>
                                          toggleGroupExpansion(groupIndex),
                                      child: Icon(
                                        expandedGroupState[groupIndex]
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_right,
                                        size: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (expandedGroupState[groupIndex])
                                Expanded(
                                  flex: 2,
                                  child: FutureBuilder(
                                    future: ref
                                        .watch(apiServiceProvider)
                                        .getListOfEquipment(
                                            assetGroupId:
                                                assetGroupList[groupIndex]
                                                    .assetGroupId
                                                    .toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                snapshot.error.toString()));
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SingleChildScrollView(
                                          child: Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: ShimmerLists(
                                                count: 5,
                                                width: double.infinity,
                                                height: 80),
                                          )),
                                        );
                                      }

                                      if (snapshot.data == null ||
                                          snapshot.data!.assetLists == null ||
                                          snapshot.data!.assetLists!.isEmpty) {
                                        return Center(
                                          child: NoDataScreen(isHeight: true),
                                        );
                                      }

                                      // Apply search filter to the asset list
                                      List<AssetLists> assetList =
                                          snapshot.data!.assetLists!;
                                      if (searchController.text.isNotEmpty) {
                                        assetList = assetList
                                            .where((asset) =>
                                                asset.assetCode != null &&
                                                asset.assetCode!
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()))
                                            .toList();
                                      }

                                      // Initialize the expanded state list for each asset group
                                      if (expandedAssetState[groupIndex] ==
                                              null ||
                                          expandedAssetState[groupIndex]!
                                                  .length !=
                                              assetList.length) {
                                        expandedAssetState[groupIndex] =
                                            List.filled(
                                                assetList.length, false);
                                      }
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: assetList.length,
                                        padding: EdgeInsets.all(12),
                                        itemBuilder: (context, assetIndex) {
                                          double isTab() {
                                            if (isTablet) {
                                              return expandedAssetState[
                                                      groupIndex]![assetIndex]
                                                  ? 460
                                                  : 125;
                                            } else {
                                              return expandedAssetState[
                                                      groupIndex]![assetIndex]
                                                  ? 340
                                                  : 110;
                                            }
                                          }

                                          return Column(
                                            children: [
                                              AnimatedContainer(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                height: isTab(),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: InkWell(
                                                  splashFactory:
                                                      NoSplash.splashFactory,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  onTap: () =>
                                                      toggleAssetExpansion(
                                                          groupIndex,
                                                          assetIndex),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Image
                                                                        .network(
                                                                      assetList[assetIndex]
                                                                              .assetImageUrl ??
                                                                          'default_image_url.png', // Replace with a default image URL if necessary
                                                                      width: 70,
                                                                      height:
                                                                          70,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image.asset(
                                                                            'images/machine.jpeg',
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                70); // Fallback image in case of error
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            12),
                                                                    Expanded(
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              assetList[assetIndex].assetName.toString(),
                                                                              style: TextStyle(
                                                                                fontFamily: "Mulish",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(30, 152, 165, 1),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 6),
                                                                            Text(assetList[assetIndex].assetCode.toString()),
                                                                            const SizedBox(height: 6),
                                                                            Text(
                                                                              "${assetList[assetIndex].location}",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                onTap: () =>
                                                                    toggleAssetExpansion(
                                                                        groupIndex,
                                                                        assetIndex),
                                                                child: Icon(
                                                                  expandedAssetState[
                                                                              groupIndex]![
                                                                          assetIndex]
                                                                      ? Icons
                                                                          .arrow_drop_down
                                                                      : Icons
                                                                          .arrow_right,
                                                                  size: 35,
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                      // Expanded(
                                                      //   child: Row(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .center,
                                                      //     children: [
                                                      //       Image.network(
                                                      //         assetList[assetIndex]
                                                      //                 .assetImageUrl ??
                                                      //             'default_image_url.png', // Replace with a default image URL if necessary
                                                      //         width: 70,
                                                      //         height: 70,
                                                      //         errorBuilder:
                                                      //             (context,
                                                      //                 error,
                                                      //                 stackTrace) {
                                                      //           return Image.asset(
                                                      //               'images/machine.jpeg',
                                                      //               width: 70,
                                                      //               height:
                                                      //                   70); // Fallback image in case of error
                                                      //         },
                                                      //       ),
                                                      //       const SizedBox(
                                                      //           width: 10),
                                                      //       Expanded(
                                                      //         child: Column(
                                                      //           crossAxisAlignment:
                                                      //               CrossAxisAlignment
                                                      //                   .start,
                                                      //           children: [
                                                      // Text(
                                                      //   assetList[
                                                      //           assetIndex]
                                                      //       .assetName
                                                      //       .toString(),
                                                      //   style:
                                                      //       TextStyle(fontFamily: "Mulish",
                                                      //     fontWeight:
                                                      //         FontWeight
                                                      //             .bold,
                                                      //     color: Theme.of(
                                                      //             context)
                                                      //         .colorScheme
                                                      //         .onPrimary,
                                                      //   ),
                                                      // ),
                                                      // const SizedBox(
                                                      //     height:
                                                      //         5),
                                                      // Text(assetList[
                                                      //         assetIndex]
                                                      //     .assetCode
                                                      //     .toString()),
                                                      // const SizedBox(
                                                      //     height:
                                                      //         5),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     assetList[
                                                      //             assetIndex]
                                                      //         .location
                                                      //         .toString(),
                                                      //     overflow:
                                                      //         TextOverflow
                                                      //             .ellipsis,
                                                      //   ),
                                                      // ),
                                                      //           ],
                                                      //         ),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      // InkWell(
                                                      //   borderRadius:
                                                      //       BorderRadius
                                                      //           .circular(12),
                                                      //   onTap: () =>
                                                      //       toggleAssetExpansion(
                                                      //           groupIndex,
                                                      //           assetIndex),
                                                      //   child: Icon(
                                                      //     expandedAssetState[
                                                      //                 groupIndex]![
                                                      //             assetIndex]
                                                      //         ? Icons
                                                      //             .arrow_drop_down
                                                      //         : Icons
                                                      //             .arrow_right,
                                                      //     size: 35,
                                                      //   ),
                                                      // ),
                                                      if (expandedAssetState[
                                                              groupIndex]![
                                                          assetIndex])
                                                        Column(
                                                          children: [
                                                            Row(children: [
                                                              // Image Icon - Open asset_image_url
                                                              IconButton(
                                                                onPressed: () {
                                                                  String
                                                                      imageUrl =
                                                                      assetList[
                                                                              assetIndex]
                                                                          .assetImageUrl
                                                                          .toString();
                                                                  _showImageDialog(
                                                                      context,
                                                                      imageUrl);
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .image_outlined),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5.0),

                                                              // Video Icon - Open asset_video_url
                                                              IconButton(
                                                                onPressed: () {
                                                                  String
                                                                      videoUrl =
                                                                      assetList[
                                                                              assetIndex]
                                                                          .assetVideoUrl
                                                                          .toString();
                                                                  _showVideoDialog(
                                                                      context,
                                                                      videoUrl);
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .video_camera_back_outlined),
                                                              ),

                                                              const SizedBox(
                                                                  width: 5.0),

                                                              IconButton(
                                                                onPressed: () {
                                                                  // Handle document icon action here if needed
                                                                  String
                                                                      documentUrl =
                                                                      assetList[
                                                                              assetIndex]
                                                                          .assetManualUrl
                                                                          .toString();
                                                                  // logger.w(
                                                                  //     documentUrl);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              PdfViewerScreen(pdfUrl: documentUrl)));
                                                                  // _openDocument(
                                                                  //     documentUrl);
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .document_scanner_outlined),
                                                              ),

                                                              const SizedBox(
                                                                  width: 5.0),
                                                            ]),
                                                            _expandedListItem(
                                                                title:
                                                                    'Asset Group',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .assetGroup
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Asset Code',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .assetCode
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Department',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .department
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Location',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .location
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Manufacturer',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .assetManufacturer
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Vendor Name',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .assetVendorName
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 5),
                                                            _expandedListItem(
                                                                title:
                                                                    'Vendor Contact',
                                                                value: assetList[
                                                                        assetIndex]
                                                                    .assetVendorContact
                                                                    .toString()),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12)
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _expandedListItem({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${title}",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(30, 152, 165, 1),
                ),
              ),
              Text(
                ":",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(30, 152, 165, 1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            maxLines: 5,
          ),
        ),
      ],
    );
  }

// Function to show the image in a dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Asset Image'),
          content: SizedBox(
            width: double.maxFinite,
            child: Image.network(
                imageUrl), // Use Image.asset if loading from local assets
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Function to show the video in a dialog
  void _showVideoDialog(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Set a fixed height for the video player
            child: VideoPlayerScreen(videoUrl: videoUrl),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to open a document
  // void _openDocument(String documentUrl) async {
  //   final result = await OpenFile.open(documentUrl);
  //   if (result.message != "Launched") {
  //     // Handle any error here, e.g., show a snackbar
  //     print('Error opening document: ${result.message}');
  //   }
  // }
}
