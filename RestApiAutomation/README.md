# Rest Api Automation

**API Endpoints to be Validated :-**

**_/products :_** 

    Find    -   GET 
    create  -   POST 
    update  -   PATCH 
    remove  -   DELETE 
    
**_/stores :_** 

    Find    -   GET 
    create  -   POST 
    update  -   PATCH 
    remove  -   DELETE 
    
**_/services :_** 

    Find    -   GET 
    create  -   POST 
    update  -   PATCH 
    remove  -   DELETE 
    
**_/categories :_** 

    Find    -   GET 
    create  -   POST 
    update  -   PATCH 
    remove  -   DELETE 
    
**_/utilities :_**
 
    health Check API |
    Version number


**Schema of each of the endpoints created :**

    The response Schemas of each of the endpoints are created and stored under LIB/TEMPLATES/schemas :- 
    
    categories_json_schema.json, products_json_schema.json, services_json_schema.json, stores_json_schema.json, 
    healthcheck_json_schema.json, version_json_schema.json
    
    The response from each of the API endpoint methods are validated against these schemas

**Library**

_RestConnection.py :_ 

    Initialize_domain :- method currently initialized to localhost, can be set to any API domain

    rest_send_request :- send API requests for supported methods for each endpoint - GET, POST, PATCH, DELETE 

_RestApiTest.py :_

    test_api_endpoint :- Method to trigger API requests with query string 

    validate_response_with_schema :- Validate the response json with pre defined schema for each endpoint

**Test Framework - to Validate API endpoints**

    requirement : pip install -r LIB/requirements.txt

    Robot Files : Categories_Endpoint_TestSuite.robot, Products_Endpoint_TestSuite.robot, Services_Endpoint_TestSuite.robot,
Stores_Endpoint_TestSuite.robot, Functional_Tests.robot

**To Run Tests**

    change directory to : /RestApiAutomation

    _Run command :_ export PYTHONPATH=.

    Command to run Tests : robot -i rest_api_tests -d Results -b debug.txt TESTSUITES/*

    -i <tag> (rest_api_tests)

    -d <result_folder_path> (Results)

    -b <debug_file> (debug.txt) 


**Test Results**

    Test Results will be generated under - "Results" folder and will possess the debufile : debug.txt, and the Robot report 
    related files : report.html, log.html, output.xml

    A folder named - "Test_Report" has been added with all the Test reports and debug files of a successful run for reference.