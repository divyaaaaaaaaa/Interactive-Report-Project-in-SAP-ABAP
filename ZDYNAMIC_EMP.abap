REPORT ZDYNAMIC_EMP.

"Program for Reading , Updating , Inserting & Deleting data from a table

TABLES: zBarry_emp1. "Employee Table
DATA: lt_itab   TYPE TABLE OF zBarry_emp1,  "Internal table for employee basic details table
      lwa_emp   TYPE zBarry_emp1, "Workarea for employee basic details table
      lt_itab1  TYPE TABLE OF zBarry_add, "Internal table for employee address details table
      lwa_emp1  TYPE zBarry_add, "Workarea for employee address details table
      lt_itab2  TYPE TABLE OF zBarry_sal1,  "Internal table for employee salary details table
      lwa_emp2  TYPE zBarry_sal1, "Workarea for employee salary details table
      total_sal TYPE zBarry_salary, "total salary
      tax       TYPE zBarry_salary, "total tax
      c         TYPE zBarry_salary, "tax percentage
      inhand    TYPE zBarry_salary. "inhand salary
PARAMETER: p_empid TYPE char8.
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE text-101. "selection screen block
PARAMETERS:p_rad1 RADIOBUTTON GROUP rg1 USER-COMMAND flag DEFAULT 'X',
           p_rad2 RADIOBUTTON GROUP rg1,
           p_rad3 RADIOBUTTON GROUP rg1,
           p_rad4 RADIOBUTTON GROUP rg1.
SELECTION-SCREEN END OF BLOCK blk1.


PARAMETERS:
  p_fname TYPE char20 MODIF ID pa1, "parameter for first name
  p_lname TYPE char20 MODIF ID pa2, "parameter for last name
  p_city  TYPE char20 MODIF ID pa3. "parameter for city name



AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1. "selecion of parameters on the basis of radiobutton selection
      WHEN 'PA1'.
        IF p_rad1 = 'X'.
          screen-active = '0'.
        ENDIF.
        IF p_rad2 = 'X'.
          screen-active = '1'.
        ENDIF.
        IF p_rad3 = 'X'.
          screen-active = '1'.
        ENDIF.
*
        IF p_rad4 = 'X'.
          screen-active = '0'.
        ENDIF.
        MODIFY SCREEN.
      WHEN 'PA2'.
        IF p_rad1 = 'X'.
          screen-active = '0'.
        ENDIF.
        IF p_rad2 = 'X'.
          screen-active = '1'.
        ENDIF.
        IF p_rad3 = 'X'.
          screen-active = '1'.
        ENDIF.
        IF p_rad4 = 'X'.
          screen-active = '0'.
        ENDIF.
        MODIFY SCREEN.
      WHEN 'PA3'.
        IF p_rad1 = 'X'.
          screen-active = '0'.
        ENDIF.
        IF p_rad2 = 'X'.
          screen-active = '1'.
        ENDIF.
        IF p_rad3 = 'X'.
          screen-active = '1'.
        ENDIF.
        IF p_rad4 = 'X'.
          screen-active = '0'.
        ENDIF.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.

AT SELECTION-SCREEN ON RADIOBUTTON GROUP rg1. "Auto-Popullating data in parameters
  IF p_rad3 EQ 'X'. "if update radio button is selected
    SELECT emp_fname emp_lname
         FROM zBarry_emp1
         INTO CORRESPONDING FIELDS OF TABLE lt_itab
       WHERE empid = p_empid.
    IF sy-subrc = 0.
      LOOP AT lt_itab INTO lwa_emp.
        p_fname = lwa_emp-emp_fname.
        p_lname = lwa_emp-emp_lname.
      ENDLOOP.
    ENDIF.
  ENDIF.
