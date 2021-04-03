/******************************************************************************/
--
--  Составной тип данных : Запись курса валюты.
--

--  Удалить тип данных
DROP TYPE IF EXISTS schm_course_currency.tp_course;

--  Создать тип данных
CREATE TYPE schm_course_currency.tp_course AS (
  f_code_chr    TEXT,
  f_code_num    TEXT,
  f_unit        DOUBLE PRECISION,
  f_full_name   TEXT,
  f_price       DOUBLE PRECISION
);

--  Добавить комментарий
COMMENT ON TYPE schm_course_currency.tp_course IS
'Составной тип данных : Запись курса валюты.';

/******************************************************************************/