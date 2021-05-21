# Script to replace web site name in WordPress

## What it does?

A command line script that asks for the new WordPress web site name, and replaces 
the current name with the new name.

First, it does some validity tests. If the script is executed as root or not inside 
a WordPress installation, it exists without replacing the name.

After the initial validaion it will search and replace the web site name in the WordPress
database and files.

## How to use?

Copy the script to a central location on your server, for example:
/usr/local/bin/wp-replace-name.sh

cd to the root of a WordPress installation, as a regular user, for exaple:

```bash
cd ~/public_html
```

Run the script:

```bash
wp-replace-name.sh

```

It will find the current name of the WordPress web site, and ask you for the new name.
It will then search and replace the name in WordPress database (all tables in the 
database) and then in the files. (It replaces only in files with extension *.css,
*.php. You can edit the script to add more extensions).
