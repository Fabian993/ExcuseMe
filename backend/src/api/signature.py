"""
Signatur
"""
from django.core import signing
from abc import ABC, abstractmethod
import json
import base64
from cryptography.exceptions import InvalidSignature

class SigningStrategy(ABC): #JSON signing
    @abstractmethod
    def signJson(self, data: dict) -> str: 
        pass
    @abstractmethod
    def verifyJson(self, signed_str: str) -> dict: 
        pass

class DjangoSigningStrategy(SigningStrategy): #Django "BuildIn" Signing
    def __init__(self, user=None, salt='excuses'):
        self.salt = salt
        self.user = user

    def signJson(self, data: dict) -> str:
        return signing.dumps(data, salt=self.salt)
    
    def verifyJson(self, signed_str: str) -> dict:
        try:
            return signing.loads(signed_str, salt=self.salt)
        except:
            raise ValueError("Invalid")
class CryptoSigningStrategy(SigningStrategy):
    _keys = {} #just for testing

    def __init__(self, user=None):
        from cryptography.hazmat.primitives.asymmetric import ed25519
        self.user = user

        if user.role != "parent":
            raise PermissionError(f"{user.role} cant sign")

        if user.id not in CryptoSigningStrategy._keys:
            CryptoSigningStrategy._keys[user.id] = ed25519.Ed25519PrivateKey.generate()

        self.privateKey = CryptoSigningStrategy._keys[user.id]
        self.publicKey = self.privateKey.public_key()

    def signJson(self, data: dict) -> str:
        payload = {
            "user_id": self.user.id,
            "data": data
        }

        message = json.dumps(payload, sort_keys=True).encode('utf-8')
        signature = self.privateKey.sign(message)
        return f"{json.dumps(payload)}|BASE64:{base64.b64encode(signature).decode()}"
    
    def verifyJson(self, signed_str: str) -> dict:
        data_str, signPart = signed_str.split('|BASE64:', 1)
        payload = json.loads(data_str)

        user_id = payload["user_id"]

        private = CryptoSigningStrategy._keys.get(user_id)
        if not private:
            raise ValueError("Unknown user")
        
        publicKey = private.public_key()

        message = json.dumps(payload, sort_keys=True).encode('utf-8')
        signature = base64.b64decode(signPart)
        try:
            publicKey.verify(signature, message)
        except InvalidSignature:
            raise ValueError("Invalid")
        return payload
    
def changeStrategy(strategyName='django', user=None):
    strategies = {
        'django': DjangoSigningStrategy,
        'crypto': CryptoSigningStrategy,
    }
    return strategies.get(strategyName, DjangoSigningStrategy)(user=user)