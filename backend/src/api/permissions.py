from rest_framework import permissions

def isTeacher(user):
    return hasattr(user, "teacher")

def isStudent(user):
    return hasattr(user, "student")

def isParent(user):
    return hasattr(user, "parent")

def teacherKlasses(user): 
    """
    Returned alle Klassen des Lehrers 
    """
    return user.teacher.klasse.all()

class SchoolUserPermission(permissions.BasePermission):
    """
    - SU: alles
    - Teacher: nur Obj aus seinen Klassen
    - Student: nur eigene Daten
    - Parent: nur eigene Kinder
    """

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
    """
    - POST: Parent oder Studen
    - GET: Parent/Student nur eigene, Teacher nur per Klasse, SU alles?
    - DELETE: Parent/Studen eigene, SU alles
    """
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