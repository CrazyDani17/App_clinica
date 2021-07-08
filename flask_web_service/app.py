from flask import Flask
from flask import request
from flask import jsonify
from flask_cors import CORS, cross_origin # para que no genere errores de CORS al hacer peticiones

from controllers.user_blueprint import user_blueprint
from controllers.medico_blueprint import medico_blueprint
from controllers.cita_blueprint import cita_blueprint

app = Flask(__name__)

app.register_blueprint(user_blueprint)
app.register_blueprint(medico_blueprint)
app.register_blueprint(cita_blueprint)

#app.config['SECRET_KEY'] = 'clinicasecretkey'

cors = CORS(app)

#if __name__ == "__main__":
#    app.run(host='0.0.0.0',port=5000)
