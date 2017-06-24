CREATE TABLE PRODUCTS_BKP
AS
   SELECT * FROM PRODUCTS
/

CREATE TABLE CUSTOMERS_BKP
AS
   SELECT * FROM CUSTOMERS
/

CREATE TABLE SALES_BKP
AS
   SELECT * FROM SALES
/

CREATE TABLE CHANNELS_BKP
AS
   SELECT * FROM CHANNELS
/

CREATE TABLE COSTS_BKP
AS
   SELECT * FROM COSTs
/

CREATE TABLE PROMOTIONS_BKP
AS
   SELECT * FROM PROMOTIONS
/
CREATE TABLE TIMES_BKP AS SELECT * FROM TIMES
/
CREATE OR REPLACE PROCEDURE CREATE_SALES_bkp_prc (P_PROD_ID_i             NUMBER,
                             P_CUST_ID_i             NUMBER,
                             P_TIME_ID_I             DATE,
                             P_CHANNEL_ID_i          NUMBER,
                             P_PROMO_ID_i            NUMBER,
                             P_QUANTITY_SOLD_i       NUMBER,
                             P_STATUS_o          OUT VARCHAR2,
                             P_ERR_MSG_o         OUT VARCHAR2)
   AS
      L_STATUS    VARCHAR2 (200);
      L_ERR_MSG   VARCHAR2 (2000);
      l_UDE       EXCEPTION;
      L_COST      NUMBER (10, 2);
	  LV_PROMO_NAME   VARCHAR2 (2000);
	        LV_PROD_NAME   VARCHAR2 (2000);
			LV_CUST_NAME   VARCHAR2 (2000);
			LV_CHANNEL_NAME VARCHAR2(2000);
			LD_TIME_ID   DATE;
   BEGIN
      L_STATUS := 'S';
     
	 BEGIN
	 SELECT PROD_NAME
        INTO LV_PROD_NAME
        FROM PRODUCTS_bkp
       WHERE     PROD_ID = P_PROD_ID_i
             AND SYSDATE BETWEEN PROD_EFF_FROM AND NVL (PROD_EFF_TO, SYSDATE);
		EXCEPTION WHEN no_data_found THEN
		L_STATUS := 'E';
         L_ERR_MSG := 'Invalid Prod id :' || P_PROD_ID_i;
      WHEN OTHERS
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := 'exception :' || SQLERRM;
		END;
		

      IF L_STATUS = 'E'
      THEN
         RAISE l_UDE;
      END IF;
	  
	  BEGIN
      SELECT CUST_FIRST_NAME
        INTO LV_CUST_NAME
        FROM CUSTOMERS_bkp
       WHERE CUST_ID = P_CUST_ID_i;
		 
		EXCEPTION WHEN no_data_found THEN
		L_STATUS := 'E';
         L_ERR_MSG := 'Invalid CUSTOMER id :' || P_CUST_ID_i;
      WHEN OTHERS
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := 'exception :' || SQLERRM;
		END;
		
      IF L_STATUS = 'E'
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := L_ERR_MSG;
         RAISE l_UDE;
      END IF;
	  
	  BEGIN
      SELECT CHANNEL_DESC
        INTO LV_CHANNEL_NAME
        FROM CHANNELS_bkp
       WHERE CHANNEL_ID = P_CHANNEL_ID_i; 
		EXCEPTION WHEN no_data_found THEN
		L_STATUS := 'E';
         L_ERR_MSG := 'Invalid cHANNEL id :' || P_CHANNEL_ID_i;
      WHEN OTHERS
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := 'exception :' || SQLERRM;
		END;
		
      IF L_STATUS = 'E'
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := L_ERR_MSG;
         RAISE l_UDE;
      END IF;


      BEGIN
      SELECT TIME_ID
        INTO LD_TIME_ID
        FROM TIMES_bkp
       WHERE TIME_ID = P_TIME_ID_i; 
		EXCEPTION WHEN no_data_found THEN
		L_STATUS := 'E';
         L_ERR_MSG := 'Invalid P_TIME_ID id :' || P_TIME_ID_i;
      WHEN OTHERS
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := 'exception :' || SQLERRM;
		END;
		
      IF L_STATUS = 'E'
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := L_ERR_MSG;
         RAISE l_UDE;
      END IF;

      BEGIN
            SELECT PROMO_NAME
        INTO LV_PROMO_NAME
        FROM PROMOTIONS_bkp
       WHERE PROMO_ID = p_PROMO_id_i; 
		EXCEPTION WHEN no_data_found THEN
		L_STATUS := 'E';
         L_ERR_MSG := 'Invalid p_PROMO_id id :' || p_PROMO_id_i;
      WHEN OTHERS
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := 'exception :' || SQLERRM;
		END;
		
      IF L_STATUS = 'E'
      THEN
         L_STATUS := 'E';
         L_ERR_MSG := L_ERR_MSG;
         RAISE l_UDE;
      END IF;


      IF SIGN (P_QUANTITY_SOLD_i) = '-1'
      THEN
         L_ERR_MSG := 'Quantity sold should be possitive value';
         L_STATUS := 'E';
         RAISE l_UDE;
      END IF;

      BEGIN
         SELECT UNIT_PRICE
           INTO L_COST
           FROM COSTS_bkp
          WHERE     PROD_ID = P_PROD_ID_i
                AND TIME_ID = P_TIME_ID_I
                AND PROMO_ID = P_PROMO_ID_i
                AND CHANNEL_ID = P_CHANNEL_ID_i;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               SELECT PROD_LIST_PRICE
                 INTO L_COST
                 FROM PRODUCTS_bkp
                WHERE PROD_ID = P_PROD_ID_i;
            EXCEPTION
               WHEN OTHERS
               THEN
                  L_ERR_MSG := 'Unknown error while gettigg Cost';
                  L_STATUS := 'E';

                  DBMS_OUTPUT.PUT_LINE ('L_STATUS :' || L_STATUS);
                  DBMS_OUTPUT.PUT_LINE ('L_ERR_MSG :' || L_ERR_MSG);
                  RAISE l_UDE;
            END;
      END;

      DBMS_OUTPUT.PUT_LINE ('L_STATUS :' || L_STATUS);
      DBMS_OUTPUT.PUT_LINE ('L_ERR_MSG :' || L_ERR_MSG);

      IF L_STATUS IN ('Y', 'S')
      THEN
         DBMS_OUTPUT.PUT_LINE ('INSEDE L_STATUS :' || L_STATUS);
         DBMS_OUTPUT.PUT_LINE ('INSIDE L_ERR_MSG :' || L_ERR_MSG);

         INSERT INTO SALES_bkp (PROD_ID,
                            CUST_ID,
                            TIME_ID,
                            CHANNEL_ID,
                            PROMO_ID,
                            QUANTITY_SOLD,
                            AMOUNT_SOLD)
              VALUES (P_PROD_ID_i,
                      P_CUST_ID_i,
                      P_TIME_ID_I,
                      P_CHANNEL_ID_i,
                      P_PROMO_ID_i,
                      P_QUANTITY_SOLD_i,
                      ROUND (P_QUANTITY_SOLD_i * L_COST));

         COMMIT;
      END IF;

      FOR REP
         IN (SELECT *
               FROM SALES_BKP
              WHERE     PROD_ID = P_PROD_ID_i
                    AND CUST_ID = P_CUST_ID_i
                    AND TIME_ID = P_TIME_ID_I
                    AND PROMO_ID = P_PROMO_ID_i)
      LOOP
         DBMS_OUTPUT.PUT_LINE (
            'prod Id :' || rep.prod_id || ':amount sold :' || rep.AMOUNT_SOLD);
      END LOOP;

      L_STATUS := 'S';
      L_ERR_MSG := 'Sales order created successfyllu.......';
      DBMS_OUTPUT.PUT_LINE ('L_STATUS :' || L_STATUS);
      DBMS_OUTPUT.PUT_LINE ('L_ERR_MSG :' || L_ERR_MSG);
      P_STATUS_o := L_STATUS;
      P_ERR_MSG_o := L_ERR_MSG;
   EXCEPTION
      WHEN l_UDE
      THEN
         P_STATUS_o := L_STATUS;
         P_ERR_MSG_o := L_ERR_MSG;
      WHEN OTHERS
      THEN
         P_STATUS_o := 'E';
         P_ERR_MSG_o := 'Unknown Exception :' || SQLERRM;
   END;
   
   --TKprof
