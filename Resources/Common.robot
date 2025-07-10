*** Settings ***
Library     SeleniumLibrary
Resource    Instance.robot


*** Keywords ***
Begin Web Test
    open browser    about:blank    edge    options=add_argument("--headless=new")
    Set Window Size    1920    1080
    # open browser    about:blank    firefox
    # maximize browser window
    set selenium timeout    15s

End Web Test
    close all browsers
