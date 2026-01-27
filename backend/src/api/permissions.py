from rest_framework import permissions

class SchoolUserPermission(permissions.BasePermission): # Lehrer/Eltern/Schüler sehen nur ihre eigenen Daten

    def has_permission(self, request, view):
        return request.user.is_authenticated
    
    def has_object_permission(self, request, _, obj):
        if request.user.is_superuser:
            return True
        
        elif hasattr(request.user, 'teacher'):
            teacher_school = request.user.teacher.school
            model_name = obj._meta.model_name

            return (
                hasattr(obj, 'school') and obj.school == teacher_school 
                or hasattr(obj, 'klasse') and obj.klasse.school == teacher_school
                or model_name in ['teacher', 'student', 'parent'] and obj.school == teacher_school
            )
        
        elif hasattr(request.user, 'student'):
            if hasattr(obj, 'student') and obj.student == request.user.student:
                return True
            return False
        
        elif hasattr(request.user, 'parent'):
            return (
                hasattr(obj, 'student') and
                obj.student.parent == request.user.parent
            )
        return False
    
class StudentPermission(permissions.BasePermission):
    def has_permission(self, request, _):
        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
            return request.user.is_authenticated
        return request.user.is_authenticated
    
    def has_object_permission(self, request, _, obj):
        if request.user.is_superuser:
            return True
        if hasattr(request.user, 'student'):
            return obj == request.user.student
        return False
    
class ParentPermission(permissions.BasePermission):
    def has_permission(self, request, _):
        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
            return request.user.is_authenticated
        return request.user.is_authenticated

    def has_object_permission(self, request, _, obj):
        if request.user.is_superuser:
            return True
        elif hasattr(request.user, 'parent'):
            return obj.student.parent == request.user.parent
        return False

class ExcusePermission(permissions.BasePermission):
    def has_permission(self, request, _):
        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
            return request.user.is_authenticated
        return request.user.is_authenticated

    def has_object_permission(self, request, _, obj):
        if request.user.is_superuser:
            return True
        
        if request.method == 'DELETE':
            if(hasattr(request.user, 'parent') and obj.student.parent == request.user.parent):
            #or (hasattr(request.user, 'student') and obj.student == request.user.student):
                return True 
            return False

        if hasattr(request.user, 'student') and obj.student == request.user.student:
            return True
        if hasattr(request.user, 'parent') and obj.student.parent == request.user.parent:
            return True
        
        if hasattr(request.user, 'teacher'):
            return obj.student.klasse == request.user.teacher.klasse
        return False