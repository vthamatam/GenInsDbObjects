/* Formatted on 17-May-17 9:51:33 PM (QP5 v5.300) */
DECLARE
    l_insured_dtls   XXGEN_INSURED_OBJ_TAB_TYPE
                         := XXGEN_INSURED_OBJ_TAB_TYPE ();
    l_insured_addr   XXGEN_INS_ADDR_OBJ_TAB_TYPE
                         := XXGEN_INS_ADDR_OBJ_TAB_TYPE ();

    l_err_msg        VARCHAR2 (200);
    l_status         VARCHAR2 (2000);
BEGIN
    l_insured_dtls.EXTEND;
    l_insured_dtls (l_insured_dtls.COUNT) := NEW XXGEN_INSURED_OBJ_TYPE ();
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_ID := NULL;
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_NAME := 'Ravi';
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_DOB := '3-may-1984';
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_PHONE := 9999999;
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_QUALIFICATION := 'M.B.A';
    l_insured_dtls (l_insured_dtls.COUNT).INSURED_PROFISSION :=
        'Government servent';

    l_insured_addr.DELETE;
    l_insured_addr.EXTEND;
    l_insured_addr (l_insured_addr.COUNT) :=
        NEW XXGEN_INSURED_ADDR_OBJ_TYPE ();
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR_ID := NULL;
    l_insured_addr (l_insured_addr.COUNT).INSURED_ID := NULL;
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_TYPE := 'PERMANANT';
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_STATUS := 'Active';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR1 := 'Ameerper';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR2 := 'SR Nagar';
    l_insured_addr (l_insured_addr.COUNT).INSURED_CITY := 'Hyderabad';
    l_insured_addr (l_insured_addr.COUNT).INSURED_STATE := 'Telangana';
    l_insured_addr (l_insured_addr.COUNT).INSURED_COUNTRY := 'India';
    l_insured_addr (l_insured_addr.COUNT).INSURED_PINCODE := 500022;
    l_insured_addr (l_insured_addr.COUNT).Phone := 78708707;
    l_insured_addr (l_insured_addr.COUNT).email := 'ravi@gmail.com';

    l_insured_addr.EXTEND;
    l_insured_addr (l_insured_addr.COUNT) :=
        NEW XXGEN_INSURED_ADDR_OBJ_TYPE ();
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR_ID := NULL;
    l_insured_addr (l_insured_addr.COUNT).INSURED_ID := NULL;
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_TYPE := 'TEMPORARY';
    l_insured_addr (l_insured_addr.COUNT).ADDRESS_STATUS := 'Active';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR1 := 'ckp';
    l_insured_addr (l_insured_addr.COUNT).INSURED_ADDR2 := 'BADVEL';
    l_insured_addr (l_insured_addr.COUNT).INSURED_CITY := 'kadapa';
    l_insured_addr (l_insured_addr.COUNT).INSURED_STATE := 'Andhrapradesh';
    l_insured_addr (l_insured_addr.COUNT).INSURED_COUNTRY := 'India';
    l_insured_addr (l_insured_addr.COUNT).INSURED_PINCODE := 5165002;
    l_insured_addr (l_insured_addr.COUNT).Phone := 787787998;
    l_insured_addr (l_insured_addr.COUNT).email := 'ravi@gmail.com';

    l_insured_dtls (l_insured_dtls.COUNT).INSURED_ADDR := l_insured_addr;

    FOR I IN l_insured_dtls.FIRST .. l_insured_dtls.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE ('name :' || L_INSURED_DTLS (i).INSURED_NAME);
        
        FOR J IN l_insured_dtls(i).INSURED_ADDR.FIRST..l_insured_dtls(i).INSURED_ADDR.LAST
        LOOP
                DBMS_OUTPUT.PUT_LINE ('addrtype :' || L_INSURED_DTLS (i).INSURED_ADDR(j).ADDRESS_TYPE);
                DBMS_OUTPUT.PUT_LINE ('addr1 :' || L_INSURED_DTLS (i).INSURED_ADDR(j).INSURED_ADDR1);
        END LOOP;
    END LOOP;
END;
