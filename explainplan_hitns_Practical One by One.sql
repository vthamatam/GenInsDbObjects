--number distinct values in calumn query : 
select * from  user_tab_columns

--Parse
--Hard Parsing 
===============

SELECT * FROM SALES WHERE PROD_ID=13

SELECT * FROM SALES WHERE PROD_ID=14

select * from  v$sql where upper(sql_text) like 'SELECT * FROM SALES WHERE PROD_ID%'

--soft parsing 

SELECT * FROM SALES WHERE PROD_ID=:PRODID

--run above query and check below query you can find one entry 

select * from  v$sql where upper(sql_text) like 'SELECT * FROM SALES WHERE PROD_ID%'


----------------==========================================EXPLAIN PLAN  =========================================
----===========QUERY WITHOUT INDEX========================================
SQL> explain plan for select * from customers_BKP;

Explained.

SQL> ED DPLAN

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2290746930

-----------------------------------------------------------------------------------
| Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |               | 37620 |    10M|   333   (2)| 00:00:04 |
|   1 |  TABLE ACCESS FULL| CUSTOMERS_BKP | 37620 |    10M|   333   (2)| 00:00:04 |
----------------------------------------------------------------------------------- 
Note
-----

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
   - dynamic sampling used for this statement

12 rows selected.

--====================================================WITHOUT INDEX WITH FILTER================================
SQL> explain plan for select * from customers_BKP WHERE CUST_ID=49671;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2290746930

-----------------------------------------------------------------------------------
| Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |               |    16 |  4768 |   330   (1)| 00:00:04 |
|*  1 |  TABLE ACCESS FULL| CUSTOMERS_BKP |    16 |  4768 |   330   (1)| 00:00:04 |
-----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------

   1 - filter("CUST_ID"=49671)

Note
-----
   - dynamic sampling used for this statement

17 rows selected.
--========================================================WITH UNIQUE INDEX FILTER===========================
SQL> create unique index idx_CUST_id on CUSTOMERS_BKP (CUST_ID) compute statistics
  2  /

Index created.

SQL> explain plan for select * from customers_BKP WHERE CUST_ID=49671;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2770601958

---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     1 |   298 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| CUSTOMERS_BKP |     1 |   298 |     2   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | IDX_CUST_ID   |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
---------------------------------------------------

   2 - access("CUST_ID"=49671)

14 rows selected.
--============================================INDEX RANGE SCAN ==============================
SQL> explain plan for select * from customers_BKP WHERE CUST_ID<3;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2215645130

---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     2 |   596 |     5   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| CUSTOMERS_BKP |     2 |   596 |     5   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_CUST_ID   |     2 |       |     2   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
---------------------------------------------------

   2 - access("CUST_ID"<3)

Note
-----
   - dynamic sampling used for this statement

18 rows selected.
--===============================================INDEX FULL SCAN==================== WHEN WHERE CLAUSE CONDITINO >
SQL> explain plan for select * from customers_BKP WHERE CUST_ID>3;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2290746930

-----------------------------------------------------------------------------------
| Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |               | 37620 |    10M|   333   (2)| 00:00:04 |
|*  1 |  TABLE ACCESS FULL| CUSTOMERS_BKP | 37620 |    10M|   333   (2)| 00:00:04 |
-----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------

   1 - filter("CUST_ID">3)

Note
-----
   - dynamic sampling used for this statement

17 rows selected.
--==================================================B-TREE INDEX==============================================
--WITHOUT INDEX
SQL> EXPLAIN PLAN FOR SELECT * FROM CUSTOMERS_BKP WHERE CUST_CITY_ID=51442;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
-------------------------------------------------------------------------------------
Plan hash value: 2290746930

-----------------------------------------------------------------------------------
| Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |               |   118 | 35164 |   331   (2)| 00:00:04 |
|*  1 |  TABLE ACCESS FULL| CUSTOMERS_BKP |   118 | 35164 |   331   (2)| 00:00:04 |
-----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
-------------------------------------------------------------------------------------

   1 - filter("CUST_CITY_ID"=51442)

