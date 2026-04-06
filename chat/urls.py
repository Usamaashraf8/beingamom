from django.urls import path
from . import api

urlpatterns = [
    path('api/register/', api.api_register, name='api_register'),
    path('api/login/', api.api_login, name='api_login'),
    path('api/logout/', api.api_logout, name='api_logout'),
    path('api/children/', api.api_get_children, name='api_get_children'),
    path('api/children/create/', api.api_create_child, name='api_create_child'),
    path('api/chat/', api.api_chat, name='api_chat'),
    path('api/analyze-image/', api.api_analyze_image, name='api_analyze_image'),
    path('api/health-log/', api.api_health_log, name='api_health_log'),
    path('api/health-logs/<int:child_id>/', api.api_get_health_logs, name='api_get_health_logs'),
]
