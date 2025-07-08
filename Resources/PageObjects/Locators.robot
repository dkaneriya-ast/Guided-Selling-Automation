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