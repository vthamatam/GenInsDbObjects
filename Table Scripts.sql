DROP TABLE USER_ROLES
/
create TABLE USER_ROLES (ROLE_CODE VARCHAR2(20) UNIQUE NOT NULL,
role_desc varchar2(2000)
)
/
drop table app_users
/
CREATE TABLE app_users (
  id        NUMBER(10)    NOT NULL,
  username  VARCHAR2(30)  NOT NULL,
  password  VARCHAR2(40)  NOT NULL,
  first_name varchar2(200),
  last_name varchar2(200),
  start_date date,
  end_date   date,  
  USER_ROLE_CODE VARCHAR2(20),
  PRIMARY KEY (id),
    FOREIGN KEY (USER_ROLE_CODE) REFERENCES user_roles(ROLE_CODE))
/
ALTER TABLE app_users ADD (
  CONSTRAINT app_users_uk UNIQUE (username)
)
/
DROP TABLE XXGEN_COMPANY_MASTER
/
create table XXGEN_COMPANY_MASTER
(COMPANY_ID NUMBER(10) PRIMARY KEY,
COMPANY_CODE VARCHAR2(200) UNIQUE NOT NULL, --pk
COMPANY_NAME VARCHAR2(2000),
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date
)
/
DROP TABLE XXGEN_COMPANY_BRANCH_MASTER
/
CREATE TABLE XXGEN_COMPANY_BRANCH_MASTER
(BRANCH_ID NUMBER PRIMARY KEY,
BRANCH_CODE VARCHAR2(20)  UNIQUE NOT NULL,
BRANCH_NAME VARCHAR2(200),
COMPANY_ID NUMBER(20), 
ADDR1 VARCHAR2(200),
ADDR2 VARCHAR2(200),
BRANCH_CITY VARCHAR2(200),
BRANCH_STATE VARCHAR2(200),
BRANCH_COUNTRY VARCHAR2(200),
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date,
FOREIGN KEY (COMPANY_ID) REFERENCES XXGEN_COMPANY_MASTER(COMPANY_ID)
)
/
DROP TABLE XXGEN_PRODUCT_MASTER
/
create table XXGEN_PRODUCT_MASTER
(PROD_ID NUMBER(20) PRIMARY KEY,
PROD_CODE VARCHAR2(200) UNIQUE NOT NULL, --pk
PROD_DESCRIPTION VARCHAR2(2000),
PROD_START_DATE DATE,
PROD_END_DATE DATE,
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date
)
/
DROP TABLE XXGEN_PRODUCT_RISK_MASTER
/
create table XXGEN_PRODUCT_RISK_MASTER
(RISK_ID NUMBER(20) PRIMARY KEY,
RISK_CODE VARCHAR2(200) UNIQUE NOT NULL,
PROD_CODE VARCHAR2(200), 
Risk_description VARCHAR2(2000),
Risk_premium_percent number(10,2),
Risk_start_date  DATE,
Risk_end_date  DATE,
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date DATE,
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
DROP TABLE XXGEN_INSURED_DTLSXXGEN_INSURED_DTLS
/
create table XXGEN_PROD_DEFAULT_RISK
(RISK_CODE VARCHAR2(200),
PROD_CODE vARCHAR2(200), 
Risk_start_date  DATE,
Risk_end_date  DATE,
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date DATE,
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE),
FOREIGN KEY (RISK_CODE) REFERENCES XXGEN_PRODUCT_RISK_MASTER(RISK_CODE)
)
/
DROP TABLE XXGEN_VEHICLE_MASTER
/
CREATE TABLE XXGEN_VEHICLE_MASTER
(MFG_COMPANY_NAME varchar2(200),
MODEL_ID VARCHAR2(200) UNIQUE NOT NULL,
model_name varchar2(200),
engine_cubic_capacity varchar2(200),
insured_declared_value number(10,2),
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date
)
/
--================================================Agency =====================================================
DROP TABLE XXGEN_AGEN_MASTER
/
CREATE TABLE XXGEN_AGEN_MASTER
(
AGEN_ID NUMBER(20) PRIMARY KEY,
AGENT_NAME VARCHAR2(200),
AGENT_DOB DATE,
AGENT_AGE NUMBER(5),
AGENT_QUALIFICATION VARCHAR2(50),
AGENT_JOIN_DATE DATE,
AGENT_START_DATE DATE,
AGENT_END_DATE DATE,
AGENT_STATUS VARCHAR2(20),
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date
)
/
DROP TABLE XXGEN_AGEN_COMMISOIN_MASTER
/
CREATE TABLE XXGEN_AGEN_COMMISOIN_MASTER
(
AGENT_ID NUMBER(20) , --FOREIGN KEY
AGENT_PROD_CODE VARCHAR2(200), --FOREIGN KEY OF COB MASTER TABLE
COMMISION_PERSENT NUMBER(10,2),
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date,
FOREIGN KEY (AGEN_ID) REFERENCES XXGEN_AGEN_MASTER(AGEN_ID),
FOREIGN KEY (AGENT_PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
--=====================================================ENDORSEMENT ===================================================
DROP TABLE XXGEN_ENDORSE_MASTER
/
CREATE TABLE XXGEN_ENDORSE_MASTER
(ENDORSEMENT_CODE VARCHAR2(200) UNIQUE NOT NULL,
ENDORSE_DESC VARCHAR2(2000),
FINANCE_IMPACT VARCHAR2(20),
START_DATE DATE,
END_DATE DATE,
created_by varchar2(200),
created_date date,
last_updated_by varchar2(200),
last_update_date date
)
--================================RE-Insurance=========================================
/
DROP TABLE XXGEN_RETENSION_MASTER
/
CREATE TABLE XXGEN_RETENSION_MASTER
(RI_PROD_CODE VARCHAR2(200),
RETENSION_FLAG VARCHAR2(200),--FIXED OR PERCENTAGE
MAX_RETENSION_LIMIT number(20),
RETENSION_PERCENT number(5),
START_DATE DATE,
END_DATE DATE,
STATUS  varchar2(10),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (RI_PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
 /
 DROP TABLE XXGEN_RI_PRIORITY_MASTER
 /
 CREATE TABLE XXGEN_RI_PRIORITY_MASTER
(PROD_CODE VARCHAR2(200), --FK
TREATY_CODE VARCHAR2(200) UNIQUE NOT NULL,
TREATY_DESCRIPTION VARCHAR2(2000),
priority number(2),
STATUS VARCHAR2(20),
START_DATE DATE,
END_DATE DATE,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
DROP TABLE XXGEN_RI_TREATY_MASTER
/
CREATE TABLE XXGEN_RI_TREATY_MASTER
(TREATY_CODE VARCHAR(200) UNIQUE NOT NULL,
PROD_CODE VARCHAR2(200),
TREATY_NAME VARCHAR2(2000),
TREATY_TYPE VARCHAR2(200),--PROPORTIONAL/NON PROPORTIONAL
TREATY_YEAR NUMBER(10),
COMMUNICATION_CHANNEL VARCHAR2(200),--BROCKER / DIRECT
TREATY_MAX_LIMIT NUMBER(20),
CURRENCY  VARCHAR2(200),
STATUS VARCHAR2(20),
START_DATE DATE,
END_DATE DATE,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_RI_TREATY_PARTICIPANTS
/
CREATE TABLE XXGEN_RI_TREATY_PARTICIPANTS
(TREATY_CODE VARCHAR(200),
INSTITUTION_CODE VARCHAR2(200),
INSTITUTION_BRANCH VARCHAR2(200),
INSTITUTION_NAME  VARCHAR2(200),
TREATY_SHARE_TYPE      VARCHAR2(200),---FIXED OR PERCENTAGE
TREATY_FIX_PERCENT  NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (TREATY_CODE) REFERENCES XXGEN_RI_TREATY_MASTER(TREATY_CODE)
)
/
DROP TABLE XXGEN_RI_TREATY_PROPORTION
/
CREATE TABLE XXGEN_RI_TREATY_PROPORTION
(TREATY_CODE VARCHAR2(200),
ACCOUNT_PERIOD  VARCHAR2(20),
PML_AMOUNT NUMBER(10,2),
MAXIMUM_CEDING_LIMIT  NUMBER(20,2),
BASE VARCHAR2(200),--Surplus or Qrotashare
value number(20),  --100%
lines number(20),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (TREATY_CODE) REFERENCES XXGEN_RI_TREATY_MASTER(TREATY_CODE)
)
/
DROP TABLE XXGEN_RI_TREATY_PROD_MASTER
/
CREATE TABLE XXGEN_RI_TREATY_PROD_MASTER
(TREATY_CODE VARCHAR2(200),
PROD_CODE VARCHAR2(200),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
--=====================================cLAIMS================================================================
/
DROP TABLE XXGEN_CLAIM_STATUS_MASTER
/
CREATE TABLE XXGEN_CLAIM_STATUS_MASTER
(CLM_STATUS_CODE VARCHAR2(200) UNIQUE NOT NULL,
CLM_STATUS_DESC VARCHAR2(2000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_CLAIM_STATUS_OUTCOME
/
CREATE TABLE XXGEN_CLAIM_STATUS_OUTCOME
(CLM_STATUS_CODE NUMBER(10) UNIQUE NOT NULL,
CLM_OUTCOME_NAME VARCHAR2(200),--Disputed --INprocess--,setteled
CLM_DESC_DESC VARCHAR2(2000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_CLAIMS_SURVEYOR_MASTER
/
CREATE TABLE XXGEN_CLAIMS_SURVEYOR_MASTER
(SURVEYOR_ID NUMBER(10) PRIMARY KEY,
SURVEYOR_NAME VARCHAR2(200),
SURVEYOR_QUALIFICAITION VARCHAR2(200),
SURVEYOR_BRACH_CODE VARCHAR(200),
SURVEYOR_CITY VARCHAR(200),
PHONE NUMBER(15),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
-- PREMIUM DEPENDENT TABLES
/
--ALL TYPES OF VEHICLES       % OF DISCOUNT ON OWN DAMAGE PREMIUM
--No claim made or pending during the preceding full year of insurance   20%
--No claim made or pending during the preceding 2 consecutive years of insurance 25%
--No claim made or pending during the preceding 3 consecutive years of insurance 35%
--No claim made or pending during the preceding 4 consecutive years of insurance 45%
--No claim made or pending during the preceding 5 consecutive years of insurance 50%
create table xxgen_NCB_MASTER
(PROD_CODE VARCHAR2(200),
NO_YEARS_FROM NUMBER(20) , 
NO_YEARS_TO NUMBER(20),
DISCOUNT_ON_PREMIUM NUMBER(10,2),
DISCOUNT_DESC varchar2(2000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
--Zone A: Ahmedabad, Bangalore, Chennai, Hyderabad , Kolkata, Mumbai, New Delhi and Pune.
--Zone B: Rest of India
CREATE TABLE XXGEN_GEOGRAPHICAL_ZONES
(ZONE_CODE VARCHAR(200) NOT NULL,
ZONE_LOC   VARCHAR2(200) NOT NULL,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
CREATE TABLE XXGEN_OWN_DAMAGE_COVER_PREM
(PROD_CODE VARCHAR2(200),
ZONE_CODE VARCHAR2(200),
VEHICLE_age_from number(10),
VEHICLE_age_to number(10),
vehicle_CC_from number(20),
vehicle_CC_to   number(20),
prem_percent_on_idv number(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
ALTER TABLE XXGEN_PRODUCT_RISK_MASTER ADD(PREM_CALC_METHOD VARCHAR2(200), --FIXED/PERCENT/TABLE_PREM
FIXED_PREM NUMBER(20,2),
FIXED_SI NUMBER(20)
)
--PA(PERSONA ACCEDENT) : 
/
CREATE TABLE XXGEN_PA_COVER_PREM
(PROD_CODE VARCHAR2(200),
VEHICLE_TYPE VARCHAR2(200),
CAPITAL_SUM_INSURED  NUMBER(10),
PREMIUM NUMBER(10,2),
COVERAGE_DETAILS VARCHAR2(4000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE))
/
CREATE TABLE XXGEN_VEHICLE_DEPRICIATION
(VEHICLE_age_from number(10),
VEHICLE_age_to number(10),
DEP_percent_on_idv number(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
--This provision deals with Personal Accident cover and only the registered owner in person is entitled to the compulsory cover where he/she holds an effective
--18 driving license. Hence compulsory PA cover cannot be granted where a vehicle is owned by a company, a partnership firm or a similar body corporate or 
--where the owner-driver does not hold an effective driving license. In all such cases, where compulsory PA cover cannot be granted, 
--the additional premium for the compulsory P.A. cover for the owner - driver should not be charged and the compulsory 
--P. A. cover provision in the policy should also be deleted. Where the owner-driver owns more than one vehicle, 
--compulsory PA cover can be granted for only one vehicle as opted by him/her.

--======================================================Transaction Tables ======================================================
/
DROP TABLE XXGEN_INSURED_DTLS
/
CREATE TABLE XXGEN_INSURED_DTLS
(INSURED_ID NUMBER(10) PRIMARY KEY,
INSURED_NAME VARCHAR2(200),
INSURED_DOB DATE,
INSURED_PHONE NUMBER(20),
INSURED_QUALIFICATION VARCHAR2(200),
INSURED_PROFISSION VARCHAR2(200),
INSURED_ADDR_CODE NUMBER(10),--FK 
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_INSURED_ADDRESS
/
CREATE TABLE XXGEN_INSURED_ADDRESS
(INSURED_ADDR_ID NUMBER PRIMARY KEY,
INSURED_ID NUMBER(20),
ADDRESS_TYPE VARCHAR2(200),--TEMPORARY OR PERMANENT
ADDRESS_STATUS VARCHAR2(20),
INSURED_ADDR1    VARCHAR2(200),
INSURED_ADDR2    VARCHAR2(200),
INSURED_CITY    VARCHAR2(200),
INSURED_SATE    VARCHAR2(200),
INSURED_COUNTRY    VARCHAR2(200),
INSURED_PINCODE    VARCHAR2(200),
Phone        number(15),
email        varchar2(200),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (INSURED_ID) REFERENCES XXGEN_INSURED_DTLS(INSURED_ID)
)
/
DROP TABLE XXGEN_POLICY_DTLS
/
create table XXGEN_POLICY_DTLS
(POLICY_NO NUMBER(20) PRIMARY KEY,
INSURED_ID NUMBER(20), --FK of XXGEN_INSURED_DTLS
PROD_CODE VARCHAR2(200),
POLICY_ISSUED_DATE DATE,
START_DATE DATE,
END_DATE DATE,
POLICY_STATUS VARCHAR2(200),--QUOTATION,PENDINGPREMIUM,ISSUED,INFORCE,LAPSE
RENEWAL_NO NUMBER(20),
PAYMENT_OPTION VARCHAR2(200),
TOTAL_PREMIUM NUMBER(20,1),  --SUM OF RISK PREMIUM
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (INSURED_ID) REFERENCES XXGEN_INSURED_DTLS(INSURED_ID),
FOREIGN KEY (PROD_CODE) REFERENCES XXGEN_PRODUCT_MASTER(PROD_CODE)
)
/
DROP TABLE XXGEN_POLICY_RISk_DTLS
/
create table XXGEN_POLICY_RISk_DTLS
(POLICY_RISK_ID VARCHAR2(200) PRIMARY KEY, 
POLICY_NO NUMBER(20), --FK of XXGEN_POLICY_DTLS
RISK_CODE VARCHAR2(200), 
Risk_description VARCHAR2(200),
Risk_premium number(20,2),
START_DATE DATE,
END_DATE DATE,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO),
FOREIGN KEY (RISK_CODE) REFERENCES XXGEN_PRODUCT_RISK_MASTER(RISK_CODE)
)
/
DROP TABLE XXGEN_POLICY_ENDORSE_DTLS
/
CREATE TABLE XXGEN_POLICY_ENDORSE_DTLS
(ENDORSE_ID number(20), --pK 
POLICY_NO NUMBER(20),--FK
ENDORSE_CODE number(20), 
Endorse_desc VARCHAR2(200),
ENDORSE_DATE DATE,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO)
)
/
DROP TABLE XXGEN_POLICY_VEHICLE_DTLS
/
CREATE TABLE XXGEN_POLICY_VEHICLE_DTLS
(VEHICLE_ID NUMBER(20) PRIMARY KEY, 
POLICY_NO NUMBER(20),
VEHICLE_YEAR NUMBER(10),
VEHICLE_MAKE VARCHAR2(200),
VEHICLE_MODEL varchar(200),  
COLOR VARCHAR2(200),
MILAGE NUMBER(10,2),
CHASIS_NUMBER varchar2(200),
ENGINE_NUMBER NUMBER(15),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO)
)
/
DROP TABLE XXGEN_POLICY_DRIVER_DTLS
/
CREATE TABLE XXGEN_POLICY_DRIVER_DTLS
(DRIVER_ID NUMBER(20),
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
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO)
)
/
DROP TABLE XXGEN_DRIVER_TRAFIC_VILATIONS
/
CREATE TABLE XXGEN_DRIVER_TRAFIC_VILATIONS
(VILATION_ID NUMBER(20) PRIMARY KEY, --PK
DRIVER_ID NUMBER(20), --FK  OF XXGEN_POLICY_VEHICLE_DTLS
VILATION_DATE DATE,--FK OF XXGEN_POLICY_DRIVERS_TLS
VILATION_PLACE VARCHAR2(200), 
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
 FOREIGN KEY (DRIVER_ID) REFERENCES XXGEN_POLICY_DRIVER_DTLS(DRIVER_ID)
)
/
DROP TABLE XXGEN_POLICY_BILLS
/
create table XXGEN_POLICY_BILLS
(BILL_ID NUMBER(20) PRIMARY KEY, --PK
POLICY_NO NUMBER(20),
PREMIUM_AMOUNT NUMBER(20,2), 
DUE_DATE DATE,
BALANCE_AMOUNT NUMBER(20,2), 
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO)
)
/
DROP TABLE XXGEN_POLICY_PAYMENT_DTLS
/
CREATE TABLE XXGEN_POLICY_PAYMENT_DTLS
(PAYMENT_ID NUMBER(20), --PK
BILL_ID NUMBER(20),
PAID_AMOUNT NUMBER(20,2),  
PAID_DATE DATE, 
DUE_DATE DATE,
PAY_METHID VARCHAR2(200),
FIRST_NAME VARCHAR2(200),
LAST_NAME VARCHAR2(200),
CARD_NUMBER NUMBER(16),
ZIP NUMBER(20),
CARD_EXP_DATE DATE,
CARD_TYPE VARCHAR2(200),
DEBIT_OR_CREDIT VARCHAR2(200),
BANK_NAME VARCHAR2(200),
ACCOUNT_NO NUMBER(20),
CHECK_NUMBER NUMBER(20),
CHECK_IMAGE CLOB,
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (BILL_ID) REFERENCES XXGEN_POLICY_BILLS(BILL_ID)
)
/
DROP TABLE XXGEN_CLAIMS
/
CREATE TABLE XXGEN_CLAIMS
(CLAIM_ID NUMBER(20) PRIMARY KEY, --PK
POLICY_NO NUMBER(20), --FK
CLAIM_DATE DATE,
claim_risk varchar2(200),
AMOUNT_CLAIMED NUMBER(20,2),
AMOUNT_SETTELED NUMBER(20,2),
DATE_OF_SETTELE DATE,
TOTAL_POLICY_AMOUNT NUMBER(20,2),
TOTAL_CLAIM_AMOUNT NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO)
)
/
DROP TABLE XXGEN_CLAIMS_PROCESS_DTLS
/
create table XXGEN_CLAIMS_PROCESS_DTLS
(CLM_PROCESS_ID NUMBER(20),--PK
CLAIM_ID NUMBER(20), --PK
POLICY_NO NUMBER(20), --FK
CLAIM_DATE DATE,
AMOUNT_CLAIMED NUMBER(20,2),
AMOUNT_SETTELED NUMBER(20,2),
DATE_OF_SETTELE DATE,
TOTAL_POLICY_AMOUNT NUMBER(20,2),
TOTAL_CLAIM_AMOUNT NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (POLICY_NO) REFERENCES XXGEN_POLICY_DTLS(POLICY_NO),
FOREIGN KEY (CLAIM_ID) REFERENCES XXGEN_CLAIMS(CLAIM_ID)
)
/
DROP TABLE XXGEN_CLAIMS_SURVEYOR_DTLS
/
CREATE TABLE XXGEN_CLAIMS_SURVEYOR_DTLS
(SURVEYOR_ID number(20), --FK
surveyor_name varchar2(200),
CLAIM_ID NUMBER(20), --PK
clm_survey_status varchar2(200),
surveyor_comments varchar2(400),
Surveyor_claim_amount number(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (CLAIM_ID) REFERENCES XXGEN_CLAIMS(CLAIM_ID),
FOREIGN KEY (SURVEYOR_ID) REFERENCES XXGEN_CLAIMS_SURVEYOR_MASTER(SURVEYOR_ID)
)
/
DROP TABLE XXGEN_CLAIMS_DOCS
/
CREATE TABLE XXGEN_CLAIMS_DOCS
(CLAIM_DOC_ID NUMBER(20) PRIMARY KEY, --PK
CLAIM_ID NUMBER(20),
doc_type_code varchar2(200),
doc_description varchar2(2000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
FOREIGN KEY (CLAIM_ID) REFERENCES XXGEN_CLAIMS(CLAIM_ID)
)
/
create table xxgen_NCB_MASTER
(NO_YEARS_FROM NUMBER(20) , --PK
NO_YEARS_TO NUMBER(20),
DISCOUNT_ON_PREMIUM NUMBER(10,2),
DISCOUNT_DESC varchar2(2000),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200),
)
/
ALTER TABLE XXGEN_POLICY_RISK_DTLS ADD RISK_SA NUMBER(20,2)
/
alter table XXGEN_POLICY_RISk_DTLS modify risk_premium number(20,2);
/
alter table XXGEN_AGEN_COMMISOIN_MASTER RENAME column agen_id  TO AGENT_ID;
/
drop table xxgen_policy_agent_comm
/
create table xxgen_policy_agent_comm (policy_no number(20),
				agent_id number(20),
				prod_code varchar2(200),
				policy_premium number(20,2),
				policy_comm number(20,2),
				CREATED_BY varchar2(200),
				CREATED_DATE date,
				LAST_UPDATE_DATE DATE,
				LAST_UPDATED_BY VARCHAR2(200)
				)
/
drop table xxgen_policy_errors
/
create table xxgen_policy_errors (policy_no number(20),
                                         error_msg varchar2(2000),
                                         module_name varchar(400),
                                         created_by number(10),
                                         creation_date date ,
                                         last_updated_by number(10),
                                         last_update_date date,
                                         request_status varchar2(200))
/
DROP TABLE XXGEN_POLICY_RETENSION_DTLS
/
CREATE TABLE XXGEN_POLICY_RETENSION_DTLS
(POLICY_NO NUMBER(20),
retension_risk_code varchar2(200),
RETENSION_RISK_SA NUMBER(20,2),
RETENSION_PERCENT NUMBER(20,2),
RETENSION_RISK_PREMIUM NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_POLICY_TREATY_DTLS
/
CREATE TABLE XXGEN_POLICY_TREATY_DTLS
(POLICY_NO NUMBER(20),
TREATY_CODE VARCHAR2(200),
treaty_risk_code varchar2(200),
TREATY_PERCENT NUMBER(20,2),
TREAY_RISK_SA NUMBER(20,2),
TREATY_RISK_PREMIUM NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
DROP TABLE XXGEN_POLICY_RI_PARTICIPANTS
/
CREATE TABLE XXGEN_POLICY_RI_PARTICIPANTS
(POLICY_NO NUMBER(20),
TREATY_CODE VARCHAR2(200),
INSTITUTION_CODE VARCHAR2(200),
INSTITUTION_BRANCH VARCHAR2(200),
INSTITUTION_NAME  VARCHAR2(200),
RI_risk_code varchar2(200),
PARTICIPANT_risk_PERCENT NUMBER(20,2),
PARTICIPANT_RISK_SA NUMBER(20,2),
PARTICIPANT_PREMIUM NUMBER(20,2),
CREATED_BY varchar2(200),
CREATED_DATE date,
LAST_UPDATE_DATE DATE,
LAST_UPDATED_BY VARCHAR2(200)
)
/
alter table XXGEN_RI_TREATY_MASTER add prod_code varchar2(200)
/
alter table XXGEN_CLAIMS_SURVEYOR_DTLS add (clm_survey_status varchar2(200), surveyor_comments varchar2(4000))
/
alter table xxgen_claims add claim_risk varchar2(200);