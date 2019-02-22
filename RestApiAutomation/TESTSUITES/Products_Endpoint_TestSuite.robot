*** Variables ***
${domain}=      localhost



*** Settings ***
Documentation    Best Buy API Playground Test Suite
Library     LIB/RestConnection.py
Library     collections
Library     LIB/RestApiTest.py
Library     String

Suite Setup     Initialize Domain   ${domain}

*** Keywords ***
Initialize Domain
    [Arguments]    ${domain}
    RestConnection.initialize_domain    ${domain}


*** Test Cases ***

Fetch All records - GET | Validate JSON Schema of the Response
    [Tags]    products      rest_api_tests
    [Documentation]  *Validate - Products endpoint for method - GET*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=  test api endpoint    products    GET
    Run Keyword and continue on Failure     should be True  ${result}
    set test variable   ${response_data}    ${response["data"]}
    :FOR  ${item}   IN      @{response_data}
    \   validate response with schema   products    ${item}


Create , Fetch, Update and Delete New record - POST, GET, PATCH, DELETE | Validate JSON Schema of each of the Responses
    [Tags]    products      rest_api_tests
    [Documentation]  *Validate - Products endpoint for methods - POST, GET, PATCH and DELETE*
    # API request format :- | api endpoint | Method | Query String | Request Data
    #Create New record
    set test variable   ${product}      {"name": "Test Create product", "type": "Hardware", "price": 200, "shipping": 0,"upc": "string","description": "test Product being added","manufacturer": "Test manufacturer","model": "test model","url": "test url","image": "test image"}
    ${result}    ${created_product_response}=  test api endpoint    products    POST     {}     ${product}
    set test variable   ${id}   ${created_product_response["id"]}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   products    ${created_product_response}

    # fetch created record
    ${result}   ${response}=  test api endpoint    products/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   products    ${response}

    #Update above created record
    set test variable   ${updated_product}      {"name": "Test Updated product", "type": "Hardware_Updated", "price": 500, "shipping": 0,"upc": "string","description": "Created product being updated","manufacturer": "Test manufacturer","model": "test model","url": "test url","image": "test image"}
    ${result}   ${response}=  test api endpoint    products/${id}    PATCH       {}     ${updated_product}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   products    ${response}

    # Delete above created record and validate deletion
    ${result}   ${response}=  test api endpoint    products/${id}    DELETE
    Run Keyword and continue on Failure     should be True  ${result}

    #Validate Deleted Record
    ${result}   ${response}=  test api endpoint    products/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}

