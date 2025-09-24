#!/bin/bash

# Process files in current directory and any subdirectories
# Usage: process_fm.sh [directory1] [directory2] [directory3] ...
# Options:
# -e, --export-to-apple-notes         Export to Apple Notes (default: false)
# -t, --migrate-tags                  Migrate tags to Obsidian format (default: false)
# -r, --remove-frontmatter-tags       Remove tags from frontmatter (default: false)
# -s, --remove-frontmatter-timestamps Remove timestamps from frontmatter (default: false)
# -h, --help                          Display this help message
#
# Example: process_fm.sh -e -t -r -s directory1 directory2 directory3

# Continue processing if only directory or file is passed and no command line options
#
#
# Continue with argument if no command line options are passed
# for arg in "$@"; do
#   if [[ "$arg" =~ ^- ]]; then
#     while [[ "$#" -gt 0 ]]; do
#     case $1 in
#       -e|--export-to-apple-notes) export_to_apple_notes=true; shift ;;
#       -t|--migrate-tags) migrate_tags=true; shift ;;
#       -r|--remove-frontmatter-tags) remove_frontmatter_tags=true; shift ;;
#       -s|--remove-frontmatter-timestamps) remove_frontmatter_timestamps=true; shift ;;
#       -h|--help) echo "Usage: process_fm.sh [file1] [file2] [file3] ..."; exit 0 ;;
#     *) echo "Unknown parameter passed: $1"; exit 1 ;;
#     esac
#     done
#   else
#     continue
#   fi
# done

