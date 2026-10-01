
import 'package:flutter/material.dart';
import 'package:medicine_finder/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final DbHelper dbRef = DbHelper.getInstance;

final TextEditingController medicineNameController =
TextEditingController();
final TextEditingController medicineCompanyController =
TextEditingController();
final TextEditingController medicinePowerController =
TextEditingController();
final TextEditingController medicineExpiryController =
TextEditingController();
final TextEditingController houseController =
TextEditingController();
final TextEditingController rackController =
TextEditingController();
final TextEditingController rowController =
TextEditingController();
final TextEditingController columnController =
TextEditingController();
final TextEditingController quantityController =
TextEditingController();

final TextEditingController searchController =
TextEditingController();
List<Map<String, dynamic>> allMedicine = [];
List<Map<String, dynamic>> filteredMedicine = [];
String selectedFilter = "All";
int totalMedicine = 0;
int expiredMedicine = 0;
int lowStockMedicine = 0;
int expiringSoonMedicine = 0;


@override
void initState() {
super.initState();
getMedicine();
}


  Future<void> getMedicine() async {
    allMedicine = await dbRef.getALLMedicine();

    filteredMedicine = List.from(allMedicine);

    totalMedicine = allMedicine.length;

    expiredMedicine = allMedicine.where((medicine) {
      return isExpired(
        medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString(),
      );
    }).length;

    lowStockMedicine = allMedicine.where((medicine) {
      return medicine[DbHelper.COULUMN_MEDICINE_QUANTITY] <= 5;
    }).length;

    expiringSoonMedicine = allMedicine.where((medicine) {
      int left = daysLeft(
        medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString(),
      );

      return left > 0 && left <= 90;
    }).length;

    setState(() {});
  }

  void searchMedicine(String value) {
    if (value.isEmpty) {
      filteredMedicine = List.from(allMedicine);
    } else {
      filteredMedicine = allMedicine.where((medicine) {
        String name = medicine[DbHelper.COLUMN_MEDICINE_NAME]
            .toString()
            .toLowerCase();

        String company = medicine[DbHelper.COLUMN_MEDICINE_COMAPNY]
            .toString()
            .toLowerCase();

        String power = medicine[DbHelper.COLUMN_MEDICINE_POWER]
            .toString()
            .toLowerCase();

        String search = value.toLowerCase();

        return name.contains(search) ||
            company.contains(search) ||
            power.contains(search);
      }).toList();
    }

    setState(() {});
  }

void clearControllers() {
medicineNameController.clear();
medicineCompanyController.clear();
medicinePowerController.clear();
medicineExpiryController.clear();
houseController.clear();
rackController.clear();
rowController.clear();
columnController.clear();
quantityController.clear();
}
Future<void> selectExpiryDate() async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    medicineExpiryController.text =
    "${pickedDate.day.toString().padLeft(2, '0')}/"
        "${pickedDate.month.toString().padLeft(2, '0')}/"
        "${pickedDate.year}";
  }
}

