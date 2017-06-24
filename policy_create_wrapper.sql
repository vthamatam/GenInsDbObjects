DECLARE

  l_insured_dtls                              XXGEN_INSURED_OBJ_TAB_TYPE  := XXGEN_INSURED_OBJ_TAB_TYPE();
   l_insured_addr                                 XXGEN_INS_ADDR_OBJ_TAB_TYPE := XXGEN_INS_ADDR_OBJ_TAB_TYPE();

   
   l_policy                              XXGEN_POLICY_TAB_OBJ_TYPE  := XXGEN_POLICY_TAB_OBJ_TYPE();
   l_risk                                 XXGEN_RISK_tab_obj_type := XXGEN_RISK_tab_obj_type();
   l_vehicle                                      XXGEN_veh_dtls_tab_obj_type := XXGEN_veh_dtls_tab_obj_type();
   l_driver                                   XXGEN_POL_DRIVER_tab_obj_type   := XXGEN_POL_DRIVER_tab_obj_type();
   
l_err_msg varchar2(200);
l_status varchar2(2000);
BEGIN

  l_insured_dtls.extend;
  l_insured_dtls (l_insured_dtls.COUNT) := NEW XXGEN_INSURED_OBJ_TYPE ();
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_ID:=null;
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_NAME:='Ravi';
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_DOB :='3-may-1984';
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_PHONE :=9999999;
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_QUALIFICATION:='M.B.A';
  l_insured_dtls (l_insured_dtls.COUNT).INSURED_PROFISSION :='Government servent';
  

    l_insured_addr.DELETE;
    l_insured_addr.EXTEND;
    l_insured_addr (l_insured_addr.COUNT) := NEW XXGEN_INSURED_ADDR_OBJ_TYPE();
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR_ID :=null;    
    l_insured_addr (l_insured_addr.COUNT).INSURED_ID :=null;
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_TYPE:='PERMANANT';
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_STATUS:='Active';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR1:='Ameerper';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR2:='SR Nagar';
    l_insured_addr (l_insured_addr.COUNT).INSURED_CITY:='Hyderabad';
    l_insured_addr (l_insured_addr.COUNT).INSURED_STATE:='Telangana';
    l_insured_addr (l_insured_addr.COUNT).INSURED_COUNTRY:='India';
    l_insured_addr (l_insured_addr.COUNT).INSURED_PINCODE:=500022;
    l_insured_addr (l_insured_addr.COUNT).Phone:=78708707;
    l_insured_addr (l_insured_addr.COUNT).email:='ravi@gmail.com';
    
    l_insured_addr.EXTEND;
    l_insured_addr (l_insured_addr.COUNT) := NEW XXGEN_INSURED_ADDR_OBJ_TYPE();
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR_ID :=null;    
    l_insured_addr (l_insured_addr.COUNT).INSURED_ID :=null;
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_TYPE:='TEMPORARY';
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_STATUS:='Active';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR1:='ckp';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR2:='BADVEL';
        l_insured_addr (l_insured_addr.COUNT).INSURED_CITY:='kadapa';
    l_insured_addr (l_insured_addr.COUNT).INSURED_STATE:='Andhrapradesh';
    l_insured_addr (l_insured_addr.COUNT).INSURED_COUNTRY:='India';
    l_insured_addr (l_insured_addr.COUNT).INSURED_PINCODE:=5165002;
    l_insured_addr (l_insured_addr.COUNT).Phone:=787787998;
    l_insured_addr (l_insured_addr.COUNT).email:='ravi@gmail.com';
    
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_ADDR:=l_insured_addr;


    l_policy.EXTEND;

    l_policy (l_policy.COUNT) := NEW XXGEN_POLICY_OBJ_TYPE ();

    l_policy (l_policy.COUNT).policy_no :=null;
    l_policy (l_policy.COUNT).trx_type  :='C';
    l_policy (l_policy.COUNT).PROD_CODE :='MOTOR2';
    l_policy (l_policy.COUNT).POLICY_ISSUED_DATE :=SYSDATE;
    l_policy (l_policy.COUNT).START_DATE :=SYSDATE+10;
    l_policy (l_policy.COUNT).END_DATE :=SYSDATE+365;
    l_policy (l_policy.COUNT).POLICY_STATUS :='SUBMITTED';
    l_policy (l_policy.COUNT).RENEWAL_NO :=0;
    l_policy (l_policy.COUNT).PAYMENT_OPTION :='Yearly';
    l_policy (l_policy.COUNT).TOTAL_PREMIUM :=null;
    l_policy (l_policy.COUNT).AGENT_ID :=5;

        l_risk.DELETE;
        l_risk.EXTEND;
        l_risk (l_risk.COUNT) := NEW xxitm_risk_dtls_obj_type();
        l_risk (l_risk.COUNT).POLICY_RISK_ID := NULL;
        l_risk (l_risk.COUNT).POLICY_NO := NULL;
        l_risk (l_risk.COUNT).RISK_CODE := 'THEFT2';
        l_risk (l_risk.COUNT).RISK_DESCRIPTION := 'Vehicle Theft';
        l_risk (l_risk.COUNT).RISK_SI := NULL;
        l_risk (l_risk.COUNT).RISK_PREMIUM := NULL;
        l_risk (l_risk.COUNT).START_DATE := SYSDATE+10;
        l_risk (l_risk.COUNT).END_DATE := SYSDATE+365;

        l_risk.EXTEND;
        l_risk (l_risk.COUNT) := NEW xxitm_risk_dtls_obj_type ();
        l_risk (l_risk.COUNT).POLICY_RISK_ID := NULL;
        l_risk (l_risk.COUNT).POLICY_NO := NULL;
        l_risk (l_risk.COUNT).RISK_CODE := 'VD2';
        l_risk (l_risk.COUNT).RISK_DESCRIPTION := 'Vehicle Damage Cover';
        l_risk (l_risk.COUNT).RISK_SI := NULL;
        l_risk (l_risk.COUNT).RISK_PREMIUM := NULL;
        l_risk (l_risk.COUNT).START_DATE := SYSDATE+10;
        l_risk (l_risk.COUNT).END_DATE := SYSDATE+365;

        l_risk.EXTEND;
        l_risk (l_risk.COUNT) := NEW xxitm_risk_dtls_obj_type ();
        l_risk (l_risk.COUNT).POLICY_RISK_ID := NULL;
        l_risk (l_risk.COUNT).POLICY_NO := NULL;
        l_risk (l_risk.COUNT).RISK_CODE := 'TPA2';
        l_risk (l_risk.COUNT).RISK_DESCRIPTION := 'Third Party Accedent Coverage';
        l_risk (l_risk.COUNT).RISK_SI := NULL;
        l_risk (l_risk.COUNT).RISK_PREMIUM := NULL;
        l_risk (l_risk.COUNT).START_DATE := SYSDATE+10;
        l_risk (l_risk.COUNT).END_DATE := SYSDATE+365;
    
          l_risk.EXTEND;
        l_risk (l_risk.COUNT) := NEW xxitm_risk_dtls_obj_type ();
        l_risk (l_risk.COUNT).POLICY_RISK_ID := NULL;
        l_risk (l_risk.COUNT).POLICY_NO := NULL;
        l_risk (l_risk.COUNT).RISK_CODE := 'DEATH';
        l_risk (l_risk.COUNT).RISK_DESCRIPTION := 'Third Party Accedent Coverage';
        l_risk (l_risk.COUNT).RISK_SI := 200000;
        l_risk (l_risk.COUNT).RISK_PREMIUM := NULL;
        l_risk (l_risk.COUNT).START_DATE := SYSDATE+10;
        l_risk (l_risk.COUNT).END_DATE := SYSDATE+365;
    
    l_policy (l_policy.COUNT).RISK_DETAILS:=l_risk;    

    
     l_vehicle.DELETE;
        l_vehicle.EXTEND;

        
        l_vehicle (l_vehicle.COUNT) := NEW xxitm_vehicle_dtls_obj_type ();

       l_vehicle (l_vehicle.COUNT).VEHICLE_ID := 3560;
     l_vehicle (l_vehicle.COUNT).POLICY_NO := NULL;
     l_vehicle (l_vehicle.COUNT).VEHICLE_YEAR := 2014;
     l_vehicle (l_vehicle.COUNT).vehicle_make := 'HONDA';
     l_vehicle (l_vehicle.COUNT).vehicle_model := 'ACTIVA4G';
     l_vehicle (l_vehicle.COUNT).color := 'BROWN';
     l_vehicle (l_vehicle.COUNT).milage := 57.44;
     l_vehicle (l_vehicle.COUNT).chasis_number := '35555';
     l_vehicle (l_vehicle.COUNT).engine_number := 35657;
                  
       l_policy (l_policy.COUNT).vehicle_dtls:=l_vehicle;

     l_driver.DELETE;
        l_driver.EXTEND;
        l_driver (l_driver.COUNT) := NEW xxitm_pol_driver_dtls_obj_type ();
       l_driver (l_driver.COUNT).DRIVER_ID := NULL;
     l_driver (l_driver.COUNT).POLICY_NO := NULL;
     l_driver (l_driver.COUNT).FIRST_NAME := 'Venu';
     l_driver (l_driver.COUNT).LAST_NAME := 'Thamatam';
     l_driver (l_driver.COUNT).DRIVER_DOB := SYSDATE;
     l_driver (l_driver.COUNT).PHONE_NO := 7095533322;
     l_driver (l_driver.COUNT).LICENSE_NO := 'A34H34H45';
     l_driver (l_driver.COUNT).LICENSE_ISSUE_DATE := SYSDATE-765;
     l_driver (l_driver.COUNT).IS_PRIMARY_POLICY_HOLDER := 'Yes';
     l_driver (l_driver.COUNT).REL_WITH_POLICY_HOLDER := 'SELF';
    l_driver (l_driver.COUNT).GENDER := 'Male';
    l_driver (l_driver.COUNT).MARITAL_STATUS := 'Married';
     l_driver (l_driver.COUNT).STATUS := 'A';

        l_driver.EXTEND;
        l_driver (l_driver.COUNT) := NEW xxitm_pol_driver_dtls_obj_type ();
       l_driver (l_driver.COUNT).DRIVER_ID := NULL;
     l_driver (l_driver.COUNT).POLICY_NO := NULL;
     l_driver (l_driver.COUNT).FIRST_NAME := 'Pratap';
     l_driver (l_driver.COUNT).LAST_NAME := 'L';
     l_driver (l_driver.COUNT).DRIVER_DOB := SYSDATE+2000;
     l_driver (l_driver.COUNT).PHONE_NO := 70955333435;
     l_driver (l_driver.COUNT).LICENSE_NO := 'A34H3222454';
     l_driver (l_driver.COUNT).LICENSE_ISSUE_DATE := SYSDATE-400;
     l_driver (l_driver.COUNT).IS_PRIMARY_POLICY_HOLDER := 'Yes';
     l_driver (l_driver.COUNT).REL_WITH_POLICY_HOLDER := 'DRIVER';
    l_driver (l_driver.COUNT).GENDER := 'Male';
    l_driver (l_driver.COUNT).MARITAL_STATUS := 'MARRIED';
    l_driver (l_driver.COUNT).STATUS := 'A';

    l_policy (l_policy.COUNT).driver_dtls:=l_driver;
   
   xxgen_create_edit_policy_pkg.create_new_policy(p_policy_dtls =>l_policy,
                                                  p_insured_dtls=>l_insured_dtls,
                                                 p_submitted_by =>'venu',
                                                 p_status =>l_status,
                                                 p_err_msg =>l_err_msg);
   
  
   DBMS_OUTPUT.PUT_LINE('l_err_msg :'||l_err_msg);
  
          
EXCEPTION WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('l_err_msg :'||l_err_msg);
END;