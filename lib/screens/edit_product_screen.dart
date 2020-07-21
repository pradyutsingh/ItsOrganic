import 'package:ItsOrganic/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ItsOrganic/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusNode = FocusNode();
  final _descriptionfocusNode = FocusNode();
  final _imageurlController = TextEditingController();
  final _imageurlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;

  @override
  void initState() {
    _imageurlFocusNode.addListener(_updateimgurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;

        _initValues = {
          'title': _editedProduct.title,
          'desciption': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageurlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    _imageurlFocusNode.removeListener(_updateimgurl);
    _pricefocusNode.dispose();
    _descriptionfocusNode.dispose();
    _imageurlController.dispose();
    _imageurlFocusNode.dispose();
    super.dispose();
  }

  void _updateimgurl() {
    if (!_imageurlFocusNode.hasFocus) {
      if ((!_imageurlController.text.startsWith('http') &&
              !_imageurlController.text.startsWith('https')) ||
          (!_imageurlController.text.endsWith('.png') &&
              !_imageurlController.text.endsWith('.jpg') &&
              !_imageurlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addproduct(_editedProduct);
      } catch (error) {
        return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('An error occcured'),
                  content: Text('Something went wrong'),
                  actions: [
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      finally{
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: _saveForm,
        child: Icon(
          Icons.done_outline,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Product forms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text('Your shop',
                  style: TextStyle(fontSize: 40, fontFamily: 'Lato')),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                'Fill this form to add your products to this organic marketplace...',
                softWrap: true,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                            labelText: 'Title', focusColor: Colors.black),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the required details.';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              description: _editedProduct.description,
                              title: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                            labelText: 'Price', fillColor: Colors.black),
                        textInputAction: TextInputAction.next,
                        focusNode: _pricefocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter price greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              description: _editedProduct.description,
                              title: _editedProduct.title,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionfocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              description: value,
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length <= 10) {
                            return 'Please enter a more informative description';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.orangeAccent)),
                            child: _imageurlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageurlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageurlController,
                              focusNode: _imageurlFocusNode,
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    description: _editedProduct.description,
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.jpg')) {
                                  return 'Please enter the URL of an image';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
