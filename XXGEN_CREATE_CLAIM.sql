CREATE OR REPLACE PACKAGE XXGEN_CREATE_CLAIM IS

PROCEDURE XXGEN_INITIATE_CLAIMS
    (
     P_POLICY_NO_i         IN XXGEN_CLAIMS.POLICY_NO%TYPE
    ,P_CLAIM_DATE_i        IN XXGEN_CLAIMS.CLAIM_DATE%TYPE
	,p_claim_risk           in XXGEN_CLAIMS.CLAIM_risk%TYPE
    ,P_AMOUNT_CLAIMED_i    IN XXGEN_CLAIMS.AMOUNT_CLAIMED%TYPE
    ,P_cre_upd_by_i        IN XXGEN_CLAIMS.CREATED_BY%TYPE
	,p_status_O         OUT VARCHAR2
    ,p_err_msg_O        OUT VARCHAR2
    ) ;
	
	PROCEDURE XXGEN_CLAIMS_DOCS_PRC(P_CLAIM_ID_I        IN XXGEN_CLAIMS_DOCS.CLAIM_ID%TYPE,
                                  P_DOC_TYPE_CODE_I   IN XXGEN_CLAIMS_DOCS.DOC_TYPE_CODE%TYPE,
                                  P_DOC_DESCRIPTION_I IN XXGEN_CLAIMS_DOCS.DOC_DESCRIPTION%TYPE,
                                  P_CRE_UPD_BY_I      IN XXGEN_CLAIMS_DOCS.CREATED_BY%TYPE,
                                  P_STATUS_O          OUT VARCHAR2,
                                  P_ERR_MSG_O         OUT VARCHAR2);
	
	PROCEDURE XXGEN_CLM_SURVEYOR_ASSIGN_PRC(P_SURVEYOR_ID_I           IN XXGEN_CLAIMS_SURVEYOR_DTLS.SURVEYOR_ID%TYPE,
                                          P_CLAIM_ID_I              IN XXGEN_CLAIMS_SURVEYOR_DTLS.CLAIM_ID%TYPE,
                                          P_CRE_UPD_BY_I            IN XXGEN_CLAIMS_SURVEYOR_DTLS.CREATED_BY%TYPE,
                                          P_STATUS_O                OUT VARCHAR2,
                                          P_ERR_MSG_O               OUT VARCHAR2);
	PROCEDURE XXGEN_CLM_SURVEYOR_update_PRC(P_CLAIM_ID_I              IN XXGEN_CLAIMS_SURVEYOR_DTLS.CLAIM_ID%TYPE,
											P_CLM_SURVEY_STATUS_I     IN XXGEN_CLAIMS_SURVEYOR_DTLS.clm_survey_status%TYPE,
											P_surveyor_comments_I    IN XXGEN_CLAIMS_SURVEYOR_DTLS.surveyor_comments%TYPE,
											P_Surveyor_claim_amount_I    IN XXGEN_CLAIMS_SURVEYOR_DTLS.Surveyor_claim_amount%TYPE,
                                          P_CRE_UPD_BY_I            IN XXGEN_CLAIMS_SURVEYOR_DTLS.CREATED_BY%TYPE,
                                          P_STATUS_O                OUT VARCHAR2,
                                          P_ERR_MSG_O               OUT VARCHAR2);
										  

	PROCEDURE XXGEN_CLAIMS_SETTELE_PRC(P_CLAIM_ID_I            IN XXGEN_CLAIMS_PROCESS_DTLS.CLAIM_ID%TYPE,
                                     P_POLICY_NO_I           IN XXGEN_CLAIMS_PROCESS_DTLS.POLICY_NO%TYPE,
                                     P_CLAIM_DATE_I          IN XXGEN_CLAIMS_PROCESS_DTLS.CLAIM_DATE%TYPE,
                                     P_AMOUNT_CLAIMED_I      IN XXGEN_CLAIMS_PROCESS_DTLS.AMOUNT_CLAIMED%TYPE,
                                     P_AMOUNT_SETTELED_I     IN XXGEN_CLAIMS_PROCESS_DTLS.AMOUNT_SETTELED%TYPE,
                                     P_DATE_OF_SETTELE_I     IN XXGEN_CLAIMS_PROCESS_DTLS.DATE_OF_SETTELE%TYPE,
                                     P_TOTAL_POLICY_AMOUNT_I IN XXGEN_CLAIMS_PROCESS_DTLS.TOTAL_POLICY_AMOUNT%TYPE,
                                     P_TOTAL_CLAIM_AMOUNT_I  IN XXGEN_CLAIMS_PROCESS_DTLS.TOTAL_CLAIM_AMOUNT%TYPE,
                                     P_CRE_UPD_BY_I          IN XXGEN_CLAIMS_PROCESS_DTLS.CREATED_BY%TYPE,
                                     P_STATUS_O              OUT VARCHAR2,
                                     P_ERR_MSG_O             OUT VARCHAR2);
	
