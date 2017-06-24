/* Formatted on 23/May/17 7:35:04 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE xxgen_create_edit_RI_pkg
AS
    PROCEDURE create_RI (P_POLICY_NO_I          NUMBER,
                         p_risk_code_i          VARCHAR2,
                         p_risk_SA_i            NUMBER,
                         p_prod_code_i          VARCHAR2,
                         p_submitted_by_i       NUMBER,
                         p_status           OUT VARCHAR2,
                         p_err_msg          OUT VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY xxgen_create_edit_RI_pkg
AS
    PROCEDURE create_RI (P_POLICY_NO_I          NUMBER,
                         p_risk_code_i          VARCHAR2,
                         p_risk_SA_i            NUMBER,
                         p_prod_code_i          VARCHAR2,
                         p_submitted_by_i       NUMBER,
                         p_status           OUT VARCHAR2,
                         p_err_msg          OUT VARCHAR2)
    AS
        lv_status                VARCHAR2 (20);
        lv_err_msg               VARCHAR2 (200);
        lv_retension_max         NUMBER (20);
        ln_exces_amount          NUMBER (20);
        ln_treaty_amount         NUMBER (20);
        ln_treaty_sa             NUMBER (20);
        ln_participant_sa        NUMBER (20);
        ln_participant_Premium   NUMBER (20);
		ln_retension_premium   number(20);
		ln_treaty_preamium number(20);
		ln_retension_sa number(20);

        CURSOR cr_priority
        IS
              SELECT *
                FROM XXGEN_RI_PRIORITY_MASTER
               WHERE prod_code = p_prod_code_i
            ORDER BY priority;

        CURSOR cr_retension
        IS
            SELECT *
              FROM XXGEN_RETENSION_MASTER
             WHERE ri_prod_code = p_prod_code_i;

        CURSOR cr_treaty (p_treaty_code VARCHAR2)
        IS
            SELECT *
              FROM XXGEN_RI_TREATY_MASTER
             WHERE prod_code = p_prod_code_i AND TREATY_CODE = p_treaty_code;

        CURSOR cr_ri_participants (p_treaty_code VARCHAR2)
        IS
            SELECT *
              FROM XXGEN_RI_TREATY_PARTICIPANTS
             WHERE TREATY_CODE = p_treaty_code;
    BEGIN
        FOR priority IN cr_priority
        LOOP
            IF PRIORITY.TREATY_CODE = 'RETENSION'
            THEN
                FOR ret IN cr_retension
                LOOP
                    lv_retension_max := ret.MAX_RETENSION_LIMIT; 

                        ln_treaty_amount :=
                            p_risk_SA_i - lv_retension_max;
							
				xxgen_create_edit_policy_pkg.calc_risk_prem (
                            p_prod_code_i     => p_prod_code_i,
                            p_risk_code_i     => p_risk_code_i,
                            p_risk_SA_i       => lv_retension_max,
                            p_risk_remium_o   => ln_retension_premium,
                            p_status_o        => lv_status,
                            p_err_msg_o       => lv_err_msg);
					
   
                    

                    INSERT
                      INTO XXGEN_POLICY_RETENSION_DTLS (POLICY_NO,
                                                        retension_risk_code,
                                                        RETENSION_RISK_SA,
                                                        RETENSION_PERCENT,
                                                        RETENSION_RISK_PREMIUM,
                                                        CREATED_BY,
                                                        CREATED_DATE,
                                                        LAST_UPDATE_DATE,
                                                        LAST_UPDATED_BY)
                    VALUES (P_POLICY_NO_I,
                            p_risk_code_i,
                            lv_retension_max,
                            NULL,
                            ln_retension_premium,
                            p_submitted_by_i,
                            SYSDATE,
                            SYSDATE,
                            p_submitted_by_i);
                END LOOP;
            ELSE
                FOR treaty IN cr_treaty (PRIORITY.TREATY_CODE)
                LOOP
                    IF ln_treaty_amount > treaty.TREATY_MAX_LIMIT
                    THEN
                        ln_exces_amount :=
                            ln_treaty_amount - treaty.TREATY_MAX_LIMIT;
                        ln_treaty_sa := treaty.TREATY_MAX_LIMIT;
                    ELSE
                        ln_treaty_sa := ln_treaty_amount;
                    END IF;
					DBMS_OUTPUT.PUT_LINE('ln_treaty_sa'||ln_treaty_sa);
				
				IF ln_treaty_sa>0 THEN
					 xxgen_create_edit_policy_pkg.calc_risk_prem (
                            p_prod_code_i     => p_prod_code_i,
                            p_risk_code_i     => p_risk_code_i,
                            p_risk_SA_i       => ln_treaty_sa,
                            p_risk_remium_o   => ln_treaty_preamium,
                            p_status_o        => lv_status,
                            p_err_msg_o       => lv_err_msg);
							
                    
                    INSERT
                      INTO XXGEN_POLICY_TREATY_DTLS (POLICY_NO,
                                                     TREATY_CODE,
                                                     treaty_risk_code,
                                                     TREATY_PERCENT,
                                                     TREAY_RISK_SA,
                                                     TREATY_RISK_PREMIUM,
                                                     CREATED_BY,
                                                     CREATED_DATE,
                                                     LAST_UPDATE_DATE,
                                                     LAST_UPDATED_BY)
                    VALUES (P_POLICY_NO_I,
                            PRIORITY.TREATY_CODE,
                            p_risk_code_i,
                            NULL,
                            ln_treaty_sa,
                            ln_treaty_preamium,
                            p_submitted_by_i,
                            SYSDATE,
                            SYSDATE,
                            p_submitted_by_i);

                    FOR participants
                        IN cr_ri_participants (PRIORITY.TREATY_CODE)
                    LOOP
                        ln_participant_sa :=
                              (ln_treaty_sa * participants.TREATY_FIX_PERCENT)
                            / 100;

							xxgen_create_edit_policy_pkg.calc_risk_prem (
                            p_prod_code_i     => p_prod_code_i,
                            p_risk_code_i     => p_risk_code_i,
                            p_risk_SA_i       => ln_participant_sa,
                            p_risk_remium_o   => ln_participant_Premium,
                            p_status_o        => lv_status,
                            p_err_msg_o       => lv_err_msg);
						
                        INSERT
                          INTO XXGEN_POLICY_RI_PARTICIPANTS (
                                   POLICY_NO,
                                   TREATY_CODE,
                                   INSTITUTION_CODE,
                                   INSTITUTION_BRANCH,
                                   INSTITUTION_NAME,
                                   RI_risk_code,
                                   PARTICIPANT_risk_PERCENT,
                                   PARTICIPANT_RISK_SA,
                                   PARTICIPANT_PREMIUM,
                                   CREATED_BY,
                                   CREATED_DATE,
                                   LAST_UPDATE_DATE,
                                   LAST_UPDATED_BY)
                        VALUES (P_POLICY_NO_I,
                                PRIORITY.TREATY_CODE,
                                participants.INSTITUTION_CODE,
                                participants.INSTITUTION_branch,
                                participants.INSTITUTION_name,
                                p_risk_code_i,
                                participants.TREATY_FIX_PERCENT,
                                ln_participant_sa,
                                ln_participant_Premium,
                                p_submitted_by_i,
                                SYSDATE,
                                SYSDATE,
                                p_submitted_by_i);
                    END LOOP;
                    ln_treaty_amount := ln_exces_amount;
					END IF;
                END LOOP;
            END IF;
        END LOOP;
		P_STATUS := 'S';
            p_err_msg :=
                   'Re Insurance Calculations happend successfully..';
EXCEPTION
WHEN OTHERS
        THEN
            P_STATUS := 'E';
            p_err_msg :=
                   'ERROR IN create_new_policy program'
                || DBMS_UTILITY.format_error_backtrace
                || ':'
                || SQLERRM;
    END;
END xxgen_create_edit_RI_pkg;
/
SHOW ERR