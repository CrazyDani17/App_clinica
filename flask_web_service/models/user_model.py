from models.connection_pool import MySQLPool
import jwt
import datetime

class UserModel:
    def __init__(self):        
        self.mysql_pool = MySQLPool()

    def user_login(self, username, password):
        params = {
            'username' : username,
            'password' : password
        }
        query = """SELECT id from users where username = %(username)s and password = %(password)s"""
        user_id = self.mysql_pool.execute(query, params)
        #Realizamos la verificación solo obteniendo un único dato de la consulta
        #Si en user_id está presente con los datos solicitados, entonces concede el acceso
        if user_id:
            token = jwt.encode({'id' : user_id[0][0], 'exp' : datetime.datetime.utcnow() + datetime.timedelta(hours = 3)}, 'clinicasecretkey')
            data = {
                'id': user_id[0][0],
                'estado' : True,
                'api_key' : token.decode('UTF-8')
            }
        else: #De lo contrario lo rechaza
            data = {
                'id': None,
                'estado' : False,
                'api_key' : "No tienes acceso necesitas logearte"
            }
        return data

    def get_user(self, id):
        params = {'id' : id}
        rv = self.mysql_pool.execute("SELECT id, username, email from users where id=%(id)s", params)       
        #data = []
        content = {}
        for result in rv:
            content = {'id': result[0], 'username': result[1], 'email': result[2]}
        #    data.append(content)
        #    content = {}
        return content 

    def get_users(self):
        rv = self.mysql_pool.execute("SELECT id, username, email from users")
        data = []
        content = {}
        for result in rv:
            content = {'id': result[0], 'username': result[1], 'email': result[2]}
            data.append(content)
            content = {}
        return data

    def create_user(self, username, password, email): 
        params = {
            'username' : username,
            'password' : password,
            'email' : email
        }
        query = """insert into users (username, password, email)
            values (%(username)s, %(password)s,%(email)s)"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {'id': cursor.lastrowid, 'username': username, 'email': email}

        query = """insert into medicos (user_id)
            values (%(id)s)"""
        cursor = self.mysql_pool.execute(query, data, commit=True)

        return data

    def update_user(self, id, username, password, email):
        params = {
            'id' : id,
            'username' : username,
            'password' : password,
            'email' : email
        }
        query = """update users set username = %(username)s, password = %(password)s, email = %(email)s where id = %(id)s"""
        cursor = self.mysql_pool.execute(query, params, commit=True)

        data = {'id': id, 'username': username, 'email': email}
        return data

    def delete_user(self, id):
        params = {'id' : id}  
        query = """delete from users where id = %(id)s"""
        self.mysql_pool.execute(query, params, commit=True)

        data = {'result': 1}
        return data

if __name__ == "__main__":
    um = UserModel()
