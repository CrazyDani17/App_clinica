from flask import Flask
from flask import Blueprint
from flask import request
from flask import jsonify
from functools import wraps
import jwt

from flask_cors import CORS, cross_origin # para que no genere errores de CORS al hacer peticiones

from models.medico_model import MedicoModel

medico_blueprint = Blueprint('medico_blueprint', __name__)

model = MedicoModel()

def  token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            token = request.headers.get('Token')
            if not token:
                return jsonify({'mensaje': 'No hay token presente, debes logearte'}), 403
        try:
            data = jwt.decode(token, 'clinicasecretkey')
        except:
            return jsonify({'mensaje': 'El token es inválido, debes logearte'}), 403
        
        return f(*args, **kwargs)
    return decorated

@medico_blueprint.route('/medico/create_doctor', methods=['POST'])
@cross_origin()
def create_doctor():
    content = model.create_doctor(request.json['name'], request.json['lastname'], request.json['medical_speciality'], request.json['user_id'])    
    return jsonify(content)

@medico_blueprint.route('/medico/update_profile/<id>', methods=['PUT'])
@cross_origin()
@token_required
def update_profile(id):
    content = model.update_profile(int(id),request.json['name'], request.json['lastname'], request.json['medical_speciality'])    
    return jsonify(content)

@medico_blueprint.route('/medico/<id>', methods=['GET'])
@cross_origin()
@token_required
def doctor(id):
    return jsonify(model.get_doctor(int(id)))

@medico_blueprint.route('/medico/get_doctors', methods=['GET'])
@cross_origin()
@token_required
def doctors():
    return jsonify(model.get_doctors())
