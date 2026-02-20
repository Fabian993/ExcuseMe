from django.core import signing
from abc import ABC, abstractmethod
import json
import base64

class SigningStrategy(ABC): #JSON signing
    @abstractmethod
    def signJson(self, data: dict) -> str: pass
    @abstractmethod
    def verifyJson(self, signed_str: str) -> dict: pass

class DjangoSigningStrategy(SigningStrategy): #Django "BuildIn" Signing
    def __init__(self, salt='exuse-approval'):
        self.salt = salt

    def signJson(self, data: dict) -> str:
        return signing.dumps(data, salt=self.salt)
    
    def verifyJson(self, signed_str: str) -> dict:
        return signing.loads(signed_str, salt=self.salt)
    
class CryptoSigningStrategy(SigningStrategy):
    def __init__(self):
        from cryptography.hazmat.primitives.asymmetric import ed25519
        self.privateKey = ed25519.Ed25519PrivateKey.generate()
        self.publicKey = self.privateKey.public_key()

    def signJson(self, data: dict) -> str:
        message = json.dumps(data, sort_keys=True).encode('utf-8')
        signature = self.privateKey.sign(message)
        return f"{json.dumps(data)}|BASE64:{base64.b64encode(signature).decode()}"
    
    def verifyJson(self, signed_str: str) -> dict:
        data_str, signPart = signed_str.split('|BASE64:')
        data = json.loads(data_str)
        message = json.dumps(data, sort_keys=True).encode('utf-8')
        signature = base64.b64decode(signPart)
        self.publicKey.verify(signature, message)
        return data
    
def changeStrategy(strategyName='django'):
    strategies = {
        'django': DjangoSigningStrategy(),
        'crypto': CryptoSigningStrategy()
    }
    return strategies.get(strategyName, DjangoSigningStrategy())