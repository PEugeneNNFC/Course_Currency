import datetime
import Load_Kurc_cb
import log
import os



if __name__ == "__main__":
    lg = log.Loging()
    lg.set_is_time(True)
    lg.writelog('<<< Start program >>>')

    cc = Load_Kurc_cb.CourseCourse()
    cc.SetURL("https://cbr.ru/currency_base/daily/?UniDbQuery.Posted=True&UniDbQuery.To=")
    cc.SetDate(datetime.datetime.today())
    #cc.SetDate( datetime.datetime.strptime("1992-07-01", "%Y-%m-%d") )
    cc.Start()
    cc.write_result_to_file()
    cc.load_to_db()

    lg.writelog('<<< End program >>>')
    lg.set_is_time(False)
    lg.writelog('')