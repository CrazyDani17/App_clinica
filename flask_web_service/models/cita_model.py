from models.connection_pool import MySQLPool
import jwt
import datetime

class CitaModel:
    def __init__(self):        
        self.mysql_pool = MySQLPool()

    def get_cita(self, id):
        params = {'id' : id}
        rv = self.mysql_pool.execute("SELECT id, schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, doctor_id from citas where id=%(id)s", params)       
        #data = []
        content = {}
        for result in rv:
            content = {
                'id': result[0], 
                'schedule_date': str(result[1]), 
                'schedule_time': str(result[2]), 
                'patient_name' : result[3], 
                'patient_lastname': result[4], 
                'patient_phonenumber': result[5], 
                'matter' : result[6], 
                'doctor_id': result[7]
                }
        #    data.append(content)
        #    content = {}
        return content 

    def get_citas(self):
        rv = self.mysql_pool.execute("SELECT id, schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, doctor_id from citas")
        data = []
        content = {}
        for result in rv:
            content = {
                'id': result[0], 
                'schedule_date': str(result[1]), 
                'schedule_time': str(result[2]), 
                'patient_name' : result[3], 
                'patient_lastname': result[4], 
                'patient_phonenumber': result[5], 
                'matter' : result[6], 
                'doctor_id': result[7]
                }
            #print(result[2])
            data.append(content)
            content = {}
        return data
    def get_citas_medico(self,token):
        data = jwt.decode(token, 'clinicasecretkey')
        rv = self.mysql_pool.execute("SELECT id, schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, doctor_id from citas where doctor_id = " + str(data["id"]))
        data = []
        content = {}
        for result in rv:
            content = {
                'id': result[0], 
                'schedule_date': str(result[1]), 
                'schedule_time': str(result[2]), 
                'patient_name' : result[3], 
                'patient_lastname': result[4], 
                'patient_phonenumber': result[5], 
                'matter' : result[6], 
                'doctor_id': result[7]
                }
            #print(result[2])
            data.append(content)
            content = {}
        return data

    def create_cita(self, schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, token): 
        data = jwt.decode(token, 'clinicasecretkey')
        doctor_id = data["id"]
        params = {
            'schedule_date': schedule_date,
            'schedule_time': schedule_time,
            'patient_name': patient_name, 
            'patient_lastname': patient_lastname,
            'patient_phonenumber': patient_phonenumber,
            'matter' : matter, 
            'doctor_id': doctor_id
        }
        query = """insert into citas (schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, doctor_id)
            values (%(schedule_date)s, %(schedule_time)s,%(patient_name)s,%(patient_lastname)s,%(patient_phonenumber)s,%(matter)s,%(doctor_id)s)"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {
            'id': cursor.lastrowid, 
            'schedule_date': schedule_date, 
            'schedule_time': schedule_time,
            'patient_name': patient_name, 
            'patient_lastname': patient_lastname,
            'patient_phonenumber': patient_phonenumber,
            'matter' : matter, 
            'doctor_id': doctor_id
        }
        
        return data

    def update_cita(self, id, schedule_date, schedule_time, patient_name, patient_lastname, patient_phonenumber, matter, token):
        data = jwt.decode(token, 'clinicasecretkey')
        doctor_id = data["id"]
        params = {
            'id': id, 
            'schedule_date': schedule_date, 
            'schedule_time': schedule_time,
            'patient_name': patient_name, 
            'patient_lastname': patient_lastname,
            'patient_phonenumber': patient_phonenumber,
            'matter' : matter, 
            'doctor_id': doctor_id
        }
        query = """update citas set schedule_date = %(schedule_date)s, schedule_time = %(schedule_time)s, patient_name = %(patient_name)s, patient_lastname = %(patient_lastname)s, patient_phonenumber = %(patient_phonenumber)s, matter = %(matter)s, doctor_id = %(doctor_id)s where id = %(id)s"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {
            'id': id, 
            'schedule_date': schedule_date,
            'schedule_time': schedule_time,
            'patient_name': patient_name,
            'patient_lastname': patient_lastname,
            'patient_phonenumber': patient_phonenumber,
            'matter' : matter, 
            'doctor_id': doctor_id}
        return data

    def delete_cita(self, id):
        params = {'id' : id}  
        query = """delete from citas where id = %(id)s"""
        self.mysql_pool.execute(query, params, commit=True)

        data = {'result': 1}
        return data

if __name__ == "__main__":
    um = ProductModel()
