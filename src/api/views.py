#We use Views to get web requests and send responses
from django.shortcuts import render  # noqa
from django.http import HttpResponse

def api(request):
    return HttpResponse("Hello World")