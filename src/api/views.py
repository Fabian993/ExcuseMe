#We use Views to get web requests and send responses
#from django.shortcuts import render  # noqa
#from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET', 'POST', 'PUT', 'DELETE'])
def api_get(request):
    if request.method == 'GET':
        return Response({"message": "Hello from API!"})
    
    elif request.method == 'POST':
        return Response({"message": "Hello World"})
    
    elif request.method == 'PUT':
        return Response({"message": "Goodbye World"})
    
    elif request.method == 'DELETE':
        return Response({"message": "Deleted World!"})

    else:
        return Response({"message": "Error, method doesnt exist!"})