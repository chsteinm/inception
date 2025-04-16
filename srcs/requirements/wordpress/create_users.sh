#!/bin/bash

wp user create chrstein chrstein@student.42lyon.fr --role=administrator --user_pass=secure_password_admin

wp user create user user@gmail.com --role=subscriber --user_pass=secure_password_user