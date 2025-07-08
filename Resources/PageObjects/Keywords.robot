*** Settings ***
Resource            ../Resources/Common.robot
Resource            Locators.robot
Library             Collections
Library             String
Library             ExcelSage
Library             pabot.PabotLib

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

Perform Guided Selling Flow
    [Arguments]    ${url}    ${locationId}    ${expectedDispositionOptions}    ${expectedBurialServiceOptions}    ${expectedBurialFacilities}    ${expectedBurialNoFacilities}    ${expectedCremationServiceOptions}    ${expectedCremationFacilities}    ${expectedCremationNoFacilities}
    Open Storefront and Accept Cookies
    # Step 1: Get all disposition options
    Start Guided Selling Until Disposition Step    ${url}
    ${location}=    Get Text    ${locationName}
    @{dispositionOptions}=    Fetch All Disposition Options
    ${dispositionLength}=    Get Length    ${dispositionOptions}

    IF    ${dispositionLength} == 0
        Fail    No disposition options found for Location ID: ${locationId}
    END

    IF    ${dispositionLength} != ${expectedDispositionOptions}
        Fail    Disposition count mismatch at Location ID: ${locationId}. Expected ${expectedDispositionOptions}, but found ${dispositionLength}.
    END

    FOR    ${dispIndex}    IN RANGE    ${dispositionLength}
        @{dispositionOptions}=    Fetch All Disposition Options
        ${disposition}=    Get From List    ${dispositionOptions}    ${dispIndex}
        ${dispLabel}=    Get Text    ${disposition}
        Click Element    ${disposition}
        Click Element    ${continueCTA}

        # Step 2: Get all service method options
        @{serviceOptions}=    Fetch All Service Method Options
        ${serviceLength}=    Get Length    ${serviceOptions}
        
        
        IF    ${serviceLength} == 0
            Fail    No service method options found for Disposition: ${dispLabel} at Location ID: ${locationId}
        END
        ${expectedBurialServiceTotalOptions}=    Evaluate    ${expectedBurialServiceOptions} + 1
        IF    '${dispLabel}' == 'Burial' and ${serviceLength} != ${expectedBurialServiceTotalOptions}
            Fail    Service count mismatch for Burial at Location ID: ${locationId}. Expected ${expectedBurialServiceTotalOptions}, but found ${serviceLength}.
        END
        ${expectedCremationServiceTotalOptions}=    Evaluate    ${expectedCremationServiceOptions} + 1
        IF    '${dispLabel}' == 'Cremation' and ${serviceLength} != ${expectedCremationServiceTotalOptions}
            Fail    Service count mismatch for Cremation at Location ID: ${locationId}. Expected ${expectedCremationServiceTotalOptions}, but found ${serviceLength}.
        END

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
            IF    ${packageCount} == 0
                Fail    No packages found for Disposition: ${dispLabel}, Service: ${serviceLabel} at Location ID: ${locationId}
            END
            IF    '${dispLabel}' == 'Burial' and '${serviceLabel}' == 'Facilities' and ${packageCount} != ${expectedBurialFacilities}
               Fail    Package count mismatch for Burial - Facilities at Location ID ${locationId}. Expected ${expectedBurialFacilities}, but found ${packageCount}.
            END
            IF    '${dispLabel}' == 'Burial' and '${serviceLabel}' == 'No Facilities' and ${packageCount} != ${expectedBurialNoFacilities}
                Fail    Package count mismatch for Burial - No Facilities at Location ID ${locationId}. Expected ${expectedBurialNoFacilities}, but found ${packageCount}.
            END
            ${expectedBurialTotal}=    Evaluate    ${expectedBurialNoFacilities} + ${expectedBurialFacilities}
            IF    '${dispLabel}' == 'Burial' and '${serviceLabel}' == 'All' and ${packageCount} != ${expectedBurialTotal}
                Fail    Package count mismatch for Burial - All at Location ID ${locationId}. Expected ${expectedBurialNoFacilities}, but found ${packageCount}.
            END
            IF    '${dispLabel}' == 'Cremation' and '${serviceLabel}' == 'Facilities' and ${packageCount} != ${expectedCremationFacilities}
                Fail    Package count mismatch for Cremation - Facilities at Location ID ${locationId}. Expected ${expectedCremationFacilities}, but found ${packageCount}.
            END
            IF    '${dispLabel}' == 'Cremation' and '${serviceLabel}' == 'No Facilities' and ${packageCount} != ${expectedCremationNoFacilities}
                Fail    Package count mismatch for Cremation - No Facilities at Location ID ${locationId}. Expected ${expectedCremationNoFacilities}, but found ${packageCount}.
            END
            ${expectedCremationTotal}=    Evaluate    ${expectedCremationNoFacilities} + ${expectedCremationFacilities}
            IF    '${dispLabel}' == 'Cremation' and '${serviceLabel}' == 'All' and ${packageCount} != ${expectedCremationTotal}
                Fail    Package count mismatch for Cremation - All at Location ID ${locationId}. Expected ${expectedCremationTotal}, but found ${packageCount}.
            END
            
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