Note
-----
   - dynamic sampling used for this statement

17 rows selected.

---WITH  INDEX
SQL> CREATE INDEX IDX_CUSTCITY_ID_IDX ON CUSTOMERS_BKP(CUST_CITY_ID);

Index created.

SQL> EXPLAIN PLAN FOR SELECT * FROM CUSTOMERS_BKP WHERE CUST_CITY_ID=51442;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 1046224024

---------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                     |   134 | 24120 |   126   (0)| 00:00:02 |
|   1 |  TABLE ACCESS BY INDEX ROWID| CUSTOMERS_BKP       |   134 | 24120 |   126   (0)| 00:00:02 |
|*  2 |   INDEX RANGE SCAN          | IDX_CUSTCITY_ID_IDX |   134 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
---------------------------------------------------

   2 - access("CUST_CITY_ID"=51442)

14 rows selected.
--===================================================FUNCTIONAL BASED INDEX=============================
SQL> EXPLAIN PLAN FOR select  * from CUSTOMERS_BKP C WHERE UPPER(CUST_CITY) ='EDE'
  2  ;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2290746930

-----------------------------------------------------------------------------------
| Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |               |   555 | 99900 |   333   (2)| 00:00:05 |
|*  1 |  TABLE ACCESS FULL| CUSTOMERS_BKP |   555 | 99900 |   333   (2)| 00:00:05 |
-----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------

   1 - filter(UPPER("CUST_CITY")='EDE')

13 rows selected.

SQL> Create index ix_fname_idx on CUSTOMERS_BKP(upper(CUST_CITY));

Index created.

SQL> EXPLAIN PLAN FOR select  * from CUSTOMERS_BKP C WHERE UPPER(CUST_CITY) ='EDE';

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 1153674455

---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |   555 | 99900 |   208   (0)| 00:00:03 |
|   1 |  TABLE ACCESS BY INDEX ROWID| CUSTOMERS_BKP |   555 | 99900 |   208   (0)| 00:00:03 |
|*  2 |   INDEX RANGE SCAN          | IX_FNAME_IDX  |   222 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
---------------------------------------------------

   2 - access(UPPER("CUST_CITY")='EDE')

14 rows selected.
--=================================================== MULTIPLE TABLE JOINING  =========================================
--WITHOUT INDEX
SQL> EXPLAIN PLAN FOR SELECT SUM(AMOUNT_SOLD),COUNT(1),PROD_ID,TIME_ID FROM SALES_BKP S,CUSTOMERS_BK
P1 C
  2  WHERE S.CUST_ID=C.CUST_ID
  3  AND C.CUST_ID=987
  4  AND CUST_GENDER='M'
  5  GROUP BY PROD_ID,TIME_ID
  6  ORDER BY PROD_ID;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 514247046

--------------------------------------------------------------------------------------
| Id  | Operation           | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                |     2 |    76 |  1364   (4)| 00:00:17 |
|   1 |  SORT GROUP BY      |                |     2 |    76 |  1364   (4)| 00:00:17 |
|*  2 |   HASH JOIN         |                |     2 |    76 |  1363   (4)| 00:00:17 |
|*  3 |    TABLE ACCESS FULL| CUSTOMERS_BKP1 |     1 |    16 |   331   (2)| 00:00:04 |
|*  4 |    TABLE ACCESS FULL| SALES_BKP      |   183 |  4026 |  1031   (5)| 00:00:13 |
--------------------------------------------------------------------------------------

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("S"."CUST_ID"="C"."CUST_ID")
   3 - filter("C"."CUST_ID"=987 AND "CUST_GENDER"='M')
   4 - filter("S"."CUST_ID"=987)

Note
-----
   - dynamic sampling used for this statement
 --WITH INDEX
 SQL> EXPLAIN PLAN FOR SELECT SUM(AMOUNT_SOLD),COUNT(1),PROD_ID,TIME_ID FROM SALES S,CUSTOMERS C
  2  WHERE S.CUST_ID=C.CUST_ID
  3  AND C.CUST_ID=987
  4  AND CUST_GENDER='M'
  5  GROUP BY PROD_ID,TIME_ID
  6  ORDER BY PROD_ID;

