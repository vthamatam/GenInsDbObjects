/* Formatted on 21/May/17 4:25:33 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE xxgen_create_edit_policy_pkg
AS
    PROCEDURE create_new_policy (
        p_policy_dtls        XXGEN_POLICY_TAB_OBJ_TYPE,
        p_insured_dtls       XXGEN_INSURED_OBJ_TAB_TYPE,
        p_submitted_by       VARCHAR2,
        p_status         OUT VARCHAR2,
        p_err_msg        OUT VARCHAR2);

    PROCEDURE calc_risk_prem (p_prod_code_i         VARCHAR2,
                              p_risk_code_i         VARCHAR2,
                              p_risk_SA_i           NUMBER,
                              p_risk_remium_o   OUT NUMBER,
                              p_status_o        OUT VARCHAR2,
                              p_err_msg_o       OUT VARCHAR2);

    PROCEDURE GET_VEHICLE_DEPRICIATION_IDV (p_mfg_company_I       VARCHAR2,
                                            p_model_id_I          VARCHAR2,
                                            P_YEAR_I              NUMBER,
                                            p_idv_o           OUT NUMBER,
                                            p_status_o        OUT VARCHAR2,
                                            p_err_msg_o       OUT VARCHAR2);

    PROCEDURE Generate_agent_comm (p_prod_code_i            VARCHAR2,
                                   p_policy_no_i            NUMBER,
                                   p_agent_id_i             NUMBER,
                                   p_policy_premium_i       NUMBER,
                                   p_submitted_by_i         NUMBER,
                                   p_status_o           OUT VARCHAR2,
                                   p_err_msg_o          OUT VARCHAR2);

    PROCEDURE xxgen_error_log (
        pi_policy_no               NUMBER,
        pi_submitter_id            NUMBER,
        pi_err_msg                 VARCHAR2,
        pi_module_name             VARCHAR2,
        po_return_status       OUT VARCHAR2,
        po_return_message      OUT VARCHAR2,
        p_request_status    IN     VARCHAR2 DEFAULT NULL);
END;
/

CREATE OR REPLACE PACKAGE BODY xxgen_create_edit_policy_pkg
AS
    PROCEDURE create_new_policy (
        p_policy_dtls        XXGEN_POLICY_TAB_OBJ_TYPE,
        p_insured_dtls       XXGEN_INSURED_OBJ_TAB_TYPE,
        p_submitted_by       VARCHAR2,
        p_status         OUT VARCHAR2,
        p_err_msg        OUT VARCHAR2)
    AS
        lv_status             VARCHAR2 (20);
        lv_err_msg            VARCHAR2 (200);
        l_insured_id          NUMBER (20);
        ln_ins_addr_id        NUMBER (20);
        ln_submited_id        NUMBER (20);
        le_invalid_user       EXCEPTION;
        ln_policy_no          NUMBER (20);
        LN_DRIVER_ID          NUMBER (20);
        LN_VEHICLE_ID         NUMBER (20);
        LN_RISK_ID            NUMBER (20);
        ln_vehicle_year       NUMBER (20);
        lv_vehicle_mfg_comp   VARCHAR2 (200);
        lv_vehicle_model      VARCHAR2 (200);
        ln_vehile_dep_idv     NUMBER (20, 2);
        ln_risk_calc_prem     NUMBER (20, 2);
        ln_tot_pol_prem       NUMBER (20, 2) := 0;
        lv_policy_dtls        XXGEN_POLICY_TAB_OBJ_TYPE
                                  := NEW XXGEN_POLICY_TAB_OBJ_TYPE ();
        lv_commit_yn          VARCHAR2 (20) := 'Y';
    BEGIN
        lv_policy_dtls := p_policy_dtls;

        SAVEPOINT policy_create;

        BEGIN
            SELECT id
              INTO ln_submited_id
              FROM app_users
             WHERE UPPER (username) = UPPER (p_submitted_by);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                RAISE le_invalid_user;
        END;

        DBMS_OUTPUT.put_line ('B STAFIRE LOOP RT' || ln_submited_id);

        IF lv_policy_dtls.EXISTS (1)
        THEN
            FOR I IN lv_policy_dtls.FIRST .. lv_policy_dtls.LAST
            LOOP
                SELECT xxgen_POLICY_NO_seq.NEXTVAL
                  INTO ln_policy_no
                  FROM DUAL;

                DBMS_OUTPUT.put_line ('LOOP START' || ln_submited_id);

                --If condition will check insured details are exist or not if not exists then insured details will get from object and insert into tables
                IF lv_policy_dtls (i).INSURED_ID IS NULL
                THEN
                    DBMS_OUTPUT.put_line ('ln_submited_id' || ln_submited_id);

                    FOR m IN p_insured_dtls.FIRST .. p_insured_dtls.LAST
                    LOOP
                        SELECT xxgen_INSURED_id_seq.NEXTVAL
                          INTO l_insured_id
                          FROM DUAL;

                        DBMS_OUTPUT.put_line (
                               'p_insured_dtls (m).insured_name'
                            || p_insured_dtls (m).insured_name);

                        BEGIN
                            INSERT
                              INTO XXGEN_INSURED_DTLS (INSURED_ID,
                                                       INSURED_NAME,
                                                       INSURED_DOB,
                                                       INSURED_PHONE,
                                                       INSURED_QUALIFICATION,
                                                       INSURED_PROFISSION,
                                                       CREATED_BY,
                                                       CREATED_DATE,
                                                       LAST_UPDATE_DATE,
                                                       LAST_UPDATED_BY)
                            VALUES (l_insured_id,
                                    p_insured_dtls (m).insured_name,
                                    p_insured_dtls (m).INSURED_DOB,
                                    p_insured_dtls (m).INSURED_PHONE,
                                    p_insured_dtls (m).INSURED_QUALIFICATION,
                                    p_insured_dtls (m).INSURED_PROFISSION,
                                    ln_submited_id,
                                    SYSDATE,
                                    SYSDATE,
                                    ln_submited_id);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                xxgen_error_log (
                                    pi_policy_no        => ln_policy_no,
                                    pi_submitter_id     => ln_submited_id,
                                    pi_err_msg          =>    'Error while insert data into XXGEN_INSURED_DTLS'
                                                           || SUBSTR (
                                                                  DBMS_UTILITY.format_error_backtrace,
                                                                  1,
                                                                  400)
                                                           || SUBSTR (SQLERRM,
                                                                      250),
                                    pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                    po_return_status    => lv_err_msg,
                                    po_return_message   => lv_err_msg,
                                    p_request_status    => 'Error');

                                lv_commit_yn := 'N';
                        END;

                        FOR n IN p_insured_dtls (m).INSURED_ADDR.FIRST ..
                                 p_insured_dtls (m).INSURED_ADDR.FIRST
                        LOOP
                            SELECT xxgen_INSURED_ADDR_id_seq.NEXTVAL
                              INTO ln_ins_addr_id
                              FROM DUAL;

                            DBMS_OUTPUT.put_line (
                                   'p_insured_dtls (m).INSURED_ADDR (n).ADDRESS_TYPE'
                                || p_insured_dtls (m).INSURED_ADDR (n).ADDRESS_TYPE);

                            BEGIN
                                INSERT
                                  INTO XXGEN_INSURED_ADDRESS (
                                           INSURED_ADDR_ID,
                                           INSURED_ID,
                                           ADDRESS_TYPE,
                                           ADDRESS_STATUS,
                                           INSURED_ADDR1,
                                           INSURED_ADDR2,
                                           INSURED_CITY,
                                           INSURED_SATE,
                                           INSURED_COUNTRY,
                                           INSURED_PINCODE,
                                           Phone,
                                           email,
                                           CREATED_BY,
                                           CREATED_DATE,
                                           LAST_UPDATE_DATE,
                                           LAST_UPDATED_BY)
                                    VALUES (
                                               ln_ins_addr_id,
                                               l_insured_id,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).ADDRESS_TYPE,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).ADDRESS_STATUS,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_ADDR1,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_ADDR2,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_CITY,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_STATE,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_COUNTRY,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).INSURED_PINCODE,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).Phone,
                                               p_insured_dtls (m).INSURED_ADDR (
                                                   n).email,
                                               ln_submited_id,
                                               SYSDATE,
                                               SYSDATE,
                                               ln_submited_id);
                            EXCEPTION
                                WHEN OTHERS
                                THEN
                                    xxgen_error_log (
                                        pi_policy_no        => ln_policy_no,
                                        pi_submitter_id     => ln_submited_id,
                                        pi_err_msg          =>    'Error while insert data into XXGEN_INSURED_ADDRESS'
                                                               || SUBSTR (
                                                                      DBMS_UTILITY.format_error_backtrace,
                                                                      1,
                                                                      400)
                                                               || SUBSTR (
                                                                      SQLERRM,
                                                                      250),
                                        pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                        po_return_status    => lv_err_msg,
                                        po_return_message   => lv_err_msg,
                                        p_request_status    => 'Error');

                                    lv_commit_yn := 'N';
                            END;
                        END LOOP;
                    END LOOP;
                END IF;

                --end insured details insert

                SELECT xxgen_POLICY_NO_seq.NEXTVAL
                  INTO ln_policy_no
                  FROM DUAL;

                DBMS_OUTPUT.put_line (
                       'lv_policy_dtls (i).prod_code'
                    || lv_policy_dtls (i).prod_code);

                BEGIN
                    INSERT INTO XXGEN_POLICY_DTLS (POLICY_NO,
                                                   INSURED_ID,
                                                   PROD_CODE,
                                                   POLICY_ISSUED_DATE,
                                                   START_DATE,
                                                   END_DATE,
                                                   POLICY_STATUS, --QUOTATION,PENDINGPREMIUM,ISSUED,INFORCE,LAPSE
                                                   RENEWAL_NO,
                                                   PAYMENT_OPTION,
                                                   CREATED_BY,
                                                   CREATED_DATE,
                                                   LAST_UPDATE_DATE,
                                                   LAST_UPDATED_BY)
                         VALUES (ln_policy_no,
                                 l_insured_id,
                                 lv_policy_dtls (i).prod_code,
                                 lv_policy_dtls (i).POLICY_ISSUED_DATE,
                                 lv_policy_dtls (i).start_date,
                                 lv_policy_dtls (i).END_DATE,
                                 lv_policy_dtls (i).policy_status,
                                 lv_policy_dtls (i).renewal_no,
                                 lv_policy_dtls (i).payment_option,
                                 ln_submited_id,
                                 SYSDATE,
                                 SYSDATE,
                                 ln_submited_id);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        xxgen_error_log (
                            pi_policy_no        => ln_policy_no,
                            pi_submitter_id     => ln_submited_id,
                            pi_err_msg          =>    'Error while insert data into XXGEN_POLICY_DTLS'
                                                   || SUBSTR (
                                                          DBMS_UTILITY.format_error_backtrace,
                                                          1,
                                                          400)
                                                   || SUBSTR (SQLERRM, 250),
                            pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                            po_return_status    => lv_err_msg,
                            po_return_message   => lv_err_msg,
                            p_request_status    => 'Error');

                        lv_commit_yn := 'N';
                END;

                FOR K IN lv_policy_dtls (i).vehicle_dtls.FIRST ..
                         lv_policy_dtls (i).vehicle_dtls.LAST
                LOOP
                    ln_vehicle_year :=
                        lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_YEAR;
                    lv_vehicle_mfg_comp :=
                        lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_MAKE;
                    lv_vehicle_model :=
                        lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_MODEL;

                    SELECT xxgen_POL_VEHICLE_ID_seq.NEXTVAL
                      INTO LN_VEHICLE_ID
                      FROM DUAL;

                    DBMS_OUTPUT.put_line (
                           'lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_YEAR'
                        || lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_YEAR);

                    BEGIN
                        INSERT
                          INTO XXGEN_POLICY_VEHICLE_DTLS (VEHICLE_ID,
                                                          POLICY_NO,
                                                          VEHICLE_YEAR,
                                                          VEHICLE_MAKE,
                                                          VEHICLE_MODEL,
                                                          COLOR,
                                                          MILAGE,
                                                          CHASIS_NUMBER,
                                                          ENGINE_NUMBER,
                                                          CREATED_BY,
                                                          CREATED_DATE,
                                                          LAST_UPDATE_DATE,
                                                          LAST_UPDATED_BY)
                            VALUES (
                                       LN_VEHICLE_ID,
                                       LN_POLICY_NO,
                                       lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_YEAR,
                                       lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_MAKE,
                                       lv_policy_dtls (i).vehicle_dtls (K).VEHICLE_MODEL,
                                       lv_policy_dtls (i).vehicle_dtls (K).COLOR,
                                       lv_policy_dtls (i).vehicle_dtls (K).MILAGE,
                                       lv_policy_dtls (i).vehicle_dtls (K).CHASIS_NUMBER,
                                       lv_policy_dtls (i).vehicle_dtls (K).ENGINE_NUMBER,
                                       ln_submited_id,
                                       SYSDATE,
                                       SYSDATE,
                                       ln_submited_id);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            xxgen_error_log (
                                pi_policy_no        => ln_policy_no,
                                pi_submitter_id     => ln_submited_id,
                                pi_err_msg          =>    'Error while insert data into XXGEN_POLICY_VEHICLE_DTLS'
                                                       || SUBSTR (
                                                              DBMS_UTILITY.format_error_backtrace,
                                                              1,
                                                              400)
                                                       || SUBSTR (SQLERRM, 250),
                                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                po_return_status    => lv_err_msg,
                                po_return_message   => lv_err_msg,
                                p_request_status    => 'Error');
                            lv_commit_yn := 'N';
                    END;
                END LOOP;

                FOR j IN lv_policy_dtls (i).risk_details.FIRST ..
                         lv_policy_dtls (i).risk_details.LAST
                LOOP
                    IF     lv_policy_dtls (i).prod_code IN
                               ('MOTOR2', 'MOTOR4')
                       AND lv_policy_dtls (i).risk_details (J).risk_si
                               IS NULL
                    THEN
                        GET_VEHICLE_DEPRICIATION_IDV (
                            p_mfg_company_I   => lv_vehicle_mfg_comp,
                            p_model_id_I      => lv_vehicle_model,
                            P_YEAR_I          => ln_vehicle_year,
                            p_idv_o           => ln_vehile_dep_idv,
                            p_status_o        => lv_status,
                            p_err_msg_o       => lv_err_msg);
                        lv_policy_dtls (i).risk_details (J).risk_si :=
                            ln_vehile_dep_idv;

                        IF lv_err_msg = 'E'
                        THEN
                            xxgen_error_log (
                                pi_policy_no        => ln_policy_no,
                                pi_submitter_id     => ln_submited_id,
                                pi_err_msg          =>    'Error while calling api GET_VEHICLE_DEPRICIATION_IDV'
                                                       || SUBSTR (
                                                              DBMS_UTILITY.format_error_backtrace,
                                                              1,
                                                              400)
                                                       || lv_err_msg,
                                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                po_return_status    => lv_err_msg,
                                po_return_message   => lv_err_msg,
                                p_request_status    => 'Error');
                            lv_commit_yn := 'N';
                        END IF;

                        DBMS_OUTPUT.put_line (
                               'procedure GET_VEHICLE_DEPRICIATION_IDV lv_status :'
                            || lv_status
                            || ':'
                            || lv_err_msg);
                    END IF;

                    calc_risk_prem (
                        p_prod_code_i     => lv_policy_dtls (i).prod_code,
                        p_risk_code_i     => lv_policy_dtls (i).risk_details (J).RISK_CODE,
                        p_risk_SA_i       => lv_policy_dtls (i).risk_details (J).risk_si,
                        p_risk_remium_o   => ln_risk_calc_prem,
                        p_status_o        => lv_status,
                        p_err_msg_o       => lv_err_msg);

                    IF lv_err_msg = 'E'
                    THEN
                        xxgen_error_log (
                            pi_policy_no        => ln_policy_no,
                            pi_submitter_id     => ln_submited_id,
                            pi_err_msg          =>    'Error while calling api calc_risk_prem'
                                                   || SUBSTR (
                                                          DBMS_UTILITY.format_error_backtrace,
                                                          1,
                                                          400)
                                                   || lv_err_msg,
                            pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                            po_return_status    => lv_err_msg,
                            po_return_message   => lv_err_msg,
                            p_request_status    => 'Error');
                        lv_commit_yn := 'N';
                    END IF;

                    lv_policy_dtls (i).risk_details (J).RISK_PREMIUM :=
                        ln_risk_calc_prem;

                    ln_tot_pol_prem :=
                        ln_tot_pol_prem + NVL (ln_risk_calc_prem, 0);
                    lv_policy_dtls (i).TOTAL_PREMIUM := ln_tot_pol_prem;

                    DBMS_OUTPUT.put_line (
                           'procedure calc_risk_prem lv_status :'
                        || lv_status
                        || ':'
                        || lv_err_msg);

                    SELECT xxgen_POL_RISK_ID_seq.NEXTVAL
                      INTO LN_RISK_ID
                      FROM DUAL;

                    BEGIN
                        INSERT INTO XXGEN_POLICY_RISk_DTLS (POLICY_RISK_ID,
                                                            POLICY_NO,
                                                            RISK_CODE,
                                                            Risk_description,
                                                            RISK_SA,
                                                            Risk_premium,
                                                            START_DATE,
                                                            END_DATE,
                                                            CREATED_BY,
                                                            CREATED_DATE,
                                                            LAST_UPDATE_DATE,
                                                            LAST_UPDATED_BY)
                                 VALUES (
                                            LN_RISK_ID,
                                            LN_POLICY_NO,
                                            lv_policy_dtls (i).risk_details (
                                                J).RISK_CODE,
                                            lv_policy_dtls (i).risk_details (
                                                J).Risk_description,
                                            lv_policy_dtls (i).risk_details (
                                                J).risk_si,
                                            lv_policy_dtls (i).risk_details (
                                                J).RISK_PREMIUM,
                                            lv_policy_dtls (i).risk_details (
                                                J).START_DATE,
                                            lv_policy_dtls (i).risk_details (
                                                J).END_DATE,
                                            ln_submited_id,
                                            SYSDATE,
                                            SYSDATE,
                                            ln_submited_id);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            xxgen_error_log (
                                pi_policy_no        => ln_policy_no,
                                pi_submitter_id     => ln_submited_id,
                                pi_err_msg          =>    'Error while insert data into XXGEN_POLICY_RISk_DTLS'
                                                       || SUBSTR (
                                                              DBMS_UTILITY.format_error_backtrace,
                                                              1,
                                                              400)
                                                       || SUBSTR (SQLERRM, 250),
                                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                po_return_status    => lv_err_msg,
                                po_return_message   => lv_err_msg,
                                p_request_status    => 'Error');
                            lv_commit_yn := 'N';
                    END;
                END LOOP;

                DBMS_OUTPUT.put_line ('before driver details loop');

                FOR L IN lv_policy_dtls (i).driver_dtls.FIRST ..
                         lv_policy_dtls (i).driver_dtls.LAST
                LOOP
                    SELECT xxgen_V_DRIVER_ID_seq.NEXTVAL
                      INTO LN_DRIVER_ID
                      FROM DUAL;

                    DBMS_OUTPUT.put_line (
                           'lv_policy_dtls (i).driver_dtls (L).FIRST_NAME'
                        || lv_policy_dtls (i).driver_dtls (L).FIRST_NAME);

                    BEGIN
                        INSERT
                          INTO XXGEN_POLICY_DRIVER_DTLS (
                                   DRIVER_ID,
                                   POLICY_NO,
                                   FIRST_NAME,
                                   LAST_NAME,
                                   DRIVER_DOB,
                                   PHONE_NO,
                                   LICENSE_NO,
                                   LICENSE_ISSUE_DATE,
                                   LICENSE_ISSUE_STATE,
                                   IS_PRIMARY_POLICY_HOLDER,
                                   REL_WITH_POLICY_HOLDER,
                                   GENDER,
                                   MARITAL_STATUS,
                                   STATUS,
                                   CREATED_BY,
                                   CREATED_DATE,
                                   LAST_UPDATE_DATE,
                                   LAST_UPDATED_BY)
                            VALUES (
                                       LN_DRIVER_ID,
                                       LN_POLICY_NO,
                                       lv_policy_dtls (i).driver_dtls (L).FIRST_NAME,
                                       lv_policy_dtls (i).driver_dtls (L).LAST_NAME,
                                       lv_policy_dtls (i).driver_dtls (L).DRIVER_DOB,
                                       lv_policy_dtls (i).driver_dtls (L).PHONE_NO,
                                       lv_policy_dtls (i).driver_dtls (L).LICENSE_NO,
                                       lv_policy_dtls (i).driver_dtls (L).LICENSE_ISSUE_DATE,
                                       lv_policy_dtls (i).driver_dtls (L).LICENSE_ISSUE_STATE,
                                       lv_policy_dtls (i).driver_dtls (L).IS_PRIMARY_POLICY_HOLDER,
                                       lv_policy_dtls (i).driver_dtls (L).REL_WITH_POLICY_HOLDER,
                                       lv_policy_dtls (i).driver_dtls (L).GENDER,
                                       lv_policy_dtls (i).driver_dtls (L).MARITAL_STATUS,
                                       lv_policy_dtls (i).driver_dtls (L).STATUS,
                                       ln_submited_id,
                                       SYSDATE,
                                       SYSDATE,
                                       ln_submited_id);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            xxgen_error_log (
                                pi_policy_no        => ln_policy_no,
                                pi_submitter_id     => ln_submited_id,
                                pi_err_msg          =>    'Error while insert data into XXGEN_POLICY_DRIVER_DTLS'
                                                       || SUBSTR (
                                                              DBMS_UTILITY.format_error_backtrace,
                                                              1,
                                                              400)
                                                       || SUBSTR (SQLERRM, 250),
                                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                                po_return_status    => lv_err_msg,
                                po_return_message   => lv_err_msg,
                                p_request_status    => 'Error');
                            DBMS_OUTPUT.put_line ('excep' || SQLERRM);
                            lv_commit_yn := 'N';
                    END;
                END LOOP;

                UPDATE XXGEN_POLICY_DTLS
                   SET total_premium = ln_tot_pol_prem
                 WHERE policy_no = LN_POLICY_NO;

                Generate_agent_comm (
                    p_prod_code_i        => lv_policy_dtls (I).PROD_CODE,
                    p_policy_no_i        => LN_POLICY_NO,
                    p_agent_id_i         => lv_policy_dtls (I).AGENT_ID,
                    p_policy_premium_i   => ln_tot_pol_prem,
                    p_submitted_by_i     => ln_submited_id,
                    p_status_o           => lv_status,
                    p_err_msg_o          => lv_err_msg);

                IF lv_err_msg = 'E'
                THEN
                    xxgen_error_log (
                        pi_policy_no        => ln_policy_no,
                        pi_submitter_id     => ln_submited_id,
                        pi_err_msg          =>    'Error while calling api Generate_agent_comm'
                                               || SUBSTR (
                                                      DBMS_UTILITY.format_error_backtrace,
                                                      1,
                                                      400)
                                               || lv_err_msg,
                        pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                        po_return_status    => lv_err_msg,
                        po_return_message   => lv_err_msg,
                        p_request_status    => 'Error');
                    lv_commit_yn := 'N';
                END IF;

                DBMS_OUTPUT.put_line (
                       'procedure Generate_agent_comm lv_status :'
                    || lv_status
                    || ':'
                    || lv_err_msg);
            END LOOP;

            IF lv_commit_yn = 'N'
            THEN
                ROLLBACK TO policy_create;
                P_STATUS := 'E';
                p_err_msg := 'Error during creating policy';
            ELSE
                P_STATUS := 'S';
                p_err_msg :=
                       'Policy create succesfully. policy no :'
                    || LN_POLICY_NO
                    || 'with Premium :'
                    || ln_tot_pol_prem;
                xxgen_error_log (
                    pi_policy_no        => ln_policy_no,
                    pi_submitter_id     => ln_submited_id,
                    pi_err_msg          => p_err_msg,
                    pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                    po_return_status    => lv_err_msg,
                    po_return_message   => lv_err_msg,
                    p_request_status    => 'Message');
                COMMIT;
            END IF;
        END IF;
    EXCEPTION
        WHEN le_invalid_user
        THEN
            P_STATUS := 'E';
            p_err_msg := 'submitted by invaid user';
        WHEN OTHERS
        THEN
            P_STATUS := 'S';
            p_err_msg :=
                   'ERROR IN create_new_policy program'
                || DBMS_UTILITY.format_error_backtrace
                || ':'
                || SQLERRM;
            ROLLBACK TO policy_create;
    END;

    --below functino will calculate the risk premium
    PROCEDURE calc_risk_prem (p_prod_code_i         VARCHAR2,
                              p_risk_code_i         VARCHAR2,
                              p_risk_SA_i           NUMBER,
                              p_risk_remium_o   OUT NUMBER,
                              p_status_o        OUT VARCHAR2,
                              p_err_msg_o       OUT VARCHAR2)
    AS
        lv_status              VARCHAR2 (200) := 'S';
        lv_err_msg             VARCHAR2 (2000);
        ln_risk_prem_percent   NUMBER (10, 4);
        ln_calc_prem           NUMBER (20, 2) := 0;
    BEGIN
        BEGIN
            SELECT risk_premium_percent
              INTO ln_risk_prem_percent
              FROM XXGEN_PRODUCT_RISK_MASTER
             WHERE PROD_CODE = p_prod_code_i AND RISK_CODE = p_risk_code_i;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_status := 'E';
                lv_err_msg :=
                       'Product COde :'
                    || p_prod_code_i
                    || ' Risk code :'
                    || p_risk_code_i
                    || ' Premium percentage is not define in XXGEN_PRODUCT_RISK_MASTER table.';
            WHEN OTHERS
            THEN
                lv_status := 'E';
                lv_err_msg :=
                    'other except in calc_risk_prem procedure :' || SQLERRM;
        END;

        IF lv_status <> 'E'
        THEN
            ln_calc_prem :=
                ROUND ( ( (p_risk_SA_i * ln_risk_prem_percent) / 100), 2);
            p_risk_remium_o := ln_calc_prem;
            lv_status := 'S';
            lv_err_msg :=
                   'Calculated Premum for given Risk :'
                || p_risk_code_i
                || ' is '
                || ln_calc_prem;
        END IF;

        p_status_o := lv_status;
        p_err_msg_o := lv_err_msg;
    EXCEPTION
        WHEN OTHERS
        THEN
            xxgen_error_log (
                pi_policy_no        => NULL,
                pi_submitter_id     => NULL,
                pi_err_msg          =>    'Error calc_risk_prem procedure'
                                       || SUBSTR (
                                              DBMS_UTILITY.format_error_backtrace,
                                              1,
                                              400)
                                       || SUBSTR (SQLERRM, 250),
                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                po_return_status    => lv_err_msg,
                po_return_message   => lv_err_msg,
                p_request_status    => 'Error');

            p_status_o := 'E';
            p_err_msg_o :=
                'main Others excetion in calc_risk_prem' || SQLERRM;
    END calc_risk_prem;

    PROCEDURE GET_VEHICLE_DEPRICIATION_IDV (p_mfg_company_I       VARCHAR2,
                                            p_model_id_I          VARCHAR2,
                                            P_YEAR_I              NUMBER,
                                            p_idv_o           OUT NUMBER,
                                            p_status_o        OUT VARCHAR2,
                                            p_err_msg_o       OUT VARCHAR2)
    AS
        lv_status        VARCHAR2 (200) := 'S';
        lv_err_msg       VARCHAR2 (2000);
        ln_IDV           NUMBER (10, 4);
        ln_vehicle_age   NUMBER (10);
        ln_vehicle_dep   NUMBER (20, 2) := 0;
        ln_dep_idv       NUMBER (20, 2);
    BEGIN
        BEGIN
            SELECT INSURED_DECLARED_VALUE
              INTO ln_IDV
              FROM XXGEN_VEHICLE_MASTER
             WHERE     MFG_COMPANY_NAME = p_mfg_company_i
                   AND MODEL_ID = p_model_id_I;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_status := 'E';
                lv_err_msg :=
                       'MFG company :'
                    || p_mfg_company_i
                    || ' Model :'
                    || p_model_id_I
                    || ' IDV value is not defined in  XXGEN_VEHICLE_MASTER table.';
            WHEN OTHERS
            THEN
                lv_status := 'E';
                lv_err_msg :=
                    'other except in calc_risk_prem procedure :' || SQLERRM;
        END;

        SELECT dep_percent_on_idv
          INTO ln_vehicle_dep
          FROM XXGEN_VEHICLE_DEPRICIATION
         WHERE TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - P_YEAR_I BETWEEN VEHICLE_AGE_FROM
                                                                    AND VEHICLE_AGE_TO;

        IF lv_status <> 'E'
        THEN
            ln_dep_idv := ROUND ( ( (ln_IDV * ln_vehicle_dep) / 100), 2);
            p_idv_o := ln_IDV - NVL (ln_dep_idv, 0);
            lv_status := 'S';
            lv_err_msg := 'Calculated Depriciated vehicle id :' || p_idv_o;
        END IF;

        p_status_o := lv_status;
        p_err_msg_o := lv_err_msg;
    EXCEPTION
        WHEN OTHERS
        THEN
            xxgen_error_log (
                pi_policy_no        => NULL,
                pi_submitter_id     => NULL,
                pi_err_msg          =>    'Error GET_VEHICLE_DEPRICIATION_IDV procedure'
                                       || SUBSTR (
                                              DBMS_UTILITY.format_error_backtrace,
                                              1,
                                              400)
                                       || SUBSTR (SQLERRM, 250),
                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                po_return_status    => lv_err_msg,
                po_return_message   => lv_err_msg,
                p_request_status    => 'Error');
            p_status_o := 'E';
            p_err_msg_o :=
                'main Others excetion in calc_risk_prem' || SQLERRM;
    END GET_VEHICLE_DEPRICIATION_IDV;

    PROCEDURE Generate_agent_comm (p_prod_code_i            VARCHAR2,
                                   p_policy_no_i            NUMBER,
                                   p_agent_id_i             NUMBER,
                                   p_policy_premium_i       NUMBER,
                                   p_submitted_by_i         NUMBER,
                                   p_status_o           OUT VARCHAR2,
                                   p_err_msg_o          OUT VARCHAR2)
    AS
        ln_policy_conn    NUMBER (20, 2);
        ln_comm_percent   NUMBER (20, 2);
        lv_status         VARCHAR2 (200) := 'S';
        lv_err_msg        VARCHAR2 (2000);
    BEGIN
        BEGIN
            SELECT COMMISION_PERSENT
              INTO ln_comm_percent
              FROM XXGEN_AGEN_COMMISOIN_MASTER
             WHERE     AGENT_ID = p_agent_id_i
                   AND AGENT_PROD_CODE = p_prod_code_i;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_status := 'E';
                lv_err_msg :=
                       'Given agent id:'
                    || p_agent_id_i
                    || ' is not valid for Product code : '
                    || p_prod_code_i;
        END;

        IF lv_status <> 'E'
        THEN
            ln_policy_conn :=
                ROUND ( (p_policy_premium_i * ln_comm_percent) / 100, 2);

            INSERT INTO xxgen_policy_agent_comm (policy_no,
                                                 agent_id,
                                                 prod_code,
                                                 policy_premium,
                                                 policy_comm,
                                                 created_by,
                                                 created_date,
                                                 last_updated_by,
                                                 last_update_date)
                 VALUES (p_policy_no_i,
                         p_agent_id_i,
                         p_prod_code_i,
                         p_policy_premium_i,
                         ln_policy_conn,
                         p_submitted_by_i,
                         SYSDATE,
                         p_submitted_by_i,
                         SYSDATE);

            lv_status := 'S';
            lv_err_msg :=
                   'For policy No :'
                || p_policy_no_i
                || ' Commison :'
                || ln_policy_conn
                || ' Generated';
        END IF;

        p_status_o := lv_status;
        p_err_msg_o := lv_err_msg;
    EXCEPTION
        WHEN OTHERS
        THEN
            xxgen_error_log (
                pi_policy_no        => p_policy_no_i,
                pi_submitter_id     => p_submitted_by_i,
                pi_err_msg          =>    'Error Generate_agent_comm procedure'
                                       || SUBSTR (
                                              DBMS_UTILITY.format_error_backtrace,
                                              1,
                                              400)
                                       || SUBSTR (SQLERRM, 250),
                pi_module_name      => 'xxgen_create_edit_policy_pkg.create_new_policy',
                po_return_status    => lv_err_msg,
                po_return_message   => lv_err_msg,
                p_request_status    => 'Error');
            p_status_o := 'E';
            p_err_msg_o :=
                   'main Others excetion in calc_risk_prem'
                || DBMS_UTILITY.format_error_stack
                || ':'
                || SQLERRM;
    END Generate_agent_comm;

    PROCEDURE xxgen_error_log (
        pi_policy_no               NUMBER,
        pi_submitter_id            NUMBER,
        pi_err_msg                 VARCHAR2,
        pi_module_name             VARCHAR2,
        po_return_status       OUT VARCHAR2,
        po_return_message      OUT VARCHAR2,
        p_request_status    IN     VARCHAR2 DEFAULT NULL)
    IS
        v_message   VARCHAR2 (4000);
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO xxgen_policy_errors (policy_no,
                                         error_msg,
                                         module_name,
                                         created_by,
                                         creation_date,
                                         last_updated_by,
                                         last_update_date,
                                         request_status)
             VALUES (NVL (pi_policy_no, -1),
                     NVL (pi_err_msg, 'NO ERR MSG'),
                     pi_module_name,
                     NVL (pi_submitter_id, -1),
                     SYSDATE,
                     NVL (pi_submitter_id, -1),
                     SYSDATE,
                     p_request_status);

        COMMIT;
        po_return_status := 'S';
        po_return_message := NULL;
    EXCEPTION
        WHEN OTHERS
        THEN
            po_return_status := 'E';
            po_return_message := v_message || '-' || SQLERRM (SQLCODE);
    END xxgen_error_log;
END xxgen_create_edit_policy_pkg;
/

SHOW ERR