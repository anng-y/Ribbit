# Phone Number Verification

Ann Yip 919530072

## Launch Screen

The launch screen is implemented in launch view, which is called first by the 
app and redirects to the Verification view once performed the animation. 
Animation is incorporated in order to make the app more appealing. I referenced 
a youtube tutorial for this function: 
https://www.youtube.com/watch?v=lBCpwYDljwI&t=938s&ab_channel=Rebeloper-RebelDeveloper

## Verification Page

The page consists of a ZStack with a rectangle and a VStack in it. The purpose
of the rectangle is to allow the tap gesture to work on all areas of the app so
that users can tap out. The VStack consists of the main title, textfield, status
message and a button at the end to proceed to the next steps.

Next to the text field is a button for switching country code that could be
functional in the future, right now just acts as a placeholder and display the
American country code.

The text field is formatted with PartialFormatter() as users type in it and
changes the phoneNumber variable. The status message displays whether or not the
input is valid when the user submits the phone number. The button triggers the
validation function, which checks with regular expression if the phone number is
valid, and checked if the phone number is too short for another possible error.
Referenced: https://www.advancedswift.com/regular-expressions/
The message displays a green success text when the phone number is in a correct
format. Once validated, the phone number is then parsed into e164 format with
phoneNumberKit.parse() and phoneNumberKit.format().

The theme of this app is pixel frog. I was inspired by retro video games. I
added a custom font in the settings in order to use the pixelated font.
