from flask import Flask
from flask import Blueprint
from flask import request
from flask import jsonify
from functools import wraps
import jwt

from flask_cors import CORS, cross_origin # para que no genere errores de CORS al hacer peticiones

from models.cita_model import CitaModel

cita_blueprint = Blueprint('cita_blueprint', __name__)

model = CitaModel()

def  token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization',None)
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

@cita_blueprint.route('/cita/create_cita', methods=['POST'])
@cross_origin()
@token_required
def create_cita():
    token = request.headers.get('Autorization', None)
    if not token:
        token = request.headers.get('Token')
    content = model.create_cita(
    request.json['schedule_date'], 
    request.json['schedule_time'], 
    request.json['patient_name'],
    request.json['patient_lastname'], 
    request.json['patient_phonenumber'], 
    request.json['matter'],
    token
    )    
    return jsonify(content)

@cita_blueprint.route('/cita/update_cita/<id>', methods=['PUT'])
@cross_origin()
@token_required
def update_cita(id):
    token = request.headers.get('Autorization', None)
    if not token:
        token = request.headers.get('Token')
    content = model.update_cita(
    int(id),
    request.json['schedule_date'], 
    request.json['schedule_time'], 
    request.json['patient_name'],
    request.json['patient_lastname'], 
    request.json['patient_phonenumber'], 
    request.json['matter'],
    token
    )    
    return jsonify(content)

@cita_blueprint.route('/cita/delete_cita/<id>', methods=['DELETE'])
@cross_origin()
@token_required
def delete_cita(id):
    return jsonify(model.delete_cita(int(id)))

@cita_blueprint.route('/cita/<id>', methods=['GET'])
@cross_origin()
@token_required
def cita(id):
    return jsonify(model.get_cita(int(id)))

@cita_blueprint.route('/cita/get_citas', methods=['GET'])
@cross_origin()
@token_required
def citas():
    return jsonify(model.get_citas())

@cita_blueprint.route('/cita/get_citas_medico', methods=['GET'])
@cross_origin()
@token_required
def citas_medico():
    token = request.headers.get('Autorization',None)
    if not token:
        token = request.headers.get('Token')
    return jsonify(model.get_citas_medico(token))
