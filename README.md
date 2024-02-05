# Loading View HW 3

Ann Yip 919530072

## Loading Screen

The loading screen consists of a picture and a progress view icon. When
called in RootView(), it gets the authtoken from the user default, and 
proceeds to load the information into userModel.

## User Model

The userModel includes User, authToken, username, phonenumber, and whether or 
not an account is created with the phone number. These information are 
published so that it can be shared with multiple views. Within the userModel,
the functions initializes the published variables as well as make changes to 
them, like logging out and changing username.

## Home View

The homeview has two different configuration. If there are accounts, the 
account names and balances are displayed in a list. If there are no accounts,
"Please create an account" will be displayed. 

## Settings View

The settings view includes the required modifiable username, displayed phone
number, and a log out button. The username is changed with the Api, and phone
number is obtained from the user object. Log out clears the user defaults as
as well as setting the objects stored in published variables to nil, and 
redirects the user to verification screen. 

## Root View

The root view consists of 3 different views, loading, new user, and old user.
New user is directed to verification view first, whereas old user is directed 
straight to home view.
