# Clinic Management System

A comprehensive web-based clinic management system built with Java, JSP, and modern web technologies. This system provides complete management capabilities for healthcare clinics including patient management, doctor scheduling, medicine inventory, and detailed analytics.

## 🏥 Project Overview

The Clinic Management System is a full-stack web application designed to streamline healthcare clinic operations. It features a modern, responsive interface with comprehensive reporting and analytics capabilities.

### Key Features

#### 👥 **Patient Management**
- Patient registration and profile management
- Medical history tracking
- Appointment scheduling and management
- Patient demographics analysis

#### 👨‍⚕️ **Doctor & Staff Management**
- Doctor profiles and specializations
- Staff scheduling and availability
- Performance tracking and analytics
- Consultation management

#### 💊 **Medicine & Inventory Management**
- Medicine catalog and stock management
- Prescription tracking
- Inventory alerts and reorder management
- Sales analytics and growth tracking

#### 📊 **Comprehensive Reporting System**
- **Patient Analytics**: Registration trends, demographics, nationality distribution
- **Doctor Performance**: Consultation volumes, treatment success rates, experience analysis
- **Medicine Analytics**: Sales trends, growth comparisons, performance analysis
- **Treatment Management**: Success rates, duration analysis, revenue tracking
- **Consultation Analytics**: Volume trends, peak hours, status distribution

#### 🎨 **Modern UI/UX**
- Responsive design with Tailwind CSS
- Interactive charts using Chart.js
- Real-time data updates
- PDF export functionality
- Professional dashboard interface

## 🛠️ Technology Stack

### Backend
- **Java 17** - Core programming language
- **Jakarta EE** - Enterprise Java framework
- **JAX-RS** - RESTful web services
- **JPA/Hibernate** - Database ORM
- **GlassFish Server** - Application server
- **MySQL** - Database management system

### Frontend
- **JSP (JavaServer Pages)** - Server-side templating
- **Tailwind CSS** - Utility-first CSS framework
- **Chart.js** - Interactive charts and graphs
- **JavaScript (ES6+)** - Client-side functionality
- **DaisyUI** - Component library for Tailwind CSS

### Development Tools
- **Maven** - Build automation and dependency management
- **Docker** - Containerization for consistent deployment
- **Git** - Version control

## 📋 Prerequisites

Before running this project, ensure you have the following installed on your system:

### Required Software

