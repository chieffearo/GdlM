#!/bin/bash

# Colors
BLACK="\033[30m"
PINK="\033[95m"
RESET="\033[0m"

# Logo Function
print_logo() {
    echo -e "${PINK}"
    cat << "EOF"
   ********   **                          
  **//////** /**  **   **                
 **      //  /** //** **  ******  ****** 
/**          /**  //***  ////**  **////**
/**    ***** /**   /**      **  /**   /**
//**  ////** /**   **      **   /**   /**
 //********  ***  **      ******//****** 
  ////////  ///  //      //////  //////  

             Version 1.0 Beta Mobile  (created by CHIƎF)
EOF
    echo -e "${RESET}"
}


select_directory() {
    zenity --file-selection --directory --title="Select Download Directory"
}

select_file() {
    zenity --file-selection --title="Select Text File"
}

download_file() {
    local url="$1"
    local directory="$2"
    local filename=$(basename "$url")
    local filepath="$directory/$filename"

    echo -e "${PINK}Downloading $filename...${RESET}"

    curl -# -o "$filepath" "$url"

    if [ $? -eq 0 ]; then
        echo -e "${PINK}Downloaded: $filename${RESET}"
    else
        echo -e "${BLACK}Error downloading $filename${RESET}"
    fi
}

download_from_file() {
    local file_path="$1"
    local directory="$2"

    while IFS= read -r url; do
        [ -z "$url" ] && continue
        download_file "$url" "$directory"
    done < "$file_path"
}


download_video() {
    local url="$1"
    local directory="$2"

    echo -e "${PINK}Downloading video from $url...${RESET}"

    yt-dlp -o "$directory/%(title)s.%(ext)s" "$url"

    if [ $? -eq 0 ]; then
        echo -e "${PINK}Video downloaded successfully!${RESET}"
    else
        echo -e "${BLACK}Error downloading video!${RESET}"
    fi
}


show_menu() {
    echo -e "${PINK}1. Download a Single Link${RESET}"
    echo -e "${PINK}2. Download Multiple Links from a File${RESET}"
    echo -e "${PINK}3. Download Video from website (Better choice) ${RESET}"
    echo -e "${PINK}4. Exit${RESET}"
}

main() {
    clear
    print_logo

    while true; do
        show_menu
        read -p "$(echo -e "${PINK}Choose an option (1/2/3/4): ${RESET}")" choice

        case "$choice" in
            1)
                read -p "$(echo -e "${PINK}Enter the file URL: ${RESET}")" url
                directory=$(select_directory)
                if [ -z "$directory" ]; then
                    echo -e "${BLACK}No directory selected!${RESET}"
                    continue
                fi
                download_file "$url" "$directory"
                ;;
            2)
                file_path=$(select_file)
                if [ -z "$file_path" ]; then
                    echo -e "${BLACK}No file selected!${RESET}"
                    continue
                fi
                directory=$(select_directory)
                if [ -z "$directory" ]; then
                    echo -e "${BLACK}No directory selected!${RESET}"
                    continue
                fi
                download_from_file "$file_path" "$directory"
                ;;
            3)
                read -p "$(echo -e "${PINK}Enter the video URL: ${RESET}")" url
                directory=$(select_directory)
                if [ -z "$directory" ]; then
                    echo -e "${BLACK}No directory selected!${RESET}"
                    continue
                fi
                download_video "$url" "$directory"
                ;;
            4)
                echo -e "${PINK}Exiting the program...${RESET}"
                exit 0
                ;;
            *)
                echo -e "${BLACK}Invalid option! Please try again.${RESET}"
                ;;
        esac
    done
}

main
