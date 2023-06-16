import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/tracking/tracking_driver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_action/slide_action.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTimeRange? selectedDate;
  String dropdownValue = 'Bulan Ini';
  TextEditingController _searchController = TextEditingController();
  bool isFinish = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Halo, Nama Driver',
                      style: textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorValue.neutralColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Analisa',
                      style: textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorValue.secondaryColor,
                        fontSize: 16
                      ),
                    ),
                    DropdownButton<String>(
                        menuMaxHeight: 150,
                        value: dropdownValue,
                        iconEnabledColor: ColorValue.neutralColor,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            if (dropdownValue == "Bulan Ini") {}
                            else if (dropdownValue == "3 Bulan Terakhir") {}
                            else if (dropdownValue == "6 Bulan Terakhir") {}
                            else if (dropdownValue == "1 Tahun Terakhir") {}
                          });
                        },
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        autofocus: true,
                        items: _months
                            .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                    style: textTheme.subtitle1!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: ColorValue.neutralColor),)
                              );
                            }).toList(),
                        onTap: () {
                          dropdownValue = dropdownValue;
                          if (dropdownValue == "Kustomisasi") {
                            showDatePickerDialog(context, 1);
                          } else {
                            dropdownValue = dropdownValue;
                            selectedDate = selectedDate;
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 5,),
                GridView.count(
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  children: [
                    card_analytic(ColorValue.secondaryColor, "Total mengantar", '17'),
                    card_analytic(ColorValue.tertiaryColor, "Pengunjung toko", '120.000'),
                    card_analytic(const Color(0xFFEE6C4D), "Rating Toko", '4.5'),
                  ],
                ),
                const SizedBox(height: 20,),
                Text(
                  'Anterin',
                  style: textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorValue.secondaryColor,
                      fontSize: 16
                  ),
                ),
                const SizedBox(height: 5,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total barang yang harus diantar: ',
                      style: textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: ColorValue.hintColor),
                    ),
                    Text(
                      '17',
                      style: textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: ColorValue.neutralColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ColorValue.hintColor,
                          width: 1,
                        ),
                      ),
                      //child textfield
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: ColorValue.hintColor,
                          ),
                          hintText: 'Cari alamat pengantaran',
                          hintStyle: textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: ColorValue.hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ColorValue.hintColor,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        color: ColorValue.hintColor,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 17,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 185,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: ColorValue.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: ColorValue.hintColor,
                          width: 0.5,
                        ),
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                              height: 125,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: ColorValue.hintColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Jane Doe',
                                            style: textTheme.subtitle1!.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: ColorValue.neutralColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Dipesan :',
                                                style: textTheme.subtitle1!.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: ColorValue.neutralColor),
                                              ),
                                              Text(
                                                '12-04-2023 12:90 ',
                                                style: textTheme.subtitle1!.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: ColorValue.hintColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          for (int i = 0; i < 2; i++)
                                            Row(
                                              children: [
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Beras Pandan Wangi 5kg',
                                                  style: textTheme.subtitle1!.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      color: ColorValue.neutralColor),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Text(
                                                    '127',
                                                    style: textTheme.subtitle1!.copyWith(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        color: ColorValue.neutralColor),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                )
                                              ],
                                            ),
                                          Text(
                                            'Lainnya...',
                                            style: textTheme.subtitle1!.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: ColorValue.secondaryColor),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          bottom_sheet();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          'Antar',
                                          style: textTheme.subtitle1!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: ColorValue.neutralColor),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            'Total : ',
                                            style: textTheme.subtitle1!.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'Rp. 100.000',
                                            style: textTheme.subtitle1!.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet
  void bottom_sheet(){
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: const AssetImage('assets/images/food_delivery.png'),
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                'Peringatan !',
                style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ColorValue.neutralColor),
              ),
              const SizedBox(height: 10,),
              Text(
                'Pesanan yang kamu antar tidak bisa kamu batalkan lho! jadi hati-hati dalam pemilihan',
                style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ColorValue.hintColor),
              ),
              const SizedBox(height: 20,),
              SlideAction(
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        // Show loading if async operation is being performed
                        state.isPerformingAction
                            ? "Tunggu sebentar..."
                            : "Mengantar Pesanan",
                        style: textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorValue.neutralColor)
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorValue.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      // Show loading indicator if async operation is being performed
                      child: state.isPerformingAction
                          ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                          : const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                action: () async {
                  // Async operation
                  await Future.delayed(
                    const Duration(seconds: 2),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrackingDriver(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }


  Widget card_analytic(Color color, String title, String value) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
          padding: const EdgeInsets.only(left: 10, top: 10),
          height: 100,
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ],
          )),
    );
  }

  Widget dropDown_Driver() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        color: ColorValue.neutralColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: _months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  final List<String> _months = [
    "Bulan Ini",
    "3 Bulan Terakhir",
    "6 Bulan Terakhir",
    "1 Tahun Terakhir",
    "Semua",
    "Kustomisasi",
  ];

  Future<void> showDatePickerDialog(BuildContext context, int variableIndex) async {
    //date range picker dialog
    final DateTimeRange? pickedDate = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now()),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        switch (variableIndex) {
          case 1:
            selectedDate = pickedDate;
            break;
          default:
            break;
        }
      });
    }
  }
}