# Handle spaces in filenames
IFS=$'\n'
for file in $(find "$@" -type f -name "*.md" -print0 | tr '\0' '\n'); do

  # Set default values
  export_to_apple_notes=false
  migrate_tags=true
  migrate_frontmatter=false
  remove_fm_tags=true
  remove_fm_timestamps=true

  # Check if the file exists
  if [ -f "$file" ]; then
    echo ""
    echo ""
    echo "================================================================================"
    echo "PROCESSING: $file"
    echo "================================================================================"


    # Save the original created and modified times, just in case
    orig_created=$(stat -f "%SB" -t "%m/%d/%Y %H:%M:%S" "$file")
    orig_modified=$(stat -f "%Sm" -t "%m/%d/%Y %H:%M:%S" "$file")

    # Check if file has any frontmatter
    if ! grep -q "^---" "$file"; then
      echo "No frontmatter found; skipping."
      continue
    fi

    # Check if the file's frontmatter is a three-line block with only "{}"
    if awk 'NR==1 { if($0=="---") next; else exit 1 }
            NR==2 { if($0=="{}") next; else exit 1 }
            NR==3 { if($0=="---") exit 0; else exit 1 }' "$file"; then
      echo "Frontmatter is empty ({}); removing entire frontmatter."
      # Remove the first three lines (i.e. the frontmatter block)
      awk 'NR>3 { print }' "$file" > tmpfile && mv tmpfile "$file"
      exit 0
    else
      echo "Frontmatter is not empty; processing..."
    fi

    # Check if the file already contains tags
  	has_tags=$(awk '
  		BEGIN { fm=0; count=0 }
  		/^---/ { fm++ }
  		fm==2 {
  			count++
  			if (count==2 && $0 ~ /^#/) { exit 1 }
  			if (count==2) { exit 0 }
  		}
  		END { exit 0 }
  	' "$file"; echo $?)

  	# If the file already contains tags, skip it
  	if [ "$has_tags" -eq 1 ]; then
  		echo "File already processed, skipping."
  		exit 0
  	fi

    echo ""
    echo "==== CREATED TIMESTAMP ====================================="

  	# Extract ctime from the filename (if it exists), i.e. YYYYMMDDHHMM
  	# Check if filename starts with "20..""
  	if [[ $file == 20* ]]; then
  		ctime=$(basename "$file" | cut -c1-12)
  		echo "Timestamp found in the filename: $ctime"
  	else
  	  frontmatter_ctime=$(yq e --front-matter="extract" '.created' "$file" | xargs -I {} date -u -j -f "%Y-%m-%d %H:%M" "{}" +"%Y%m%d%H%M%S")
  		original_ctime=$(stat -f "%SB" -t "%Y%m%d%H%M%S" "$file")

      echo "Frontmatter created time: $frontmatter_ctime"
      echo "File created time:        $original_ctime"
  		if (( frontmatter_ctime < original_ctime )); then
        echo "Picking older created timestamp: Frontmatter"
  		  ctime=$frontmatter_ctime
  		else
        echo "Picking older created timestamp: File"
  		  ctime=$original_ctime
  		fi

      cyear=${ctime:0:4}
      cmonth=${ctime:4:2}
      cday=${ctime:6:2}
      chour=${ctime:8:2}
      cminute=${ctime:10:2}
      csecond=${ctime:12:2}

      orig_created="$cmonth/$cday/$cyear $chour:$cminute:$csecond"
      echo "Setting created time: $orig_created"
    fi

    echo ""
    echo "==== MODIFIED TIMESTAMP ===================================="

    tag_mtime=$(yq e --front-matter="extract" '.updated' "$file" | xargs -I {} date -u -j -f "%Y-%m-%d %H:%M" "{}" +"%Y%m%d%H%M%S")
    if [ -z "$tag_mtime" ] || [ "$tag_mtime" == "null" ]; then
      echo "No updated time found in the frontmatter."
      echo "Setting modified time: $orig_modified"
    else
      frontmatter_mtime="$tag_mtime"
  		original_mtime=$(stat -f "%Sm" -t "%Y%m%d%H%M%S" "$file")

      echo "Frontmatter modified time: $frontmatter_mtime"
      echo "File modified time:        $original_mtime"

      if (( frontmatter_mtime < original_mtime )); then
        echo "Picking older modified timestamp: Frontmatter"
  		  mtime=$frontmatter_mtime
  		else
        echo "Picking older modified timestamp: File"
  		  mtime=$original_mtime
  		fi

      myear=${mtime:0:4}
      mmonth=${mtime:4:2}
      mday=${mtime:6:2}
      mhour=${mtime:8:2}
      mminute=${mtime:10:2}
      msecond=${mtime:12:2}

      orig_modified="$mmonth/$mday/$myear $mhour:$mminute:$msecond"
      echo "Setting modified time: $orig_modified"
    fi




      echo ""
      echo "==== TITLE & TAGS =========================================="

      if [ "$export_to_apple_notes" == true ]; then
        echo "Inserting title: $title"
        title="# $(basename "$file" | sed 's/\.md//')"
      else
        echo "Title will not be inserted."
        title=()
      fi

      tags=$(yq e --front-matter=extract '.tags' "$file")
      if [ -z "$tags" ] || [ "$tags" == "null" ]; then
        echo "No tags found in the frontmatter."
      elif [ "$migrate_tags" == true ]; then
        echo "Tags found: '$tags'"
        tags=$(echo "$tags" | awk -F', ' '{for(i=1;i<=NF;i++){ $i="#"$i } OFS=" "; print}')
        echo "Inserting tags: $tags"
      fi

    echo ""
    echo "==== CLEANUP ==============================================="
    echo "Removing frontmatter tags and timestamps."
    if [ "$remove_fm_tags" == true ]; then
      echo "Removing tags from frontmatter."
      yq e --front-matter=process 'del(.tags)' -i "$file"
    fi
    if [ "$remove_fm_timestamps" == true ]; then
      echo "Removing timestamps from frontmatter."
      yq e --front-matter=process 'del(.created)' -i "$file"
      yq e --front-matter=process 'del(.updated)' -i "$file"
    fi

    # Check if the file's frontmatter is a three-line block with only "{}"
    if awk 'NR==1 { if($0=="---") next; else exit 1 }
            NR==2 { if($0=="{}") next; else exit 1 }
            NR==3 { if($0=="---") exit 0; else exit 1 }' "$file"; then
      echo "Frontmatter is empty; removing entire frontmatter block."
      # Remove the first three lines (i.e. the frontmatter block)
      awk 'NR>3 { print }' "$file" > tmpfile && mv tmpfile "$file"
    elif [ "$migrate_frontmatter" == true ]; then
      echo "Frontmatter is not empty. Re-formatting it as a codeblock."
      awk '
      {
        if ($0 == "---") {
          if (!first) {
            first = 1
            # Replace first occurrence with the metadata header and a code block start
            print "### Metadata:"
            print "```"
            next
          } else if (!second) {
            second = 1
            # Replace second occurrence with a code block end and an empty line
            print "```"
            printf "\n"
            next
          }
        }
        print
      }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    fi

    awk -v title="$title" -v tags="$tags" '
    BEGIN {
      if (title != "") {
        print title
        printf "\n"
      }
      # Conditionally insert tags if non-empty
      if (tags != "" && tags != "null") {
        print tags
        printf "\n"
      }
    }
    { print }
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"


    if $export_to_apple_notes; then
      echo ""
      echo "==== CONVERTING TO RTF ====================================="
      echo "Converting to RTF format, saving as: ${file}.rtf"
      pandoc -f markdown -s "$file" -o "${file}.rtf"

      # Check if the RTF file was created successfully
      if [ -f "${file}.rtf" ]; then
        echo "Conversion successful, removing original file."
        rm "$file"
      else
        echo "Error creating RTF file."
      fi

      echo ""
      echo "==== SETTING TIMESTAMPS ===================================="
      echo "Setting created time: $orig_created"
      SetFile -d "$orig_created" "${file}.rtf"
      echo "Setting original modified time: $orig_modified"
      SetFile -m "$orig_modified" "${file}.rtf"

    else
      echo ""
      echo "==== SETTING TIMESTAMPS ===================================="
      echo "Setting created time: $orig_created"
      SetFile -d "$orig_created" "$file"
      echo "Setting original modified time: $orig_modified"
      SetFile -m "$orig_modified" "$file"
    fi

  else
    echo "File not found: $file"
  fi
done