START-OF-SELECTION.
  IF p_rad3 EQ 'X'. "Updating data
    SELECT *
         FROM zBarry_emp1
         INTO TABLE lt_itab
         WHERE empid = p_empid.
    UPDATE zBarry_emp1 SET emp_fname = p_fname
        emp_lname = p_lname WHERE empid = p_empid.
    UPDATE zBarry_add SET city_name = p_city WHERE empid = p_empid.
    IF sy-subrc = 0.
      MESSAGE 'Employee Record Updated' TYPE 'I'.
    ELSEIF sy-subrc <> 0 .
      MESSAGE 'Wrong Employee ID3' TYPE 'E'.
      EXIT.
    ENDIF.
    EXIT.
  ENDIF.
  IF p_rad1 EQ 'X'. "Displaying Data
    SELECT *
      FROM zBarry_emp1
      INTO TABLE lt_itab
      WHERE empid = p_empid.
    IF sy-subrc = 0 .
      LOOP AT lt_itab INTO lwa_emp.
        FORMAT COLOR 1 INTENSIFIED ON. "adding dark color to headings
        WRITE: /3 'Employee Id',
                20 'First Name',
                35 'Last Name',
                70  'Date Of Birth',
                90  'Gender',
                110  'Marital Status',
                130  'Created By',
                150  'Creation Date'.
        ULINE. " FOR UNDERLINE
        FORMAT COLOR 2 INTENSIFIED ON. "adding dark color to fields
        WRITE:/3 lwa_emp-empid, 20 lwa_emp-emp_fname,35 lwa_emp-emp_lname,70 lwa_emp-dob,90 lwa_emp-gender,110 lwa_emp-marital,
        130 lwa_emp-created_by,150 lwa_emp-created_date.
      ENDLOOP.
      ULINE.
      SELECT *
     FROM zBarry_add
     INTO TABLE lt_itab1
     WHERE empid = p_empid.
      LOOP AT lt_itab1 INTO lwa_emp1.
        FORMAT COLOR 1 INTENSIFIED ON. "adding dark color to headings
        WRITE: /3 'Employee Id',
                20 'Flat No.',
                35 'Street Name',
                70  'City Name',
                90  'State',
                110  'Pincode'.
        ULINE. " FOR UNDERLINE
        FORMAT COLOR 2 INTENSIFIED ON. "adding dark color to fields
        WRITE:/3 lwa_emp1-empid, 20 lwa_emp1-flat_no, 35 lwa_emp1-street_name,70 lwa_emp1-city_name,90 lwa_emp1-state,110 lwa_emp1-pincode.
      ENDLOOP.
      ULINE.
      SELECT *
      FROM zBarry_sal1
      INTO TABLE lt_itab2
      WHERE empid = p_empid.
      LOOP AT lt_itab2 INTO lwa_emp2.
        FORMAT COLOR 1 INTENSIFIED ON. "adding dark color to headings
        WRITE: /3 'Employee Id',
                20 'Transaction ID',
                35 'Month',
                70  'Date Of Salary',
                90  'Basic Salary',
                110  'Food Card',
                130  'Transport',
                150  'Variable_M',
                170  'Variable_Q',
                190  'Medical',
                210  'Others'.
        ULINE. " FOR UNDERLINE
        FORMAT COLOR 2 INTENSIFIED ON. "adding dark color to fields

        WRITE:/3 lwa_emp2-empid,20 lwa_emp2-tid,35 lwa_emp2-mon,70 lwa_emp2-dos,90 lwa_emp2-bs,110 lwa_emp2-fc,130 lwa_emp2-transport,
        150 lwa_emp2-variable_m,170 lwa_emp2-variable_q,190 lwa_emp2-medical,210 lwa_emp2-others.
      ENDLOOP.
      ULINE.
      total_sal = lwa_emp2-bs + lwa_emp2-fc + lwa_emp2-transport + lwa_emp2-variable_m +
      lwa_emp2-variable_q + lwa_emp2-medical + lwa_emp2-others. "total salary calculated
      WRITE:/ 'Total Salary = ', total_sal.
      IF total_sal < 10000.
        WRITE: 'Voila! No Tax'.
      ELSEIF ( 10000 < total_sal AND total_sal <  35000 ).
        c = 5 / 100.
        tax = c * total_sal. "total tax calculated when 10000< total salary <35000
        WRITE : / 'Tax = ', tax.
      ELSEIF ( 30000 < total_sal AND total_sal <  50000 ).
        c = 10 / 100.
        tax = c * total_sal. "total tax calculated when 30000 < total salary <50000
        WRITE : / 'Tax = ', tax.
      ELSEIF total_sal > 50000.
        c = 15 / 100.
        tax = c * total_sal. "total tax calculated when total salary >50000
        WRITE : / 'Tax = ', tax.
      ENDIF.
      inhand = total_sal - tax. "inhand salary
      WRITE : / 'Inhand Salary' , inhand.
    ELSEIF sy-subrc <> 0 .
      MESSAGE 'Wrong Employee ID1' TYPE 'E'.
      EXIT.
    ENDIF.
  ENDIF.

  IF p_rad2 EQ 'X'. "Inserting Data
    lwa_emp-empid = p_empid.
    lwa_emp-emp_fname = p_fname.
    lwa_emp-emp_lname = p_lname.
    lwa_emp1-empid = p_empid.
    lwa_emp1-city_name = p_city.
    INSERT zBarry_emp1 FROM lwa_emp.
    INSERT zBarry_add FROM lwa_emp1.
    IF sy-subrc = 0.
      MESSAGE 'Employee Record Inserted' TYPE 'I'.
    ELSEIF sy-subrc <> 0 .
      MESSAGE 'Wrong Employee ID2' TYPE 'E'.
      EXIT.
    ENDIF.
    EXIT.
  ENDIF.

  IF p_rad4 EQ 'X'. "Deleting Data
    DELETE FROM zBarry_emp WHERE empid = p_empid.
    IF sy-subrc = 0.
      MESSAGE 'Employee Record Deleted' TYPE 'I'.
    ELSEIF sy-subrc <> 0 .
      MESSAGE 'Wrong Employee ID4' TYPE 'E'.
      EXIT.
    ENDIF.
  ENDIF.
