#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

nvimpath="${HOME}/build/neovim"
logpath="${nvimpath}/my-logs"
buildlog="${logpath}/build.log"

echo "Has the repo been updated to the version you want to build?"

read -p "(y/n)? " answer

if [ "${answer}" = "y" ]; then
    echo -e "${GREEN}Starting update...${NC}"
    echo "logs saved to: ${logpath}"
    mkdir -p ${logpath}
    cd ${nvimpath}
    echo -e "${GREEN}Uninstalling previous version...${NC}"
    echo "Requires privileges:"
    sudo cmake --build build/ --target uninstall > ${logpath}/uninstall.log
    sudo rm -rf ~/build/neovim/build/
    echo -e "${GREEN}Building new version...${NC}"
    sleep 1

    make CMAKE_BUILD_TYPE=Release > ${buildlog} &
    BUILD_PID=$!
    watch -n 1 "tail -n 10 ${buildlog}" &
    WATCH_PID=$!
    wait $BUILD_PID
    sleep 0.5
    kill $WATCH_PID
    tail -n 15 ${buildlog}

    echo -e "${GREEN}Installing...${NC}"
    sudo make install
    echo -e "${GREEN}Done.${NC}"

# Fallback option with no watch for progress
elif [ "${answer}" = "Yes" ]; then
    echo -e "${GREEN}Starting update...${NC}"
    echo "logs saved to: ${logpath}"
    mkdir -p ${logpath}
    cd ${nvimpath}
    echo -e "${GREEN}Uninstalling previous version...${NC}"
    sleep 0.5
    sudo cmake --build build/ --target uninstall > ${logpath}/uninstall.log
    sudo rm -rf ~/build/neovim/build/
    echo -e "${GREEN}Building new version...${NC}"
    sleep 0.5
    make CMAKE_BUILD_TYPE=Release > ${buildlog}
    echo -e "${GREEN}Installing...${NC}"
    sudo make install
    echo -e "${GREEN}Done.${NC}"

elif [ "${answer}" = "n" ]; then
    echo -e "${RED}Aborted.${NC}"

else
    echo -e "${RED}invalid input${NC}: '${answer}'"
fi

