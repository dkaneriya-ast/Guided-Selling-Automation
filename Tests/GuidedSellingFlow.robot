*** Settings ***
Resource            ../Resources/Common.robot
Library             DataDriver    file=Data/locations.xlsx
Library             Collections
Library             String
Library             ExcelSage
Library             pabot.PabotLib

Suite Setup         Run Setup Only Once    Initialize Parallel Result Storage
Suite Teardown      Run Teardown Only Once    Write Test Results to Excel File
Test Setup          Begin Web Test
Test Teardown       End Web Test
Test Template       Execute Guided Selling Flow for All Combinations
# Run the Script
# robot -d results Tests/GuidedSellingFlow.robot
# pabot --processes 2 --testlevelsplit --outputdir Results Tests/GuidedSellingFlow.robot


*** Variables ***
# interaction locators
${rejectCookies}=                   xpath://a[@aria-controls="consent-dialog" and contains(text(), "Accept Without Tracking")]
${locationName}=                    xpath://h1[@class="b-location_details-title"]
${arrangeOnline}=                   xpath://button[contains(@class, 'b-location_details-btn') and contains(text(), 'Arrange Online')]
${startPlanning}=                   xpath://button[@data-widget-event-click="startPlanning"]
${immediateNeedRadio}=              xpath://span[normalize-space(text())="I need to arrange a service now"]

# loved one inputs
${lovedOneDetailsStep}=             xpath://h2[normalize-space(text())="To help guide you through this process, we’ll need a few details about your loved one before we continue."]
${dateOfPassingInput}=              xpath://input[@name="dwfrm_guidedSelling_date"]
${dateOfPassingLabel}=              xpath://label[@for="dwfrm_guidedSelling_date"]

# owner inputs
${personalDetailsStep}=             xpath://h2[normalize-space(text())="Now, we just need a few details about you so we can assist you through this process."]
${ownerPhoneNumberInput}=           xpath://input[@name="dwfrm_guidedSelling_phone"]
${ownerEmailAddressInput}=          xpath://input[@name="dwfrm_guidedSelling_email"]
${ownerRelationShip}=               xpath://select[@id="dwfrm_guidedSelling_relationship"]

${firstNameInput}=                  xpath://input[@name="dwfrm_guidedSelling_firstName"]
${lastNameInput}=                   xpath://input[@name="dwfrm_guidedSelling_lastName"]

# get all disposition and service options
${disposition&serviceOptions}=      xpath://label[@class="b-radio_custom-label"]//span

# get all service options
${serviceDetailsStep}=              xpath://h2[normalize-space(text())="Some families prefer a gathering or ceremony to honor their loved one, while others choose a simpler approach."]

# get all packages
${packageOptions}=                  xpath://thead//th[contains(@class, "b-gs_table-heading_cell")][position() > 1]

${continueCTA}=                     xpath://button[@type="submit" and @name="dwfrm_guidedSelling_continue"]

# active plan found popup
${activePlanFoundPopup}=            xpath://h2[@class="b-dialog-title" and normalize-space(text())="Active Plan Found"]
${startNewCTA}=                     xpath://button[normalize-space(text())="Start New"]

# test data for Loved Ones
${lovedOneFirstName}=               Test
${lovedOneLastName}=                Test
${dateOfPassing}=                   07012025

# test data for Owner
${ownerFirstName}=                  Test
${ownerLastName}=                   Test
${ownerPhoneNumber}=                +1(987) 654-3210
${ownerEmailAddress}=               d.kaneriya+test@astoundigital.com
${ownerRelationShipValue}=          Uncle

@{rowHeader}=                       Location Name    Location ID    Disposition    Service    Package Count


*** Test Cases ***
Verify All Location-Driven Package Combinations


*** Keywords ***
Initialize Parallel Result Storage
    Set Parallel Value For Key    testResultsGlobal    ${EMPTY}

Write Test Results to Excel File
    ${testResults}=    Get Parallel Value For Key    testResultsGlobal
    @{testResults}=    Split String    ${testResults}    separator=\n
    Create Workbook    Results/results.xlsx    overwrite=True
    Insert Row    row_index=1    row_data=${rowHeader}
    ${row}=    Set Variable    2
    FOR    ${rowData}    IN    @{testResults}
        ${cols}=    Split String    ${rowData}    separator=|
        Insert Row    row_index=${row}    row_data=${cols}
        ${row}=    Evaluate    ${row} + 1
    END
    Save WorkBook

Open Storefront and Accept Cookies
    Go To    ${env}
    Wait Until Element Is Visible    ${rejectCookies}
    Click Element    ${rejectCookies}
    Wait Until Element Is Not Visible    ${rejectCookies}

Fetch All Disposition Options
    Wait Until Element Is Visible    ${disposition&serviceOptions}
    @{options}=    Get WebElements    ${disposition&serviceOptions}
    RETURN    @{options}

Fetch All Service Method Options
    Wait Until Element Is Visible    ${serviceDetailsStep}
    Wait Until Element Is Visible    ${disposition&serviceOptions}
    @{services}=    Get WebElements    ${disposition&serviceOptions}
    RETURN    @{services}

Get Package Count for Current Selection
    Wait Until Element Is Visible    ${packageOptions}
    ${packages}=    Get WebElements    ${packageOptions}
    ${count}=    Get Length    ${packages}
    RETURN    ${count}

