*** Settings ***
Resource            ../Resources/PageObjects/Keywords.robot

Test Setup          Begin Web Test
Test Teardown       End Web Test

# robot -d results/rerun Tests/LocationSpecific.robot

*** Test Cases ***
GS for coasc
    Perform Guided Selling Flow Single    https://staging.afterall.com/funeral-cremation/colorado/colorado-springs/all-states-cremation-colorado-springs/coasc.html	coasc	1	0	0	0	2	4	3

GS for coama
    Perform Guided Selling Flow Single    https://staging.afterall.com/funeral-cremation/colorado/arvada/aspen-mortuaries-arvada/coama.html	coama	2	2	4	1	2	4	2

GS for coaml
    Perform Guided Selling Flow Single    https://staging.afterall.com/funeral-cremation/colorado/lakewood/aspen-mortuaries-lakewood/coaml.html	coaml	2	2	4	1	2	4	2    