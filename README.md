[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/4WrZhqsw)
# Lab: Building a Jenkins CI/CD Pipeline

## Goal
Create a Jenkins CI/CD pipeline that automatically builds, tests, and packages a Spring Boot application when code is pushed to a Git repository.

## Learning Objectives
- Set up Jenkins in a Docker container
- Create a declarative Jenkinsfile pipeline
- Configure Jenkins to pull from a Git repository
- Understand pipeline stages: Build, Test, Package
- (Bonus) Add a Docker build stage

## Pre-requisites
- Docker installed and running
- A GitHub account
- Completed or watched the Week 8 Day 3 Jenkins demo
- Basic understanding of Git and Maven

## Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                             │
│                                                                   │
│   ┌──────────┐     ┌──────────────────────────────────────────┐  │
│   │  GitHub  │────►│               Jenkins                    │  │
│   │   Repo   │     │  ┌────────────────────────────────────┐  │  │
│   └──────────┘     │  │           Jenkinsfile              │  │  │
│                    │  │                                    │  │  │
│                    │  │  ┌─────────┐  ┌──────┐  ┌────────┐ │  │  │
│                    │  │  │ Build   │─►│ Test │─►│Package │ │  │  │
│                    │  │  └─────────┘  └──────┘  └────────┘ │  │  │
│                    │  └────────────────────────────────────┘  │  │
│                    └──────────────────────────────────────────┘  │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

## Tasks

### Task 1: Start Jenkins in Docker
Run Jenkins in a Docker container with persistent storage.

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

**Steps:**
1. Run the command above
2. Get the initial admin password:
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Open http://localhost:8080 in your browser
4. Paste the password and complete the setup wizard
5. Choose "Install suggested plugins"
6. Create an admin user or skip

---

### Task 2: Install Required Plugins
In Jenkins, go to **Manage Jenkins** → **Plugins** → **Available plugins**.

Install the following plugins:
- [ ] Pipeline
- [ ] Git
- [ ] Pipeline Maven Integration
- [ ] Eclipse Temurin installer (for Java 21+)

After installing, restart Jenkins if prompted.

---

### Task 3: Configure Java in Jenkins
1. Go to **Manage Jenkins** → **Tools**
2. Scroll to **JDK installations** → Click **Add JDK**
3. Name it: `JDK21`
4. Check **"Install automatically"**
5. Click **"Add Installer"** → Select **"Install from adoptium.net"**
6. Choose **JDK 21**
7. Click **Save**

---

### Task 4: Fork the Starter Repository
Fork or clone the provided starter Spring Boot app to your GitHub account.

**Starter repo structure:**
```
my-app/
├── src/
│   ├── main/java/...
│   └── test/java/...
├── pom.xml
├── mvnw
└── Jenkinsfile   ← You will create this
```

If using the provided `starter_code`, push it to a new GitHub repo:
```bash
cd starter_code
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

---

### Task 5: Create Your Jenkinsfile
Create a `Jenkinsfile` in the root of your repository with the following stages:

**Complete the TODO sections:**

```groovy
pipeline {
    agent any
    
    tools {
        jdk 'JDK21'  // Must match the name from Task 3
    }
    
    stages {
        stage('Hello') {
            steps {
                echo 'Pipeline started!'
                echo "Building on: ${env.NODE_NAME}"
            }
        }
        
        stage('Checkout') {
            steps {
                // TODO: The checkout happens automatically when using 
                // "Pipeline script from SCM", but add an echo for visibility
                echo 'Code checked out from Git'
            }
        }
        
        stage('Build') {
            steps {
                // TODO: Make mvnw executable and run compile
                // Hint: Use sh 'chmod +x mvnw' and sh './mvnw clean compile'
            }
        }
        
        stage('Test') {
            steps {
                // TODO: Run the Maven tests
                // Hint: sh './mvnw test'
            }
        }
        
        stage('Package') {
            steps {
                // TODO: Create the JAR file, skipping tests (already ran)
                // Hint: sh './mvnw package -DskipTests'
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
```

Commit and push your Jenkinsfile:
```bash
git add Jenkinsfile
git commit -m "Add Jenkinsfile"
git push
```

---

### Task 6: Create a Jenkins Pipeline Job
1. In Jenkins, click **"New Item"**
2. Enter a name (e.g., `MyAppPipeline`)
3. Select **"Pipeline"** and click **OK**
4. Scroll to the **Pipeline** section
5. Change **Definition** to **"Pipeline script from SCM"**
6. Configure:
   - **SCM**: Git
   - **Repository URL**: `https://github.com/YOUR_USERNAME/YOUR_REPO.git`
   - **Branch Specifier**: `*/main`
   - **Script Path**: `Jenkinsfile`
7. Click **Save**

---

### Task 7: Run and Verify the Pipeline
1. Click **"Build Now"** in the left sidebar
2. Watch the build progress in **Build History**
3. Click on the build number → **Console Output**
4. Verify all stages completed successfully

**Expected Output:**
- Build stage shows Maven compiling
- Test stage shows test results
- Package stage shows JAR being created
- Green checkmarks on all stages

---

### Task 8: Fix a Failing Build (Practice)
1. Intentionally break a test in your code
2. Push the change
3. Run the pipeline again
4. Observe how Jenkins reports the failure
5. Fix the test and push again
6. Verify the pipeline passes

---

### Bonus Task 9: Add Docker Build Stage
If you completed Docker socket mounting in the demo, add a Docker build stage:

```groovy
stage('Docker Build') {
    steps {
        echo "Building Docker image..."
        sh 'docker build -t myapp:${BUILD_NUMBER} .'
    }
}
```

**Pre-requisite:** You'll need a `Dockerfile` in your repo and Docker configured in Jenkins (see Week 8 Day 3 INSTRUCTOR_GUIDE for setup).

---

## Deliverables
1. [ ] Screenshot of Jenkins dashboard with successful build
2. [ ] Screenshot of Console Output showing all stages passed
3. [ ] Your completed `Jenkinsfile` (committed to Git)
4. [ ] (Bonus) Screenshot showing a failed build, then fixed

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `mvnw: Permission denied` | Add `sh 'chmod +x mvnw'` before running mvnw |
| `JAVA_HOME not set` | Ensure JDK is configured in Tools and referenced in `tools { jdk 'JDK21' }` |
| Pipeline not finding Jenkinsfile | Check Script Path matches your file location |
| `release version X not supported` | JDK version mismatch - configure correct Java version |

## Hints
- Use `echo` statements liberally to debug your pipeline
- Check Console Output for detailed error messages
- The `post` section runs even if stages fail
- Environment variables like `${BUILD_NUMBER}` are available automatically

## Extension Ideas
- Add code quality analysis with SonarQube stage
- Set up GitHub webhook for automatic builds
- Add deployment stage to push to a server
- Create separate pipelines for dev/staging/prod branches
