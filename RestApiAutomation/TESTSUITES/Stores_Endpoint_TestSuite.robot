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
    [Tags]    stores      rest_api_tests
    [Documentation]  *Validate - Stores endpoint for method - GET*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=  test api endpoint    stores    GET
    Run Keyword and continue on Failure     should be True  ${result}
    set test variable   ${response_data}    ${response["data"]}
    :FOR  ${item}   IN      @{response_data}
    \   validate response with schema   stores    ${item}


Create , Fetch, Update and Delete New record - POST, GET, PATCH, DELETE | Validate JSON Schema of each of the Responses
    [Tags]    stores      rest_api_tests
    [Documentation]  *Validate - Stores endpoint for methods - POST, GET, PATCH and DELETE*
    # API request format :- | api endpoint | Method | Query String | Request Data
    # Create New record
    set test variable   ${store}      {"name": "Test Create New Store","type": "BigBox","address": "123 Fake St","address2": "","city": "Springfield","state": "MN","zip": "55123","lat": 44.969658,"lng": -93.449539,"hours": "Mon: 10-9; Tue: 10-9; Wed: 10-9; Thurs: 10-9; Fri: 10-9; Sat: 10-9; Sun: 10-8"}
    ${result}    ${created_store_response}=  test api endpoint    stores    POST     {}     ${store}
    set test variable   ${id}   ${created_store_response["id"]}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   stores    ${created_store_response}

    #Fetch Newly created record and validate JSON schema
    ${result}   ${response}=  test api endpoint    stores/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   stores    ${response}

    #Update above created record
    set test variable   ${updated_store}      {"name": "Test Update Created Store","type": "BigBox_updated","address": "123 Fake St","address2_updated": "updated","city": "Springfield_updated","state": "MN","zip": "55123","lat": 44.969658,"lng": -93.449539,"hours": "Mon: 10-9; Tue: 10-9; Wed: 10-9; Thurs: 10-9; Fri: 10-9; Sat: 10-9; Sun: 10-8"}
    ${result}   ${response}=  test api endpoint    stores/${id}    PATCH       {}     ${updated_store}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   stores    ${response}

    # Delete above created record
    ${result}   ${response}=  test api endpoint    stores/${id}    DELETE
    Run Keyword and continue on Failure     should be True  ${result}

    #Validate Deleted Record
    ${result}   ${response}=  test api endpoint    stores/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}

