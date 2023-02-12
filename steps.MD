## *FOR SMTP*

Create password for external App(In our case Lambda function)
Got to Google Account Security and Scroll down to "Signing in to Google" option. If you don't have 2 step verification on; enable it. Then you will see "App passwords" option. Generate a password for your lambda function.
https://myaccount.google.com/security

Make sure to copy the Password else you will not be able to copy it later.

# FOR LAMBDA PACKAGE
cd source
pip install --target ./package requests
cd package
zip -r ../package.zip .


cd ..
zip package.zip ec2_with_sg_email.py
