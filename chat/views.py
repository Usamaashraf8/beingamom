from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from .models import Conversation, Message
from .forms import SignUpForm
import openai

def register(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('login')
    else:
        form = SignUpForm()
    return render(request, 'chat/register.html', {'form': form})

@login_required
def chat(request):
    return render(request, 'chat/chat.html')

@login_required
def get_response(request):
    if request.method == 'POST':
        user_input = request.POST.get('message')
        conversation, created = Conversation.objects.get_or_create(user=request.user)
        
        Message.objects.create(conversation=conversation, content=user_input, is_user=True)
        
        # Here you would integrate with OpenAI's GPT API
        # For this example, we'll just provide a mock response
        gpt_response = "As a new mom, it's important to remember that every child is unique. For specific advice about your child's diet and health, it's best to consult with your pediatrician. However, here are some general tips: ensure your baby is getting enough sleep, maintain a consistent feeding schedule, and don't hesitate to ask for help when you need it. Remember, you're doing great!"
        
        Message.objects.create(conversation=conversation, content=gpt_response, is_user=False)
        
        return JsonResponse({'message': gpt_response})