Explained.

SQL> SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 1336107950

----------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name           | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |                |   130 |  3770 |    58   (2)| 00:00:01 |       |       |
|   1 |  SORT GROUP BY                       |                |   130 |  3770 |    58   (2)| 00:00:01 |       |       |
|*  2 |   HASH JOIN                          |                |   130 |  3770 |    57   (0)| 00:00:01 |       |       |
|*  3 |    TABLE ACCESS BY INDEX ROWID       | CUSTOMERS      |     1 |     7 |     2   (0)| 00:00:01 |
|*  4 |     INDEX UNIQUE SCAN                | CUSTOMERS_PK   |     1 |       |     1   (0)| 00:00:01 |       |
|   5 |    PARTITION RANGE ALL               |                |   130 |  2860 |    55   (0)| 00:00:01 |     1 |    28 

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
|   6 |     TABLE ACCESS BY LOCAL INDEX ROWID| SALES          |   130 |  2860 |    55   (0)| 00:00:01 |  
|   7 |      BITMAP CONVERSION TO ROWIDS     |                |       |       |            |          |       |       
|*  8 |       BITMAP INDEX SINGLE VALUE      | SALES_CUST_BIX |       |       |            |          |     1 
----------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("S"."CUST_ID"="C"."CUST_ID")
   3 - filter("CUST_GENDER"='M')
   4 - access("C"."CUST_ID"=987)

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
   8 - access("S"."CUST_ID"=987)

23 rows selected.
--===============================
--example of index fast full scan, BIT map index,Hash JOin,Partition Index
SELECT SUM(AMOUNT_SOLD),COUNT(1),TIME_ID FROM SALES S,CUSTOMERS Cy
WHERE S.CUST_ID=C.CUST_ID
--AND C.CUST_ID=987
AND CUST_GENDER='M'
AND TIME_ID='10-Jan-98'
GROUP BY TIME_ID
--example of FUll Table scan,index full and fast,hash join,view,hash group by,sort order by
SELECT SUM(AMOUNT_SOLD),COUNT(1),TIME_ID FROM SALES S,CUSTOMERS C
WHERE S.CUST_ID=C.CUST_ID
--AND C.CUST_ID=987
AND CUST_GENDER='M'
GROUP BY TIME_ID
HAVING COUNT(1)>30
ORDER BY 1


select SUM(AMOUNT_SOLD),S.CUST_ID,COUNT(1),S.TIME_ID from  SALES S ,CUSTOMERS C, TIMES T,CHANNELS C,PROMOTIONS P,PRODUCTS PR
WHERE S.CUST_ID=C.CUST_ID
AND  S.TIME_ID=T.TIME_ID
AND C.CHANNEL_ID=S.CHANNEL_ID 
AND S.PROMO_ID=P.PROMO_ID
AND PR.PROD_ID = S.PROD_ID
AND C.CHANNEL_ID=3
AND S.TIME_ID='20/Jan/98'
GROUP BY S.CUST_ID,S.TIME_ID

--=======================================HINTS example ===========================================

--FIRST_ROWS(n): This hint instructs the optimizer to select a plan that returns the first n rows most efficiently.

SELECT /*+ FIRST_ROWS(10) */ empno, ename
FROM emp
WHERE deptno = 10;

You may also want to read up about FIRST_ROWS_1, FIRST_ROWS_10 and FIRST_ROWS_100. Of interest, also, is ALL_ROWS which details the 
optimizer to choose the plan that most effectively returns the resultset at the minimum cost.
--===================================

--NO_INDEX(<table_name> < index_name>): Instructs the optimizer to specifically not use the named index in determining a plan.

SELECT /*+ NO_INDEX(emp emp_ix) */ empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

