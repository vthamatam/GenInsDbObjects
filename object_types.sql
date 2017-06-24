DROP TYPE XXGEN_INSURED_OBJ_TAB_TYPE
/
DROP TYPE XXGEN_INSURED_OBJ_TYPE
/
DROP TYPE XXGEN_INS_ADDR_OBJ_TAB_TYPE
/
DROP TYPE XXGEN_INSURED_ADDR_OBJ_TYPE
/
drop type XXGEN_POLICY_TAB_OBJ_TYPE
/
drop type XXGEN_POLICY_OBJ_TYPE
/
drop type XXGEN_POL_ENDORSE_TAB_OBJ_TYPE
/
drop type XXGEN_POL_ENDORSE_OBJ_TYPE
/
drop type XXGEN_veh_dtls_tab_obj_type
/
drop type xxitm_vehicle_dtls_obj_type
/
drop type XXGEN_POL_DRIVER_tab_obj_type
/
drop type xxitm_pol_driver_dtls_obj_type
/
drop type XXGEN_RISK_tab_obj_type
/
drop type xxitm_risk_dtls_obj_type
/
CREATE OR REPLACE
TYPE  XXGEN_INSURED_ADDR_OBJ_TYPE AS OBJECT (
        INSURED_ADDR_ID NUMBER (10),
		INSURED_ID NUMBER(20),
		ADDRESS_TYPE VARCHAR2(200),--TEMPORARY OR PERMANENT
		ADDRESS_STATUS VARCHAR2(20),
		INSURED_ADDR1    VARCHAR2(200),
		INSURED_ADDR2    VARCHAR2(200),
		INSURED_CITY    VARCHAR2(200),
		INSURED_STATE    VARCHAR2(200),
		INSURED_COUNTRY    VARCHAR2(200),
		INSURED_PINCODE    VARCHAR2(200),
		Phone        number(15),
		email        varchar2(200),
   CONSTRUCTOR FUNCTION XXGEN_INSURED_ADDR_OBJ_TYPE
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION XXGEN_INSURED_ADDR_OBJ_TYPE (
        INSURED_ADDR_ID_I NUMBER,
		INSURED_ID_I NUMBER,
		ADDRESS_TYPE_I VARCHAR2,--TEMPORARY OR PERMANENT
		ADDRESS_STATUS_I VARCHAR2,
		INSURED_ADDR1_I    VARCHAR2,
		INSURED_ADDR2_I    VARCHAR2,
		INSURED_CITY_I    VARCHAR2,
		INSURED_STATE_I    VARCHAR2,
		INSURED_COUNTRY_I    VARCHAR2,
		INSURED_PINCODE_I    VARCHAR2,
		Phone_I        number,
		email_I        varchar2
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      XXGEN_INSURED_ADDR_OBJ_TYPE
AS
   CONSTRUCTOR FUNCTION XXGEN_INSURED_ADDR_OBJ_TYPE
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.INSURED_ADDR_ID := '';
      SELF.INSURED_ID := '';
      SELF.ADDRESS_TYPE := '';
      SELF.ADDRESS_STATUS := '';
      SELF.INSURED_ADDR1 := '';
      SELF.INSURED_ADDR2 := '';
      SELF.INSURED_CITY := '';
      SELF.INSURED_STATE := '';
	  SELF.INSURED_COUNTRY := '';
	  SELF.INSURED_PINCODE := '';
	  SELF.Phone := '';
	  SELF.email := '';
      RETURN;
   END;

   CONSTRUCTOR FUNCTION XXGEN_INSURED_ADDR_OBJ_TYPE (
      INSURED_ADDR_ID_I NUMBER,
		INSURED_ID_I NUMBER,
		ADDRESS_TYPE_I VARCHAR2,--TEMPORARY OR PERMANENT
		ADDRESS_STATUS_I VARCHAR2,
		INSURED_ADDR1_I    VARCHAR2,
		INSURED_ADDR2_I    VARCHAR2,
		INSURED_CITY_I    VARCHAR2,
		INSURED_STATE_I    VARCHAR2,
		INSURED_COUNTRY_I    VARCHAR2,
		INSURED_PINCODE_I    VARCHAR2,
		Phone_I        number,
		email_I        varchar2
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.INSURED_ADDR_ID := INSURED_ADDR_ID_I;
      SELF.INSURED_ID := INSURED_ID_I;
      SELF.ADDRESS_TYPE := ADDRESS_TYPE_I;
      SELF.ADDRESS_STATUS := ADDRESS_STATUS_I;
      SELF.INSURED_ADDR1 := INSURED_ADDR1_I;
      SELF.INSURED_ADDR2 := INSURED_ADDR2_I;
      SELF.INSURED_CITY := INSURED_CITY_I;
      SELF.INSURED_STATE := INSURED_STATE_I;
	  SELF.INSURED_COUNTRY := INSURED_COUNTRY_I;
	  SELF.INSURED_PINCODE := INSURED_PINCODE_I;
	  SELF.Phone := PHONE_I;
	  SELF.email := EMAIL_I;
      RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_INS_ADDR_OBJ_TAB_TYPE IS TABLE OF XXGEN_INSURED_ADDR_OBJ_TYPE
/
CREATE OR REPLACE
TYPE  XXGEN_INSURED_OBJ_TYPE AS OBJECT (
        INSURED_ID NUMBER(10),
		INSURED_NAME VARCHAR2(200),
		INSURED_DOB DATE,
		INSURED_PHONE NUMBER(20),
		INSURED_QUALIFICATION VARCHAR2(200),
		INSURED_PROFISSION VARCHAR2(200),
		INSURED_ADDR XXGEN_INS_ADDR_OBJ_TAB_TYPE,
   CONSTRUCTOR FUNCTION XXGEN_INSURED_OBJ_TYPE
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION XXGEN_INSURED_OBJ_TYPE (
        INSURED_ID_I NUMBER,
		INSURED_NAME_I VARCHAR2,
		INSURED_DOB_I DATE,
		INSURED_PHONE_I NUMBER,
		INSURED_QUALIFICATION_I VARCHAR2,
		INSURED_PROFISSION_I VARCHAR2,
		INSURED_ADDR_I XXGEN_INS_ADDR_OBJ_TAB_TYPE
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      XXGEN_INSURED_OBJ_TYPE
AS
   CONSTRUCTOR FUNCTION XXGEN_INSURED_OBJ_TYPE
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.INSURED_ID := '';
      SELF.INSURED_NAME := '';
      SELF.INSURED_DOB := '';
      SELF.INSURED_PHONE := '';
      SELF.INSURED_QUALIFICATION := '';
      SELF.INSURED_PROFISSION := '';
      SELF.INSURED_ADDR :=XXGEN_INS_ADDR_OBJ_TAB_TYPE();
      
      RETURN;
   END;

   CONSTRUCTOR FUNCTION XXGEN_INSURED_OBJ_TYPE (
      INSURED_ID_I NUMBER,
		INSURED_NAME_I VARCHAR2,
		INSURED_DOB_I DATE,
		INSURED_PHONE_I NUMBER,
		INSURED_QUALIFICATION_I VARCHAR2,
		INSURED_PROFISSION_I VARCHAR2,
		INSURED_ADDR_I XXGEN_INS_ADDR_OBJ_TAB_TYPE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.INSURED_ID := INSURED_ID_I;
      SELF.INSURED_NAME := INSURED_NAME_I;
      SELF.INSURED_DOB := INSURED_DOB_I;
      SELF.INSURED_PHONE := INSURED_PHONE_I;
      SELF.INSURED_QUALIFICATION := INSURED_QUALIFICATION_I;
      SELF.INSURED_PROFISSION := INSURED_PROFISSION_I;
      SELF.INSURED_ADDR := INSURED_ADDR_I;
      RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_INSURED_OBJ_TAB_TYPE IS TABLE OF XXGEN_INSURED_OBJ_TYPE
/
--======================
CREATE OR REPLACE
TYPE  XXGEN_POL_ENDORSE_OBJ_TYPE AS OBJECT (
        ENDORSE_ID number(20), 
        POLICY_NO NUMBER(20),
        ENDORSE_CODE number(20),
        ENDDORSE_TRX_TYPE VARCHAR2(5), 
        ENDORSE_SI NUMBER(20,2),
        FINANCIAL_IMPACT VARCHAR2(5),
        ENDORSE_DATE DATE,
   CONSTRUCTOR FUNCTION XXGEN_POL_ENDORSE_OBJ_TYPE
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION XXGEN_POL_ENDORSE_OBJ_TYPE (
        ENDORSE_ID_i number, 
        POLICY_NO_i NUMBER,
        ENDORSE_CODE_i number,
        ENDDORSE_TRX_TYPE_i VARCHAR2, 
        ENDORSE_SI_i NUMBER,
        FINANCIAL_IMPACT_i VARCHAR2,
        ENDORSE_DATE_i DATE
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      XXGEN_POL_ENDORSE_OBJ_TYPE
AS
   CONSTRUCTOR FUNCTION XXGEN_POL_ENDORSE_OBJ_TYPE
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.ENDORSE_ID := '';
      SELF.POLICY_NO := '';
      SELF.ENDORSE_CODE := '';
      SELF.ENDDORSE_TRX_TYPE := '';
      SELF.ENDORSE_SI := '';
      SELF.FINANCIAL_IMPACT := '';
      SELF.ENDORSE_DATE := '';
      
      RETURN;
   END;

   CONSTRUCTOR FUNCTION XXGEN_POL_ENDORSE_OBJ_TYPE (
      ENDORSE_ID_i number, 
        POLICY_NO_i NUMBER,
        ENDORSE_CODE_i number,
        ENDDORSE_TRX_TYPE_i VARCHAR2, 
        ENDORSE_SI_i NUMBER,
        FINANCIAL_IMPACT_i VARCHAR2,
        ENDORSE_DATE_i DATE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.ENDORSE_ID := ENDORSE_ID_i;
      SELF.POLICY_NO := POLICY_NO_i;
      SELF.ENDORSE_CODE := ENDORSE_CODE_i;
      SELF.ENDDORSE_TRX_TYPE := ENDDORSE_TRX_TYPE_i;
      SELF.ENDORSE_SI := ENDORSE_SI_i;
      SELF.FINANCIAL_IMPACT := FINANCIAL_IMPACT_i;
      SELF.ENDORSE_DATE := ENDORSE_DATE_i;
      RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_POL_ENDORSE_TAB_OBJ_TYPE IS TABLE OF XXGEN_POL_ENDORSE_OBJ_TYPE
/
CREATE OR REPLACE
TYPE      xxitm_pol_driver_dtls_obj_type AS OBJECT (
            DRIVER_ID NUMBER(20),
POLICY_NO NUMBER(20), --fK
FIRST_NAME VARCHAR2(200),
LAST_NAME  varchar2(200),
DRIVER_DOB  DATE,
PHONE_NO NUMBER(15),
LICENSE_NO VARCHAR2(200),
LICENSE_ISSUE_DATE DATE,
LICENSE_ISSUE_STATE VARCHAR2(200),
IS_PRIMARY_POLICY_HOLDER VARCHAR2(200),
REL_WITH_POLICY_HOLDER VARCHAR2(200),
GENDER VARCHAR2(20),
 MARITAL_STATUS VARCHAR2(200),
STATUS VARCHAR2(20),
   CONSTRUCTOR FUNCTION xxitm_pol_driver_dtls_obj_type
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION xxitm_pol_driver_dtls_obj_type (
            DRIVER_ID_i NUMBER,
            POLICY_NO_i NUMBER, --fK
            FIRST_NAME_i VARCHAR2,
            LAST_NAME_i  varchar2,
            DRIVER_DOB_i  DATE,
            PHONE_NO_i NUMBER,
            LICENSE_NO_i VARCHAR2,
            LICENSE_ISSUE_DATE_i DATE,
            LICENSE_ISSUE_STATE_i VARCHAR2,
            IS_PRIMARY_POLICY_HOLDER_i VARCHAR2,
            REL_WITH_POLICY_HOLDER_i VARCHAR2,
            GENDER_i VARCHAR2,
            MARITAL_STATUS_i VARCHAR2,
            STATUS_i VARCHAR2
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      xxitm_pol_driver_dtls_obj_type
AS
   CONSTRUCTOR FUNCTION xxitm_pol_driver_dtls_obj_type
      RETURN SELF AS RESULT
   IS
   BEGIN
      self.DRIVER_ID:='';
      SELF.POLICY_NO          := '';
      SELF.FIRST_NAME            := '';
      SELF.LAST_NAME      := '';
      SELF.DRIVER_DOB                := '';
      SELF.PHONE_NO                := '';
      SELF.LICENSE_NO  := '';
      SELF.LICENSE_ISSUE_DATE      := '';
      SELF.LICENSE_ISSUE_STATE       := '';
      SELF.IS_PRIMARY_POLICY_HOLDER       := '';
      self.REL_WITH_POLICY_HOLDER:='';
      self.GENDER:='';
      self.MARITAL_STATUS:='';
      self.STATUS:='';
  RETURN;
   END;

   CONSTRUCTOR FUNCTION xxitm_pol_driver_dtls_obj_type (
                  DRIVER_ID_i NUMBER,
            POLICY_NO_i NUMBER, --fK
            FIRST_NAME_i VARCHAR2,
            LAST_NAME_i  varchar2,
            DRIVER_DOB_i  DATE,
            PHONE_NO_i NUMBER,
            LICENSE_NO_i VARCHAR2,
            LICENSE_ISSUE_DATE_i DATE,
            LICENSE_ISSUE_STATE_i VARCHAR2,
            IS_PRIMARY_POLICY_HOLDER_i VARCHAR2,
            REL_WITH_POLICY_HOLDER_i VARCHAR2,
            GENDER_i VARCHAR2,
            MARITAL_STATUS_i VARCHAR2,
            STATUS_i VARCHAR2
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
    self.DRIVER_ID:=DRIVER_ID_i;
      SELF.POLICY_NO          := policy_no_i;
      SELF.FIRST_NAME            := first_name_i;
      SELF.LAST_NAME      := last_name_i;
      SELF.DRIVER_DOB                := driver_dob_i;
      SELF.PHONE_NO                := phone_no_i;
      SELF.LICENSE_NO  := license_no_i;
      SELF.LICENSE_ISSUE_DATE      := license_issue_date_i;
      SELF.LICENSE_ISSUE_STATE       := LICENSE_ISSUE_STATE_i;
      SELF.IS_PRIMARY_POLICY_HOLDER       := IS_PRIMARY_POLICY_HOLDER_i;
      self.REL_WITH_POLICY_HOLDER:=REL_WITH_POLICY_HOLDER_i;
      self.GENDER:=GENDER_i;
      self.MARITAL_STATUS:=MARITAL_STATUS_I;
      self.STATUS:=STATUS_I; 
    RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_POL_DRIVER_tab_obj_type IS TABLE OF xxitm_pol_driver_dtls_obj_type
/
--===================================================
CREATE OR REPLACE
TYPE      xxitm_vehicle_dtls_obj_type AS OBJECT (
            VEHICLE_ID number, 
            POLICY_NO NUMBER(20), 
            VEHICLE_YEAR number, 
            vehicle_make VARCHAR2(200),
            vehicle_model varchar2(200),
            color varchar2(200),
            milage number(10,2),
            chasis_number varchar2(200),
            engine_number number(20),
   CONSTRUCTOR FUNCTION xxitm_vehicle_dtls_obj_type
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION xxitm_vehicle_dtls_obj_type (
            VEHICLE_ID_i number, 
            POLICY_NO_i NUMBER, 
            VEHICLE_YEAR_i number, 
            vehicle_make_i VARCHAR2,
            vehicle_model_i varchar2,
            color_i varchar2,
            milage_i number,
            chasis_number_i varchar2,
            engine_number_i number
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      xxitm_vehicle_dtls_obj_type
AS
   CONSTRUCTOR FUNCTION xxitm_vehicle_dtls_obj_type
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.VEHICLE_ID          := '';
      SELF.POLICY_NO            := '';
      SELF.VEHICLE_YEAR      := '';
      SELF.vehicle_make                := '';
      SELF.vehicle_model                := '';
      SELF.color  := '';
      SELF.milage      := '';
      SELF.chasis_number       := '';
      SELF.engine_number       := '';
   RETURN;
   END;

   CONSTRUCTOR FUNCTION xxitm_vehicle_dtls_obj_type (
      VEHICLE_ID_i number, 
            POLICY_NO_i NUMBER, 
            VEHICLE_YEAR_i number, 
            vehicle_make_i VARCHAR2,
            vehicle_model_i varchar2,
            color_i varchar2,
            milage_i number,
            chasis_number_i varchar2,
            engine_number_i number
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
    SELF.VEHICLE_ID          := VEHICLE_ID;
      SELF.POLICY_NO            := POLICY_NO_i;
      SELF.VEHICLE_YEAR      := VEHICLE_YEAR_i;
      SELF.vehicle_make                := vehicle_make_i;
      SELF.vehicle_model                := vehicle_model_i;
      SELF.color  := color_i;
      SELF.milage      := milage_i;
      SELF.chasis_number       := chasis_number_i;
      SELF.engine_number       := engine_number_i;      
    RETURN;
   END;
END;
/
CREATE OR REPLACE TYPE XXGEN_veh_dtls_tab_obj_type IS TABLE OF xxitm_vehicle_dtls_obj_type
/
--============================
CREATE OR REPLACE
TYPE      xxitm_risk_dtls_obj_type AS OBJECT (
            POLICY_RISK_ID number(20),
            trx_type varchar2(20), 
            POLICY_NO NUMBER(20), 
            RISK_CODE VARCHAR2(200), 
            Risk_description VARCHAR2(200),
            Risk_SI number(20),
            Risk_premium number,
            START_DATE DATE,
            END_DATE DATE,
 CONSTRUCTOR FUNCTION xxitm_risk_dtls_obj_type
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION xxitm_risk_dtls_obj_type (
           POLICY_RISK_ID_i number, 
            trx_type_i varchar2,
            POLICY_NO_i NUMBER, 
            RISK_CODE_i VARCHAR2, 
            Risk_description_i VARCHAR2,
            Risk_SI_i number,
            Risk_premium_i number,
            START_DATE_i DATE,
            END_DATE_i DATE
   )
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      xxitm_risk_dtls_obj_type
AS
   CONSTRUCTOR FUNCTION xxitm_risk_dtls_obj_type
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.POLICY_RISK_ID          := '';
      self.trx_type  := '';
      SELF.POLICY_NO            := '';
      SELF.risk_code      := '';
      SELF.risk_description                := '';
      SELF.risk_si                := '';
      SELF.risk_premium  := '';
      SELF.start_date      := '';
      SELF.end_date       := '';
  RETURN;
   END;

   CONSTRUCTOR FUNCTION xxitm_risk_dtls_obj_type (
                  POLICY_RISK_ID_i number, 
            trx_type_i varchar2,
            POLICY_NO_i NUMBER, 
            RISK_CODE_i VARCHAR2, 
            Risk_description_i VARCHAR2,
            Risk_SI_i number,
            Risk_premium_i number,
            START_DATE_i DATE,
            END_DATE_i DATE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
    SELF.POLICY_RISK_ID          := POLICY_RISK_ID_i;
    SELF.trx_type            := trx_type_i;
      SELF.POLICY_NO            := policy_no_i;
      SELF.risk_code      := risk_code_i;
      SELF.risk_description                := risk_description_i;
      SELF.risk_si                := risk_si_i;
      SELF.risk_premium  := risk_premium_i;
      SELF.start_date      := start_date_i;
      SELF.end_date       := end_date_i;
    RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_RISK_tab_obj_type IS TABLE OF xxitm_risk_dtls_obj_type
/
CREATE OR REPLACE
TYPE  XXGEN_POLICY_OBJ_TYPE AS OBJECT (
        policy_no number,
		insured_id number,
        trx_type  varchar2(10),
        PROD_CODE VARCHAR2(200),
        POLICY_ISSUED_DATE DATE,
        START_DATE DATE,
        END_DATE DATE,
        POLICY_STATUS VARCHAR2(200),
        renewal_no NUMBER(20),
        PAYMENT_OPTION VARCHAR2(200),
		AGENT_ID  number(20),
        TOTAL_PREMIUM NUMBER(20,1), 
        RISK_DETAILS                   XXGEN_RISK_tab_obj_type,
        vehicle_dtls XXGEN_veh_dtls_tab_obj_type,
        driver_dtls XXGEN_POL_DRIVER_tab_obj_type,
        endorse_dtls XXGEN_POL_ENDORSE_TAB_OBJ_TYPE,
   CONSTRUCTOR FUNCTION XXGEN_POLICY_OBJ_TYPE
      RETURN SELF AS RESULT,
   CONSTRUCTOR FUNCTION XXGEN_POLICY_OBJ_TYPE (
    policy_no_i number,
	insured_id_i number,
    trx_type_i  varchar2,
    PROD_CODE_I VARCHAR2,
    POLICY_ISSUED_DATE_i DATE,
    START_DATE_I DATE,
    END_DATE_I DATE,
    POLICY_STATUS_I VARCHAR2,
    renewal_no_i NUMBER,
    PAYMENT_OPTION_i VARCHAR2,
	AGENt_ID_i number,
	TOTAL_PREMIUM_i number,
      RISK_DETAILS_i                   XXGEN_RISK_tab_obj_type,
      vehicle_dtls_i XXGEN_veh_dtls_tab_obj_type,
      driver_dtls_i XXGEN_POL_DRIVER_tab_obj_type,
      endorse_dtls_i XXGEN_POL_ENDORSE_TAB_OBJ_TYPE
)
      RETURN SELF AS RESULT
)
NOT FINAL
/
CREATE OR REPLACE
TYPE BODY      XXGEN_POLICY_OBJ_TYPE
AS
   CONSTRUCTOR FUNCTION XXGEN_POLICY_OBJ_TYPE
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.policy_no := '';
	  self.insured_id :='';
      SELF.trx_type := '';
      SELF.prod_code := '';
      SELF.POLICY_ISSUED_DATE := '';
      SELF.start_date := '';
      SELF.end_date := '';
      SELF.policy_status := '';
      SELF.renewal_no := '';
      SELF.payment_option := '';
	  self.agent_id:='';
	  SELF.TOTAL_PREMIUM:='';
      SELF.risk_details := XXGEN_RISK_tab_obj_type ();
      self.vehicle_dtls :=XXGEN_veh_dtls_tab_obj_type();
    self.driver_dtls :=XXGEN_POL_DRIVER_tab_obj_type();
      self.endorse_dtls:= XXGEN_POL_ENDORSE_TAB_OBJ_TYPE();
      RETURN;
   END;

   CONSTRUCTOR FUNCTION XXGEN_POLICY_OBJ_TYPE (
      policy_no_i number,
	  insured_id_i number,
    trx_type_i  varchar2,
    PROD_CODE_I VARCHAR2,
    POLICY_ISSUED_DATE_i DATE,
    START_DATE_I DATE,
    END_DATE_I DATE,
    POLICY_STATUS_I VARCHAR2,
    renewal_no_i NUMBER,
    PAYMENT_OPTION_i VARCHAR2,
	agent_id_i number,
	TOTAL_PREMIUM_i number,
      RISK_DETAILS_i                   XXGEN_RISK_tab_obj_type,
      vehicle_dtls_i XXGEN_veh_dtls_tab_obj_type,
      driver_dtls_i XXGEN_POL_DRIVER_tab_obj_type,
      endorse_dtls_i XXGEN_POL_ENDORSE_TAB_OBJ_TYPE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.policy_no := policy_no_i;
	  self.insured_id :=insured_id_i;
      SELF.trx_type := trx_type_i;
      SELF.PROD_CODE := PROD_CODE_I;
      SELF.POLICY_ISSUED_DATE := POLICY_ISSUED_DATE_i;
      SELF.START_DATE := START_DATE;
      SELF.END_DATE := END_DATE_I;
      SELF.POLICY_STATUS := POLICY_STATUS_i;
      SELF.renewal_no := renewal_no_i;
      SELF.PAYMENT_OPTION := PAYMENT_OPTION_i;
	  self.agent_id:=agent_id_i;
	  self.TOTAL_PREMIUM :=	TOTAL_PREMIUM_i;
      SELF.RISK_DETAILS := RISK_DETAILS_i;
      self.vehicle_dtls:=vehicle_dtls_i;
      self.driver_dtls:=driver_dtls_i;
      self.endorse_dtls :=endorse_dtls_i;
      RETURN;
   END;
END;
/
CREATE OR REPLACE
TYPE XXGEN_POLICY_TAB_OBJ_TYPE IS TABLE OF XXGEN_POLICY_OBJ_TYPE
/
CREATE OR REPLACE PACKAGE bt
IS
  TYPE error_rt IS RECORD (
    program_owner all_objects.owner%TYPE
  , program_name all_objects.object_name%TYPE
  , line_number PLS_INTEGER
  );

  FUNCTION info (backtrace_in  IN VARCHAR2)
    RETURN error_rt;

  PROCEDURE show_info (backtrace_in  IN VARCHAR2);
END bt;
/