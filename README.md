Chirpy Plankton
=======================

This small Sinatra web application allows you to securely exchange your
created username and password with your users.

If you send login information and passwords via mail to users and the user
does not delete the mail or change the password, the password is stored
into the mailaccount for long time.

If the mailbox get cracked the login information is lost!

That's why you need Chirpy Plankton application.

You store the password via https on the Chirpy Plankton webapp. The app
creates an one time unique url. If the user access the url to receive the
password the password information is deleted from the stored backend
immediately.

The password is stored encrypted on disc!

You can blacklist user agents and blacklist IP address space. So you can
exclude Google bot or Google mail to open the unique password url!

Screenshots
----------------
- https://github.com/hggh/chirpy-plankton/tree/master/screeenshots/0_insert.png
- https://github.com/hggh/chirpy-plankton/tree/master/screeenshots/1_receive.png
- https://github.com/hggh/chirpy-plankton/tree/master/screeenshots/2_stored.png


Installation on Debian
-----------------------

##### Packages to install: #####

-   ruby1.9.1
-   ruby-sinatra
-   libapache2-mod-passenger or Unicorn and NGINX



Contact?
------------------

Jonas Genannt <jonas@brachium-system.net>