void showMedicineBottomSheet({Map<String, dynamic>? medicine}) {
if (medicine != null) {
medicineNameController.text =
medicine[DbHelper.COLUMN_MEDICINE_NAME].toString();

medicineCompanyController.text =
medicine[DbHelper.COLUMN_MEDICINE_COMAPNY].toString();

medicinePowerController.text =
medicine[DbHelper.COLUMN_MEDICINE_POWER].toString();

medicineExpiryController.text =
medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString();

houseController.text =
medicine[DbHelper.COLUMN_HOUSE_NAME].toString();

rackController.text =
medicine[DbHelper.COLUMN_RACK_NUMBER].toString();

rowController.text =
medicine[DbHelper.COLUMN_ROW_NUMBER].toString();

columnController.text =
medicine[DbHelper.COLUMN_COLUMN_NUMBER].toString();

quantityController.text =
medicine[DbHelper.COULUMN_MEDICINE_QUANTITY].toString();
}

showModalBottomSheet(
context: context,
isScrollControlled: true,
builder: (context) {
return Padding(
padding: EdgeInsets.only(
left: 16,
right: 16,
top: 20,
bottom: MediaQuery.of(context).viewInsets.bottom + 20,
),
child: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [

Text(
medicine == null
? "Add Medicine"
: "Update Medicine",
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

TextField(
controller: medicineNameController,
decoration: const InputDecoration(
labelText: "Medicine Name",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: medicineCompanyController,
decoration: const InputDecoration(
labelText: "Company Name",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: medicinePowerController,
decoration: const InputDecoration(
labelText: "Medicine Power",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),
  TextField(
    controller: medicineExpiryController,
    readOnly: true,
    onTap: selectExpiryDate,
    decoration: const InputDecoration(
      labelText: "Expiry Date",
      suffixIcon: Icon(Icons.calendar_today),
      border: OutlineInputBorder(),
    ),
  ),



const SizedBox(height: 12),

TextField(
controller: houseController,
decoration: const InputDecoration(
labelText: "House Name",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: rackController,
decoration: const InputDecoration(
labelText: "Rack Number",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: rowController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Row Number",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: columnController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Column Number",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: quantityController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Quantity",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 20),

SizedBox(
width: double.infinity,
height: 50,
child: ElevatedButton(
child: Text(
medicine == null
? "ADD MEDICINE"
: "UPDATE MEDICINE",
),
onPressed: () async {

if (medicineNameController.text.isEmpty ||
medicineCompanyController.text.isEmpty ||
medicinePowerController.text.isEmpty ||
medicineExpiryController.text.isEmpty ||
houseController.text.isEmpty ||
rackController.text.isEmpty ||
rowController.text.isEmpty ||
columnController.text.isEmpty ||
quantityController.text.isEmpty) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Please fill all fields"),
),
);
return;
}

if (medicine == null) {

bool check =
await dbRef.addmedicine_name(
mName: medicineNameController.text,
mCompany: medicineCompanyController.text,
mPower: medicinePowerController.text,
mExpiryDate: medicineExpiryController.text,
mHouse_name: houseController.text,
mRack_number: rackController.text,
mRow_number:
int.parse(rowController.text),
mColumn_number:
int.parse(columnController.text),
mQuantity:
int.parse(quantityController.text),
);

if (check) {
getMedicine();
}

} else {

bool check =
await dbRef.updateMedicine(
Id: medicine[
DbHelper.COLOUMN_MEDICINE_ID],
mName: medicineNameController.text,
mCompany:
medicineCompanyController.text,
mPower: medicinePowerController.text,
mExpiryDate:
medicineExpiryController.text,
mHouse_name: houseController.text,
mRack_number: rackController.text,
mRow_number:
int.parse(rowController.text),
mColumn_number:
int.parse(columnController.text),
mQuantity:
int.parse(quantityController.text),
);

if (check) {
getMedicine();
}
}

clearControllers();
Navigator.pop(context);
},
),
),

const SizedBox(height: 10),
],
),
),
);
},
);
}

  DateTime? getExpiryDate(String date) {
    try {
      List<String> parts = date.split('/');

      if (parts.length != 3) {
        return null;
      }

      return DateTime(
        int.parse(parts[2]), // Year
        int.parse(parts[1]), // Month
        int.parse(parts[0]), // Day
      );
    } catch (e) {
      return null;
    }
  }

  DateTime getToday() {
    DateTime now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  bool isExpired(String date) {
    DateTime? expiry = getExpiryDate(date);

    if (expiry == null) {
      return false;
    }

    DateTime today = getToday();

    return expiry.isBefore(today);
  }

  int daysLeft(String date) {
    DateTime? expiry = getExpiryDate(date);

    if (expiry == null) {
      return -1;
    }

    DateTime today = getToday();

    return expiry.difference(today).inDays;
  }
  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;

      if (filter == "All") {
        filteredMedicine = List.from(allMedicine);
      }

      else if (filter == "Expired") {
        filteredMedicine = allMedicine.where((medicine) {
          return isExpired(
            medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString(),
          );
        }).toList();
      }

      else if (filter == "Low Stock") {
        filteredMedicine = allMedicine.where((medicine) {
          int quantity = int.tryParse(
            medicine[DbHelper.COULUMN_MEDICINE_QUANTITY].toString(),
          ) ?? 0;

          return quantity <= 5;
        }).toList();
      }

      else if (filter == "Expiring Soon") {
        filteredMedicine = allMedicine.where((medicine) {
          int left = daysLeft(
            medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString(),
          );

          return left > 0 && left <= 90;
        }).toList();
      }
    });
  }
  Widget dashboardCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget filterChip(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5),
  //     child: ChoiceChip(
  //       label: Text(title),
  //       selected: selectedFilter == title,
  //       onSelected: (value) {
  //         applyFilter(title);
  //       },
  //     ),
  //   );
  // }
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
"Medicine Finder",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
backgroundColor: Colors.green,
),

floatingActionButton: FloatingActionButton(
backgroundColor: Colors.green,
child: const Icon(Icons.add),
onPressed: () {
clearControllers();
showMedicineBottomSheet();
},
),

body: Column(
children: [
  Padding(
    padding: const EdgeInsets.all(10),
    child: GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2,
      children: [
        dashboardCard(
          "Total",
          totalMedicine.toString(),
          Colors.blue,
        ),
        dashboardCard(
          "Expired",
          expiredMedicine.toString(),
          Colors.red,
        ),
        dashboardCard(
          "Low Stock",
          lowStockMedicine.toString(),
          Colors.orange,
        ),

        dashboardCard(
          "Expiring Soon",
          expiringSoonMedicine.toString(),
          Colors.green,
        ),

      ],
    ),
  ),

Padding(
padding: const EdgeInsets.all(12),
 child: TextField(
controller: searchController,
onChanged: searchMedicine,
decoration: InputDecoration(
hintText: "Search Medicine",
prefixIcon: const Icon(Icons.search),
border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(12),
 ),
),
),
),
  SizedBox(height: 10,),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [

          FilterChip(
            label: const Text("All"),
            selected: selectedFilter == "All",
            onSelected: (_) {
              //
              applyFilter("All");
            },
          ),

          const SizedBox(width: 8),


          FilterChip(
            label: const Text("Expired"),
            selected: selectedFilter == "Expired",
            onSelected: (_) {
              applyFilter("Expired");
            },
          ),

          const SizedBox(width: 8),

          // FilterChip(
          //   label: const Text("Low Stock"),
          //   selected: selectedFilter == "Low Stock",
          //   onSelected: (_) {
          //     setState(() {
          //       selectedFilter = "Low Stock";
          //       filteredMedicine = allMedicine.where((medicine) {
          //         return medicine[
          //         DbHelper.COULUMN_MEDICINE_QUANTITY] <=
          //             5;
          //       }).toList();
          //     });
          //   },
          // ),
          FilterChip(
            label: const Text("Low Stock"),
            selected: selectedFilter == "Low Stock",
            onSelected: (_) {
              applyFilter("Low Stock");
            },
          ),

          const SizedBox(width: 8),
          FilterChip(
            label: const Text("Expiring Soon"),
            selected: selectedFilter == "Expiring Soon",
            onSelected: (_) {
              applyFilter("Expiring Soon");
            },
          ),


        ],
      ),
    ),
  ),
