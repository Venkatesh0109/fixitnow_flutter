// import 'package:auscurator/api_service/api_service.dart';
// import 'package:auscurator/components/no_data_animation.dart';
// import 'package:auscurator/machine_iot/screens/MainCategoryDialog.dart';
// import 'package:auscurator/machine_iot/screens/SubCategoryDialog.dart';
// import 'package:auscurator/machine_iot/screens/TicketAcceptScreen.dart';
// import 'package:auscurator/machine_iot/screens/TicketDetailsScreen.dart';
// import 'package:auscurator/machine_iot/screens/custom_search_dialog.dart';
// import 'package:auscurator/machine_iot/screens/ticket_checkin_screen.dart';
// import 'package:auscurator/machine_iot/screens/ticket_compeleted_screen.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/elevated_button_widget.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/event/save_button_event.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/state/save_button_state.dart';
// import 'package:auscurator/machine_iot/util.dart';
// import 'package:auscurator/machine_iot/widget/qr_scanner_widget.dart';
// import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
// import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
// import 'package:auscurator/main.dart';
// import 'package:auscurator/model/BreakdownTicketModel.dart';
// import 'package:auscurator/model/MainCategoryModel.dart';
// import 'package:auscurator/model/SubCategoryModel.dart';
// import 'package:auscurator/provider/all_provider.dart';
// import 'package:auscurator/repository/asset_repository.dart';
// import 'package:auscurator/repository/breakdown_repository.dart';
// import 'package:auscurator/repository/ticket_repository.dart';
// import 'package:auscurator/screens/breakdown/widgets/date_time_picker.dart';
// import 'package:auscurator/screens/breakdown/widgets/segmented_priority.dart';
// import 'package:auscurator/util/shared_util.dart';
// import 'package:auscurator/util/util.dart';
// import 'package:auscurator/widgets/context_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BreakDownScreen extends ConsumerStatefulWidget {
//   const BreakDownScreen({super.key});

//   @override
//   ConsumerState createState() {
//     return _MyHomePageState();
//   }
// }

// String selectedPriority = 'Low';
// String selectedStatus = '1';

// class _MyHomePageState extends ConsumerState {
//   TextEditingController searchController = TextEditingController();

//   List<String> statusList = [
//     'Open',
//     'Assigned',
//     'Accepted',
//     'On Progress',
//     'Pending',
//     // 'Await RCA',
//     'Acknowledge',
//     'Closed'
//   ];
//   // Corresponding API keys for counts
//   List<String> apiKeys = [
//     'Open',
//     'Assigned',
//     'Accepted',
//     'On_Progress',
//     'Hold_Pending',
//     // 'rca',
//     'Acknowledge',
//     'Closed'
//   ];
//   List<int> counts = List.filled(7, 0);

//   int selectedIndex = 0;

//   List<BreakdownDetailList> assetList = [];
//   List<BreakdownDetailList> sortedList = [];
//   List<BreakdownListCount> countList = [];
//   String dropdownValue = 'Ascending';
//   String selectedSortOption = 'Date and Time'; // Default sorting option
//   DateTime? _fromDate;
//   DateTime? _toDate;
//   Future<BreakkdownTicketModel>? companyFuture;
//   bool _isFirstLoad = true;
//   final employee_type = SharedUtil().getEmployeeType;
//   final employee_name = SharedUtil().getEmployeeName;
//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData(
//             useMaterial3: true,
//             colorScheme: ColorScheme.light(
//               primary: const Color.fromRGBO(
//                   21, 147, 159, 1), // Header background color
//               onPrimary: Colors.white, // Header text and selected text color
//               onSurface: Colors.black, // Default text color
//             ),
//             textTheme: TextTheme(
//               titleMedium: TextStyle(
//                 fontFamily: "Mulish",
//                 fontWeight: FontWeight.w500,
//                 fontStyle: FontStyle.normal,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != (isFromDate ? _fromDate : _toDate)) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//       });
//       _fetchTicketCounts();
//     }
//   }

//   void handleRowTap(String rowType) {
//     // Handle the row tap based on rowType
//     print('Tapped on $rowType');
//   }

