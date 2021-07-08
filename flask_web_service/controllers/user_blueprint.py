from flask import Flask
from flask import Blueprint
from flask import request
from flask import jsonify
from functools import wraps
import jwt

from flask_cors import CORS, cross_origin # para que no genere errores de CORS al hacer peticiones

from models.user_model import UserModel

user_blueprint = Blueprint('user_blueprint', __name__)

model = UserModel()

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

@user_blueprint.route('/user/register', methods=['POST'])
@cross_origin()
def create_user():
    content = model.create_user(request.json['username'], request.json['password'], request.json['email'])    
    return jsonify(content)

@user_blueprint.route('/user/update_user/<id>', methods=['PUT'])
@cross_origin()
@token_required
def update_user(id):
    content = model.update_user(request.json['username'], request.json['password'], request.json['email'])    
    return jsonify(content)

@user_blueprint.route('/user/delete_user/<id>', methods=['DELETE'])
@cross_origin()
@token_required
def delete_user(id):
    return jsonify(model.delete_user(int(id)))

@user_blueprint.route('/user/<id>', methods=['GET'])
@cross_origin()
@token_required
def user(id):
    return jsonify(model.get_user(int(id)))

@user_blueprint.route('/user/get_users', methods=['GET'])
@cross_origin()
@token_required
def users():
    return jsonify(model.get_users())

@user_blueprint.route('/user/login', methods=['POST'])
@cross_origin() # new decorator
def login():
    return jsonify(model.user_login(request.json['username'],
        request.json['password']))



