/******************************************************************************/
--
--  Представление : ПОказываем курс валют за определенную дату.
--

--  Удалить представление
DROP VIEW IF EXISTS schm_course_currency.vw_cc;

--  Создать представление
CREATE VIEW schm_course_currency.vw_cc AS
  SELECT  d.f_date        AS o_date,
          cs.f_unit       AS o_unit,
          cs.f_price      AS o_price,
          cr.f_full_name  AS o_full_name,
          cr.f_code_chr   AS o_char_code,
          cr.f_code_num   AS o_number_code
    FROM  schm_course_currency.tbl_date       AS d,
          schm_course_currency.tbl_currency   AS cr,
          schm_course_currency.tbl_course     AS cs
    WHERE d.f_id = cs.f_id_date
          AND
          cs.f_id_currency = cr.f_id;

--  Добавить комментарий
COMMENT ON VIEW schm_course_currency.vw_cc IS
'Выводим весь список курс валют.';

/******************************************************************************/