#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test configuration
IMAGE_NAME="artwall-demo"
CONTAINER_NAME="artwall-test"
TEST_PORTS=(8080 8081 8082)

# Check if required files exist
echo -e "${YELLOW}Checking required files...${NC}"
required_files=("start.sh" "healthcheck.sh" "Dockerfile")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Missing required file: $file${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ Found: $file${NC}"
        ls -la "$file"
    fi
done

# Make scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
chmod +x start.sh healthcheck.sh

# Debug: Show current directory and all files
echo -e "${YELLOW}Current directory: $(pwd)${NC}"
echo -e "${YELLOW}Files that Docker should see in build context:${NC}"
find . -maxdepth 1 -type f -name "*.sh" -o -name "Dockerfile" -o -name "*.html" -o -name "*.conf" | sort

# Check for .dockerignore that might exclude files
if [ -f ".dockerignore" ]; then
    echo -e "${YELLOW}.dockerignore contents:${NC}"
    cat .dockerignore
fi

# Try to verify Docker can see the files by creating a simple test Dockerfile
echo -e "${YELLOW}Testing Docker build context...${NC}"
cat > Dockerfile.test << 'EOF'
FROM alpine
COPY healthcheck.sh /test-healthcheck.sh
RUN ls -la /test-healthcheck.sh
EOF

echo -e "${YELLOW}Testing if Docker can copy healthcheck.sh...${NC}"
if docker build -f Dockerfile.test -t test-context . >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker can see healthcheck.sh${NC}"
    docker rmi test-context >/dev/null 2>&1
else
    echo -e "${RED}✗ Docker cannot see healthcheck.sh in build context${NC}"
    echo -e "${YELLOW}Trying to rebuild Docker daemon cache...${NC}"
    docker system prune -f >/dev/null 2>&1
fi
rm -f Dockerfile.test

echo -e "${YELLOW}Building Docker image with verbose output...${NC}"
docker build -t $IMAGE_NAME --progress=plain --no-cache .

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build image${NC}"
    exit 1
fi

# Function to test a specific port
test_port() {
    local port=$1
    echo -e "\n${YELLOW}Testing on port $port...${NC}"
    
    # Stop and remove existing container
    docker stop $CONTAINER_NAME 2>/dev/null
    docker rm $CONTAINER_NAME 2>/dev/null
    
    # Run container with specific port
    echo -e "${YELLOW}Starting container on port $port...${NC}"
    docker run -d --name $CONTAINER_NAME -p $port:$port -e PORT=$port $IMAGE_NAME
    
    # Wait for container to start
    sleep 5
    
    # Show container status
    echo -e "${YELLOW}Container status:${NC}"
    docker ps -a | grep $CONTAINER_NAME
    
    # Show detailed container logs immediately
    echo -e "${YELLOW}Container logs:${NC}"
    docker logs $CONTAINER_NAME
    
    # Test if container is running
    if ! docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${RED}Container failed to start on port $port${NC}"
        
        # Additional debugging - inspect the container
        echo -e "${YELLOW}Container inspect (last state):${NC}"
        docker inspect $CONTAINER_NAME | grep -A 10 '"State":'
        
        return 1
    fi
    
    # Test HTTP response
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$port)
    
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ Port $port: HTTP $response - SUCCESS${NC}"
        
        # Test health check
        if docker exec $CONTAINER_NAME /healthcheck.sh >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Port $port: Health check - SUCCESS${NC}"
        else
            echo -e "${RED}✗ Port $port: Health check - FAILED${NC}"
            echo -e "${YELLOW}Health check output:${NC}"
            docker exec $CONTAINER_NAME /healthcheck.sh
        fi
    else
        echo -e "${RED}✗ Port $port: HTTP $response - FAILED${NC}"
    fi
    
    # Stop container
    docker stop $CONTAINER_NAME >/dev/null 2>&1
}

# Test multiple ports
for port in "${TEST_PORTS[@]}"; do
    test_port $port
done

# Cleanup
echo -e "\n${YELLOW}Cleaning up...${NC}"
docker rm $CONTAINER_NAME 2>/dev/null

echo -e "\n${GREEN}Testing complete!${NC}"
echo -e "${YELLOW}To test manually, run:${NC}"
echo "docker run -d --name test-app -p 8080:8080 -e PORT=8080 $IMAGE_NAME"
echo "curl http://localhost:8080"
echo "docker exec test-app /healthcheck.sh"
