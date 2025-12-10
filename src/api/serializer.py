from rest_framework import serializers
#from .models import School, User
from .models import *

class SchoolSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class KlasseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Klasse
        fields = '__all__'

class TeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Teacher
        fields = '__all__'

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'

class ParentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = '__all__'

class StatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = '__all__'

class ExcuseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Excuse
        fields = '__all__'
    
class ExcuseTeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Excuse
        fields = '__all__'