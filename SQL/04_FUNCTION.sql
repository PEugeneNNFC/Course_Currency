/******************************************************************************/
--
--  Функция : Получаем идентивикатор даты, но сначала вставляем дату.
--  Дату мы берем серверную.
--

--  Пересоздание функции
CREATE OR REPLACE FUNCTION schm_course_currency.fnc_date_get_id()
RETURNS BIGINT
AS
$$
DECLARE a_date  TIMESTAMP DEFAULT statement_timestamp();
        a_id    BIGINT;
BEGIN
  SELECT  d.f_id INTO a_id
    FROM  schm_course_currency.tbl_date AS d
    WHERE to_char(d.f_date, 'YYYY-MM-DD') = to_char(a_date, 'YYYY-MM-DD');
  
  IF (a_id = 0) OR (a_id IS NULL) THEN
    SELECT nextval('schm_course_currency.sqnc_date_next_id') INTO a_id;
    
    INSERT INTO schm_course_currency.tbl_date(f_id, f_date)
      VALUES (a_id, a_date);
  END IF;

  RETURN a_id;
END
$$
LANGUAGE plpgsql
VOLATILE;

--  Добавить комментарий
COMMENT ON FUNCTION schm_course_currency.fnc_date_get_id() IS
'Функция : Получаем идентивикатор даты, но сначала вставляем дату.
Дату мы берем серверную.';

/******************************************************************************/



/******************************************************************************/
--
--  Функция : Получаем идентивикатор даты, но сначала вставляем дату.
--  Дату мы вставляем свою.
--

--  Пересоздание функции
CREATE OR REPLACE FUNCTION schm_course_currency.fnc_date_get_id(
  IN p_date DATE
)
RETURNS BIGINT
AS
$$
DECLARE a_id BIGINT;
BEGIN
  SELECT  d.f_id INTO a_id
    FROM  schm_course_currency.tbl_date AS d
    WHERE to_char(d.f_date, 'YYYY-MM-DD') = to_char(p_date, 'YYYY-MM-DD');
  
  IF (a_id = 0) OR (a_id IS NULL) THEN
    SELECT nextval('schm_course_currency.sqnc_date_next_id') INTO a_id;
    
    INSERT INTO schm_course_currency.tbl_date(f_id, f_date)
      VALUES (a_id, p_date);
  END IF;

  RETURN a_id;
END
$$
LANGUAGE plpgsql
VOLATILE;

--  Добавить комментарий
COMMENT ON FUNCTION schm_course_currency.fnc_date_get_id(
  IN p_date DATE
) IS
'Функция : Получаем идентивикатор даты, но сначала вставляем дату.
Дату мы вставляем свою.';

/******************************************************************************/



/******************************************************************************/
--
--  Функция : Получем идентификатор валюты, а если запись отсутствует, то запись
--  добавляется.

--  Пересоздать функцию.
CREATE OR REPLACE FUNCTION schm_course_currency.fnc_currency_get_id(
  IN  p_code_chr   TEXT,
  IN  p_code_num   TEXT,
  IN  p_full_name  TEXT
)
RETURNS BIGINT
AS
$$
DECLARE a_id BIGINT;
BEGIN
  SELECT  c.f_id INTO a_id
    FROM  schm_course_currency.tbl_currency AS c
    WHERE c.f_code_chr = p_code_chr
          AND
          c.f_code_num = p_code_num
          AND
          c.f_full_name = p_full_name;
  
  IF (a_id = 0) OR (a_id IS NULL) THEN
    SELECT nextval('schm_course_currency.sqnc_currency_next_id') INTO a_id;
    
    INSERT INTO schm_course_currency.tbl_currency(f_id, f_code_chr, f_code_num, 
        f_full_name)
      VALUES(a_id, p_code_chr, p_code_num, p_full_name);
  END IF;
  
  RETURN a_id;
END;
$$
LANGUAGE plpgsql
VOLATILE;

--  Добавить комменатрий.
COMMENT ON FUNCTION schm_course_currency.fnc_currency_get_id(
  IN  p_code_chr   TEXT,
  IN  p_code_num   TEXT,
  IN  p_full_name  TEXT
) IS
'Функция : Получем идентификатор валюты, а если запись отсутствует, то запись 
добавляется.';

