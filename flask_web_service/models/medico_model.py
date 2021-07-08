from models.connection_pool import MySQLPool

class MedicoModel:
    def __init__(self):        
        self.mysql_pool = MySQLPool()
    
    def create_doctor(self, name, lastname, medical_speciality, user_id): 
        params = {
            'name' : name,
            'lastname' : lastname,
            'medical_speciality' : medical_speciality,
            'user_id' : user_id
        }
        query = """insert into medicos (name, lastname, medical_speciality, user_id)
            values (%(name)s, %(lastname)s,%(medical_speciality)s,%(user_id)s)"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {'id': cursor.lastrowid, 'name': name, 'lastname': lastname, 'medical_speciality': medical_speciality, 'user_id' : user_id}
        
        return data

    def get_doctor(self, id):
        params = {'id' : id}
        rv = self.mysql_pool.execute("SELECT id, name, lastname, medical_speciality, user_id from medicos where id=%(id)s", params)       
        #data = []
        content = {}
        for result in rv:
            content = {'id': result[0], 'name': result[1], 'lastname': result[2], 'medical_speciality' : result[3], 'user_id': result[4] }
        #    data.append(content)
        #    content = {}
        return content 

    def get_doctors(self):
        rv = self.mysql_pool.execute("SELECT id, name, lastname, medical_speciality, user_id from medicos")
        data = []
        content = {}
        for result in rv:
            content = {'id': result[0], 'name': result[1], 'lastname': result[2], 'medical_speciality' : result[3], 'user_id': result[4] }
            data.append(content)
            content = {}
        return data

    def update_profile(self, id, name, lastname, medical_speciality):
        params = {
            'id' : id,
            'name' : name,
            'lastname' : lastname,
            'medical_speciality' : medical_speciality
        }
        query = """update medicos set name = %(name)s, lastname = %(lastname)s, medical_speciality = %(medical_speciality)s where id = %(id)s"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {'id': id, 'name': name, 'lastname': lastname, 'medical_speciality' : medical_speciality}
        return data

if __name__ == "__main__":
    mm = ProductModel()