Expanded(
child: filteredMedicine.isEmpty
? const Center(
child: Text(
"No Medicine Found",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
)

: ListView.builder(
itemCount: filteredMedicine.length,

itemBuilder: (context, index) {

final medicine = filteredMedicine[index];


return Card(
color: isExpired(
medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString())
  ? Colors.red.shade100
      : Colors.white,
  elevation: 5,
  margin: const EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 8,
  ),
// elevation: 5,
// margin: const EdgeInsets.symmetric(
// horizontal: 12,
// vertical: 8,
// ),

child: Padding(
padding: const EdgeInsets.all(10),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Text(
medicine[
DbHelper.COLUMN_MEDICINE_NAME],
style: const TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
"Company : ${medicine[DbHelper.COLUMN_MEDICINE_COMAPNY]}"),

  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // Text(
      //   "Expiry : ${medicine[DbHelper.COLUMN_EXPAIRY_DATE]}",
      // ),

      Builder(
        builder: (context) {

          int left = daysLeft(
            medicine[DbHelper.COLUMN_EXPAIRY_DATE].toString(),
          );

          if (left < 0) {
            return const Text(
              "❌ Medicine Expired",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          if (left <= 90) {
            return Text(
              "⚠ Expires in $left days",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          return const SizedBox();
        },
      ),
    ],
  ),
Text(
 "Power : ${medicine[DbHelper.COLUMN_MEDICINE_POWER]}"),

Text(
"Expiry : ${medicine[DbHelper.COLUMN_EXPAIRY_DATE]}"),

Text(
"House : ${medicine[DbHelper.COLUMN_HOUSE_NAME]}"),

Text(
"Rack : ${medicine[DbHelper.COLUMN_RACK_NUMBER]}"),

Text(
"Row : ${medicine[DbHelper.COLUMN_ROW_NUMBER]}"),

Text(
"Column : ${medicine[DbHelper.COLUMN_COLUMN_NUMBER]}"),

Text(
"Quantity : ${medicine[DbHelper.COULUMN_MEDICINE_QUANTITY]}"),

const Divider(),

Row(
mainAxisAlignment:
MainAxisAlignment.end,

children: [

IconButton(
icon: const Icon(
Icons.edit,
color: Colors.blue,
),
onPressed: () {
  editMedicine(medicine);
}
,
),

IconButton(
icon: const Icon(
Icons.delete,
color: Colors.red,
),
onPressed: () {
  showDeleteDialog(medicine);

},
),
],
),
],
),
),
);
},
),
),
],
),

);
}
@override
void dispose() {
medicineNameController.dispose();
medicineCompanyController.dispose();
medicinePowerController.dispose();
medicineExpiryController.dispose();
houseController.dispose();
rackController.dispose();
rowController.dispose();
columnController.dispose();
quantityController.dispose();
searchController.dispose();
super.dispose();
}

void editMedicine(Map<String, dynamic> medicine) {
showMedicineBottomSheet(medicine: medicine);
}

Future<void> deleteMedicine(int id) async {
bool check = await dbRef.deleteMedicine_name(id: id);

if (check) {
getMedicine();

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Medicine Deleted Successfully"),
),
);
}
}

void showDeleteDialog(Map<String, dynamic> medicine)
{
showDialog
(
context
:
context
,
builder
:
(
context
)
{
return
AlertDialog
(
title
:
const
Text
('delete medicine')
,
content
:
const
Text('are you sure you want to delete a medicine')

,
actions
:
[

TextButton
(
onPressed
:
(
)
{
Navigator
.
pop
(
context
);
}
,
child
:
const
Text
("cancle")

,
)
,

ElevatedButton
(
style
:
ElevatedButton
.
styleFrom
(
backgroundColor
:
Colors
.
red
,
)
,
onPressed
:
(
)
async
{

Navigator
.
pop
(
context
);

await
deleteMedicine
(
medicine
[
DbHelper
.
COLOUMN_MEDICINE_ID
]
,
);
}
,
child
:
const
Text
("delet"),),

]
,
);
}
,
);
}
}
