import 'package:flutter/material.dart';
import 'Customer_details.dart';

class CustomerActionButtons extends StatelessWidget {
  final Map<String, String> row;
  final int index;

  const CustomerActionButtons({
    super.key,
    required this.row,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,  
      icon: const Icon(Icons.more_vert,color:Colors.black), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
      elevation: 8, // shadow effect
      color: Colors.white, // popup background color
      offset: const Offset(0, 40), // dropdown position
      onSelected: (value) async{
        if(value == 'view'){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Customer_Details(row: row),
            ),
          );
        }
      },      
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: const [
              Icon(Icons.visibility, color: Colors.blue,size: 20,),
              SizedBox(width: 5),
              Text('view', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),       
      ],  
    );
  }
}


