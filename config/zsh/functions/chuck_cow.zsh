#!/usr/bin/env zsh
# Chuck Norris fortune function using official oh-my-zsh fortunes

chuck_cow() {
    local fortunes_file="$ZDOTDIR/functions/chuck_fortunes.db"
    
    if [[ ! -f "$fortunes_file" ]]; then
        echo "💪 Chuck Norris doesn't need fortune files. He IS the fortune."
        return
    fi
    
    # Read fortunes separated by % lines
    local -a fortunes
    while IFS= read -r line; do
        if [[ "$line" == "%" ]]; then
            continue
        elif [[ -n "$line" ]]; then
            fortunes+=("$line")
        fi
    done < "$fortunes_file"
    
    # Pick a random fortune
    local fortune=${fortunes[$((RANDOM % ${#fortunes[@]} + 1))]}
    
    if command -v cowsay &> /dev/null; then
        echo "$fortune" | cowsay
    else
        echo "💪 $fortune"
    fi
}