/******************************************************************************/



/******************************************************************************/
--
--  Функция : Добавляем курс валюты по текущей дате на сервере.
--

--  Пересоздать функцию
CREATE OR REPLACE FUNCTION schm_course_currency.fnc_course_ins(
  IN p_arr_cc schm_course_currency.tp_course[]
)
RETURNS TEXT
AS
$$
DECLARE a_id_date     BIGINT;
        a_id_currency BIGINT;
        a_msg         TEXT;
        a_error_code  TEXT;
        a_error_msg   TEXT;

BEGIN
  SELECT schm_course_currency.fnc_date_get_id() INTO a_id_date;
  
  DELETE
    FROM schm_course_currency.tbl_course AS c
    WHERE c.f_id_date = a_id_date;
  
  BEGIN

    FOR indx IN 1..array_upper(p_arr_cc, 1) LOOP
      SELECT schm_course_currency.fnc_currency_get_id(p_arr_cc[indx].f_code_chr, 
        p_arr_cc[indx].f_code_num, p_arr_cc[indx].f_full_name) INTO a_id_currency;

      INSERT INTO schm_course_currency.tbl_course(f_id, 
          f_id_currency, f_id_date, f_unit, f_price)
        VALUES(nextval('schm_course_currency.sqnc_course_next_id'),
          a_id_currency, a_id_date, p_arr_cc[indx].f_unit, 
          p_arr_cc[indx].f_price);

    END LOOP;
    
    a_msg := '';
    
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS a_error_code := RETURNED_SQLSTATE,
                            a_error_msg  := MESSAGE_TEXT;
    a_msg := 'Error :  Code = ' || a_error_code || ' . Message : ' || 
      a_error_msg;
  END;
  
  RETURN a_msg;
END;
$$
LANGUAGE plpgsql
VOLATILE;

--  Добавить комментарий
COMMENT ON FUNCTION schm_course_currency.fnc_course_ins(
  IN p_arr_cc schm_course_currency.tp_course[]
)IS
'Функция : Добавляем курс валюты по текущей дате на сервере.';
/******************************************************************************/



/******************************************************************************/
--
--  Функция : Добавляем курс валюты по заданной дате.
--

--  Пересоздать функцию
CREATE OR REPLACE FUNCTION schm_course_currency.fnc_course_ins(
  IN p_arr_cc schm_course_currency.tp_course[],
  IN p_date   DATE
)
RETURNS TEXT
AS
$$
DECLARE a_id_date     BIGINT;
        a_id_currency BIGINT;
        a_msg         TEXT;
        a_error_code  TEXT;
        a_error_msg   TEXT;

BEGIN
  SELECT schm_course_currency.fnc_date_get_id(p_date) INTO a_id_date;
  
  DELETE
    FROM schm_course_currency.tbl_course AS c
    WHERE c.f_id_date = a_id_date;
  
  BEGIN

    FOR indx IN 1..array_upper(p_arr_cc, 1) LOOP
      SELECT schm_course_currency.fnc_currency_get_id(p_arr_cc[indx].f_code_chr, 
        p_arr_cc[indx].f_code_num, p_arr_cc[indx].f_full_name) INTO a_id_currency;

      INSERT INTO schm_course_currency.tbl_course(f_id, 
          f_id_currency, f_id_date, f_unit, f_price)
        VALUES(nextval('schm_course_currency.sqnc_course_next_id'),
          a_id_currency, a_id_date, p_arr_cc[indx].f_unit, 
          p_arr_cc[indx].f_price);

    END LOOP;
    
    a_msg := '';
    
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS a_error_code := RETURNED_SQLSTATE,
                            a_error_msg  := MESSAGE_TEXT;
    a_msg := 'Error :  Code = ' || a_error_code || ' . Message : ' || 
      a_error_msg;
  END;
  
  RETURN a_msg;
END;
$$
LANGUAGE plpgsql
VOLATILE;

--  Добавить комментарий
COMMENT ON FUNCTION schm_course_currency.fnc_course_ins(
  IN p_arr_cc schm_course_currency.tp_course[],
  IN p_date DATE
)IS
'Функция : Добавляем курс валюты по заданной дате.';
/******************************************************************************/