//   void _showSortBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter bottomSheetSetState) {
//             return Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           children: [
//                             const Text(
//                               'Sort By',
//                               style: TextStyle(
//                                   fontFamily: "Mulish",
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 20,
//                                   color: Color.fromRGBO(21, 147, 159, 1)),
//                             ),
//                             const Spacer(),
//                             DropdownButton<String>(
//                               value: dropdownValue,
//                               onChanged: (String? newValue) {
//                                 bottomSheetSetState(() {
//                                   dropdownValue = newValue!;
//                                 });
//                               },
//                               items: [
//                                 'Ascending',
//                                 'Descending'
//                               ].map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         _buildSortOption('Date and Time',
//                             Icons.calendar_month_outlined, bottomSheetSetState),
//                         const SizedBox(height: 10),
//                         _buildSortOption('Ticket Number', Icons.airplane_ticket,
//                             bottomSheetSetState),
//                         const SizedBox(height: 10),
//                         _buildSortOption('Status',
//                             Icons.filter_tilt_shift_sharp, bottomSheetSetState),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             print(dropdownValue);
//                             print(selectedSortOption);
//                             _sortAssetList(bottomSheetSetState);
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromRGBO(21, 147, 159, 1),
//                           ),
//                           child: const Text(
//                             'Submit',
//                             style: TextStyle(
//                               fontFamily: "Mulish",
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildSortOption(
//       String label, IconData icon, StateSetter bottomSheetSetState) {
//     return GestureDetector(
//       onTap: () {
//         selectedSortOption = label;
//         bottomSheetSetState(() {});
//         setState(() {}); // Trigger a rebuild of the parent widget if needed
//       },
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: selectedSortOption == label
//                 ? const Color(0xFF018786)
//                 : Colors.black,
//           ),
//           const SizedBox(width: 10),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: "Mulish",
//               color: selectedSortOption == label
//                   ? const Color(0xFF018786)
//                   : Colors.black,
//               fontWeight: selectedSortOption == label
//                   ? FontWeight.bold
//                   : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sortAssetList(StateSetter bottomSheetSetState) {
//     setState(() {
//       // Sort the assetList in place based on selectedSortOption and dropdownValue
//       if (selectedSortOption == 'Ticket Number') {
//         assetList.sort((a, b) {
//           int comparison = a.ticketNo!.compareTo(b.ticketNo!);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       } else if (selectedSortOption == 'Date and Time') {
//         assetList.sort((a, b) {
//           DateTime dateA = DateTime.parse(a.createdOn!);
//           DateTime dateB = DateTime.parse(b.createdOn!);
//           int comparison = dateA.compareTo(dateB);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       } else if (selectedSortOption == 'Status') {
//         assetList.sort((a, b) {
//           int comparison = a.status!.compareTo(b.status!);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       }
//       bottomSheetSetState(() {});
//     });
//   }

//   void _showCreateTicketModal(BuildContext context) {
//     // String selectedText = '';
//     String selectedAssetId = '';
//     String selectedAssetGroupId = '';
//     String selectedMainCategoryId = '';
//     String selectedSubCategoryId = '';
//     TextEditingController textController = TextEditingController();
//     TextEditingController textCategoryController = TextEditingController();
//     TextEditingController textSubCategoryController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(10.0), // Adjust padding inside content
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Adjust height dynamically
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 10.0),
//                   const Text(
//                     'Create Ticket',
//                     style: TextStyle(
//                         fontFamily: "Mulish",
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromRGBO(21, 147, 159, 1)),
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextField(
//                     controller: textController,
//                     readOnly: true,
//                     onTap: () async {
//                       // Show the CustomSearchDialog and get the selected asset
//                       final AssetLists? result = await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return CustomSearchDialog();
//                         },
//                       );
//                       // Check if a result was returned
//                       if (result != null) {
//                         setState(() {
//                           // Update the text field with the assetCode, but you can also use asset_id and asset_group_id
//                           textController.text =
//                               result.assetCode ?? 'Unknown Asset';
//                           selectedAssetId = result.assetId.toString();
//                           selectedAssetGroupId = result.assetGroupId.toString();
//                           // You can store or use asset_id and asset_group_id here
//                           print(
//                               'Asset ID: ${result.assetId}, Asset Group ID: ${result.assetGroupId}');
//                         });
//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.setString(
//                             'asset_group_id', result.assetGroupId.toString());
//                       }
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'Select or Scan Equipment ID',
//                       labelStyle: TextStyle(
//                         fontFamily: "Mulish",
//                       ),
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                       suffixIcon: IconButton(
//                         onPressed: () async {
//                           // Navigate to the QR scanner and wait for the result
//                           final scannedValue = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const QRScannerWidget(),
//                             ),
//                           );
//                           Map<String, dynamic> matchingAsset = {};
//                           // Check if a scanned value was returned
//                           if (scannedValue != null) {
//                             matchingAsset =
//                                 ticketProvider.listEquipmentData?.firstWhere(
//                               (asset) => asset["asset_code"] == scannedValue,
//                               orElse: () => null,
//                             );

//                             textController.text = scannedValue;
//                             selectedAssetId =
//                                 matchingAsset["asset_id"].toString();

//                             selectedAssetGroupId =
//                                 matchingAsset["asset_group_id"].toString();
//                             SharedPreferences prefs =
//                                 await SharedPreferences.getInstance();
//                             prefs.setString('asset_group_id',
//                                 "${matchingAsset["asset_group_id"]}");

//                             setState(() {});
//                           }
//                         },
//                         icon: const Icon(Icons.qr_code_scanner_outlined),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                         child: Text(
//                           'Date and Time',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(21, 147, 159, 1)),
//                         ),
//                       )),
//                   const SizedBox(height: 10.0),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       DatePicker(),
//                       SizedBox(width: 10.0),
//                       TimePicker(),
//                     ],
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                         child: Text(
//                           'Breadown Category',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(21, 147, 159, 1)),
//                         ),
//                       )),
//                   const SizedBox(height: 10.0),
//                   TextField(
//                     controller: textCategoryController,
//                     readOnly: true,
//                     onTap: () async {
//                       // Show the CustomSearchDialog and get the selected asset
//                       final MainBreakdownCategoryLists? result =
//                           await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return MainCategoryDialog();
//                         },
//                       );
//                       if (result != null) {
//                         setState(() {
//                           textCategoryController.text =
//                               result.breakdownCategoryName.toString();
//                           selectedMainCategoryId =
//                               result.breakdownCategoryId.toString();
//                         });
//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.setString('breakdown_category_id',
//                             result.breakdownCategoryId.toString());
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       labelText: 'Select Breakdown Category',
//                       labelStyle: TextStyle(
//                         fontFamily: "Mulish",
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                         child: Text(
//                           'Breadown',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(21, 147, 159, 1)),
//                         ),
//                       )),
//                   const SizedBox(height: 10.0),
//                   TextField(
//                     controller: textSubCategoryController,
//                     readOnly: true,
//                     onTap: () async {
//                       final BreakdownCategoryLists? result = await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SubCategoryDialog();
//                         },
//                       );
//                       if (result != null) {
//                         setState(() {
//                           textSubCategoryController.text =
//                               result.breakdownSubCategory.toString();
//                           selectedSubCategoryId =
//                               result.breakdownSubCategoryId.toString();
//                         });
//                         print(
//                             'Breakdown SubCategory ID: ${result.breakdownCategoryId}');
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       labelText: 'Select Breakdown',
//                       labelStyle: TextStyle(
//                         fontFamily: "Mulish",
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                         child: Text(
//                           'Machine Status',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(21, 147, 159, 1)),
//                         ),
//                       )),
//                   const SizedBox(height: 10.0),
//                   SegmentedControlStatus(
//                     onStatusChanged: (String status) {
//                       setState(() {
//                         selectedStatus = status; // Update the selected priority
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                         child: Text(
//                           'Priority',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(21, 147, 159, 1)),
//                         ),
//                       )),
//                   const SizedBox(height: 10.0),
//                   SegmentedControlPriority(
//                     onPriorityChanged: (String priority) {
//                       setState(() {
//                         selectedPriority =
//                             priority; // Update the selected priority
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10.0),
//                   Row(
//                     children: [
//                       BlocConsumer<SaveButtonBloc, SaveButtonState>(
//                         builder: (context, state) {
//                           return ElevatedButtonWidget(
//                             flex: 1,
//                             label: state is SaveButtonLoadingState
//                                 ? 'Loading...!'
//                                 : 'Submit',
//                             onTab: () {
//                               if (selectedAssetGroupId.isNotEmpty ||
//                                   selectedAssetId.isNotEmpty ||
//                                   selectedMainCategoryId.isNotEmpty ||
//                                   selectedSubCategoryId.isNotEmpty ||
//                                   selectedStatus.isNotEmpty ||
//                                   selectedPriority.isNotEmpty) {
//                                 BlocProvider.of<SaveButtonBloc>(context).add(
//                                   SaveButtonOnClickEvent(
//                                       assetGroupId: selectedAssetGroupId,
//                                       assetId: selectedAssetId,
//                                       breakdownCategoryId:
//                                           selectedMainCategoryId,
//                                       breakdownsubCategoryId:
//                                           selectedSubCategoryId,
//                                       assetStatus: selectedStatus,
//                                       priorityId: selectedPriority,
//                                       userLoginId: '',
//                                       comment: ''),
//                                 );
//                                 _fetchTicketCounts();
//                               } else {
//                                 showMessage(
//                                     context: context,
//                                     isError: true,
//                                     responseMessage:
//                                         'Kindly Select Mandatory Fields');
//                               }
//                             },
//                           );
//                         },
//                         listener: (context, state) {
//                           if (state is SaveButtonErrorState) {
//                             print(state.errorMessage.toString());
//                             Util.showToastMessage(
//                                 10, context, state.errorMessage, true);
//                           }
//                           if (state is SaveButtonSuccessState) {
//                             Util.showToastMessage(
//                                 10, context, state.message, false);
//                             Navigator.of(context).pop();
//                           }
//                         },
//                       ),
//                       const Gap(10),
//                       ElevatedButtonWidget(
//                         flex: 1,
//                         label: 'Cancel',
//                         onTab: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((time) {
//       TicketRepository().getAssetEquipmentList(context);
//       BreakdownRepository().getListOfBreadownSub(context);
//       BreakdownRepository().getListOfIssue(context);
//       AssetRepository().getListOfEquipment(context, assetGroupId: "");
//     });
//     checkConnection(context);
//     searchController.addListener(() {
//       filterItems();
//     });
//     // Set default dates: 'from' is one month before today, 'to' is today
//     _fromDate = DateTime.now().subtract(const Duration(days: 30));
//     _toDate = DateTime.now();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (_isFirstLoad) {
//       // Fetch the ticket counts after dependencies are loaded
//       _fetchTicketCounts();
//       _isFirstLoad = false; // Ensure this is only called once
//     }
//   }

//   void filterItems() {
//     setState(() {}); // Trigger a rebuild to filter in the UI
//   }

//   // Function to fetch ticket counts
//   Future<void> _fetchTicketCounts() async {
//     try {
//       final response =
//           await ref.watch(apiServiceProvider).getBreakDownStatusList(
//                 breakdown_status: apiKeys[selectedIndex].toLowerCase(),
//                 period: 'from_to',
//                 from_date: DateFormat('dd-MM-yyyy').format(_fromDate!),
//                 to_date: DateFormat('dd-MM-yyyy').format(_toDate!),
//                 user_login_id: '',
//               );

//       if (response.breakdownListCount != null &&
//           response.breakdownListCount!.isNotEmpty) {
//         var countData = response.breakdownListCount![0];
//         assetList = response.breakdownDetailList!;
//         // Update counts in the state
//         setState(() {
//           counts[0] = countData.open!.toInt();
//           counts[1] = countData.assigned!;
//           counts[2] = countData.accepted!;
//           counts[3] = countData.onProgress!;
//           counts[4] = countData.holdPending!;
//           counts[5] = countData.acknowledge!;
//           counts[6] = countData.closed!;
//           // counts[5] = countData.rca!;
//           // counts[6] = countData.acknowledge!;
//           // counts[7] = countData.closed!;
//         });
//       }

//       setState(() {
//         companyFuture = Future.value(response); // Assign response to Future
//       });
//     } catch (e) {
//       // Handle error
//       print("Error fetching data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var width = MediaQuery.of(context).size.width;
//     // var height = MediaQuery.of(context).size.height;
//     // String dropdownValue = 'Ascending';

//     final companyFuture = ref.watch(apiServiceProvider).getBreakDownStatusList(
//           breakdown_status: apiKeys[selectedIndex].toLowerCase(),
//           period: 'from_to',
//           from_date: _fromDate != null
//               ? DateFormat('dd-MM-yyyy').format(_fromDate!)
//               : '', // Default or selected date
//           to_date: _toDate != null
//               ? DateFormat('dd-MM-yyyy').format(_toDate!)
//               : '', // Default or selected date
//           user_login_id: '',
//         );

//     print(statusList[selectedIndex]);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Breakdown',
//             style: TextStyle(
//               fontFamily: "Mulish",
//               color: Colors.white,
//             )),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.filter_alt_outlined),
//           color: Colors.white,
//           onPressed: () => _showSortBottomSheet(context),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.add),
//             color: Colors.white,
//             onPressed: () => _showCreateTicketModal(context),
//           ),
//         ],
//       ),
//       backgroundColor: const Color.fromARGB(240, 255, 255, 255),
//       body: ListView(
//         physics: NeverScrollableScrollPhysics(),
//         children: <Widget>[
//           const SizedBox(height: 5.0),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Tickets',
//                 labelStyle: TextStyle(
//                   fontFamily: "Mulish",
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//             ),
//           ),
//           // From/To Date Picker
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: () => _selectDate(context, true),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             spreadRadius: 2,
//                             offset: Offset(2, 4),
//                           ),
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.05),
//                             blurRadius: 16,
//                             spreadRadius: -1,
//                             offset: Offset(-2, -2),
//                           ),
//                         ]),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_today,
//                           size: 25.0, // Adjust the size here
//                           color: Color(0xFF018786),
//                         ),
//                         // Gap(3),
//                         // Text(
//                         //   "From:",
//                         //   style: TextStyle(fontFamily: "Mulish",
//                         //     fontSize: 16,
//                         //   ),
//                         // ),
//                         SizedBox(width: 12),
//                         Text(
//                           _fromDate != null
//                               ? DateFormat('dd-MM-yyyy').format(_fromDate!)
//                               : 'Select From Date',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => _selectDate(context, false),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             spreadRadius: 2,
//                             offset: Offset(2, 4),
//                           ),
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.05),
//                             blurRadius: 16,
//                             spreadRadius: -1,
//                             offset: Offset(-2, -2),
//                           ),
//                         ]),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_today,
//                           size: 25.0, // Adjust the size here
//                           color: Color(0xFF018786),
//                         ),
//                         // Gap(3),
//                         // Text(
//                         //   "To:",
//                         //   style: TextStyle(fontFamily: "Mulish",
//                         //     fontSize: 16,
//                         //   ),
//                         // ),
//                         SizedBox(width: 12),

//                         Text(
//                           _toDate != null
//                               ? DateFormat('dd-MM-yyyy').format(_toDate!)
//                               : 'Select To Date',
//                           style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12.0),
//           // Horizontal list
//           Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: SizedBox(
//               height: 50, // Set the height of the horizontal list
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: statusList.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 5.0, horizontal: 5.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: selectedIndex == index
//                             ? const Color.fromRGBO(
//                                 21, 147, 159, 1) // Selected button color
//                             : Colors.white, // Unselected button color
//                         foregroundColor: selectedIndex == index
//                             ? Colors.white // Text color for selected
//                             : Colors.black, // Text color for unselected
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         elevation:
//                             2, // Control the elevation for the shadow effect
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           selectedIndex = index;
//                         });
//                         _fetchTicketCounts();
//                       },
//                       child: Text(
//                         '${statusList[index]} (${counts[index]})',
//                         style: TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           // Vertical list
//           FutureBuilder(
//               future: companyFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text(snapshot.error.toString()));
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return SingleChildScrollView(
//                     child: const Center(
//                         child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: ShimmerLists(
//                         count: 10,
//                         width: double.infinity,
//                         height: 300,
//                         shapeBorder: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                       ),
//                     )),
//                   );
//                 }
//                 if (snapshot.data == null ||
//                     snapshot.data!.breakdownDetailList == null ||
//                     snapshot.data!.breakdownDetailList!.isEmpty) {
//                   return Center(child: NoDataScreen());
//                 }
//                 if (snapshot.data!.breakdownListCount != null &&
//                     snapshot.data!.breakdownListCount!.isNotEmpty) {
//                   // Get the first object from the breakdownListCount list
//                   var countData = snapshot.data!.breakdownListCount![0];
//                   // Map the counts directly from the properties of BreakdownListCount
//                   counts[0] = countData.open!.toInt();
//                   counts[1] = countData.assigned!;
//                   counts[2] = countData.accepted!;
//                   counts[3] = countData.onProgress!;
//                   counts[4] = countData.holdPending!;
//                   counts[5] = countData.acknowledge!;
//                   counts[6] = countData.closed!;
//                   // counts[5] = countData.rca!;
//                   // counts[6] = countData.acknowledge!;
//                   // counts[7] = countData.closed!;
//                 }
//                 TextEditingController textFieldController =
//                     TextEditingController();

//                 textFieldController.clear();

//                 assetList = snapshot.data!.breakdownDetailList!;

//                 if (searchController.text.isNotEmpty) {
//                   assetList = assetList
//                       .where((asset) =>
//                           asset.ticketNo != null &&
//                           asset.ticketNo!
//                               .toLowerCase()
//                               .contains(searchController.text.toLowerCase()))
//                       .toList();
//                 }
//                 bool isTablet = MediaQuery.of(context).size.width >
//                     600; // Threshold for tablets

//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     // You can trigger the refresh logic here, like re-fetching data
//                     await ref.read(apiServiceProvider).getBreakDownStatusList(
//                           breakdown_status:
//                               apiKeys[selectedIndex].toLowerCase(),
//                           period: 'from_to',
//                           from_date: _fromDate != null
//                               ? DateFormat('dd-MM-yyyy').format(_fromDate!)
//                               : '', // Default or selected date
//                           to_date: _toDate != null
//                               ? DateFormat('dd-MM-yyyy').format(_toDate!)
//                               : '', // Default or selected date
//                           user_login_id: '',
//                         );
//                     setState(
//                         () {}); // Refresh the widget to reflect the new data
//                   },
//                   child: SizedBox(
//                     height: isTablet
//                         ? context.heightFull() - 370
//                         : context.heightHalf() + 50,
//                     child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: assetList.length,
//                       itemBuilder: (context, index) {
//                         // logger.e(assetList[index].toJson());
//                         TextEditingController textFieldController =
//                             TextEditingController(
//                                 text: assetList[index].status == 'Open'
//                                     ? assetList[index].openComment.toString()
//                                     : assetList[index].status == 'Assign'
//                                         ? assetList[index]
//                                             .assignedComment
//                                             .toString()
//                                         : assetList[index].status == 'Accept'
//                                             ? assetList[index]
//                                                 .acceptComment
//                                                 .toString()
//                                             : assetList[index].status ==
//                                                     'Check In'
//                                                 ? assetList[index]
//                                                     .checkInComment
//                                                     .toString()
//                                                 : assetList[index].status ==
//                                                         'On Hold'
//                                                     ? assetList[index]
//                                                         .checkOutComment
//                                                         .toString()
//                                                     : assetList[index].status ==
//                                                             'Pending'
//                                                         ? assetList[index]
//                                                             .pendingComment
//                                                             .toString()
//                                                         : assetList[index]
//                                                                     .status ==
//                                                                 'Completed'
//                                                             ? assetList[index]
//                                                                 .completedComment
//                                                                 .toString()
//                                                             : assetList[index]
//                                                                         .status ==
//                                                                     'Fixed'
//                                                                 ? assetList[
//                                                                         index]
//                                                                     .completedComment
//                                                                     .toString()
//                                                                 : assetList[index]
//                                                                             .status ==
//                                                                         'Reject'
//                                                                     ? assetList[
//                                                                             index]
//                                                                         .rejectComment
//                                                                         .toString()
//                                                                     : assetList[index].status ==
//                                                                             'Reopen'
//                                                                         ? assetList[index]
//                                                                             .reopenComment
//                                                                             .toString()
//                                                                         : assetList[index].status ==
//                                                                                 'Reassign'
//                                                                             ? assetList[index].reassignComment.toString()
//                                                                             : 'empty');
//                         return Column(
//                           children: [
//                             index == 0
//                                 ? SizedBox(height: 12)
//                                 : SizedBox.shrink(),
//                             GestureDetector(
//                               onTap: () {
//                                 if (assetList[index].status == 'Open' ||
//                                     assetList[index].status == 'Reject' ||
//                                     assetList[index].status == 'Reopen') {
//                                   if (employee_type == "Super Admin" ||
//                                       employee_type == "Head" ||
//                                       employee_type == "Head/Engineer" ||
//                                       employee_type == "Department Head" ||
//                                       employee_type == " Plant Head" ||
//                                       employee_type == "BU Head") {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               TicketDetailsScreen(
//                                             ticketNumber:
//                                                 assetList[index].id.toString(),
//                                           ),
//                                         ));
//                                   } else {
//                                     showMessage(
//                                       context: context,
//                                       isError: true,
//                                       responseMessage:
//                                           "${employee_type} not allowed to Assign",
//                                     );
//                                   }
//                                 }

//                                 if (assetList[index].status == 'Assign') {
//                                   if (employee_type == "Super Admin" ||
//                                       employee_type == "Head/Engineer" ||
//                                       employee_type == "Engineer") {
//                                     if (employee_name ==
//                                         assetList[index].assignedToEngineer) {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 TicketAcceptScreen(
//                                               ticketNumber: assetList[index]
//                                                   .id
//                                                   .toString(),
//                                             ),
//                                           ));
//                                     } else if (assetList[index]
//                                             .assignedToEngineer ==
//                                         "") {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 TicketAcceptScreen(
//                                               ticketNumber: assetList[index]
//                                                   .id
//                                                   .toString(),
//                                             ),
//                                           ));
//                                     } else {
//                                       showMessage(
//                                         context: context,
//                                         isError: true,
//                                         responseMessage:
//                                             "This Ticket is not Assigned to you ${employee_name}",
//                                       );
//                                     }
//                                   } else {
//                                     showMessage(
//                                       context: context,
//                                       isError: true,
//                                       responseMessage:
//                                           "${employee_type} not allowed to Accept",
//                                     );
//                                   }
//                                 }
//                                 if (assetList[index].status == 'Pending' ||
//                                     assetList[index].status == 'Check In' ||
//                                     assetList[index].status == 'On Hold' ||
//                                     assetList[index].status == 'Accept') {
//                                   if (employee_type == "Super Admin" ||
//                                       employee_type == "Head/Engineer" ||
//                                       employee_type == "Engineer") {
//                                     if (employee_name ==
//                                         assetList[index].assignedToEngineer) {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => TicketCheckIn(
//                                               ticketNumber: assetList[index]
//                                                   .id
//                                                   .toString(),
//                                             ),
//                                           ));
//                                     } else {
//                                       showMessage(
//                                         context: context,
//                                         isError: true,
//                                         responseMessage:
//                                             "This Ticket is not Assigned to you ${employee_name}",
//                                       );
//                                     }
//                                   } else {
//                                     showMessage(
//                                       context: context,
//                                       isError: true,
//                                       responseMessage:
//                                           "${employee_type} not allowed to Check In or Check Out",
//                                     );
//                                   }
//                                 }
//                                 if (assetList[index].status == 'Completed' ||
//                                     assetList[index].status == 'Fixed' ||
//                                     assetList[index].status == 'Awaiting RCA') {
//                                   if (employee_type == "Super Admin" ||
//                                       employee_type == "Head" ||
//                                       employee_type == "Head/Engineer" ||
//                                       employee_type == "Department Head" ||
//                                       employee_type == " Plant Head" ||
//                                       employee_type == "BU Head") {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               TicketCompletedScreen(
//                                             ticketNumber:
//                                                 assetList[index].id.toString(),
//                                           ),
//                                         ));
//                                   } else {
//                                     showMessage(
//                                       context: context,
//                                       isError: true,
//                                       responseMessage: "${employee_type} ",
//                                     );
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                       left: BorderSide(
//                                         width: 5.0,
//                                         color: () {
//                                           switch (assetList[index].status) {
//                                             case "Open":
//                                               return Color(0xFF17a2b8);
//                                             case "Assign":
//                                             case "Reassign":
//                                               return Color(0xFF7a7a00);
//                                             case "Accept":
//                                               return Color(0xFF64a300);
//                                             case "Pending":
//                                               return Color(0xFFc30000);
//                                             case "Fixed":
//                                               return Color(0xFF008000);
//                                             case "Completed":
//                                               return Color(0xFF0039a1);
//                                             case "Reject":
//                                               return Color(0xFFb53101);
//                                             case "Reopen":
//                                               return Color(0xFF17a2b8);
//                                             case "Check In":
//                                               return Color(0xFF0072ff);
//                                             case "On Hold":
//                                               return Color(0xFFbb5600);
//                                             default:
//                                               return Colors.grey;
//                                           }
//                                         }(),
//                                       ),
//                                     ),
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         blurRadius: 12,
//                                         spreadRadius: 2,
//                                         offset: Offset(0, 8),
//                                       )
//                                     ]),
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           '${assetList[index].ticketNo}',
//                                           style: TextStyle(
//                                             fontFamily: "Mulish",
//                                             fontWeight: FontWeight.bold,
//                                             color: () {
//                                               switch (assetList[index].status) {
//                                                 case "Open":
//                                                   return Color(0xFF17a2b8);
//                                                 case "Assign":
//                                                 case "Reassign":
//                                                   return Color(0xFF7a7a00);
//                                                 case "Accept":
//                                                   return Color(0xFF64a300);
//                                                 case "Pending":
//                                                   return Color(0xFFc30000);
//                                                 case "Fixed":
//                                                   return Color(0xFF008000);
//                                                 case "Completed":
//                                                   return Color(0xFF0039a1);
//                                                 case "Reject":
//                                                   return Color(0xFFb53101);
//                                                 case "Reopen":
//                                                   return Color(0xFF17a2b8);
//                                                 case "Check In":
//                                                   return Color(0xFF0072ff);
//                                                 case "On Hold":
//                                                   return Color(0xFFbb5600);
//                                                 default:
//                                                   return Colors.grey;
//                                               }
//                                             }(),
//                                           ),
//                                         ),
//                                         // TicketInfoCardWidget(
//                                         //     title: '',
//                                         //     value:
//                                         //         '${assetList[index].ticketNo}'),
//                                         const Spacer(),
//                                         Text(
//                                           '${assetList[index].status} | ',
//                                           style: TextStyle(
//                                               fontFamily: "Mulish",
//                                               color: Colors.red,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         const SizedBox(width: 2),
//                                         Text('${assetList[index].priority}',
//                                             style: const TextStyle(
//                                                 fontFamily: "Mulish",
//                                                 color: Colors.blue,
//                                                 fontWeight: FontWeight.w500))
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Category',
//                                         value:
//                                             '${assetList[index].breakdownCategoryName}'),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Issue',
//                                         value:
//                                             '${assetList[index].breakdownSubCategoryName}'),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Asset',
//                                         value: '${assetList[index].asset}'),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Location',
//                                         value:
//                                             '${assetList[index].locationName}'),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Raised By',
//                                         value: '${assetList[index].createdBy}'),
//                                     const SizedBox(height: 8),
//                                     TicketInfoCardWidget(
//                                         title: 'Date and Time',
//                                         value: assetList[index].createdOn !=
//                                                 null
//                                             ? DateFormat('yyyy-MM-dd HH:mm')
//                                                 .format(DateTime.parse(
//                                                         assetList[index]
//                                                             .createdOn
//                                                             .toString())
//                                                     .toLocal())
//                                             : 'N/A' // If createdOn is null, show 'N/A'
//                                         ),
//                                     const SizedBox(height: 8),
//                                     if (assetList[index].status == "Reject")
//                                       TicketInfoCardWidget(
//                                           title: 'Rejected By',
//                                           value:
//                                               '${assetList[index].rejectedBy}'),
//                                     const SizedBox(height: 8),
//                                     if (assetList[index].status != "Open")
//                                       TicketInfoCardWidget(
//                                           title: 'Assigned To',
//                                           value:
//                                               '${assetList[index].assignedToEngineer}'),
//                                     const Divider(),
//                                     Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           IconButton(
//                                             onPressed: () {
//                                               print(assetList[index]
//                                                   .id
//                                                   .toString());
//                                               showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   final ticketdetails = ref
//                                                       .watch(apiServiceProvider)
//                                                       .getBreakDownDetailList(
//                                                           ticket_no:
//                                                               assetList[index]
//                                                                   .id
//                                                                   .toString());

//                                                   return AlertDialog(
//                                                     title: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         const Text(
//                                                           'Remarks',
//                                                           style: TextStyle(
//                                                               fontFamily:
//                                                                   "Mulish",
//                                                               fontSize: 16,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                         ),
//                                                         if (assetList[index]
//                                                                 .status ==
//                                                             'Fixed')
//                                                           InkWell(
//                                                               onTap: () =>
//                                                                   Navigator.pop(
//                                                                       context),
//                                                               child: Icon(
//                                                                   Icons.close)),
//                                                       ],
//                                                     ),
//                                                     backgroundColor:
//                                                         Colors.white,
//                                                     content: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         FutureBuilder(
//                                                             future:
//                                                                 ticketdetails,
//                                                             builder: (context,
//                                                                 snapshot) {
//                                                               if (snapshot
//                                                                   .hasError) {
//                                                                 return Center(
//                                                                     child: Text(
//                                                                         snapshot
//                                                                             .error
//                                                                             .toString()));
//                                                               }

//                                                               if (snapshot
//                                                                       .connectionState ==
//                                                                   ConnectionState
//                                                                       .waiting) {
//                                                                 return const Center(
//                                                                     child:
//                                                                         CircularProgressIndicator());
//                                                               }

//                                                               if (snapshot.data == null ||
//                                                                   snapshot.data!
//                                                                           .breakdownDetailList ==
//                                                                       null ||
//                                                                   snapshot
//                                                                       .data!
//                                                                       .breakdownDetailList!
//                                                                       .isEmpty) {
//                                                                 return const Center(
//                                                                     child: Text(
//                                                                         "No data available"));
//                                                               }
//                                                               return TextField(
//                                                                 controller:
//                                                                     textFieldController,
//                                                                 decoration:
//                                                                     InputDecoration(
//                                                                   labelText:
//                                                                       'Enter Reason',
//                                                                   labelStyle: TextStyle(
//                                                                       fontFamily:
//                                                                           "Mulish",
//                                                                       color: Colors
//                                                                           .black),
//                                                                   border:
//                                                                       const OutlineInputBorder(
//                                                                     borderRadius:
//                                                                         BorderRadius.all(
//                                                                             Radius.circular(15.0)),
//                                                                   ),
//                                                                   enabledBorder:
//                                                                       OutlineInputBorder(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             15),
//                                                                     borderSide:
//                                                                         const BorderSide(
//                                                                             color:
//                                                                                 Colors.black),
//                                                                   ),
//                                                                   focusedBorder:
//                                                                       OutlineInputBorder(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             15),
//                                                                     borderSide:
//                                                                         const BorderSide(
//                                                                             color:
//                                                                                 Colors.black),
//                                                                   ),
//                                                                 ),
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         "Mulish",
//                                                                     color: Colors
//                                                                         .black),
//                                                               );
//                                                             }),
//                                                       ],
//                                                     ),
//                                                     actions: assetList[index]
//                                                                 .status ==
//                                                             'Fixed'
//                                                         ? []
//                                                         : [
//                                                             TextButton(
//                                                               onPressed: () {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                               child: const Text(
//                                                                 'Cancel',
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         "Mulish",
//                                                                     color: Colors
//                                                                         .black),
//                                                               ),
//                                                             ),
//                                                             ElevatedButton(
//                                                               onPressed: () {
//                                                                 ApiService()
//                                                                     .TicketAccept(
//                                                                         ticketNo: assetList[index]
//                                                                             .id
//                                                                             .toString(),
//                                                                         status_id: assetList[index].status ==
//                                                                                 'Open'
//                                                                             ? '1'
//                                                                             : assetList[index].status == 'Assign'
//                                                                                 ? '2'
//                                                                                 : assetList[index].status == 'Accept'
//                                                                                     ? '3'
//                                                                                     : assetList[index].status == 'Check In'
//                                                                                         ? "6"
//                                                                                         : assetList[index].status == 'On Hold'
//                                                                                             ? '8'
//                                                                                             : assetList[index].status == 'Pending'
//                                                                                                 ? '9'
//                                                                                                 : assetList[index].status == 'Completed'
//                                                                                                     ? '10'
//                                                                                                     : assetList[index].status == 'Fixed'
//                                                                                                         ? assetList[index].completedComment.toString()
//                                                                                                         : assetList[index].status == 'Reject'
//                                                                                                             ? '4'
//                                                                                                             : assetList[index].status == 'Reopen'
//                                                                                                                 ? '12'
//                                                                                                                 : assetList[index].status == 'Reassign'
//                                                                                                                     ? '5'
//                                                                                                                     : '',
//                                                                         priority: '',
//                                                                         assign_type: '',
//                                                                         downtime_val: '',
//                                                                         open_comment: textFieldController.text,
//                                                                         assigned_comment: textFieldController.text,
//                                                                         accept_comment: textFieldController.text,
//                                                                         reject_comment: textFieldController.text,
//                                                                         hold_comment: textFieldController.text,
//                                                                         pending_comment: textFieldController.text,
//                                                                         check_out_comment: textFieldController.text,
//                                                                         completed_comment: textFieldController.text,
//                                                                         reopen_comment: textFieldController.text,
//                                                                         reassign_comment: textFieldController.text,
//                                                                         comment: '',
//                                                                         solution: '',
//                                                                         breakdown_category_id: '',
//                                                                         breakdown_subcategory_id: '',
//                                                                         checkin_comment: '')
//                                                                     .then((value) {
//                                                                   if (value
//                                                                           .isError ==
//                                                                       false) {
//                                                                     _fetchTicketCounts();

//                                                                     Navigator.pop(
//                                                                         context);
//                                                                   }
//                                                                   showMessage(
//                                                                     context:
//                                                                         context,
//                                                                     isError: value
//                                                                         .isError!,
//                                                                     responseMessage:
//                                                                         value
//                                                                             .message!,
//                                                                   );
//                                                                 });
//                                                               },
//                                                               style:
//                                                                   ElevatedButton
//                                                                       .styleFrom(
//                                                                 backgroundColor:
//                                                                     const Color
//                                                                         .fromRGBO(
//                                                                         21,
//                                                                         147,
//                                                                         159,
//                                                                         1),
//                                                               ),
//                                                               child: const Text(
//                                                                 'Submit',
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         "Mulish",
//                                                                     color: Colors
//                                                                         .white),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                   );
//                                                 },
//                                               );
//                                               setState(() {});
//                                             },
//                                             icon:
//                                                 const Icon(Icons.chat_outlined),
//                                             color: Colors.black,
//                                             iconSize: 24,
//                                           ),

//                                           // Check if the status is 'acknowledge' or 'fixed'
//                                           if (assetList[index].status ==
//                                                   'Completed' &&
//                                               employee_type != "Engineer") ...[
//                                             IconButton(
//                                               onPressed: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     return AlertDialog(
//                                                       title: const Text(
//                                                         'Are you sure you want to Acknowledge this ticket?',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 "Mulish",
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal),
//                                                       ),
//                                                       backgroundColor:
//                                                           Colors.white,
//                                                       actions: [
//                                                         TextButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: const Text(
//                                                             'Cancel',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Mulish",
//                                                                 color: Colors
//                                                                     .black),
//                                                           ),
//                                                         ),
//                                                         ElevatedButton(
//                                                           onPressed: () {
//                                                             ApiService()
//                                                                 .TicketAccept(
//                                                               ticketNo: assetList[
//                                                                       index]
//                                                                   .id
//                                                                   .toString(),
//                                                               status_id: '11',
//                                                               priority: '',
//                                                               assign_type: '',
//                                                               downtime_val: '',
//                                                               open_comment: '',
//                                                               assigned_comment:
//                                                                   '',
//                                                               accept_comment:
//                                                                   '',
//                                                               reject_comment:
//                                                                   '',
//                                                               hold_comment: '',
//                                                               pending_comment:
//                                                                   '',
//                                                               check_out_comment:
//                                                                   '',
//                                                               completed_comment:
//                                                                   '',
//                                                               reopen_comment:
//                                                                   '',
//                                                               reassign_comment:
//                                                                   '',
//                                                               comment: '',
//                                                               solution: '',
//                                                               breakdown_category_id:
//                                                                   '',
//                                                               breakdown_subcategory_id:
//                                                                   '',
//                                                               checkin_comment:
//                                                                   '',
//                                                             )
//                                                                 .then((value) {
//                                                               if (value
//                                                                       .isError ==
//                                                                   false) {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               }
//                                                               showMessage(
//                                                                 context:
//                                                                     context,
//                                                                 isError: value
//                                                                     .isError!,
//                                                                 responseMessage:
//                                                                     value
//                                                                         .message!,
//                                                               );
//                                                             });
//                                                           },
//                                                           style: ElevatedButton
//                                                               .styleFrom(
//                                                             backgroundColor:
//                                                                 const Color
//                                                                     .fromRGBO(
//                                                                     21,
//                                                                     147,
//                                                                     159,
//                                                                     1),
//                                                           ),
//                                                           child: const Text(
//                                                             'Submit',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Mulish",
//                                                                 color: Colors
//                                                                     .white),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                               icon: const Icon(
//                                                   Icons.thumb_up_alt_outlined),
//                                               color: Colors.black,
//                                               iconSize: 24,
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     TextEditingController
//                                                         textFieldController =
//                                                         TextEditingController();

//                                                     return AlertDialog(
//                                                       title: const Text(
//                                                         'Reason For Re-Open...',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 "Mulish",
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal),
//                                                       ),
//                                                       backgroundColor:
//                                                           Colors.white,
//                                                       content: Column(
//                                                         mainAxisSize:
//                                                             MainAxisSize.min,
//                                                         children: [
//                                                           TextField(
//                                                             decoration:
//                                                                 InputDecoration(
//                                                               labelText:
//                                                                   'Enter Reason',
//                                                               labelStyle: const TextStyle(
//                                                                   fontFamily:
//                                                                       "Mulish",
//                                                                   color: Colors
//                                                                       .black),
//                                                               border:
//                                                                   const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             15.0)),
//                                                               ),
//                                                               enabledBorder:
//                                                                   OutlineInputBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             15),
//                                                                 borderSide: const BorderSide(
//                                                                     color: Colors
//                                                                         .black),
//                                                               ),
//                                                               focusedBorder:
//                                                                   OutlineInputBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             15),
//                                                                 borderSide: const BorderSide(
//                                                                     color: Colors
//                                                                         .black),
//                                                               ),
//                                                             ),
//                                                             style:
//                                                                 const TextStyle(
//                                                                     fontFamily:
//                                                                         "Mulish",
//                                                                     color: Colors
//                                                                         .black),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       actions: [
//                                                         TextButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: const Text(
//                                                             'Cancel',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Mulish",
//                                                                 color: Colors
//                                                                     .black),
//                                                           ),
//                                                         ),
//                                                         ElevatedButton(
//                                                           onPressed: () {
//                                                             ApiService()
//                                                                 .TicketAccept(
//                                                               ticketNo: assetList[
//                                                                       index]
//                                                                   .id
//                                                                   .toString(),
//                                                               status_id: '12',
//                                                               priority: '',
//                                                               assign_type: '',
//                                                               downtime_val: '',
//                                                               open_comment: '',
//                                                               assigned_comment:
//                                                                   '',
//                                                               accept_comment:
//                                                                   '',
//                                                               reject_comment:
//                                                                   '',
//                                                               hold_comment: '',
//                                                               pending_comment:
//                                                                   '',
//                                                               check_out_comment:
//                                                                   '',
//                                                               completed_comment:
//                                                                   '',
//                                                               reopen_comment:
//                                                                   textFieldController
//                                                                       .text,
//                                                               reassign_comment:
//                                                                   '',
//                                                               comment: '',
//                                                               solution: '',
//                                                               breakdown_category_id:
//                                                                   '',
//                                                               breakdown_subcategory_id:
//                                                                   '',
//                                                               checkin_comment:
//                                                                   '',
//                                                             )
//                                                                 .then((value) {
//                                                               if (value
//                                                                       .isError ==
//                                                                   false) {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               }
//                                                               showMessage(
//                                                                 context:
//                                                                     context,
//                                                                 isError: value
//                                                                     .isError!,
//                                                                 responseMessage:
//                                                                     value
//                                                                         .message!,
//                                                               );
//                                                             });
//                                                           },
//                                                           style: ElevatedButton
//                                                               .styleFrom(
//                                                             backgroundColor:
//                                                                 const Color
//                                                                     .fromRGBO(
//                                                                     21,
//                                                                     147,
//                                                                     159,
//                                                                     1),
//                                                           ),
//                                                           child: const Text(
//                                                             'Re-Open',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Mulish",
//                                                                 color: Colors
//                                                                     .white),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                               icon: const Icon(Icons
//                                                   .thumb_down_off_alt_sharp),
//                                               color: Colors.black,
//                                               iconSize: 24,
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                         // );
//                       },
//                     ),
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
