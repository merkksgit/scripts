#!/usr/bin/env bash

# Function to create basic web project structure
create_web_project() {
    local project_name="$1"
    
    # Check if directory already exists
    if [ -d "$project_name" ]; then
        echo "Warning: Directory '$project_name' already exists!"
        read -p "Do you want to overwrite it? (y/n): " answer
        
        case $answer in
            [Yy]* )
                echo "Removing existing directory..."
                rm -rf "$project_name"
                ;;
            * )
                echo "Operation cancelled."
                exit 1
                ;;
        esac
    fi
    
    # Create project directory and subdirectories
    echo "Creating new project structure..."
    mkdir -p "$project_name"/{css,js}
    
    # Create HTML file with corrected boilerplate
    cat > "$project_name/index.html" << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title></title>
    <link href="css/style.css" rel="stylesheet" />
  </head>
  <body>

    <script src="js/functions.js"></script>
  </body>
</html>
EOF
    
    # Create empty CSS and JS files
    touch "$project_name/css/style.css"
    touch "$project_name/js/functions.js"
    
    # Show the created structure
    echo "Created web project structure:"
    tree "$project_name"
}

# Check if project name is provided
if [ $# -eq 0 ]; then
    echo "Please provide a project name."
    echo "Usage: $0 project_name"
    exit 1
fi

# Create the project
create_web_project "$1"
echo "Basic web project setup complete!"
