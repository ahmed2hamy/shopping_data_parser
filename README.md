# Shopping Data Parser
An app to parse shopping data from CSV files as an E2E solution.

## How To Use:


- Run the app from a Flutter development environment.
- The app will start on input screen which will have a picker button to pick a CSV file.
- The app will parse the file and return the the result and store that result in two files as follows:
    1.  0_input_file_name:  In the first column, list the product name. The second column should contain the average quantity of the product purchased per order.

    2.  1_input_file_name:  In the first column, list the product name. The second column should be the most popular brand for that product. Most popular brand is defined as the brand with the most total orders and not the quantity.
- Run test from test folder in Flutter development environment and it will generate the two files in test folder and will compare results by the expected results.
