class LogInWithEmailAndPasswordFailure {
  final String message;

  const LogInWithEmailAndPasswordFailure([this.message = 'An Unkown error occurred']);

  factory LogInWithEmailAndPasswordFailure.code(String message){
   switch(message){
     case 'error_invalid_email':
       return const LogInWithEmailAndPasswordFailure('Your email address appears to be malformed. ');
     case 'error_wrong_password':
       return const LogInWithEmailAndPasswordFailure('Your password is wrong. ');
     case 'error_user_not_found':
       return const LogInWithEmailAndPasswordFailure("User with this email doesn't exist. ");
     case 'error_user_disabled':
       return const LogInWithEmailAndPasswordFailure('User with this email has been disabled. ');
     case 'error_email_already_in_use':
       return const LogInWithEmailAndPasswordFailure('The email has already been registered. Please login or reset your password. ');
     default :
       return const LogInWithEmailAndPasswordFailure();
      
    
      
    }
 }
}