END XXGEN_CREATE_CLAIM;
/
CREATE OR REPLACE PACKAGE BODY XXGEN_CREATE_CLAIM IS

  PROCEDURE XXGEN_INITIATE_CLAIMS(P_POLICY_NO_I          IN XXGEN_CLAIMS.POLICY_NO%TYPE,
                                  P_CLAIM_DATE_I         IN XXGEN_CLAIMS.CLAIM_DATE%TYPE,
                                  P_CLAIM_RISK           IN XXGEN_CLAIMS.CLAIM_RISK%TYPE,
                                  P_AMOUNT_CLAIMED_I     IN XXGEN_CLAIMS.AMOUNT_CLAIMED%TYPE,
                                  P_CRE_UPD_BY_I         IN XXGEN_CLAIMS.CREATED_BY%TYPE,
                                  P_STATUS_O             OUT VARCHAR2,
                                  P_ERR_MSG_O            OUT VARCHAR2) IS
    LN_CLAIM_ID  NUMBER;
    LN_POLICY_C  NUMBER;
    LN_ERR_MSG   VARCHAR2(4000);
    LV_STATUS    VARCHAR2(2);
    LV_RISK_CODE VARCHAR2(200);
    LN_RISK_SI   NUMBER;
    LN_POLICY_NO NUMBER;
  BEGIN
    SELECT XXGEN_CLAIM_ID_SEQ.NEXTVAL INTO LN_CLAIM_ID FROM DUAL;
  
    BEGIN
      SELECT POLICY_NO
        INTO LN_POLICY_NO
        FROM XXGEN_POLICY_DTLS
       WHERE POLICY_NO = P_POLICY_NO_I;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        LN_ERR_MSG := 'Err1 : GIven POlicy no ' || P_POLICY_NO_I ||
                      '  is not valid. pls. provide valid Policy No';
        LV_STATUS  := 'E';
    END;
  
    BEGIN
      SELECT RISK_CODE, RISK_SA
        INTO LV_RISK_CODE, LN_RISK_SI
        FROM XXGEN_POLICY_RISK_DTLS
       WHERE RISK_CODE = P_CLAIM_RISK
         AND POLICY_NO = P_POLICY_NO_I;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        LN_ERR_MSG := LN_ERR_MSG || '        Err2 : Risk ' || P_CLAIM_RISK ||
                      ' is not valid risk for POlicy no ' || P_POLICY_NO_I ||
                      'pls. check policy coverages';
        LV_STATUS  := 'E';
    END;
  
    IF LN_RISK_SI < P_AMOUNT_CLAIMED_I THEN
      LN_ERR_MSG := LN_ERR_MSG || '        Err3 : Claimed Amount :' ||
                    P_AMOUNT_CLAIMED_I ||
                    ' is grater than policy Risk SI :' || LN_RISK_SI;
      LV_STATUS  := 'E';
    END IF;
  
    IF P_CLAIM_DATE_I > SYSDATE THEN
      LN_ERR_MSG := LN_ERR_MSG ||
                    '        Err4 : Claimed Date shoudl not be future date ';
      LV_STATUS  := 'E';
    END IF;
  
    IF LV_STATUS <> 'E' THEN
      INSERT INTO XXGEN_CLAIMS
        (CLAIM_ID,
         POLICY_NO,
         CLAIM_DATE,
         AMOUNT_CLAIMED,
         AMOUNT_SETTELED,
         DATE_OF_SETTELE,
         TOTAL_POLICY_AMOUNT,
         CREATED_BY,
         CREATED_DATE,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY)
      VALUES
        (LN_CLAIM_ID,
         P_POLICY_NO_I,
         P_CLAIM_DATE_I,
         P_AMOUNT_CLAIMED_I,
         0,
         NULL,
         LN_RISK_SI,
         P_CRE_UPD_BY_I,
         SYSDATE,
         SYSDATE,
         P_CRE_UPD_BY_I);
      COMMIT;
    END IF;
    IF LV_STATUS = 'E' THEN
      P_STATUS_O  := LV_STATUS;
      P_ERR_MSG_O := LN_ERR_MSG;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_STATUS_O  := 'E';
      P_ERR_MSG_O := 'Error while executing the procedure XXGEN_INITIATE_CLAIMS';
    
  END XXGEN_INITIATE_CLAIMS;

  PROCEDURE XXGEN_CLAIMS_DOCS_PRC(P_CLAIM_ID_I        IN XXGEN_CLAIMS_DOCS.CLAIM_ID%TYPE,
                                  P_DOC_TYPE_CODE_I   IN XXGEN_CLAIMS_DOCS.DOC_TYPE_CODE%TYPE,
                                  P_DOC_DESCRIPTION_I IN XXGEN_CLAIMS_DOCS.DOC_DESCRIPTION%TYPE,
                                  P_CRE_UPD_BY_I      IN XXGEN_CLAIMS_DOCS.CREATED_BY%TYPE,
                                  P_STATUS_O          OUT VARCHAR2,
                                  P_ERR_MSG_O         OUT VARCHAR2) IS
    LN_CLM_DOC_ID NUMBER;
  BEGIN
  
    SELECT XXGEN_CLM_DOC_ID_SEQ.NEXTVAL INTO LN_CLM_DOC_ID FROM DUAL;
    INSERT INTO XXGEN_CLAIMS_DOCS
      (CLAIM_DOC_ID,
       CLAIM_ID,
       DOC_TYPE_CODE,
       DOC_DESCRIPTION,
       CREATED_BY,
       CREATED_DATE,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY)
    VALUES
      (LN_CLM_DOC_ID,
       P_CLAIM_ID_I,
       P_DOC_TYPE_CODE_I,
       P_DOC_DESCRIPTION_I,
       P_CRE_UPD_BY_I,
       SYSDATE,
       SYSDATE,
       P_CRE_UPD_BY_I);
    COMMIT;
    P_STATUS_O  := 'Claim Documents submitted';
    P_ERR_MSG_O := 'S';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_STATUS_O  := 'E';
      P_ERR_MSG_O := 'Error while executing the procedure XXGEN_CLAIMS_DOCS_PRC';
  END XXGEN_CLAIMS_DOCS_PRC;

  PROCEDURE XXGEN_CLM_SURVEYOR_ASSIGN_PRC(P_SURVEYOR_ID_I IN XXGEN_CLAIMS_SURVEYOR_DTLS.SURVEYOR_ID%TYPE,
                                          P_CLAIM_ID_I    IN XXGEN_CLAIMS_SURVEYOR_DTLS.CLAIM_ID%TYPE,
                                          P_CRE_UPD_BY_I  IN XXGEN_CLAIMS_SURVEYOR_DTLS.CREATED_BY%TYPE,
                                          P_STATUS_O      OUT VARCHAR2,
                                          P_ERR_MSG_O     OUT VARCHAR2) IS
  
    LN_ERR_MSG       VARCHAR2(4000);
    LV_STATUS        VARCHAR2(2);
    LV_SURVEYOR_ID   NUMBER;
    LV_SURVEYOR_NAME VARCHAR2(200);
  
  BEGIN
  
    BEGIN
      SELECT SURVEYOR_ID, SURVEYOR_NAME
        INTO LV_SURVEYOR_ID, LV_SURVEYOR_NAME
        FROM XXGEN_CLAIMS_SURVEYOR_MASTER
       WHERE SURVEYOR_ID = P_SURVEYOR_ID_I;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        LN_ERR_MSG := 'Err1 : GIve Surveyor id :' || P_SURVEYOR_ID_I ||
                      ' is not valid pls assing valid surveyor id';
        LV_STATUS  := 'E';
    END;
  
    INSERT INTO XXGEN_CLAIMS_SURVEYOR_DTLS
      (SURVEYOR_ID,
       SURVEYOR_NAME,
       CLM_SURVEY_STATUS,
       CLAIM_ID,
       CREATED_BY,
       CREATED_DATE,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY)
    VALUES
      (P_SURVEYOR_ID_I,
       LV_SURVEYOR_NAME,
       'PENDING SURVEY',
       P_CLAIM_ID_I,
       P_CRE_UPD_BY_I,
       SYSDATE,
       SYSDATE,
       P_CRE_UPD_BY_I);
    COMMIT;
    P_STATUS_O  := ' surveyor assigned to Claim';
    P_ERR_MSG_O := 'S';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_STATUS_O  := 'E';
      P_ERR_MSG_O := 'Error while executing the procedure XXGEN_CLM_SURVEYOR_ASSIGN_PRC';
  END XXGEN_CLM_SURVEYOR_ASSIGN_PRC;
  --============
  PROCEDURE XXGEN_CLM_SURVEYOR_UPDATE_PRC(P_CLAIM_ID_I              IN XXGEN_CLAIMS_SURVEYOR_DTLS.CLAIM_ID%TYPE,
                                          P_CLM_SURVEY_STATUS_I     IN XXGEN_CLAIMS_SURVEYOR_DTLS.CLM_SURVEY_STATUS%TYPE,
                                          P_SURVEYOR_COMMENTS_I     IN XXGEN_CLAIMS_SURVEYOR_DTLS.SURVEYOR_COMMENTS%TYPE,
                                          P_SURVEYOR_CLAIM_AMOUNT_I IN XXGEN_CLAIMS_SURVEYOR_DTLS.SURVEYOR_CLAIM_AMOUNT%TYPE,
                                          P_CRE_UPD_BY_I            IN XXGEN_CLAIMS_SURVEYOR_DTLS.CREATED_BY%TYPE,
                                          P_STATUS_O                OUT VARCHAR2,
                                          P_ERR_MSG_O               OUT VARCHAR2) IS
  
    LN_ERR_MSG VARCHAR2(4000);
    LV_STATUS  VARCHAR2(2);
  
  BEGIN
  
    UPDATE XXGEN_CLAIMS_SURVEYOR_DTLS
       SET CLM_SURVEY_STATUS     = P_CLM_SURVEY_STATUS_I,
           SURVEYOR_COMMENTS     = P_SURVEYOR_COMMENTS_I,
           SURVEYOR_CLAIM_AMOUNT = P_SURVEYOR_CLAIM_AMOUNT_I
     WHERE CLAIM_ID = P_CLAIM_ID_I;
    COMMIT;
    P_STATUS_O  := 'Claim updated surveyor';
    P_ERR_MSG_O := 'S';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_STATUS_O  := 'E';
      P_ERR_MSG_O := 'Error while executing the procedure XXGEN_CLM_SURVEYOR_update_PRC';
  END XXGEN_CLM_SURVEYOR_UPDATE_PRC;

  PROCEDURE XXGEN_CLAIMS_SETTELE_PRC(P_CLAIM_ID_I            IN XXGEN_CLAIMS_PROCESS_DTLS.CLAIM_ID%TYPE,
                                     P_POLICY_NO_I           IN XXGEN_CLAIMS_PROCESS_DTLS.POLICY_NO%TYPE,
                                     P_CLAIM_DATE_I          IN XXGEN_CLAIMS_PROCESS_DTLS.CLAIM_DATE%TYPE,
                                     P_AMOUNT_CLAIMED_I      IN XXGEN_CLAIMS_PROCESS_DTLS.AMOUNT_CLAIMED%TYPE,
                                     P_AMOUNT_SETTELED_I     IN XXGEN_CLAIMS_PROCESS_DTLS.AMOUNT_SETTELED%TYPE,
                                     P_DATE_OF_SETTELE_I     IN XXGEN_CLAIMS_PROCESS_DTLS.DATE_OF_SETTELE%TYPE,
                                     P_TOTAL_POLICY_AMOUNT_I IN XXGEN_CLAIMS_PROCESS_DTLS.TOTAL_POLICY_AMOUNT%TYPE,
                                     P_TOTAL_CLAIM_AMOUNT_I  IN XXGEN_CLAIMS_PROCESS_DTLS.TOTAL_CLAIM_AMOUNT%TYPE,
                                     P_CRE_UPD_BY_I          IN XXGEN_CLAIMS_PROCESS_DTLS.CREATED_BY%TYPE,
                                     P_STATUS_O              OUT VARCHAR2,
                                     P_ERR_MSG_O             OUT VARCHAR2) IS
    LN_PROCESS_ID NUMBER;
  BEGIN
  
    SELECT XXGEN_CLM_PROCESS_ID_SEQ.NEXTVAL INTO LN_PROCESS_ID FROM DUAL;
  
    INSERT INTO XXGEN_CLAIMS_PROCESS_DTLS
      (CLM_PROCESS_ID,
       CLAIM_ID,
       POLICY_NO,
       CLAIM_DATE,
       AMOUNT_CLAIMED,
       AMOUNT_SETTELED,
       DATE_OF_SETTELE,
       TOTAL_POLICY_AMOUNT,
       TOTAL_CLAIM_AMOUNT,
       CREATED_BY,
       CREATED_DATE,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY)
    VALUES
      (LN_PROCESS_ID,
       P_CLAIM_ID_I,
       P_POLICY_NO_I,
       P_CLAIM_DATE_I,
       P_AMOUNT_CLAIMED_I,
       P_AMOUNT_SETTELED_I,
       P_DATE_OF_SETTELE_I,
       P_TOTAL_POLICY_AMOUNT_I,
       P_TOTAL_CLAIM_AMOUNT_I,
       P_CRE_UPD_BY_I,
       SYSDATE,
       SYSDATE,
       P_CRE_UPD_BY_I);
    COMMIT;
    P_STATUS_O  := 'Claim processed ';
    P_ERR_MSG_O := 'S';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_STATUS_O  := 'E';
      P_ERR_MSG_O := 'Error while executing the procedure XXGEN_CLAIMS_SETTELE_PRC';
  END XXGEN_CLAIMS_SETTELE_PRC;

END XXGEN_CREATE_CLAIM;
/

