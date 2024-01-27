# OTP View HW 2

Ann Yip 919530072

## OTP Screen

The OTP Screen consists of instruction texts, 6 text boxes, and resend OTP 
button. The text boxes are implemented with the invisible textfield method. I 
converted the String where I store the textfield input into an array of 
characters, where I then looped through to present on each of the text boxes.
The textfield is automatically focused and the user has no way to remove the
focus unless they hit the back button or proceed to the next view. The user
cannot interact with text boxes as they are just textboxes.

## Navigation Stack

I have the verification (phone number input) view transition to OTPView via
navigationDestination. The navigation change is triggered after the program 
sends OTP text via Api. The user is able to return to the phone number input
page via the back button on the top of OTPView. The OTPView then switches to
HomeView also via navigationDestination once the verification code is checked.
There is no back button on HomeView however, by using the function 
"navigationBarBackButtonHidden()" to remove it. 

Phone number is passed via Binding so that OTPView can reference it for 
resending the OTP as well as verifying the code.