See also: the INDEX hint. You may also want to investigate INDEX_COMBINE, INDEX_JOIN, INDEX_ASC and INDEX_FFS.
--======================

--LEADING(table_name): This hint tells Oracle to use the parameterised table as the first in the join order. 
--The optimizer will consequently select a join chain that starts with this table.

SELECT /*+ LEADING (dept) */ empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--Related to the LEADING hint is the ORDERED hint.  This hint instructs Oracle to join tables in the exact order in which they are listed in the FROM clause.
---===========================================


--CACHE(table): This hint tells Oracle to add the blocks retrieved for the table to the head of the most recently used list. 
--This might be useful with regularly-used lookup tables, for example.

SELECT /*+ CACHE (d) */ deptno, dname
FROM dept d;

Oracle caches small tables by default, making this hint redundant in many cases. Also often redundant is the NOCACHE hint, since this places blocks at the tail of the LRU list, which is also Oracle’s default behaviour with the majority of blocks.
--===========================

--CARDINALITY(table n): This hint instructs Oracle to use n as the table, rather than rely on its own stats. 
--You may need to use this hint with a global temporary table, for instance.

SELECT /*+ CARDINALITY (gtt, 1000) */ gtt.gtt_id, dname
FROM dept d, global_temp_tab gtt
WHERE d.deptno = gtt.deptno;

--REWRITE: This hint instructs Oracle to rewrite the query using a materialized view, irrespective of cost. To learn more about Query Rewrite, you may want to read this other article that I wrote.

--PARALLEL (table n): This hint tells the optimizer to use n concurrent servers for a parallel operation.

--APPEND: This hint instructs the optimizer to carry out a direct-path insert.  This may make INSERT … SELECT statements faster because inserted data is simply appended to the end of the table and any referential constraints are ignored.

--FIRST_ROWS
SELECT /*+ FIRST_ROWS(10) */ CUST_FIRST_NAME,CUST_GENDER FROM CUSTOMERS  WHERE CUST_GENDER='F' --cost 2

SELECT  CUST_FIRST_NAME,CUST_GENDER FROM CUSTOMERS  WHERE CUST_GENDER='F' --cost 333
 
 SELECT /*+ FIRST_ROWS(10) */ prod_id,cust_id,amount_sold
  FROM sales
  WHERE prod_id = 13;
  
    select /*+ FULL(e) */ prod_name,prod_category,prod_subcategory from products e where prod_category like :pc 

 -------------append hint-------------
	In direct-path INSERT, data is appended to the end of the table, rather than using existing space currently allocated to the table. 
	As a result, direct-path INSERT can be considerably faster than conventional INSERT.
	----index hint-------------
	conn oe/oe

CREATE INDEX ix_customers_gender
ON customers(gender);

set autotrace traceonly explain

SELECT *
FROM customers
WHERE gender = 'M';

SELECT /*+ INDEX(customers ix_customers_gender) */ *
FROM customers
WHERE gender = 'M';

SELECT /*+ INDEX_ASC(customers ix_customers_gender) */ *
FROM customers
WHERE gender = 'M';

SELECT /*+ INDEX_DESC(customers ix_customers_gender) */ *
FROM customers
WHERE gender = 'M';
 
 select /*+ FULL(sales) PARALLEL(sales, 4) */  * from sales
 
 --===============================profiler=============================
 -- Install the DBMS_PROFILER package.
CONNECT sys/password@service AS SYSDBA
@$ORACLE_HOME/rdbms/admin/profload.sql
-- Install tables in a shared schema.
CREATE USER profiler IDENTIFIED BY profiler DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
GRANT CREATE SESSION TO profiler;
GRANT CREATE TABLE, CREATE SEQUENCE TO profiler;

CREATE PUBLIC SYNONYM plsql_profiler_runs FOR profiler.plsql_profiler_runs;
CREATE PUBLIC SYNONYM plsql_profiler_units FOR profiler.plsql_profiler_units;
CREATE PUBLIC SYNONYM plsql_profiler_data FOR profiler.plsql_profiler_data;
CREATE PUBLIC SYNONYM plsql_profiler_runnumber FOR profiler.plsql_profiler_runnumber;

