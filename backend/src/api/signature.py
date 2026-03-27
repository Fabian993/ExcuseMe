"""
Signatur
"""
from django.core import signing
from abc import ABC, abstractmethod
import json
import base64, hashlib
from .models import ParentKey
from cryptography.fernet import Fernet
from django.conf import settings

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

    def __init__(self, user=None):
        from cryptography.hazmat.primitives.asymmetric import ed25519
        from cryptography.hazmat.primitives.serialization import(
            Encoding, PrivateFormat, NoEncryption, PublicFormat
        )
        self.user = user
        if user.role != "parent":
            raise PermissionError(f"{user.role} cant sign")
        
        key_obj = ParentKey.objects.filter(user=user).first()
        if key_obj:
            decrypted = get_fernet().decrypt(bytes(key_obj.private_key))
            self.privateKey = ed25519.Ed25519PrivateKey.from_private_bytes(decrypted)

        else:
            self.privateKey = ed25519.Ed25519PrivateKey.generate()
            raw = self.privateKey.private_bytes(Encoding.Raw, PrivateFormat.Raw, NoEncryption())
            encrypted = get_fernet().encrypt(raw)
            ParentKey.objects.create(user=user, private_key=encrypted)

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
        from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey

        data_str, signPart = signed_str.split('|BASE64:', 1)
        payload = json.loads(data_str)

        user_id = payload["user_id"]
        
        key_obj = ParentKey.objects.filter(user_id=user_id).first()
        if not key_obj:
            raise ValueError("Unknown user")
        
        decrypted = get_fernet().decrypt(bytes(key_obj.private_key))
        privateKey = Ed25519PrivateKey.from_private_bytes(decrypted)
        publicKey = privateKey.public_key()

        message = json.dumps(payload, sort_keys=True).encode('utf-8')
        signature = base64.b64decode(signPart)
        publicKey.verify(signature, message)
        return payload
    
    
def changeStrategy(strategyName='django', user=None):
    strategies = {
        'django': DjangoSigningStrategy,
        'crypto': CryptoSigningStrategy,
    }
    return strategies.get(strategyName, DjangoSigningStrategy)(user=user)

def get_fernet():
    key = hashlib.sha256(settings.SECRET_KEY.encode()).digest()
    return Fernet(base64.urlsafe_b64encode(key))