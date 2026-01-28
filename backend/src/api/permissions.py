from rest_framework import permissions

def isTeacher(user):
    return hasattr(user, "teacher")

def isStudent(user):
    return hasattr(user, "student")

def isParent(user):
    return hasattr(user, "parent")

def teacherClasses(user): 
    """
    Returned alle Klassen des Lehrers 
    """
    return user.teacher.klassen.all()

class isAuthOnly(permissions.BasePermission):
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated)

class userAdminOnly(permissions.BasePermission):
    """
    Damit nur SU in User endpoint arbeiten können
    """
    def has_permission(self, request, view):
        return bool(request.user and request.user_is_superuser)

    def has_object_permission(self, request, view, obj):
        return bool(request.user and request.user_is_superuser)
class SchoolUserPermission(permissions.BasePermission):
    """
    - SU: alles
    - Teacher: nur Obj aus seinen Klassen
    - Student: nur eigene Daten
    - Parent: nur eigene Kinder
    """

    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated)
    
    def has_object_permission(self, request, view, obj):
        if request.user.is_superuser:
            return True

        if isTeacher(request.user):
            tc = teacherClasses(request.user)
            
            if obj._meta.model_name == "student":
                return tc.filter(pk=obj.klasse_id).exists()

            elif obj._meta.model_name == "klasse":
                return tc.filter(pk=obj.pk).exists()
            
            elif hasattr(obj, "klasse_id"):
                return tc.filter(pl=obj.klasse_id).exists()

            elif hasattr(obj, "student_id"):
                return tc.filter(pk=obj.student_klasse_id).exists()
            
            elif hasattr(obj, "school_id"):
                return obj.school_id == request.user.teacher.school_id
            
            return False
        
        elif isStudent(request.user):
            if obj.meta.model_name == "student":
                return obj.pk == request.user.student.pk

            elif hasattr(obj, "student"):
                return obj.student_id == request.user.student.pk
            return False
        
        elif isParent(request.user):
            if obj._meta.model_name == "parent":
                return obj.pk == request.user.pk
            
            elif obj._meta.model_name == "student":
                return obj.parent_id == request.user.parent.pk
            
            elif hasattr(obj, "student_id"):
                return obj.student.parent_id == request.user.parent.pk
            return False
        return False
    
#class StudentPermission(permissions.BasePermission):
#    def has_permission(self, request, view):
#        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
#            return request.user.is_authenticated
#        return request.user.is_authenticated
#    
#    def has_object_permission(self, request, view, obj):
#        if request.user.is_superuser:
#            return True
#        if hasattr(request.user, 'student'):
#            return obj == request.user.student
#        return False
#    
#class ParentPermission(permissions.BasePermission):
#    def has_permission(self, request, view):
#        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
#            return request.user.is_authenticated
#        return request.user.is_authenticated
#
#    def has_object_permission(self, request, view, obj):
#        if request.user.is_superuser:
#            return True
#        elif hasattr(request.user, 'parent'):
#            return obj.student.parent == request.user.parent
#        return False

class ExcusePermission(permissions.BasePermission):
    """
    - POST: Parent oder Studen
    - GET: Parent/Student nur eigene, Teacher nur per Klasse, SU alles?
    - DELETE: Parent/Studen eigene, SU alles
    """
    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        
        elif request.method in permissions.SAFE_METHODS or request.method == 'POST':
            return isParent(request.user) or isStudent(request.user)
        return True

    def has_object_permission(self, request, view, obj):
        if request.user.is_superuser:
            return True
        
#        if request.method == 'DELETE':
#            if(hasattr(request.user, 'parent') and obj.student.parent == request.user.parent):
#            #or (hasattr(request.user, 'student') and obj.student == request.user.student):
#                return True 
#            return False

        if isStudent(request.user):
            return obj.student_id == request.user.student.pk
        
        if isParent(request.user):
            return obj.student.parent_id == request.user.parent.pk
        
        if isTeacher(request.user):
            return teacherClasses(request.user).filter(pk=obj.student.klasse_id).exists()
        return False