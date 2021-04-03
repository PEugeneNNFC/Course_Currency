import datetime
import requests
import psycopg2
from bs4 import BeautifulSoup
import log
import os



class CourseCourse(object):
    def __init__(self):
        self.url   = None
        self.date  = None
        self.query = None
        self.lst  = []       
        self.lg   = log.Loging()
        self.lg.set_is_time(True)

        self.user     = ''
        self.password = '' 
        self.host     = ''
        self.port     = 5432
        self.database = ''


    # Устанавливаем значение в переменную
    def SetURL(self, value: str):
        self.url = value


    # Устанавливаем значение в переменную
    def SetDate(self, value):
        self.date = str(value)[8:10] + '.' + str(value)[5:7] + '.' + str(value)[:4]


    # Парсим, получаем данные
    def __parcer__(self)->bool:
        try:
            self.lg.writelog('URL : ' + self.url + self.date)
            self.response = requests.get(self.url + self.date)
            self.soup = BeautifulSoup(self.response.text, 'lxml')
            self.quotes = self.soup.find_all('td')
            return True
        except Exception as e:
            self.lg.writelog('Answer : Error')
            self.lg.writelog('Answer : ' + str(e))
            return False


    # Формируем список записей(список в списке)
    def __set_list__(self):
        for i in range(0, len(self.quotes), 5):
            self.lst_tmp = []
            for j in range(i, (i + 5)):
                self.lst_tmp.append( self.quotes[j].text )
            self.lst.append( self.lst_tmp )


    # Записываем результат в файл
    def write_result_to_file(self):
        if not(os.path.exists('data/')):
            os.mkdir('data/')
        self.f = open( 'data/' + str(datetime.datetime.today())[:10]  + ".txt", 'a')
        self.f.write('Time : ' + str(datetime.datetime.today())[11:23] )
        self.f.write('\n')
        for i in range( 0, len( self.lst ) ):
            for j in range(0, 5):
                if (j == 0) or (j == 1) or (j == 2) or (j == 4):
                    self.f.write( self.lst[i][j].ljust(10))
                else:
                    self.f.write( self.lst[i][j].ljust(45))
            self.f.write('\n')
        self.f.write('\n')
        self.f.write('\n')
        self.f.close()


    # запускаем весь процесс (получение данных, парсинг и формирование списка)
    def Start(self):
        if self.__parcer__() :
            self.__set_list__()
            self.__get_query__()


    # Формируем запрос
    def __get_query__(self):
        self.lg.writelog('Query : Shape query')
        try:
            self.query = 'SELECT schm_course_currency.fnc_course_ins(ARRAY['
            for i in range( 0, len( self.lst ) ):
                self.query = self.query + "ROW("
                for j in range(0, 5):
                    if (j == 0) or (j == 1) or (j == 3):
                        self.query = self.query + "'" + self.lst[i][j] + "'"
                    else:
                        self.query = self.query + self.lst[i][j].replace(',','.').replace(' ','')
                    if (j == 4):
                        self.query = self.query + ")"
                    else:
                        self.query = self.query + ", "
                if ( i != len( self.lst ) - 1 ):
                    self.query = self.query + ', '
            self.query = self.query + ']::schm_course_currency.tp_course[]'

            if not(str(datetime.datetime.today())[:10] == self.date):
                self.query = self.query + ',' + "'" + self.date + "'" + ');'
            else:
                self.query = self.query + ');'

            self.lg.writelog('Answer : OK')
            self.lg.writelog('Text query : ' + self.query)

        except Exception as e:
            self.lg.writelog('Answer : Error')
            self.lg.writelog('Answer : ' + str(e))


    def __get_query_transaction_start__(self)->str:
        return 'START TRANSACTION;'


    def __get_query_transaction_commit__(self)->str:
        return 'COMMIT TRANSACTION;'


    def __get_query_transaction_rollback__(self)->str:
        return 'ROLLBACK TRANSACTION;'


    def __connection_to_db__(self)->bool:
        try:
            self.lg.writelog('Query : connect to database')
            self.conn = psycopg2.connect(
                user     = self.user, 
                password = self.password, 
                host     = self.host, 
                port     = self.port,
                database = self.database)
            return True
        except Exception as e:
            self.lg.writelog('Answer : ERROR : ')
            self.lg.writelog('Answer : ' + str(e))
            return False


    # Загрузка данных в БД 
    def load_to_db(self):

        if not(self.__connection_to_db__()):
            pass
        else:
            try:
                self.cursor = self.conn.cursor()

                self.lg.writelog('Query : Execution query : ' + self.__get_query_transaction_start__())
                self.cursor.execute( self.__get_query_transaction_start__() )
                self.lg.writelog('Answer : OK')

                self.lg.writelog('Query : Execution query : ' + self.query )
                self.cursor.execute( self.query )
                record = self.cursor.fetchone()

                if (str(record[0]) == ''):
                    self.lg.writelog('Answer : OK')
                    self.lg.writelog('Query : Execution query : ' + self.__get_query_transaction_commit__() )
                    self.cursor.execute( self.__get_query_transaction_commit__() )
                    self.lg.writelog('Answer : OK')
                else:
                    self.lg.writelog('Answer : ERROR : ')
                    self.lg.writelog('Query : Execution query :' + self.__get_query_transaction_rollback__() )
                    self.cursor.execute( self.__get_query_transaction_rollback__() )
                    self.lg.writelog('Answer : OK')

            except Exception as e:
                self.lg.writelog('Answer : ERROR : ')
                self.lg.writelog('Answer : ' + str(e))

            self.cursor.close()
            self.conn.close()            