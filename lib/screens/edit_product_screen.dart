import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    categoryId: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'categoryId': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'categoryId': _editedProduct.categoryId,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    _editedProduct.categoryId = _DropdownButtonExampleState.dropdownValue;
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Network error.'),
            content: Text('Could not add product.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {
              _saveProduct();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: ((value) {
                          if (value.isEmpty) {
                            return 'You need to provide a title.';
                          } else {
                            return null;
                          }
                        }),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: newValue,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                            categoryId: _editedProduct.categoryId,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: ((value) {
                          if (value.isEmpty) {
                            return 'You need to provide a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be greater than zero.';
                          }
                          return null;
                        }),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue),
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                            categoryId: _editedProduct.categoryId,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: ((value) {
                          if (value.isEmpty) {
                            return 'You need to provide a description.';
                          }
                          if (value.length < 5) {
                            return 'Description should at least be 5 characters.';
                          }
                          return null;
                        }),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: newValue,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                            categoryId: _editedProduct.categoryId,
                          );
                        },
                      ),
                      SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    'No Image',
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: ((_) {
                                _saveProduct();
                              }),
                              validator: ((value) {
                                if (value.isEmpty) {
                                  return 'You need to provide a image URL.';
                                }
                                if (!value.startsWith('https') &&
                                    !value.startsWith('http')) {
                                  return 'Invalid URL.';
                                }
                                return null;
                              }),
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue,
                                  isFavorite: _editedProduct.isFavorite,
                                  categoryId: _editedProduct.categoryId,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10),
                          DropdownButtonExample(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  static const List<String> list = <String>[
    'Laptops',
    'Phones',
    'Headphones',
    'Shoes',
    'Monitors'
  ];
  static String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: DropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        value: dropdownValue,
        elevation: 16,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary, fontSize: 16),
        onChanged: (String value) {
          setState(() {
            dropdownValue = value;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
