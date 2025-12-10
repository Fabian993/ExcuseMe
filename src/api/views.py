"""
Docstring for api.views

Statuscodes:
- 201 = Created
- 204 = No Content
- 400 = Bad Request
- 405 = Method not allowed
"""
#We use Views to get web requests and send responses
#from django.shortcuts import render  # noqa
#from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializer import *
from .models import *

#Test API
#@api_view(['GET', 'POST', 'PUT', 'DELETE'])
#def api(request):
#    if request.method == 'GET':
#        return Response({"message": "Hello from API!"})
#    
#    elif request.method == 'POST':
#        return Response({"message": "Hello World"})
#    
#    elif request.method == 'PUT':
#        return Response({"message": "Goodbye World"})
#    
#    elif request.method == 'DELETE':
#        return Response({"message": "Deleted World!"})
#
#    else:
#        return Response({"message": "Error, method doesnt exist!"})
#    
#def frontend(request):
#    return render(request, "frontend/index.html")

#Actual API
@api_view(['GET', 'POST', 'PUT', 'DELETE'])
def SchoolView(request, pk_r = None):
    if request.method == 'GET':
        schools = School.objects.all()
        serializer = SchoolSerializer(schools, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = SchoolSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = 201)
        return Response(serializer.errors, status = 400)
    
    elif request.method == 'PUT':
        school = School.objects.get(pk = pk_r)
        serializer = SchoolSerializer(school, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status = 400)
    
    elif request.method == 'DELETE':
        school = School.objects.get(pk = pk_r)
        school.delete()
        return Response(status = 204)