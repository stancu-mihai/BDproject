-- cu test_var

[<<eticheta>>]
CASE test_var
WHEN valoare_1 THEN secvenţa_de_comenzi_1;
WHEN valoare_2 THEN secvenţa_de_comenzi_2;
…
WHEN valoare_k THEN secvenţa_de_comenzi_k;
[ELSE altă_secvenţă;]
END CASE [eticheta];


-- Exemplu
SET SERVEROUTPUT ON
DEFINE p_zi = x
DECLARE
v_zi CHAR(2) := UPPER('&p_zi');
BEGIN
CASE v_zi
WHEN 'L' THEN DBMS_OUTPUT.PUT_LINE('Luni');
WHEN 'M' THEN DBMS_OUTPUT.PUT_LINE('Marti');
WHEN 'MI' THEN DBMS_OUTPUT.PUT_LINE('Miercuri');
WHEN 'J' THEN DBMS_OUTPUT.PUT_LINE('Joi');
WHEN 'V' THEN DBMS_OUTPUT.PUT_LINE('Vineri');
WHEN 'S' THEN DBMS_OUTPUT.PUT_LINE('Sambata');
WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE('Duminica');
ELSE DBMS_OUTPUT.PUT_LINE('este o eroare!');
END CASE;
END;
/
SET SERVEROUTPUT OFF


-- fara test_var

[<<eticheta>>]
CASE
WHEN condiţie_1 THEN secvenţa_de_comenzi_1;
WHEN condiţie_2 THEN secvenţa_de_comenzi_2;
…
WHEN condiţie_k THEN secvenţa_de_comenzi_k;
[ELSE altă_secvenţă;]
END CASE [eticheta];


--Exemplu
SET SERVEROUTPUT ON
DEFINE p_zi = x
DECLARE
v_zi CHAR(2) := UPPER('&p_zi');
BEGIN
CASE
WHEN v_zi = 'L' THEN
DBMS_OUTPUT.PUT_LINE('Luni');
WHEN v_zi = 'M' THEN
DBMS_OUTPUT.PUT_LINE('Marti');
WHEN v_zi = 'MI' THEN
DBMS_OUTPUT.PUT_LINE('Miercuri');
WHEN v_zi = 'J' THEN
DBMS_OUTPUT.PUT_LINE('Joi');
WHEN v_zi = 'V' THEN
DBMS_OUTPUT.PUT_LINE('Vineri');
WHEN v_zi = 'S' THEN
DBMS_OUTPUT.PUT_LINE('Sambata');
WHEN v_zi = 'D' THEN
DBMS_OUTPUT.PUT_LINE('Duminica');
ELSE DBMS_OUTPUT.PUT_LINE('Este o eroare!');
END CASE;
END;
/
SET SERVEROUTPUT OFF



--CASE in comanda SQL din PL/SQL
BEGIN
FOR j IN (SELECT
        CASE valoare
            WHEN 1000 THEN 1100
            WHEN 10000 THEN 11000
            WHEN 100000 THEN 110000
            ELSE valoare
        END
    FROM opera)
…
END LOOP;
END;