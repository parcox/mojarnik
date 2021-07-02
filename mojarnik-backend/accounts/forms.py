from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from .models import CustomUser

# class CustomUserCreationForm(UserCreationForm):

#     class Meta(UserCreationForm.Meta):
#         model = CustomUser
#         fields = ('email', 'username',)

# class CustomUserChangeForm(UserChangeForm):

#     class Meta:
#         model = CustomUser
#         fields = ('email', 'username',)

class CustomUserCreationForm(UserCreationForm):
    first_name = forms.CharField(
        label='Nama depan', max_length=30, required=True)
    last_name = forms.CharField(label='Nama belakang', max_length=30, required=True,
                                help_text='Ulangi nama depan jika nama terdiri dari satu suku kata.')

    class Meta(UserCreationForm.Meta):
        model = CustomUser
        fields = '__all__'

class CustomUserChangeForm(UserChangeForm):
    first_name = forms.CharField(
        label='Nama depan', max_length=30, required=True)
    last_name = forms.CharField(
        label='Nama belakang', max_length=30, required=True, help_text='Ulangi nama depan jika nama terdiri dari satu suku kata.')

    class Meta:
        model = CustomUser
        fields = '__all__'