BARCODE PRODUCT MANAGEMENT APP

DEVELOPERS:
10148830858 KADER TULIN SURE
28505181482 EYLUL BASAK CAGLAYAN 

PROJECT DESCRIPTION
This project is a Flutter mobile application developed for the BIM 493 – Mobile Programming I course.
The aim of the application is to allow users to quickly query products using barcode numbers and display
product name, price, and stock information in a clean grid layout.

If a product does not exist in the database, the user is prompted to add a new product.

--------------------------------------------------

OBJECTIVES
- Create and validate form-based inputs in Flutter
- Store data locally using SQLite (sqflite)
- Display product data in a clean grid layout (DataTable)
- Implement CRUD operations (Create, Read, Update, Delete)
- Provide user-friendly error and success messages
- Ensure data persistence after application restart

--------------------------------------------------

TECHNOLOGIES USED
- Flutter
- Dart
- sqflite (Local Database)
- provider (State Management)

--------------------------------------------------

DATABASE DESIGN

Product Table Fields:
- barcodeNo (String, Primary Key)
- productName (String, Not Null)
- category (String, Not Null)
- unitPrice (Double, Not Null)
- taxRate (Integer, Not Null)
- price (Double, Not Null)
- stockInfo (Integer, Nullable)

Only one table is used as required in the assignment.

--------------------------------------------------

APPLICATION FEATURES

Barcode Search:
- Products can be searched using barcode numbers
- If the product exists, it is displayed in the grid
- If the product does not exist, a dialog asks whether to add a new product

Add Product:
- Products can be added using a form dialog
- Required fields are validated
- Stock information is optional

Edit Product:
- Existing products can be edited
- Barcode field is disabled during editing

Delete Product:
- Products can be deleted with a confirmation dialog

Clean Grid Layout:
- Products are displayed using DataTable
- Displayed information:
  - Product Name
  - Price
  - Stock Information

--------------------------------------------------

VALIDATION RULES
- Barcode must be unique
- Required fields cannot be empty
- Negative values are not allowed
- Tax rate must be between 0 and 100
- Stock value cannot be negative

--------------------------------------------------

TEST SCENARIOS

1. Duplicate Barcode
   - Input: Same barcode twice
   - Expected Result: Error message shown

2. Empty Fields
   - Input: Empty required fields
   - Expected Result: Validation error

3. Negative Stock
   - Input: -5
   - Expected Result: Validation error

4. Invalid Tax Rate
   - Input: 150
   - Expected Result: Validation error

5. Valid Product
   - Input: Correct values
   - Expected Result: Product added successfully

6. Search Existing Product
   - Input: Existing barcode
   - Expected Result: Product displayed

7. Search Non-existing Product
   - Input: Non-existing barcode
   - Expected Result: Add product dialog shown

8. App Restart
   - Input: Restart application
   - Expected Result: Data persists

--------------------------------------------------

PROJECT STRUCTURE

lib/
- db/
  - database_helper.dart
- models/
  - product.dart
- providers/
  - product_provider.dart
- screens/
  - main_screen.dart
  - product_form_dialog.dart
- main.dart

--------------------------------------------------

HOW TO RUN
1. Clone the project
2. Run flutter pub get
3. Start an Android emulator or connect a physical device
4. Run flutter run

--------------------------------------------------


