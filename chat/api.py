from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.utils.decorators import method_decorator
import json
import openai
from .models import ChildProfile, Conversation, Message, HealthLog

openai.api_key = "YOUR_OPENAI_API_KEY"

@csrf_exempt
@require_http_methods(["POST"])
def api_register(request):
    try:
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')
        email = data.get('email', '')

        if User.objects.filter(username=username).exists():
            return JsonResponse({'error': 'Username already exists'}, status=400)

        user = User.objects.create_user(username=username, password=password, email=email)
        return JsonResponse({'message': 'User created successfully', 'user_id': user.id})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@require_http_methods(["POST"])
def api_login(request):
    try:
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')

        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            return JsonResponse({'message': 'Login successful', 'user_id': user.id, 'username': user.username})
        else:
            return JsonResponse({'error': 'Invalid credentials'}, status=401)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@require_http_methods(["GET"])
def api_logout(request):
    logout(request)
    return JsonResponse({'message': 'Logged out successfully'})

@csrf_exempt
@require_http_methods(["POST"])
def api_create_child(request):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    try:
        data = json.loads(request.body)
        child = ChildProfile.objects.create(
            user=request.user,
            name=data.get('name'),
            birth_date=data.get('birth_date'),
            avatar_url=data.get('avatar_url', '')
        )
        return JsonResponse({
            'message': 'Child profile created',
            'child_id': child.id,
            'name': child.name,
            'age': child.get_age()
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@require_http_methods(["GET"])
def api_get_children(request):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    children = ChildProfile.objects.filter(user=request.user)
    children_data = [{
        'id': child.id,
        'name': child.name,
        'birth_date': str(child.birth_date),
        'age': child.get_age(),
        'age_months': child.get_age_months(),
        'avatar_url': child.avatar_url
    } for child in children]
    return JsonResponse({'children': children_data})

@csrf_exempt
@require_http_methods(["POST"])
def api_chat(request):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    try:
        data = json.loads(request.body)
        message = data.get('message')
        child_id = data.get('child_id')

        child = None
        if child_id:
            child = ChildProfile.objects.get(id=child_id, user=request.user)

        # Get conversation
        conversation, created = Conversation.objects.get_or_create(
            user=request.user,
            child=child
        )

        # Save user message
        Message.objects.create(conversation=conversation, content=message, is_user=True)

        # Get child's age for context
        child_age = child.get_age() if child else None
        child_age_months = child.get_age_months() if child else None

        # Build context-aware prompt for pediatric health
        system_prompt = f"""You are a friendly children's health companion named Beeba.
You provide helpful, age-appropriate health and nutrition information for children.
Always include a disclaimer that you are not a doctor and professional medical advice should be sought.
Be friendly, encouraging, and easy to understand.
"""
        if child:
            system_prompt += f"The child you're helping is {child.name}, who is {child_age} years old ({child_age_months} months)."

        # Call OpenAI API
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": message}
            ]
        )

        ai_response = response.choices[0].message.content

        # Save AI response
        Message.objects.create(conversation=conversation, content=ai_response, is_user=False)

        return JsonResponse({
            'response': ai_response,
            'child_age': child_age
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@require_http_methods(["POST"])
def api_analyze_image(request):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    try:
        data = json.loads(request.body)
        image_url = data.get('image_url')
        child_id = data.get('child_id')
        description = data.get('description', '')

        child = None
        if child_id:
            child = ChildProfile.objects.get(id=child_id, user=request.user)

        child_age = child.get_age() if child else None

        # Call OpenAI Vision API
        response = openai.ChatCompletion.create(
            model="gpt-4-vision-preview",
            messages=[
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image_url",
                            "image_url": {"url": image_url}
                        },
                        {
                            "type": "text",
                            "text": f"Analyze this image for any visible skin conditions, rashes, or health concerns. The child is {child_age} years old. {description}"
                        }
                    ]
                }
            ],
            max_tokens=500
        )

        analysis = response.choices[0].message.content

        # Log the image analysis
        if child:
            HealthLog.objects.create(
                child=child,
                log_type='image_analysis',
                description=analysis,
                image_url=image_url
            )

        return JsonResponse({
            'analysis': analysis,
            'disclaimer': 'This is an AI analysis. Please consult a healthcare professional for proper diagnosis.'
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@require_http_methods(["POST"])
def api_health_log(request):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    try:
        data = json.loads(request.body)
        child_id = data.get('child_id')

        child = ChildProfile.objects.get(id=child_id, user=request.user)

        health_log = HealthLog.objects.create(
            child=child,
            log_type=data.get('log_type', 'general'),
            description=data.get('description'),
            image_url=data.get('image_url', '')
        )

        return JsonResponse({
            'message': 'Health log created',
            'log_id': health_log.id
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@require_http_methods(["GET"])
def api_get_health_logs(request, child_id):
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    try:
        child = ChildProfile.objects.get(id=child_id, user=request.user)
        logs = HealthLog.objects.filter(child=child).order_by('-created_at')

        logs_data = [{
            'id': log.id,
            'log_type': log.log_type,
            'description': log.description,
            'image_url': log.image_url,
            'created_at': str(log.created_at)
        } for log in logs]

        return JsonResponse({'health_logs': logs_data})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)