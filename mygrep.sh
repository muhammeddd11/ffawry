usage() {
    echo "Usage: $0 [-n] [-v] pattern [file]"
    echo "Searches for pattern in file (or stdin if no file given)."
    echo "  -n  Print line numbers with matches"
    echo "  -v  Show lines that *don't* match"
    echo "  --help  Show this and bail"
    echo
    echo "Examples:"
    echo "  $0 foo bar.txt         # Find 'foo' in bar.txt (case insensitive)"
    echo "  $0 -n foo bar.txt      # Same, but with line numbers"
    echo "  $0 -v foo              # Lines from stdin that don't have 'foo'"
    exit 0
}

line_nums=0
inverse=0
pattern=""
file=""

while [ $# -gt 0 ]; do
    case "$1" in
        --help)
            usage
            ;;
        -n)
            line_nums=1
            shift
            ;;
        -v)
            inverse=1
            shift
            ;;
        -nv|-vn)
            line_nums=1
            inverse=1
            shift
            ;;
        -*)
            echo "WTF is $1? Not a valid option!" >&2
            exit 1
            ;;
        *)
            if [ -z "$pattern" ]; then
                pattern="$1"
            elif [ -z "$file" ]; then
                file="$1"
            else
                echo "Too many arguments, relax!" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$pattern" ]; then
    echo "Error: No search pattern provided! Gotta have something to look for." >&2
    echo "Try './mygrep.sh --help' for usage info." >&2
    exit 1
fi
if [[ "$pattern" =~ ^[[:space:]]*$ ]]; then
    echo "Error: Pattern is just whitespace! Give me something real." >&2
    echo "Try './mygrep.sh --help' for usage info." >&2
    exit 1
fi

if [ -z "$file" ]; then
    input="/dev/stdin"
else
    if [ ! -f "$file" ]; then
        echo "File '$file' ain't there, try again!" >&2
        exit 1
    fi
    input="$file"
fi

shopt -s nocasematch


lnum=0
while IFS= read -r line; do
    lnum=$((lnum + 1))
    
    if [[ "$line" =~ $pattern ]]; then
        matched=1
    else
        matched=0
    fi
    
    [ "$inverse" -eq 1 ] && matched=$((1 - matched))
    
    if [ "$matched" -eq 1 ]; then
        if [ "$line_nums" -eq 1 ]; then
            printf "%d:" "$lnum"
        fi
        echo "$line"
    fi
done < "$input"

shopt -u nocasematch