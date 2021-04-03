import os
import datetime


class Loging(object):
    def __init__(self):
        self.name_dir_log  = 'log/'
        self.name_file_log = self.name_dir_log + str(datetime.datetime.today())[:10] + '.txt'
        self.is_time = False
        self.__create_dir__()
        self.__create_file__()

    def __create_dir__(self):
        if not(os.path.exists(self.name_dir_log)):
            os.mkdir(self.name_dir_log)
    
    def __create_file__(self):
        if not(os.path.exists(self.name_file_log)):
            self.log_file = open( self.name_file_log, 'w' )
            self.log_file.write('')
            self.log_file.close()

    def set_is_time(self, value: bool):
        self.is_time = value

    def writelog(self, value):
        self.log_file = open( self.name_file_log, 'a' )
        if self.is_time:
            self.log_file.write('[' + str(datetime.datetime.today())[11:23] + '] : ' )
        self.log_file.write('\n')
        self.log_file.write(value)
        self.log_file.write('\n')
        self.log_file.close()
    


