import 'package:ItsOrganic/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ItsOrganic/providers/products_provider.dart';

class UserProductitem extends StatelessWidget {
  final String imageurl;
  final String id;
  final String title;
  UserProductitem({this.id, this.imageurl, this.title});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: ()async{
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteproduct(id);
                } catch (error) {
                  
                      scaffold.showSnackBar(SnackBar(content: Text('Deletion failed')));
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
