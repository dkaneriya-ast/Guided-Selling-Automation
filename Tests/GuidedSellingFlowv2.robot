*** Settings ***
Resource            ../Resources/PageObjects/Keywords.robot
Library             DataDriver    file=../Data/locations.xlsx

Suite Setup         Run Setup Only Once    Initialize Parallel Result Storage
Suite Teardown      Run Teardown Only Once    Write Test Results to Excel File
Test Setup          Begin Web Test
Test Teardown       End Web Test

Test Template       Execute Guided Selling Flow for All Combinations

# Run the Script
# robot -d results Tests/GuidedSellingFlow.robot
# pabot --processes 6 --testlevelsplit --variable env:dev --outputdir Results Tests/GuidedSellingFlowv2.robot

*** Test Cases ***
Run GS for all Locations

*** Keywords ***
Execute Guided Selling Flow for All Combinations
    [Arguments]    ${url}    ${locationId}    
    Perform Guided Selling Flow V2    ${url}    ${locationId}