ALTER SYSTEM SET TIMED_STATISTICS = TRUE;
/
ALTER SESSION SET SQL_TRACE = TRUE; 
/
--excecute the plsql program
DECLARE
   l_result       BINARY_INTEGER;
   L_PROD_ID      NUMBER := 14;
   L_PROMO        NUMBER := 999;
   L_CUST_ID      NUMBER := 6783;
   L_TIME_ID      DATE := '17-Jan-98';
   L_CHANNEL_ID   NUMBER := 3;
   L_QTY_SOLD     NUMBER := 2;
   L_STATUS       VARCHAR2 (2);
   L_ERR_MSG      VARCHAR2 (2000);
BEGIN
      -- Call the procedure
   CREATE_SALES_bkp_prc (
      p_prod_id_i         => L_PROD_ID,
      p_cust_id_i         => L_CUST_ID,
      p_time_id_i         => L_TIME_ID,
      p_channel_id_i      => L_CHANNEL_ID,
      p_promo_id_i        => L_PROMO,
      p_quantity_sold_i   => L_QTY_SOLD,
      p_status_o          => L_STATUS,
      p_err_msg_o         => L_ERR_MSG);

   DBMS_OUTPUT.PUT_LINE ('L_STATUS :' || L_STATUS);
   DBMS_OUTPUT.PUT_LINE ('L_ERR_MSG :' || L_ERR_MSG);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE ('error' || SQLERRM);