CONNECT profiler/profiler@service
@$ORACLE_HOME/rdbms/admin/proftab.sql
GRANT SELECT ON plsql_profiler_runnumber TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON plsql_profiler_data TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON plsql_profiler_units TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON plsql_profiler_runs TO PUBLIC;

--============profiler example
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
      DBMS_PROFILER.start_profiler (
         run_comment   => 'CREATESALESPBKP: ' || SYSDATE);
   -- Call the procedure
   XXOE_CREATE_SALES_BKP_PKG.create_sales_p (
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


--==================bulk bind
CREATE TABLE bulk_collect_test ASSELECT owner,object_name,object_idFROM   all_objects; 
DECLARE
   TYPE t_bulk_collect_test_tab IS TABLE OF bulk_collect_test%ROWTYPE;
   l_tabt_bulk_collect_test_tab   := t_bulk_collect_test_tab();
l_start  NUMBER;
BEGIN  -- Time a regular population.
    l_start := DBMS_UTILITY.get_time;
FOR cur_rec IN (SELECT *  FROM   bulk_collect_test)
LOOP
      l_tab.extend;l_tab(l_tab.last) := cur_rec;
END LOOP;
DBMS_OUTPUT.put_line('Regular (' || l_tab.count || ' rows): ' ||(DBMS_UTILITY.get_time - l_start));  -- Time bulk population.
      l_start := DBMS_UTILITY.get_time;
    SELECT *  BULK COLLECT INTO l_tab  FROM bulk_collect_test;
DBMS_OUTPUT.put_line('Bulk    (' || l_tab.count || ' rows): ' ||(DBMS_UTILITY.get_time - l_start));
END;
Regular (42578 rows): 66
Bulk    (42578 rows): 4

--=================FORALL===============
CREATE TABLE forall_test (id NUMBER(10),code  VARCHAR2(10),description  VARCHAR2(50));
ALTER TABLE forall_test ADD (  CONSTRAINT forall_test_pk PRIMARY KEY (id));
ALTER TABLE forall_test ADD (  CONSTRAINT forall_test_uk UNIQUE (code)); 
DECLARE
   TYPE t_forall_test_tab IS TABLE OF forall_test%ROWTYPE;
   l_tabt_forall_test_tab   := t_forall_test_tab();
l_start  NUMBER;
l_size   NUMBER            := 10000;
BEGIN.
  FOR i IN 1 ..l_size LOOP -- Populate collection
l_tab.extend;
l_tab(l_tab.last).id          := i;
l_tab(l_tab.last).code        := TO_CHAR(i);
l_tab(l_tab.last).description := 'Description: ' || TO_CHAR(i);
  END LOOP;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE forall_test';
l_start := DBMS_UTILITY.get_time; -- Time regular inserts
  FOR i IN l_tab.first ..l_tab.last LOOP
    INSERT INTO forall_test (id, code, description)
    VALUES (l_tab(i).id, l_tab(i).code, l_tab(i).description);
  END LOOP;
DBMS_OUTPUT.put_line('Normal Inserts: ' || (DBMS_UTILITY.get_time - l_start));
  EXECUTE IMMEDIATE 'TRUNCATE TABLE forall_test';  -- Time bulk inserts.
l_start := DBMS_UTILITY.get_time;
  FORALL i IN l_tab.first ..l_tab.last
    INSERT INTO forall_test VALUES l_tab(i);
DBMS_OUTPUT.put_line('Bulk Inserts  : ' || (DBMS_UTILITY.get_time - l_start));
  COMMIT;
END;
--==================NOCOPY==================
DECLARE
TYPE t_tab IS TABLE OF VARCHAR2(32767); 
l_tab   t_tab := t_tab(); l_start NUMBER;
PROCEDURE in_out (p_tab IN OUT  t_tab) IS 
BEGIN
NULL;
END; 
PROCEDURE in_out_nocopy (p_tab   iN OUT NOCOPY    t_tab) IS
BEGIN
nULL;
END;
BEGIN
l_tab.extend;
l_tab(1) := '1234567890123456789012345678901234567890';
l_tab.extend(999999, 1); -- Copy element 1 into 2..1000000   
l_start := DBMS_UTILITY.get_time; -- Time normal IN OUT
in_out(l_tab);
DBMS_OUTPUT.put_line('IN OUT       : ' || (DBMS_UTILITY.get_time - l_start));
l_start := DBMS_UTILITY.get_time; -- Time IN OUT NOCOPY
in_out_nocopy(l_tab); -- pass IN OUT NOCOPY parameter
DBMS_OUTPUT.put_line('IN OUT NOCOPY: ' || (DBMS_UTILITY.get_time - l_start));
END;
--==============================PRAGMA INLINE===================
 --WITHOUT PRGAM INLINE
 DECLARE  
   LN$START_TIME  NUMBER;  
   LN$END_TIME   NUMBER;  
   LN$RESULT    NUMBER;  

   FUNCTION ADD_FIVE (IN_NUMBER1 NUMBER)  
    RETURN NUMBER  
   IS  
   BEGIN  
    RETURN NVL (IN_NUMBER1, 0) + 5;  
   END;  
 BEGIN  
   LN$START_TIME := DBMS_UTILITY.GET_TIME;  

   FOR I IN 1 .. 10000000  
   LOOP  
    LN$RESULT := ADD_FIVE (I);  
   END LOOP;  

   LN$END_TIME := DBMS_UTILITY.GET_TIME;  
   DBMS_OUTPUT.  
   PUT_LINE ('Time Elapsed is ' || TO_CHAR (LN$END_TIME - LN$START_TIME));  
 END;  

 --WITH PRGAM INLINE
 DECLARE  
   LN$START_TIME  NUMBER;  
   LN$END_TIME   NUMBER;  
   LN$RESULT    NUMBER;  

   FUNCTION ADD_FIVE (IN_NUMBER1 NUMBER)  
    RETURN NUMBER  
   IS  
   BEGIN  
    RETURN NVL (IN_NUMBER1, 0) + 5;  
   END;  
 BEGIN  
   LN$START_TIME := DBMS_UTILITY.GET_TIME;  

   FOR I IN 1 .. 10000000  
   LOOP  
    PRAGMA INLINE (ADD_FIVE, 'YES');  
    LN$RESULT := ADD_FIVE (I);  
   END LOOP;  

   LN$END_TIME := DBMS_UTILITY.GET_TIME;  
   DBMS_OUTPUT.  
   PUT_LINE ('Time Elapsed is ' || TO_CHAR (LN$END_TIME - LN$START_TIME));  
 END;

 
--------------------------------------Statistics------------------------
ANALYZE TABLE SALES_BKP DELETE STATISTICS;
/
SELECT SUM(AMOUNT_SOLD),COUNT(1),PROD_ID,TIME_ID FROM SALES_BKP S,CUSTOMERS c
    WHERE S.CUST_ID=C.CUST_ID
    AND C.CUST_ID=987
    AND CUST_GENDER='M'
    GROUP BY PROD_ID,TIME_ID
    ORDER BY PROD_ID;

select * from  V$SQL WHERE UPPER(SQL_TEXT) LIKE 'SELECT SUM(AMOUNT_SOLD),COUNT(1)%'

declare
stmt_task VARCHAR2(40);
begin
stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '552yy42gzhc22');
DBMS_OUTPUT.put_line('task_id: ' || stmt_task );
end;
/
EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => 'TASK_2666');
/
SELECT task_name, status FROM dba_advisor_log WHERE owner = 'SH';
/
SELECT DBMS_SQLTUNE.report_tuning_task('TASK_2666') AS recommendations FROM dual;
/
EXECUTE SYS.DBMS_SQLTUNE.drop_tuning_task (task_name => 'TASK_2666');