1. **Java Development Kit (JDK) 17**
   - Download from [Oracle JDK](https://www.oracle.com/java/technologies/downloads/#java17) or [OpenJDK](https://adoptium.net/)
   - Set JAVA_HOME environment variable

2. **Docker Desktop**
   - Download from [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Ensure Docker is running before starting the application

3. **MySQL Database (Optional - Docker will handle this)**
   - If running locally: MySQL 8.0+
   - If using Docker: Included in docker-compose

4. **IDE (Choose one)**
   - **IntelliJ IDEA** (Recommended)
   - **Visual Studio Code** with Java extensions
   - **Eclipse** with Java EE support

### System Requirements

- **Operating System**: Windows 10+, macOS 10.15+, or Linux
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: At least 2GB free space
- **Network**: Internet connection for Docker image downloads

## 🚀 Installation & Setup

### ⚠️ Platform-Specific Prerequisites

**For Windows Users:**
Before proceeding with any installation method, Windows users should address potential line ending issues:

```bash
# Open Git Bash and navigate to project directory
cd /path/to/ClinicManagementSystem

# Fix line endings for shell scripts
dos2unix mvnw
dos2unix deploy/glassfish_init/init.sh

# Make scripts executable
chmod +x mvnw
chmod +x deploy/glassfish_init/init.sh
chmod +x docker-build-war.sh
```

**For macOS/Linux Users:**
```bash
# Make scripts executable
chmod +x mvnw
chmod +x deploy/glassfish_init/init.sh
chmod +x docker-build-war.sh
```

### Option 1: IntelliJ IDEA (Recommended)

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd ClinicManagementSystem
   ```

2. **Open in IntelliJ IDEA**
   - Open IntelliJ IDEA
   - Select "Open" and choose the project folder
   - Wait for Maven to download dependencies

3. **Configure Run Configuration**
   - Go to `Run` → `Edit Configurations`
   - Import the provided run configuration from `.idea/runConfigurations/`
   - Ensure Docker is running

4. **Start the Application**
   - Run the "deploy" configuration first
   - Then run the "build-war" configuration
   - The application will be available at `http://localhost:8080`

### Option 2: Visual Studio Code

1. **Install Extensions**
   - Install "Extension Pack for Java"
   - Install "Docker" extension
   - Install "Maven for Java" extension

2. **Open Terminal and Navigate to Project**
   ```bash
   cd ClinicManagementSystem
   ```

3. **Start Docker**
   ```bash
   # Ensure Docker is running
   docker --version
   ```

4. **Build and Deploy**
   ```bash
   # For macOS/Linux
   ./docker-build-war.sh
   
   # For Windows
   .\docker-build-war.ps1
   ```

5. **Access the Application**
   - Open browser and go to `http://localhost:8080`
   - Default admin credentials: Check the database setup

### Option 3: Command Line (Any OS)

1. **Prerequisites Check**
   ```bash
   java --version
   docker --version
   mvn --version
   ```

2. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd ClinicManagementSystem
   ```

3. **Build and Deploy**
   ```bash
   # macOS/Linux
   chmod +x docker-build-war.sh
   ./docker-build-war.sh
   
   # Windows
   .\docker-build-war.ps1
   ```

4. **Access Application**
   - Navigate to `http://localhost:8080`
   - Login with admin credentials

## 📁 Project Structure

```
ClinicManagementSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── DTO/                 # Data Transfer Objects
│   │   │   ├── models/              # Entity models
│   │   │   ├── repositories/        # Data access layer
│   │   │   ├── servlet/             # REST API endpoints
│   │   │   └── utils/               # Utility classes
│   │   ├── resources/
│   │   │   ├── data.sql             # Database initialization
│   │   │   └── META-INF/
│   │   └── webapp/
│   │       ├── static/              # CSS, JS, images
│   │       ├── views/               # JSP pages
│   │       └── WEB-INF/
├── deploy/                          # Deployment artifacts
├── docker-compose.yml              # Docker configuration
├── Dockerfile                      # Docker build instructions
├── pom.xml                         # Maven configuration
└── README.md                       # This file
```

## 🔧 Configuration

### Database Configuration
The application uses MySQL database. Configuration is handled automatically through Docker, but you can customize it in:
- `src/main/resources/META-INF/persistence.xml`
- `docker-compose.yml`

### Application Settings
- **Port**: Default 8080 (configurable in docker-compose.yml)
- **Context Path**: `/` (root)
- **Admin Interface**: Available at `/admin`

## 📊 Features in Detail

### Patient Management
- **Registration**: Complete patient profiles with medical history
- **Demographics**: Age, gender, nationality, blood type analysis
- **Appointments**: Scheduling and tracking system
- **Medical Records**: Comprehensive health information storage

### Doctor Management
- **Profiles**: Detailed doctor information and specializations
- **Scheduling**: Flexible appointment scheduling system
- **Performance**: Analytics on consultation volumes and success rates
- **Experience Tracking**: Years of experience and expertise areas

### Medicine & Inventory
- **Catalog Management**: Complete medicine database
- **Stock Tracking**: Real-time inventory monitoring
- **Sales Analytics**: Revenue tracking and growth analysis
- **Reorder Alerts**: Automatic low stock notifications

### Advanced Analytics
- **Real-time Reports**: Live data visualization
- **Growth Analysis**: Period-over-period comparisons
- **Performance Metrics**: Success rates and efficiency indicators
- **Export Capabilities**: PDF report generation

## 🐛 Troubleshooting

### Common Issues

1. **Docker Not Running**
   ```bash
   # Start Docker Desktop
   # Check status
   docker ps
   ```

2. **Port Already in Use**
   ```bash
   # Check what's using port 8080
   lsof -i :8080  # macOS/Linux
   netstat -ano | findstr :8080  # Windows
   ```

3. **Java Version Issues**
   ```bash
   # Ensure Java 17 is installed
   java --version
   # Set JAVA_HOME if needed
   export JAVA_HOME=/path/to/java17  # macOS/Linux
   set JAVA_HOME=C:\path\to\java17   # Windows
   ```

4. **Maven Dependencies**
   ```bash
   # Clean and rebuild
   mvn clean install
   ```

5. **Platform-Specific Line Ending Issues (Windows)**
   
   **Problem**: Windows users may encounter issues with shell scripts due to different line endings (CRLF vs LF).
   
   **Symptoms**:
   - `mvnw` script fails with "command not found" or syntax errors
   - `init.sh` script fails during Docker initialization
   - Permission denied errors on shell scripts
   
   **Solutions**:
   
   **Option A: Using Git Bash (Recommended)**
   ```bash
   # Open Git Bash and navigate to project
   cd /path/to/ClinicManagementSystem
   
   # Fix line endings for Maven wrapper
   dos2unix mvnw
   
   # Fix line endings for init script
   dos2unix deploy/glassfish_init/init.sh
   
   # Make scripts executable
   chmod +x mvnw
   chmod +x deploy/glassfish_init/init.sh
   ```
   
   **Option B: Using PowerShell**
   ```powershell
   # Install dos2unix if not available
   # Using Chocolatey: choco install dos2unix
   # Using Scoop: scoop install dos2unix
   
   # Fix line endings
   dos2unix mvnw
   dos2unix deploy/glassfish_init/init.sh
   ```
   
   **Option C: Manual Fix in VS Code**
   - Open the file in VS Code
   - Click on the line ending indicator in the bottom right (CRLF/LF)
   - Change from CRLF to LF
   - Save the file
   
   **Option D: Git Configuration**
   ```bash
   # Configure Git to handle line endings automatically
   git config --global core.autocrlf false
   git config --global core.eol lf
   
   # Re-clone the repository
   git clone <repository-url>
   ```

6. **Shell Script Permission Issues**
   ```bash
   # Make scripts executable (macOS/Linux)
   chmod +x mvnw
   chmod +x deploy/glassfish_init/init.sh
   chmod +x docker-build-war.sh
   
   # For Windows Git Bash
   git update-index --chmod=+x mvnw
   git update-index --chmod=+x deploy/glassfish_init/init.sh
   git update-index --chmod=+x docker-build-war.sh
   ```

### Performance Optimization

- **Memory**: Increase JVM heap size for large datasets
- **Database**: Optimize MySQL configuration for better performance
- **Caching**: Enable application-level caching for frequently accessed data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section above
- Review the project documentation

## 🔄 Updates

Stay updated with the latest features and bug fixes by:
- Watching the repository
- Checking the releases page
- Following the changelog

---

**Note**: This is a comprehensive clinic management system designed for educational and demonstration purposes. For production use, additional security measures and compliance features should be implemented.
