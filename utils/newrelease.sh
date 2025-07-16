#!/bin/bash

# Get the directory name
dir_name=$(basename `pwd`)

# Get the version update type
version_type=$1

echo "Creating new $version_type version for $dir_name"

# Check if is a plugin and php file exists
if [ -f "${dir_name}.php" ]; then
    # Get the current version
    current_version=$(grep -oP 'Version:\s*([a-zA-Z 0-9:\/\.\-\_]*)' "${dir_name}.php" | sed 's/Version:\s*\([a-zA-Z 0-9:\/\.\-\_]*\)/\1/')
    echo "Current version is $current_version"

    # Split the version into major, minor, patch
    IFS='.' read -r -a version_parts <<< "$current_version"

    # Increment the version based on the input parameter
    case $version_type in
        "major")
            version_parts[0]=$((version_parts[0] + 1))
        version_parts[1]=0
        version_parts[2]=0
            ;;
        "minor")
            version_parts[1]=$((version_parts[1] + 1))
        version_parts[2]=0
            ;;
        "patch")
            version_parts[2]=$((version_parts[2] + 1))
            ;;
        *)
            echo "Invalid version type. Please use major, minor, or patch."
            exit 1
            ;;
    esac

    # Join the version parts back together
    new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

    echo "New version is $new_version"

    # Replace the version in the file
    sed -i "s/$current_version/$new_version/" "${dir_name}.php"

    # Commit the changes
    git add "${dir_name}.php"
    git commit -m "chore(version): update to version $new_version"

    # Tag the commit
    git tag -a "$new_version" -m "Release of version $new_version"
    git push
    git push --tags

# Check if it is a theme, and style.css exists
elif [ -f "style.css" ]; then
    # Get the current version
    current_version=$(grep -oP 'Version:\s*([a-zA-Z 0-9:\/\.\-\_]*)' style.css | sed 's/Version:\s*\([a-zA-Z 0-9:\/\.\-\_]*\)/\1/')
    echo "Current version is $current_version"

    # Split the version into major, minor, patch
    IFS='.' read -r -a version_parts <<< "$current_version"

    # Increment the version based on the input parameter
    case $version_type in
        "major")
            version_parts[0]=$((version_parts[0] + 1))
        version_parts[1]=0
        version_parts[2]=0
            ;;
        "minor")
            version_parts[1]=$((version_parts[1] + 1))
        version_parts[2]=0
            ;;
        "patch")
            version_parts[2]=$((version_parts[2] + 1))
            ;;
        *)
            echo "Invalid version type. Please use major, minor, or patch."
            exit 1
            ;;
    esac

    # Join the version parts back together
    new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

    echo "New version is $new_version"

    # Replace the version in the file
    sed -i "s/$current_version/$new_version/" style.css

    # Commit the changes
    git add style.css
    git commit -m "chore(version): update to version $new_version"

    # Tag the commit
    git tag -a "$new_version" -m "Release of version $new_version"
    git push
    git push --tags

else
    echo "File ${dir_name}.php does not exist in the current directory."
fi