Start Guided Selling Until Disposition Step
    [Arguments]    ${url}
    Go To    ${url}
    # arrange Online click
    Wait Until Element Is Visible    ${arrangeOnline}
    Click Element    ${arrangeOnline}

    # start planning inside GS
    Wait Until Element Is Visible    ${startPlanning}
    Click Element    ${startPlanning}

    # check and close active plan popup if present
    ${isPopupPresent}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${activePlanFoundPopup}
    ...    timeout=3s
    IF    '${isPopupPresent}' == 'True'    Click Element    ${startNewCTA}

    # choose immediate need
    Wait Until Page Contains Element    ${immediateNeedRadio}
    Click Element    ${immediateNeedRadio}

    # enter loved one details
    Wait Until Element Is Visible    ${lovedOneDetailsStep}
    Wait Until Element Is Visible    ${firstNameInput}
    Input Text    ${firstNameInput}    ${lovedOneFirstName}
    Wait Until Element Is Visible    ${lastNameInput}
    Input Text    ${lastNameInput}    ${lovedOneLastName}
    Wait Until Element Is Visible    ${dateOfPassingLabel}
    Mouse Down    ${dateOfPassingLabel}
    Mouse Up    ${dateOfPassingLabel}
    Sleep    1s
    Press Keys    ${dateOfPassingInput}    ${dateOfPassing}
    Wait Until Element Is Visible    ${continueCTA}
    Click Element    ${continueCTA}

    # enter personal details
    Wait Until Element Is Visible    ${personalDetailsStep}
    Wait Until Element Is Visible    ${firstNameInput}
    Input Text    ${firstNameInput}    ${ownerFirstName}
    Wait Until Element Is Visible    ${lastNameInput}
    Input Text    ${lastNameInput}    ${ownerLastName}
    Wait Until Element Is Visible    ${ownerPhoneNumberInput}
    Input Text    ${ownerPhoneNumberInput}    ${ownerPhoneNumber}
    Wait Until Element Is Visible    ${ownerEmailAddressInput}
    Input Text    ${ownerEmailAddressInput}    ${ownerEmailAddress}
    Select From List By Label    ${ownerRelationShip}    ${ownerRelationShipValue}
    ${nextStep}=    Get WebElement    ${continueCTA}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${nextStep}

Execute Guided Selling Flow for All Combinations
    [Arguments]    ${url}    ${locationId}
    Open Storefront and Accept Cookies
    # Step 1: Get all disposition options
    Start Guided Selling Until Disposition Step    ${url}
    ${location}=    Get Text    ${locationName}
    @{dispositionOptions}=    Fetch All Disposition Options
    ${dispositionLength}=    Get Length    ${dispositionOptions}
    FOR    ${dispIndex}    IN RANGE    ${dispositionLength}
        @{dispositionOptions}=    Fetch All Disposition Options
        ${disposition}=    Get From List    ${dispositionOptions}    ${dispIndex}
        ${dispLabel}=    Get Text    ${disposition}
        Click Element    ${disposition}
        Click Element    ${continueCTA}

        # Step 2: Get all service method options
        @{serviceOptions}=    Fetch All Service Method Options
        ${serviceLength}=    Get Length    ${serviceOptions}
        FOR    ${serviceIndex}    IN RANGE    ${serviceLength}
            IF    ${serviceIndex} != 0
                @{dispositionOptions}=    Fetch All Disposition Options
                ${disposition}=    Get From List    ${dispositionOptions}    ${dispIndex}
                ${dispLabel}=    Get Text    ${disposition}
                Click Element    ${disposition}
                Click Element    ${continueCTA}
            END
            @{serviceOptions}=    Fetch All Service Method Options
            ${service}=    Get From List    ${serviceOptions}    ${serviceIndex}
            ${serviceLabel}=    Get Text    ${service}
            IF    '${serviceLabel}' == 'A private viewing, service, or celebration at church, funeral home, or other location'
                ${serviceLabel}=    Set Variable    Facilities
            ELSE IF    '${serviceLabel}' == 'No formal service. Just the Burial selection' or '${serviceLabel}' == 'No formal service. Just the Cremation selection'
                ${serviceLabel}=    Set Variable    No Facilities
            ELSE IF    '${serviceLabel}' == 'I’m not sure yet'
                ${serviceLabel}=    Set Variable    All
            END
            ${service}=    Get WebElement    ${service}
            Execute Javascript    arguments[0].click();    ARGUMENTS    ${service}
            # Step 3: Package count
            ${packageCount}=    Get Package Count for Current Selection

            # Log the full combination
            Log
            ...    Package Combination - Location: ${location} | ${locationId} | Disposition: ${dispLabel} | Service: ${serviceLabel} | Packages: ${packageCount}
            Log To Console
            ...    Package Combination - Location: ${location} | ${locationId} | Disposition: ${dispLabel} | Service: ${serviceLabel} | Packages: ${packageCount}
            ${dataRow}=    Catenate
            ...    SEPARATOR=|
            ...    ${location}
            ...    ${locationId}
            ...    ${dispLabel}
            ...    ${serviceLabel}
            ...    ${packageCount}
            Acquire Lock    result
            ${existing}=    Get Parallel Value For Key    testResultsGlobal
            IF    $existing == 'NONE'
                ${existing}=    Set Variable    ${dataRow}
            ELSE
                ${existing}=    Catenate    SEPARATOR=\n    ${existing}    ${dataRow}
            END
            Set Parallel Value For Key    testResultsGlobal    ${existing}
            Release Lock    result
            ${isLastService}=    Evaluate    ${serviceIndex} == ${serviceLength}-1
            ${isLastDisposition}=    Evaluate    ${dispIndex} == ${dispositionLength}-1
            IF    not (${isLastService} and ${isLastDisposition})
                Start Guided Selling Until Disposition Step    ${url}
            END
        END
    END