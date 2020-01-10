FOR contor_ciclu IN [REVERSE] lim_inf..lim_sup LOOP
secvenţa_de_comenzi;
END LOOP;


for i in 1..vector_nume.count loop
    DBMS_OUTPUT.PUT_LINE('Result: '||vector_nume(i));
end loop;


ALTER TABLE opera
ADD stea VARCHAR2(20);
DEFINE p_cod_opera = 7777
DECLARE
v_cod_opera opera.cod_opera%TYPE := &p_cod_opera;
v_valoare opera.valoare%TYPE;
v_stea opera.stea%TYPE := NULL;
BEGIN
SELECT NVL(ROUND(valoare/10000),0)
INTO v_valoare
FROM opera
WHERE cod_opera = v_cod_opera;
IF v_valoare > 0 THEN
FOR i IN 1..v_valoare LOOP
v_stea := v_stea || '*';
END LOOP;
END IF;
UPDATE opera
SET stea = v_stea
WHERE cod_opera = v_cod_opera;
COMMIT;
END;


DECLARE
v_contor BINARY_INTEGER := 1;
raspuns VARCHAR2(10);
alt_raspuns VARCHAR2(10);
BEGIN
…
<<exterior>>
LOOP
v_contor := v_contor + 1;
EXIT WHEN v_contor > 70;
<<interior>>
LOOP
…
EXIT exterior WHEN raspuns = 'DA';
-- se parasesc ambele cicluri
EXIT WHEN alt_raspuns = 'DA';
-- se paraseste ciclul interior
…
END LOOP interior;
…
END LOOP exterior;
END;