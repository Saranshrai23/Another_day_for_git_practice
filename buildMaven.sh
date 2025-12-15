#!/bin/bash

# ---------------------- CONFIG ----------------------
REPO_URL="https://github.com/opstree/spring3hibernate.git"
PROJECT_DIR=$(basename "$REPO_URL" .git)
TOMCAT_PATH="/var/lib/tomcat9/webapps"   # Adjust if your Tomcat path is different

# ---------------------- INSTALL PREREQUISITES ----------------------
echo "Installing prerequisites..."
sudo apt update -y
sudo apt install -y openjdk-11-jdk maven git || { echo "Failed to install prerequisites"; exit 1; }

# ---------------------- HELP ----------------------
show_help() {
    echo "Usage: ./buildMaven.sh [options]"
    echo "-a  Generate artifact"
    echo "-i  Install artifact to local Maven repo"
    echo "-s  Perform static code analysis (checkstyle|findbugs|spotbugs|pmd)"
    echo "-t  Run unit tests (plugins: test|surefire:test|jacoco:report|cobertura:cobertura)"
    echo "-d  Deploy artifact to Tomcat"
    echo "-h  Show this help"
}

# ---------------------- CLONE REPO AND INITIAL MAVEN BUILD ----------------------
clone_repo() {
    if [[ -d "$PROJECT_DIR" ]]; then
        echo "Project directory '$PROJECT_DIR' already exists. Pulling latest changes..."
        cd "$PROJECT_DIR" || exit 1
        git pull origin master || echo "git pull failed, continuing with existing code"
    else
        echo "Cloning repository: $REPO_URL"
        git clone "$REPO_URL" || { echo "git clone failed"; exit 1; }
        cd "$PROJECT_DIR" || { echo "Failed to enter project directory"; exit 1; }

        # Initial Maven build
        echo -e "\nRunning initial Maven build steps..."
        mvn dependency:resolve || { echo "Dependency resolution failed"; exit 1; }
        mvn clean compile || { echo "Compile failed"; exit 1; }
        
    fi
    cd - >/dev/null
}

# ---------------------- STATIC ANALYSIS ----------------------
run_static_analysis() {
    if [[ -z "$STATIC_TOOL" ]]; then
        echo "No static analysis tool specified. Skipping."
        return
    fi

    cd "$PROJECT_DIR" || { echo "Project directory not found"; exit 1; }
    echo "Running static analysis: $STATIC_TOOL"

    case $STATIC_TOOL in
        checkstyle)
            mvn checkstyle:checkstyle || { echo "Checkstyle failed"; exit 1; } ;;
        pmd)
            mvn pmd:pmd || { echo "PMD failed"; exit 1; } ;;
        findbugs|spotbugs)
            mvn spotbugs:spotbugs || { echo "SpotBugs failed"; exit 1; } ;;
        *)
            echo "Unknown static tool: $STATIC_TOOL"; exit 1 ;;
    esac
    cd - >/dev/null
}

# ---------------------- GENERATE ARTIFACT ----------------------
generate_artifact() {
    cd "$PROJECT_DIR" || { echo "Project directory not found"; exit 1; }
    echo "Generating artifact..."
    mvn clean package || { echo "Package failed"; exit 1; }
    cd - >/dev/null
}

# ---------------------- INSTALL ARTIFACT ----------------------
install_artifact() {
    cd "$PROJECT_DIR" || { echo "Project directory not found"; exit 1; }
    echo "Installing artifact to local repository..."
    mvn clean install -Ddependency-check.skip=true || { echo "Install failed"; exit 1; }
    cd - >/dev/null
}

# ---------------------- UNIT TEST ----------------------
run_unit_tests() {
    # Default plugin if user did not specify
    if [[ -z "$UNIT_PLUGIN" ]]; then
        echo "No unit test plugin specified. Using default 'test' phase."
        UNIT_PLUGIN="test"
    fi

    # Allowed unit test plugins (add more if needed)
    VALID_UNIT_PLUGINS=("test" "surefire:test" "jacoco:report" "cobertura:cobertura")

    # Validate user input
    if [[ ! " ${VALID_UNIT_PLUGINS[@]} " =~ " ${UNIT_PLUGIN} " ]]; then
        echo "Warning: Unknown unit test plugin '$UNIT_PLUGIN'. Falling back to default 'test' phase."
        UNIT_PLUGIN="test"
    fi

    cd "$PROJECT_DIR" || { echo "Project directory not found"; exit 1; }
    echo "Running unit tests with plugin: $UNIT_PLUGIN"

    # Run unit tests
    mvn clean "$UNIT_PLUGIN" || { echo "Unit tests failed"; exit 1; }

    # Generate code coverage if default test or cobertura configured
    if [[ "$UNIT_PLUGIN" == "test" ]]; then
        echo "Generating code coverage with Cobertura..."
        mvn cobertura:cobertura || echo "Code coverage report failed"
    fi

    cd - >/dev/null
}




# ---------------------- DEPLOY ARTIFACT ----------------------
deploy_artifact() {
    cd "$PROJECT_DIR" || { echo "Project directory not found"; exit 1; }
    echo "Deploying artifact to Tomcat..."
    WAR_FILE=$(ls target/*.war 2>/dev/null || true)
    if [[ -z "$WAR_FILE" ]]; then
        echo "WAR file not found. Package first using -a."
        exit 1
    fi
    sudo cp "$WAR_FILE" "$TOMCAT_PATH" || { echo "Failed to deploy to Tomcat"; exit 1; }
    cd - >/dev/null
    echo "Artifact deployed successfully to $TOMCAT_PATH"
}

# ---------------------- MAIN ----------------------
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# Clone repo first
clone_repo

while getopts "a i s:t:d h" opt; do
    case $opt in
        a) generate_artifact ;;
        i) install_artifact ;;
        s) STATIC_TOOL="$OPTARG"; run_static_analysis ;;
        t) run_unit_tests; run_unit_tests ;;
        d) deploy_artifact ;;
        h) show_help ;;
        *) show_help ;;
    esac
done
