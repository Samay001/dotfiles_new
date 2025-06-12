#!/bin/bash

# Set initial states
last_title=""
declare -a lyrics_times lyrics_lines

while true; do
    # Get current track metadata
    title=$(playerctl --player=spotify metadata --format '{{title}}')
    current_sec=$(playerctl --player=spotify metadata --format '{{duration(position)}}' | 
                  awk -F: '{print ($1 * 60 + $2)}')

    # Fetch new lyrics only when song changes
    if [[ "$title" != "$last_title" ]]; then
        encoded_title=$(jq -rn --arg t "$title" '$t | @uri')
        lyrics_json=$(curl -s "https://lyricsapi.vercel.app/api/lyrics?name=$encoded_title")
        
        # Reset lyric arrays
        lyrics_times=()
        lyrics_lines=()
        
        # Parse lyrics into parallel arrays
        while IFS= read -r line; do
            time_ms=$(echo "$line" | awk '{print $1}')
            lyrics_times+=("$((time_ms / 1000))")  # Convert to seconds
            lyrics_lines+=("$(echo "$line" | cut -d' ' -f2-)")
        done < <(echo "$lyrics_json" | jq -r '.[] | "\(.time) \(.words)"')
        
        last_title="$title"
    fi

    # Find current lyric using binary search
    current_line=""
    low=0
    high=$(( ${#lyrics_times[@]} - 1 ))
    while (( low <= high )); do
        mid=$(( (low + high) / 2 ))
        if (( current_sec >= lyrics_times[mid] )); then
            current_line="${lyrics_lines[mid]}"
            low=$((mid + 1))
        else
            high=$((mid - 1))
        fi
    done

    # Output to polybar
    echo "${current_line:-🎵 $title}"  # Fallback to title if no lyrics
    
    sleep 0.5  # Reduced refresh rate for better performance
done

