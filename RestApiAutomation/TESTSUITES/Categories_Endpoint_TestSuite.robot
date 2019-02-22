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
    [Tags]    categories      rest_api_tests
    [Documentation]   *Validate - categories endpoint for method - GET*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    # Fetch All records
    ${result}   ${response}=  test api endpoint    categories    GET
    Run Keyword and continue on Failure     should be True  ${result}
    set test variable   ${response_data}    ${response["data"]}
    :FOR  ${item}   IN      @{response_data}
    \   validate response with schema   categories    ${item}


Create , Fetch, Update and Delete New record - POST, GET, PATCH, DELETE | Validate JSON Schema of each of the Responses
    [Tags]    categories      rest_api_tests
    [Documentation]  *Validate - categories endpoint for methods - POST, GET, PATCH and DELETE*
    # Create New record
    ${random_id}=   Generate Random String  8  [LETTERS]
    log to console      ${random_id}
    set test variable   ${product}      {"id": "${random_id}", "name": "Test Category created"}
    ${result}    ${created_product_response}=  test api endpoint    categories    POST     {}     ${product}
    set test variable   ${id}   ${created_product_response["id"]}
    Run Keyword and continue on Failure     should be True  ${result}

    # fetch created record
    ${result}   ${response}=  test api endpoint    categories/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   categories    ${response}

    #Update above created record
    set test variable   ${updated_product}      {"name": "Test Update New category"}
    ${result}   ${response}=  test api endpoint    categories/${id}    PATCH       {}     ${updated_product}
    Run Keyword and continue on Failure     should be True  ${result}
    validate response with schema   categories    ${response}

    # Delete above created record
    ${result}   ${response}=  test api endpoint    categories/${id}    DELETE
    Run Keyword and continue on Failure     should be True  ${result}

    #Validate Deleted Record
    ${result}   ${response}=  test api endpoint    categories/${id}    GET
    Run Keyword and continue on Failure     should be True  ${result}
