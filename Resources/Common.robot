*** Settings ***
Library     SeleniumLibrary
Resource    Instance.robot


*** Keywords ***
Begin Web Test
    open browser    about:blank    firefox
    maximize browser window
    set selenium timeout    15s

End Web Test
    close all browsers
