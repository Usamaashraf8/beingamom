from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    path('', auth_views.LoginView.as_view(template_name='chat/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('register/', views.register, name='register'),
    path('chat/', views.chat, name='chat'),
    path('get_response/', views.get_response, name='get_response'),
]