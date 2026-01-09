REPORT ZINTERACTIVE_DEMO.

TABLES zBarry_emp.
TABLES zBarry_sal.
DATA : it_emp1 TYPE TABLE OF zBarry_emp,
       it_emp2 TYPE TABLE OF zBarry_sal,
       wa_emp  TYPE zBarry_emp,
       wa_emp2 TYPE zBarry_sal,
       it_emp3 TYPE TABLE OF zBarry_add,
       wa_emp3 TYPE zBarry_add,
       fnam    TYPE char20,
       fval    TYPE INT4,
       fnam1   TYPE char20,
       fval1   TYPE INT4.
set PF-STATUS 'PFSTATUS'.
SELECT-OPTIONS : p_empid FOR zBarry_emp-empid.
AT USER-COMMAND.
CASE SY-UCOMM.
    WHEN 'MAIN'.
     sy-lsind = 1.
     PERFORM display_data.
  ENDCASE.
AT SELECTION-SCREEN.
  PERFORM validate_input.
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM display_data.
TOP-OF-PAGE.
  FORMAT COLOR COL_HEADING INVERSE.
  WRITE 'BASIC EMPLOYEE DETAILS'.
TOP-OF-PAGE DURING LINE-SELECTION.
  IF sy-lsind = 1.
    FORMAT COLOR COL_HEADING INVERSE.
    WRITE 'EMPLOYEE SALARY DETAILS'.
  ELSEIF sy-lsind = 2.
    FORMAT COLOR COL_HEADING INVERSE.
    WRITE 'EMPLOYEE ADDRESS DETAILS'.
  ENDIF.
AT LINE-SELECTION.
  PERFORM primary_list.
  PERFORM secondary_list.


*&---------------------------------------------------------------------*
*&      Form  VALIDATE_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_input . "validating input
  IF p_empid  IS INITIAL.
    MESSAGE 'Please Enter Employee Number' TYPE 'E'. "if the employee id field is left blank
  ELSE.
    SELECT empid FROM zBarry_emp INTO TABLE it_emp1 WHERE empid IN p_empid.
    IF sy-subrc <> 0.
      MESSAGE 'Please Enter Correct Employee Number' TYPE 'E'. "if wrong employee id is entered
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data . "fetching basic employee details from table
  SELECT * FROM zBarry_emp INTO TABLE it_emp1 WHERE empid IN p_empid.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data . "displaying data
  FORMAT COLOR COL_NEGATIVE INVERSE.
  WRITE:/,3 'Employee ID',
      20 'First NAME',
      35 'Last NAME'.
  SKIP.
  LOOP AT it_emp1 INTO wa_emp.
    FORMAT COLOR COL_POSITIVE INVERSE.
    WRITE : /3 wa_emp-empid,20 wa_emp-FNAME,35 wa_emp-LNAME.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRIMARY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM primary_list . "fetching employee salary details on list 1
  IF sy-lsind = 1.
    GET CURSOR FIELD fnam VALUE fval.
    IF fnam =  'WA_EMP-EMPID'. "if employee id is selected
      SELECT * FROM zBarry_sal INTO TABLE it_emp2 WHERE empid = fval .
      FORMAT COLOR COL_NEGATIVE INVERSE.
      WRITE:/,3 'Employee ID',
               20 'Transaction ID',
               35 'Month',
               55 'Date Of Salary'.
      SKIP.
      LOOP AT it_emp2 INTO wa_emp2.
        FORMAT COLOR COL_POSITIVE INVERSE.
        WRITE : /3 wa_emp2-empid,20 wa_emp2-tid,35 wa_emp2-mon,55 wa_emp2-dos.
      ENDLOOP.
    ENDIF.
    IF  fnam = 'WA_EMP-EMP_FNAME'. "if employee name is selected
      WRITE: / 'name'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SECONDARY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM secondary_list . "fetching employee address details on list 2
  IF sy-lsind = 2.
    GET CURSOR FIELD fnam1 VALUE fval1.
    IF fnam =  'WA_EMP-EMPID'. "if employee id is selected
      SELECT * FROM zBarry_add INTO TABLE it_emp3 WHERE empid = fval1 .
      FORMAT COLOR COL_NEGATIVE INVERSE.
      WRITE:/,3 'Employee ID',
               20 'Flat No.',
               35 'Street Name',
               55 'City Name'.
      SKIP.
      LOOP AT it_emp3 INTO wa_emp3.
        FORMAT COLOR COL_POSITIVE INVERSE.
        WRITE : /3 wa_emp3-empid,20 wa_emp3-flat_no,35 wa_emp3-street_name,55 wa_emp3-city_name.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
