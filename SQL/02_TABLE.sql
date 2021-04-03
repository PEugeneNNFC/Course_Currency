/******************************************************************************/
--
--  Таблица : Валюта.
--

--  Удалить таблицу
DROP TABLE IF EXISTS schm_course_currency.tbl_currency;

--  Создать таблицу
CREATE TABLE schm_course_currency.tbl_currency(
  f_id          BIGINT,
  f_code_chr    TEXT,
  f_code_num    TEXT,
  f_full_name   TEXT
);

--  Добавить комментарий
COMMENT ON TABLE schm_course_currency.tbl_currency IS
'Таблица : Валюта.';
COMMENT ON COLUMN schm_course_currency.tbl_currency.f_id IS
'Идентификатор записи (Валюты).';
COMMENT ON COLUMN schm_course_currency.tbl_currency.f_code_chr IS
'Буквенный код валюты.';
COMMENT ON COLUMN schm_course_currency.tbl_currency.f_code_num IS
'Числовой код валюты.';
COMMENT ON COLUMN schm_course_currency.tbl_currency.f_full_name IS
'Полное наименование валюты.';

--  Добавить ограничения
ALTER TABLE schm_course_currency.tbl_currency ADD PRIMARY KEY (f_id);

--  Создать индексы
CREATE INDEX indx_currency_code_chr_code_num_full_name
  ON schm_course_currency.tbl_currency(f_code_chr, f_code_num, f_full_name);

/******************************************************************************/



/******************************************************************************/
--
--  Таблица : Даты.
--

--  Удалить таблицу
DROP TABLE IF EXISTS schm_course_currency.tbl_date;

--  Создать таблицу
CREATE TABLE schm_course_currency.tbl_date(
  f_id      BIGINT,
  f_date    DATE
);

--  Добавить комментарий
COMMENT ON TABLE schm_course_currency.tbl_date IS
'Таблица : Даты.';
COMMENT ON COLUMN schm_course_currency.tbl_date.f_id IS
'Идентифкатор даты.';
COMMENT ON COLUMN schm_course_currency.tbl_date.f_date IS
'Дата.';

--  Добавить ограничения
ALTER TABLE schm_course_currency.tbl_date ADD PRIMARY KEY (f_id);

--  Добавить индексы
CREATE INDEX indx_date_date
  ON schm_course_currency.tbl_date(f_date);

/******************************************************************************/



/******************************************************************************/
--
--  Таблица : Курс валюты.
--

--  Удалить таблицу
DROP TABLE IF EXISTS schm_course_currency.tbl_course;

--  Создать таблицу
CREATE TABLE schm_course_currency.tbl_course(
  f_id            BIGINT,
  f_id_currency   BIGINT,
  f_id_date       BIGINT,
  f_unit          DOUBLE PRECISION,
  f_price         DOUBLE PRECISION
);

--  Добавить комментарии
COMMENT ON TABLE schm_course_currency.tbl_course IS
'Таблица : Курс валюты.';
COMMENT ON COLUMN schm_course_currency.tbl_course.f_id IS
'Идентификатор записи (курса).';
COMMENT ON COLUMN schm_course_currency.tbl_course.f_id_currency IS
'Идентификатор валюты.';
COMMENT ON COLUMN schm_course_currency.tbl_course.f_id_date IS
'Идентификатор даты.';
COMMENT ON COLUMN schm_course_currency.tbl_course.f_unit IS
'Единица.';
COMMENT ON COLUMN schm_course_currency.tbl_course.f_price IS
'Цена за единицу.';

--  Добавить ограничения
ALTER TABLE schm_course_currency.tbl_course ADD PRIMARY KEY (f_id);

--  Добавить индексы
CREATE INDEX indx_course_di_currency_id_date
  ON schm_course_currency.tbl_course(f_id_currency, f_id_date);

/******************************************************************************/