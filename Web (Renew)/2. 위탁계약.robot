*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    String
Library    RequestsLibrary
Library    BuiltIn
Resource   ../support/keywords.robot
Library    Process
Library    DateTime
Resource    ../.secrets.robot

Suite Setup    Initialize Test Suite
Suite Teardown    Finalize Test Suite

*** Variables ***
${lastBizReNo}    None
${bizNo}    None


*** Keywords ***
Get Unused Biz Number
    ${files}=         List Files In Directory    ${unused_bizRegNo_DIR}   pattern=bizRegNo_*.txt
    ${random_index}=  Evaluate    random.randint(0, len(${files}) - 1)    modules=random
    ${file}=          Get From List    ${files}    ${random_index}
    ${path}=          Catenate    SEPARATOR=/    ${unused_bizRegNo_DIR}    ${file}
    
    ${content}=       Get File    ${path}
    ${lines}=         Split To Lines    ${content}
    Run Keyword Unless    ${lines}    Fatal Error    사용 가능한 사업자번호가 없습니다: ${file}

    ${last}=          Get From List    ${lines}    -1
    Remove From List  ${lines}    -1
    ${new_content}=   Catenate    SEPARATOR=\n    @{lines}
    Create File       ${path}    ${new_content}
    
    Log To Console    \n선택된 파일 : ${file}
    Log To Console    사용된 사업자번호 : ${last}

    [Return]          ${last}

Get Absolute File Path
    [Arguments]    ${relative_path}
    ${abs}=    Normalize Path    ${EXECDIR}/${relative_path}
    [Return]    ${abs}


*** Test Cases ***
---- Testcase
    Wait Until Element Is Visible    xpath=//img[contains(@src, 'logo_200.25f0e37e.png')]    5

    Input Text    name=email    ${id_1}
    Press Key    name=password    ${password}
    Sleep    1
    Click Button    xpath=//button[text()='로그인']
    Sleep    3





    ##### 가입된 업체 추가 
    # 업체 추가하기 
    Click Button    css=button[title="작성하기"]
    Sleep    2

    # 직전 회원가입한 사업자번호 입력
    ${lastBizReNo}=    Get Last BizRegNo From File
    Set Suite Variable    ${lastBizReNo}
    Log To Console    ${lastBizReNo}
    Press Key    id=bizNumber    ${lastBizReNo}
    Sleep    2
    Click Button    xpath=//button[text()='확인하기']
    Sleep    2

    # 위탁업체 추가하기 
    Wait Until Element Is Visible    class=text-lg    5
    
    # 관리코드
    ${datetime}=    Evaluate    __import__('datetime').datetime.now().strftime('%m%d-%H%M')
    ${managementCode}=    Set Variable    ${datetime}
    Press Key    name=managementCode    ${managementCode}
    
    # 담당자 이름
    Press Key    name=managerName    자동화
    
    ## 담당자 휴대폰 번호 
    ${random_number}=    Evaluate    str(__import__('random').randint(10000000, 99999999))
    ${phone_number}=    Set Variable    010${random_number}
    Press Key    name=managerPhone    ${phone_number}
    
    # 담당자 이메일 
    Press Key    name=managerEmail    auto@mation.com
    Sleep    1 
    
    # 추가하기
    Click Button    xpath=//button[text()='추가하기']
    Sleep    1

    # 확인버튼
    Wait Until Element Is Visible    xpath=//button[normalize-space(.)='나중에']    5
    Click Button    xpath=//button[normalize-space(.)='나중에']
    Sleep    2

    Go Back
    Sleep    1



    ##### 미가입사용자 추가 
    # 업체 추가하기 
    Click Button    css=button[title="작성하기"]
    Sleep    2
    
    ${bizNo}=    Get Unused Biz Number
    Press Key    id=bizNumber    ${bizNo}
    Sleep    2

    Click Button    xpath=//button[text()='확인하기']
    Sleep    2

    # 모달 waiting
    Wait Until Element Is Visible    class=space-y-4    5

    # 파일 첨부    
    ${abs_path}=    Normalize Path    ${testfile_PATH}
    Choose File     xpath=//*[@id="bizRegCertFileUuid"]//input    ${abs_path}
    Sleep    1
    Choose File     xpath=//*[@id="salesCertFileUuid"]//input    ${abs_path}
    Sleep    1

    # 관리코드
    ${datetime}=    Evaluate    __import__('datetime').datetime.now().strftime('%m%d-%H%M')
    ${managementCode}=    Set Variable    ${datetime}
    Press Key    name=managementCode    ${managementCode}.
    
    # 담당자 이름
    Press Key    name=managerName    자동화

    ## 담당자 휴대폰 번호 
    ${random_number}=    Evaluate    str(__import__('random').randint(10000000, 99999999))
    ${phone_number}=    Set Variable    010${random_number}
    Press Key    name=managerPhone    ${phone_number}
    
    # 담당자 이메일 
    Press Key    name=managerEmail    auto@mation.com
    Sleep    1 

    # 추가하기
    Click Button    xpath=//button[text()='추가하기']
    Sleep    1

    # 확인버튼
    Wait Until Element Is Visible    xpath=//button[normalize-space(.)='확인']    5
    Click Button    xpath=//button[normalize-space(.)='확인']
    Sleep    2

    Go Back
    Sleep    1



    Press Keys    NONE    ESC
    
    Sleep    2

