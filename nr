#!/usr/bin/env bash
#
# NeoRunner: A small, portable code runner script written in BASH 4.3+
# https://github.com/awesomearc/neorunner
#
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org/>

# Version information 
__version="1.0"

# Check for dependencies
if [[ ! -x $(command -v jq) ]]; then

    printf "Error: jq was not found on this system!\n" 1>&2
    printf "Please install it correctly before running this script.\n" 1>&2

    exit 1

fi

# Variables
executor_map_fallback_path="/usr/local/etc/nr/executor_map_by_ext.json"
executor_map_path="$HOME/.config/nr/executor_map_by_ext.json"
file_path=
file_name=
file_type=
file_name_without_ext=
dir_name=

# Prints help message
function print_help() {

    printf '%s\n' "NeoRunner is a simple code runner script written in BASH."
    printf '%s\n' "It relies on a file extension-based executor map written in JSON to specify snippets for each language."
    printf '\n'
    printf '%s\n' 'Usage: nr [options] <path-to-file>'
    printf '\n'
    printf '%s\n' "Options:"
    printf '\t%s\n' "-f extension, --file-type=extension: Force NeoRunner to ignore the file extension and use a specific executor."
    printf '\t%s\n' "-e path, --executor-map-path=path: Read the executor map from a specific path instead of the default."
    printf '\t%s\n' "-h, --help: Print this help message"
    printf '\t%s\n' "-v, --version: Print the script version"

}

# Prints version
function print_version() {

    printf '%s\n' "$__version"

}

# Parses arguments and sets variables accordingly
function parse_arguments() {

    while [[ $# > 0 ]]; do

        _option="$1"

        case $_option in

            -f|--file-type)
                file_type="$2"
                shift
            ;;

            --file-type=*)
                file_type="${_option##--file-type=}"
            ;;

            -f*)
                file_type="${_option##-f}"
            ;;

            -e|--executor-map-path)
                executor_map_path="$2"
                shift
            ;;

            --executor-map-path=*)
                executor_map_path="${_option##--executor-map-path=}"
            ;;

            -e*)
                executor_map_path="${_option##-e}"
            ;;

            -h|--help)
                print_help
                exit 0
            ;;
            
            -h*)
                print_help
                exit 0
            ;;

            -v|--version)
                print_version
                exit 0
            ;;
            
            -v*)
                print_version
                exit 0
            ;;

            *)
                file_path="$1"
            ;;

        esac

        shift

    done

}

# Checks whether file path is specified, exists, and readable
function check_file_path() {

    if [[ -z "$file_path" ]]; then

        printf '%s\n' "Error: File path not specified!" 1>&2
        printf '\n'
        printf '%s\n' "Run with -h or --help for usage information" 1>&2

        exit 1

    elif [[ ! -f "$file_path" ]]; then

        printf '%s\n' "Error: Specified file does not exist!" 1>&2

        exit 1

    fi

}

# Checks whether executor map exists and is readable
function check_executor_map_path() {

    if [[ ! -f "$executor_map_path" ]]; then

        if [[ -f "$executor_map_fallback_path" ]]; then

            executor_map_path="$executor_map_fallback_path"

            return 0

        fi

        printf '%s\n' "Error: Executor map not found!" 1>&2
        printf '%s\n' "An example executor map can be found at:" 1>&2
        printf '%s\n' "https://github.com/awesomearc/nr/README.md" 1>&2
        printf '\n' 1>&2
        printf '%s\n' "Please set up an executor map at ~/.config/nr/executor_map_by_ext.json before running this script." 1>&2

        exit 1

    elif [[ ! -r "$executor_map_path" ]]; then

        printf '%s\n' "Error: Executor map is not readable!" 1>&2
        printf '%s\n' "Please make sure this user has permission to read $executor_map_path." 1>&2

        exit 1

    fi

}

# Runs the code
function run_code() {

    file_name="$(basename "$file_path")"
    dir_name="$(dirname "$file_path")"

    if [[ "$file_name" != *.* ]] && [[ -z "$file_type" ]]; then
        
        printf "Warning: No file extension specified. Running as a shell script." 1>&2

        file_type="sh"

    else

        if [[ -z "$file_type"  ]]; then

            file_type="${file_name##*.}"

        fi

        file_name_without_ext="${file_name%.*}"

    fi

    if [[ $(jq -r "has(\"$file_type\")" "$executor_map_path") == "true" ]]; then

        executor="$(jq -r ."$file_type" "$executor_map_path")"
        eval "cd \"$dir_name\"; $executor"

    else

        printf "Error: No executor is defined for this language\n" 1>&2

        exit 1

    fi

}

function main() {

    parse_arguments "$@"
    check_file_path
    check_executor_map_path
    run_code

}

main "$@"

exit 0
