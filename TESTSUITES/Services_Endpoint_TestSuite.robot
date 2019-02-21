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
    [Tags]    services      rest_api_tests
    [Documentation]   *Validate - Services endpoint for method - GET*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    # Fetch All records
    ${result}   ${response}=  test api endpoint    services    GET
    Run Keyword and continue on Failure     should be True  ${result}
    set test variable   ${response_data}    ${response["data"]}
    :FOR  ${item}   IN      @{response_data}
    \   validate response with schema   services    ${item}


Create , Fetch, Update and Delete New record - POST, GET, PATCH, DELETE | Validate JSON Schema of each of the Responses
    [Tags]    services      rest_api_tests
    [Documentation]  *Validate - Services endpoint for methods - POST, GET, PATCH and DELETE*
    # Create New record
    set test variable   ${service}      {"name": "Test Create New Service"}
    ${result}    ${created_service_response}=  test api endpoint    services    POST     {}     ${service}
    set test variable   ${id}   ${created_service_response["id"]}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   services    ${created_service_response}

    # fetch created record
    ${result}   ${response}=  test api endpoint    services/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   services    ${response}

    #Update above created record
    set test variable   ${updated_service}      {"name": "Test Update New Service"}
    ${result}   ${response}=  test api endpoint    services/${id}    PATCH       {}     ${updated_service}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   services    ${response}

    # Delete above created record
    ${result}   ${response}=  test api endpoint    services/${id}    DELETE
    Run Keyword and continue on Failure     should be True  ${result}

    #Validate Deleted Record
    ${result}   ${response}=  test api endpoint    services/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