END;
/
ALTER SESSION SET SQL_TRACE = FALSE; 
 /
 --check the trace file in D:\oracle\product\10.2.0\admin\WIP\udump
 /
 TKPROF D:\oracle\product\10.2.0\admin\WIP\udump\wip_ora_4456.trc C:\VenuPerfomancetune\TKproof_rep24.txt explain=sh/oracle@wip table=sys.plan_table
   --=========================Profile
DECLARE
   l_result       BINARY_INTEGER;
   L_PROD_ID      NUMBER := 14;
   L_PROMO        NUMBER := 999;
   L_CUST_ID      NUMBER := 6783;
   L_TIME_ID      DATE := '17-Jan-98';
   L_CHANNEL_ID   NUMBER := 3;
   L_QTY_SOLD     NUMBER := 2;
   L_STATUS       VARCHAR2 (2);
   L_ERR_MSG      VARCHAR2 (2000);
BEGIN
   l_result :=
      DBMS_PROFILER.start_profiler (RUN_COMMENT   => 'TEST: ' || SYSDATE);
DBMS_OUTPUT.PUT_LINE('l_result'||l_result);      
   -- Call the procedure
   CREATE_SALES_bkp_prc (
      p_prod_id_i         => L_PROD_ID,
      p_cust_id_i         => L_CUST_ID,
      p_time_id_i         => L_TIME_ID,
      p_channel_id_i      => L_CHANNEL_ID,
      p_promo_id_i        => L_PROMO,
      p_quantity_sold_i   => L_QTY_SOLD,
      p_status_o          => L_STATUS,
      p_err_msg_o         => L_ERR_MSG);
   l_result := DBMS_PROFILER.stop_profiler;
   DBMS_OUTPUT.PUT_LINE ('L_STATUS :' || L_STATUS);
   DBMS_OUTPUT.PUT_LINE ('L_ERR_MSG :' || L_ERR_MSG);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE ('error' || SQLERRM);
END;

DELETE FROM PLSQL_PROFILER_DATA

DELETE FROM PLSQL_PROFILER_UNITS

SELECT * FROM PLSQL_PROFILER_DATA

SELECT C.LINE#,U.TEXT,C.TOTAL_OCCUR,
   C.TOTAL_TIME/1000000000 LINE_TOT_SECS,
   C.MIN_TIME/1000000000 MIN_TIME,
   C.MAX_TIME/1000000000 MAX_TIME,
A.RUN_TOTAL_TIME /1000000000 TOTAL_RUN_SEC,
A.RUN_OWNER
FROM PLSQL_PROFILER_RUNS A,PLSQL_PROFILER_UNITS B,
PLSQL_PROFILER_DATA C,USER_SOURCE U
WHERE A.RUNID=B.RUNID
AND A.RUNID=C.RUNID AND  B.UNIT_NAME=U.NAME
AND C.LINE#=U.LINE

SELECT u.runid, u.unit_number, u.unit_type, u.unit_owner, 
u.unit_name, d.line#, A.TEXT, 
d.total_occur, d.total_time, 
d.min_time, d.max_time ,name
FROM plsql_profiler_units u, all_source a, plsql_profiler_data d 
WHERE 1=1
--AND U.runid=16 
and u.runid=d.runid 
AND u.unit_number=d.unit_number 
and owner='SH' 
AND type='PROCEDURE' 
AND U.unit_name='CREATE_SALES_PRC'
and d.line#=a.line 
ORDER BY u.unit_number,d.line#;