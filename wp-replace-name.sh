#!/bin/bash


# configuration, location of wp-cli

WP=/usr/local/bin/wp

# Check if a folder is the home folder of WordPress installation
# We do a superficial test, check if there is a wp-content folder and
# that there is a wp-config.php. We might enhance this test.

function is_wp_home_folder() {
    local myfolder=$1
    echo "  Checking if ${myfolder} is part the root of WordPress Instalation"

    if [ ! -f "${myfolder}/wp-config.php" ]
    then
        echo "Folder does not have wp-config.php file. This is not a WordPress home. We cannot run this script."
        return 1
    fi

    if [ ! -d "${myfolder}/wp-content" ]
    then
        echo "There is not wp-content folder, so it isn't a WordPress folder."
        return 1
    fi

    echo "  This folder seems to be a WordPress root folder"
    return 0
}

# Gets the current domain name part of the web site name
function get_current_wp_name {
    local OLDNAME=$($WP option get siteurl | sed -E 's/http[s]*\:\/\///g')
    echo $OLDNAME
    # remove the http:// or https:// prefix
}

# Asks for the new name that will replace the old name
function get_new_name {
    local OLDNAME=$1
    echo "The web site name now is $OLDNAME."
    echo -n "What is the new name? "
    read NEWNAME
}


# Searches and replaces the name in the WordPress database
function search_replace_in_db {
    local OLDNAME=$1
    local NEWNAME=$2
    local command="$WP search-replace --all-tables ${OLDNAME} ${NEWNAME}"
    echo "Executing: $command"
    local result=$($command)
    echo $result

}

# Search and replaces the name in the files.
function search_replace_files {
    local OLDNAME=$1
    local NEWNAME=$2
    local EXTENTIONS=( "css" "php" )
    local t
    for t in ${EXTENTIONS[@]}; do
        echo "Searching and replacing in *.$t files..."
        find . -name "*.$t" -type f -exec grep "$OLDNAME" {} \; -exec sed -i "s|${OLDNAME}|${NEWNAME}|g" {} \;
    done

}


function main {
    # Check if the current folder is a wordpress site.
    local CURRENT_FOLDER=$(pwd)
    if is_wp_home_folder $CURRENT_FOLDER
    then
        echo "This is a WP folder."
    else
        echo "Not a WP folder, exiting"
        exit 1
    fi

    # Check if wp-cli exists
     if [ ! -f "${WP}" ]; then
        echo "${WP} not found. It is required to run this script. Exiting."
        exit 1
    fi

    # Make sure we are not running as root
    if [[ $EUID -eq 0 ]]; then
        echo "This script must not execute as root. Exiting." 
        exit 1
    fi

    # Now we are ready to do the real work
    local OLDNAME=$(get_current_wp_name)
    get_new_name "$OLDNAME"
    search_replace_in_db "$OLDNAME" "$NEWNAME"
    search_replace_files "${OLDNAME}" "${NEWNAME}"



    # Once both above two tests completed we can continue
    # get the current web site name.

    # Ask for the new site name:

    # run a search replace on the database

    # run a search replace 
}

main

