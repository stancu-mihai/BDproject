Schemele relaţionale ale modelului folosit sunt:
STATIE(cod_statie, denumire,nr_angajati, cod_companie, capacitate, oras)
ACHIZITIE (cod_st, cod_prod, data_achizitie, cantitate, pret_achizitie)
PRODUS (cod_produs, denumire, pret_vanzare)
COMPANIE (cod, denumire, capital, presedinte)

Exerciţii:
-- 1. Subprogram care primeşte ca parametru un cod de companie şi întoarce lista staţiilor
-- companiei care nu au mai achiziţionat produse în ultimele 10 zile. Apelaţi. (3p)
CREATE OR REPLACE FUNCTION Ex1 (IN Companie.Cod%TYPE)
RETURN 
    TABLE OF STATIE.cod_statie%TYPE
IS
    TYPE t_itable IS TABLE OF STATIE.cod_statie%TYPE
    INDEX BY PLS_INTEGER;
    v_itable t_itable;
BEGIN
    SELECT cod_statie
    BULK COLLECT INTO t_itable
    FROM statie S
    LEFT JOIN ACHIZITIE A on S.cod_statie=A.cod_st
    WHERE TO_NUMBER(TO_CHAR(SYSDATE-data_achizitie), 'DD-MON-YYYY') >10;
    RETURN v_itable;
END Ex1;

-- 2. Subprogram care primeşte ca parametru un cod de produs, afişează denumirea şi oraşul
-- staţiilor în care a fost distribuit la un preţ de achiziţie mai mic decât preţul de vânzare.
-- Subprogramul va returna cantitatea totală vandută din produsul dat ca parametru. Trataţi
-- erorile care pot sa apară. Apelaţi. (3p)
Schemele relaţionale ale modelului folosit sunt:
STATIE(cod_statie, denumire,nr_angajati, cod_companie, capacitate, oras)
ACHIZITIE (cod_st, cod_prod, data_achizitie, cantitate, pret_achizitie)
PRODUS (cod_produs, denumire, pret_vanzare)
COMPANIE (cod, denumire, capital, presedinte)

CREATE OR REPLACE FUNCTION Ex2 (IN cod PRODUS.COD%TYPE)
RETURN ACHIZITIE.CANTITATE%TYPE
IS
    v_cantitate ACHIZITIE.CANTITATE%TYPE;
BEGIN
    FOR i IN 
    (SELECT S.denumire as denumire, oras 
    FROM Achizitie A
    LEFT JOIN STATIE S ON A.cod_st = S.cod_statie
    LEFT JOIN PRODUS P on A.cod_prod = P.cod_produs
    WHERE pret_achizitie<pret_vanzare
    AND A.cod_prod = cod) LOOP
        DBMS_OUTPUT.PUT_LINE('Denumire:' || i.denumire || ' ,oras:' || i.oras);
    END LOOP;

    SELECT SUM(CANTITATE)
    INTO v_cantitate
    FROM Achizitie A
    WHERE cod_produs = cod;
    RETURN v_cantitate;
END Ex2;

-- 3. Să se adauge tabelului statie o coloană stoc care să reprezinte cantitatea totală de
-- produse achiziţionate de fiecare staţie. Actualizaţi această coloană. Să se scrie un trigger
-- care asigură consistenţa acestei coloane. (3p) 
Schemele relaţionale ale modelului folosit sunt:
STATIE(cod_statie, denumire,nr_angajati, cod_companie, capacitate, oras)
ACHIZITIE (cod_st, cod_prod, data_achizitie, cantitate, pret_achizitie)
PRODUS (cod_produs, denumire, pret_vanzare)
COMPANIE (cod, denumire, capital, presedinte)

ALTER TABLE Statie Add ctotala NUMBER(12,2);
/
DECLARE
    TYPE t_itable IS TABLE OF STATIE.cod_statie%TYPE
    INDEX BY PLS_INTEGER;
    v_itable t_itable;
BEGIN
    SELECT cod_statie BULK COLLECT INTO v_itable FROM statie;
    FOR i IN v_itable.FIRST..v_itable.LAST LOOP
        UPDATE STATIE SET ctotala = 
            (SELECT SUM(cantitate)
                FROM Achizitie
                WHERE cod_statie= v_itable(i)
                )
        WHERE cod_statie=v_itable(i)
    END LOOP
END;

CREATE OR REPLACE TRIGGER I_U_D_ctotala 
BEFORE INSERT OR UPDATE OR DELETE OF cantitate ON achizitie
FOR EACH ROW
DECLARE
    STATIE.cod_statie%TYPE
BEGIN
    IF INSERTING THEN
        UPDATE STATIE SET ctotala=ctotala + :NEW.cantitate
        WHERE cod_statie = :NEW.cod_statie;
    ELSIF DELETING THEN
        UPDATE STATIE SET ctotala=ctotala - :OLD.cantitate
        WHERE cod_statie = :OLD.cod_statie;
    ELSE
        UPDATE STATIE SET ctotala=ctotala + :NEW.cantitate - :OLD.cantitate
        WHERE cod_statie = :NEW.cod_statie;
    END IF;
END;