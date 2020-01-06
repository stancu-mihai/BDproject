IF condiţie1 THEN
secvenţa_de_comenzi_1
[ELSIF condiţie2 THEN
secvenţa_de_comenzi_2]
…
[ELSE
secvenţa_de_comenzi_n]
END IF;




SET SERVEROUTPUT ON
DEFINE p_cod_gal = 753
DECLARE
v_cod_galerie opera.cod_galerie%TYPE := &p_cod_gal;
v_numar NUMBER(3) := 0;
v_comentariu VARCHAR2(10);
BEGIN
SELECT COUNT(*)
INTO v_numar
FROM opera
WHERE cod_galerie = v_cod_galerie;
IF v_numar < 100 THEN
v_comentariu := 'mica';
ELSIF v_numar BETWEEN 100 AND 200 THEN
v_comentariu := 'medie';
ELSE
v_comentariu := 'mare';
END IF;
DBMS_OUTPUT.PUT_LINE('Galeria avand codul '||
v_cod_galerie ||' este de tip '|| v_comentariu);
END;
/
SET SERVEROUTPUT OFF