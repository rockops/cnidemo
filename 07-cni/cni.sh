#!/bin/bash

case $CNI_COMMAND in
    ADD)
        echo "ADD"
        ;;
    DEL)
        echo "DEL"
        ;;
    CHECK)
        echo "CHECK"
        ;;
    VERSION)
        echo "VERSION"
        ;;
    *)  
        echo "Unknown CNI command: $CNI_COMMAND"
        ;;
esac
