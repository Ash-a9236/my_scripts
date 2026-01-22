# my_scripts
Library of scripts to help with small tasks that take way too long to remember otherwise :P

Author : ash-a9236
See license for copyright details


## WINDOWS

Scripts that will only work on Windows or a portable usb drive made for Windows (10 or 11).

### login

Creates an SSH agent to connect to github through port 22 when the port might be blocked or when you are on a public computer. 
<br>
If you are on a public computer I recommend also adding the lifetime to that ssh key on the computer that you are using. It will not delete the key from github but simply flush the ssh agent on the computer after the set time if you forgot to log out.

<br>

You need to have either a portable USB with the following structure : 

```
E:
  |_ .ssh
      |_ ssh_key // created from github.com
  |_ Git_portable // where you will run the script
  ...
```

Or know the path to your .ssh folder (often held in C:/Users/username/) such as 

```
/home/user
  |_ .ssh
      |_ ssh_key // created from github.com
  |_ Documents
  |_ Downloads
  ...
```


### npm_VSC

Creates an instance of VSC with Node.js installed to be able to run any project such as a React.js project if you are on a public computer or a computer that restrict installation.
<br>
It redirects the files that would normally be loaded in Windows' 'Program files' to the drive to leave no trace of the installation on the host computer.
<br>
The script will also load VSC in the background

You need to have a portable USB with the following structure : 

```
E:
  |_ .ssh
  |_ Git_portable // where you will run the script
  |_ node-XX.XX.X-wind-x64
  |_ VSC // Visual Studio Code portable (normal Visual Studio installation with an added data directory)
  ...
```

### repo_auth

Maks any repo as safe if they are either in the Documents folder of a USB drive or in htdocs of Wampoon server (LAMP stack).

You need to have a portable USB with the following structure : 

```
E:
  |_ .ssh
  |_ Git_portable // where you will run the script
  |_ Documents
      |_ [your_repo]
  |_ Wampoon
      |_ htdocs
            |_ [your_repo]
  ...
```


## LINUX

Scripts that will only work on Linux or a portable usb drive made for Linux (tested on Debian 13 stable).

### login

Creates an SSH agent to connect to github through port 22 when the port might be blocked or when you are on a public computer. 
<br>
If you are on a public computer I recommend also adding the lifetime to that ssh key on the computer that you are using. It will not delete the key from github but simply flush the ssh agent on the computer after the set time if you forgot to log out.

<br>

You need to have either a portable USB with the following structure : 

```
E:
  |_ .ssh
      |_ ssh_key // created from github.com
  |_ Git_portable // where you will run the script
  ...
```

Or know the path to your .ssh folder (often held in C:/Users/username/) such as 

```
/home/user
  |_ .ssh
      |_ ssh_key // created from github.com
  |_ Documents
  |_ Downloads
  ...
```

### new_nginx_website

Creates the configuration for a website on localhost using a LNMP stack. Can also create the base folder for the website (though you might need to rerun the script if you create the website from it to enable the correct permissions on the files).

You will need to have already installed : 

- MariaDB
- PhpMyAdmin

