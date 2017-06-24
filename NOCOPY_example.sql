
The test user will need the following privileges to compile the test code.

CONN / AS SYSDBA

GRANT SELECT ON v_$statname TO test;
GRANT SELECT ON v_$mystat TO test;
GRANT CREATE PROCEDURE TO test;

With the privileges in place, compile the test code displayed below.

CONN test/test

CREATE OR REPLACE PACKAGE test_nocopy AS

PROCEDURE in_out_time;
PROCEDURE in_out_memory;
PROCEDURE in_out_nocopy_time;
PROCEDURE in_out_nocopy_memory;

END;
/

CREATE OR REPLACE PACKAGE BODY test_nocopy AS

TYPE     t_tab IS TABLE OF VARCHAR2(32767);
g_tab    t_tab := t_tab();
g_start  NUMBER;

FUNCTION get_stat (p_stat IN VARCHAR2) RETURN NUMBER;
PROCEDURE in_out (p_tab  IN OUT  t_tab);
PROCEDURE in_out_nocopy (p_tab  IN OUT NOCOPY  t_tab);

-- Function to return the specified statistics value.
FUNCTION get_stat (p_stat IN VARCHAR2) RETURN NUMBER AS
  l_return  NUMBER;
BEGIN
  SELECT ms.value
  INTO   l_return
  FROM   v$mystat ms,
         v$statname sn
  WHERE  ms.statistic# = sn.statistic#
  AND    sn.name = p_stat;
  RETURN l_return;
END get_stat;


-- Basic test procedures.
PROCEDURE in_out (p_tab  IN OUT  t_tab) IS
  l_count NUMBER;
BEGIN
  l_count := p_tab.count;
END in_out;

PROCEDURE in_out_nocopy (p_tab  IN OUT NOCOPY  t_tab) IS
  l_count NUMBER;
BEGIN
  l_count := p_tab.count;
END in_out_nocopy;


-- Time a single call using IN OUT.
PROCEDURE in_out_time IS
BEGIN
   g_start := DBMS_UTILITY.get_time;

   in_out(g_tab);

   DBMS_OUTPUT.put_line('IN OUT Time         : ' || 
                        (DBMS_UTILITY.get_time - g_start) || ' hsecs');
END in_out_time;


-- Check the memory used by a single call using IN OUT.
PROCEDURE in_out_memory IS
BEGIN
   g_start := get_stat('session pga memory');

   in_out(g_tab);

   DBMS_OUTPUT.put_line('IN OUT Memory       : ' || 
                        (get_stat('session pga memory') - g_start) || ' bytes');
END in_out_memory;


-- Time a single call using IN OUT NOCOPY.
PROCEDURE in_out_nocopy_time IS
BEGIN
   g_start := DBMS_UTILITY.get_time;

   in_out_nocopy(g_tab);

   DBMS_OUTPUT.put_line('IN OUT NOCOPY Time  : ' || 
                        (DBMS_UTILITY.get_time - g_start) || ' hsecs');
END in_out_nocopy_time;


-- Check the memory used by a single call using IN OUT NOCOPY.
PROCEDURE in_out_nocopy_memory IS
BEGIN
   g_start := get_stat('session pga memory');

   in_out_nocopy(g_tab);

   DBMS_OUTPUT.put_line('IN OUT NOCOPY Memory: ' || 
                        (get_stat('session pga memory') - g_start) || ' bytes');
END in_out_nocopy_memory;


-- Initialization block to populate test collection.
BEGIN
  g_tab.extend;
  g_tab(1) := '1234567890123456789012345678901234567890';
  g_tab.extend(999999, 1);  -- Copy element 1 into 2..1000000
END;
/

The test code includes the following basic elements:

    g_tab : A global collection populated with a million rows in the initialization block of the package.
    get_stat : A function to return the specified statistics value. In this case we will use this to return the "session pga memory" value before and after the test and calculate the delta value, representing the memory allocated during the test. Remember, PGA memory is allocated in chunks, so the value will not represent exactly what is required for the temporary buffer space.
    in_out[_nocopy] : Two test procedures that accept a collection as a parameter and check the number of rows in the collection. The definitions are the same, except for the inclusion of the NOCOPY hint in one of them.
    in_out[_nocopy]_time : Two procedures that measure the elapsed time associated with calling their respective test procedures.
    in_out[_nocopy]_memory : Two procedures that measure the memory allocated when calling their respective test procedures.

Run The Tests

When running the test procedures, it makes sense to reconnect every time to make sure you get a new session with a clean PGA allocation.

CONN test/test

SET SERVEROUTPUT ON
EXEC test_nocopy.in_out_time;

CONN test/test

SET SERVEROUTPUT ON
EXEC test_nocopy.in_out_nocopy_time;

CONN test/test

SET SERVEROUTPUT ON
EXEC test_nocopy.in_out_memory;

CONN test/test

SET SERVEROUTPUT ON
EXEC test_nocopy.in_out_nocopy_memory;

When we run these tests, the output looks something like this.

Connected.
IN OUT Time         : 126 hsecs

PL/SQL procedure successfully completed.

Connected.
IN OUT NOCOPY Time  : 0 hsecs

PL/SQL procedure successfully completed.

Connected.
IN OUT Memory       : 99549184 bytes

PL/SQL procedure successfully completed.

Connected.
IN OUT NOCOPY Memory: 0 bytes

PL/SQL procedure successfully completed.

SQL>