DECLARE
alfa INTERVAL YEAR TO MONTH;
BEGIN
alfa := INTERVAL '200-7' YEAR TO MONTH;
-- alfa ia valoarea 200 de ani si 7 luni
alfa := INTERVAL '200' YEAR;
-- pot fi specificati numai anii
alfa := INTERVAL '7' MONTH;
-- pot fi specificate numai lunile
alfa := '200-7';
-- conversie implicita din caracter
END;