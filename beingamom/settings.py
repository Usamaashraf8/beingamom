# settings.py
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'chat',
]

ALLOWED_HOSTS = ['localhost', '127.0.0.1']
LOGIN_REDIRECT_URL = '/chat/'
LOGOUT_REDIRECT_URL = '/'
SECRET_KEY = '&6k#t3x&et3$17zuo)%p&o_(9j2q=4=&@3@h-gsqre9uvep_l9'