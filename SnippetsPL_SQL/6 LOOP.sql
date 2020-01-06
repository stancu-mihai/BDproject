LOOP
secvenţa_de_comenzi;
END LOOP;


DECLARE
v_contor BINARY_INTEGER := 1;
BEGIN
LOOP
INSERT INTO org_tab
VALUES (v_contor, 'indicele ciclului');
v_contor := v_contor + 1;
EXIT WHEN v_contor > 70;
END LOOP; COMMIT;
END;