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
# pabot --processes 2 --testlevelsplit --outputdir Results Tests/GuidedSellingFlow.robot


*** Test Cases ***
Run GS for ${locationId}

*** Keywords ***
Execute Guided Selling Flow for All Combinations
    [Arguments]    ${url}    ${locationId}    ${expectedDispositionOptions}    ${expectedBurialServiceOptions}    ${expectedBurialFacilities}    ${expectedBurialNoFacilities}    ${expectedCremationServiceOptions}    ${expectedCremationFacilities}    ${expectedCremationNoFacilities}
    Perform Guided Selling Flow    ${url}    ${locationId}    ${expectedDispositionOptions}    ${expectedBurialServiceOptions}    ${expectedBurialFacilities}    ${expectedBurialNoFacilities}    ${expectedCremationServiceOptions}    ${expectedCremationFacilities}    ${expectedCremationNoFacilities}