WHILE condiţie LOOP
secvenţa_de_comenzi;
END LOOP;




DECLARE
v_contor BINARY_INTEGER := 1;
BEGIN
WHILE v_contor <= 70 LOOP
INSERT INTO org_tab
VALUES (v_contor, 'indicele ciclului');
v_contor := v_contor + 1;
END LOOP;
END;