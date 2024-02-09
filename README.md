# Account Modifying HW 4

Ann Yip 919530072
Yeongjin Lee 916567611
Jinho Yon 917507227

## Creating/Deleting Account

- Creating account feature has its own view where the users can type in the name
on the textField. Once the user clicks on the "create account" button, the
createAccount function from UserViewModel is triggered, adding new account to
the user.
- Deleteing Account can be done by simply swiping the account item in the list to
the right. When it is "onDelete", the deleteAccount function will be triggered and
remove the account from the user.

## Total Amount

- The total amount is a published variable in the UserViewModel.
Everytime the the account gets updated via "deposit", "withdraw", and "transfer",
the total amount will be updated. These functions are the methods of UserViewModel.

## Deposit, Withdraw, Transfer

- Each of the account displayed in home view directs the user to the page where
they can deposit, withdraw, or transfer their money. The button then performs
the action/request in the userModel, then redirects the user once success or
display error message. The transfer button redirects the user to a list of 
their other accounts to choose and transfer.
