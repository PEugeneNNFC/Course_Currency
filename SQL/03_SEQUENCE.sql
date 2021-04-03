/******************************************************************************/
--
--  Последовательность : Для таблицы даты (tbl_date).
--

--  Удалить последовательность
DROP SEQUENCE IF EXISTS schm_course_currency.sqnc_date_next_id;

--  Создать последовательность
CREATE SEQUENCE schm_course_currency.sqnc_date_next_id
  MINVALUE    1
  START       1
  INCREMENT   1
  MAXVALUE    9223372036854775807
  CACHE       1
;

--  Добавить комментарий
COMMENT ON SEQUENCE schm_course_currency.sqnc_date_next_id IS
'Последовательность : Для таблицы даты (tbl_date).';
/******************************************************************************/



/******************************************************************************/
--
--  Последовательность : Для таблицы валюта (tbl_currency).
--

--  Удалить последовательность
DROP SEQUENCE IF EXISTS schm_course_currency.sqnc_currency_next_id;

--  Создать последовательность
CREATE SEQUENCE schm_course_currency.sqnc_currency_next_id
  MINVALUE    1
  START       1
  INCREMENT   1
  MAXVALUE    9223372036854775807
  CACHE       1
;

--  Добавить комментарий
COMMENT ON SEQUENCE schm_course_currency.sqnc_currency_next_id IS
'Последовательность : Для таблицы валюта (tbl_currency).';
/******************************************************************************/



/******************************************************************************/
--
--  Последовательность : Для таблицы курс валюты (tbl_course).
--

--  Удалить последовательность
DROP SEQUENCE IF EXISTS schm_course_currency.sqnc_course_next_id;

--  Создать последовательность
CREATE SEQUENCE schm_course_currency.sqnc_course_next_id
  MINVALUE    1
  START       1
  INCREMENT   1
  MAXVALUE    9223372036854775807
  CACHE       1
;

--  Добавить комментарий
COMMENT ON SEQUENCE schm_course_currency.sqnc_course_next_id IS
'Последовательность : Для таблицы курс валюты (tbl_course).';
/******************************************************************************/