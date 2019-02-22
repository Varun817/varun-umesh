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

Fetch Highest Priced Products
    [Tags]    products      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    products    GET     {"$sort[price]":"-1"}
    should be True  ${result}


Product Name and Description Only
    [Tags]    products      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    products    GET     {"$select[]":["name","description"]}
    should be True  ${result}


TVs with free shipping and price between $500 and $800
    [Tags]    products      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    products    GET     {"category.name":"TVs","price[$gt]":"500","price[$lt]":"800","shipping[$eq]":"0"}
    should be True  ${result}

Categories with TV in the name
    [Tags]    categories      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    categories    GET     {"name[$like]":"*TV*"}
    should be True  ${result}

Find stores in Minnesota
    [Tags]    stores      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    stores    GET     {"state":"MN"}
    should be True  ${result}

Find stores that sell Apple products
    [Tags]    stores      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    stores    GET     {"service.name":"Apple Shop"}
    should be True  ${result}


Find Stores Within 10 Miles of Beverly Hills
    [Tags]    stores      rest_api_tests
    [Documentation]   *Validate Query String provided*
    # API request format :- | api endpoint | Method | Query String | Request Data |
    ${result}   ${response}=   test api endpoint    stores    GET     {"near":"90210","service.name":"Windows%20Store"}
    should be True  ${result}

Validate Health Check Api
    [Tags]    healthcheck      rest_api_tests
    [Documentation]  *Validate Health Check*
    ${result}   ${response}=   test api endpoint    healthcheck     GET
    Run keyword and continue on Failure     should be True  ${result}
    validate response with schema   healthcheck    ${response}

Validate version Api
    [Tags]    version      rest_api_tests
    [Documentation]  *Validate Health Check*
    ${result}   ${response}=   test api endpoint    version     GET
    should be True  ${result}
    validate response with schema   version    ${response}