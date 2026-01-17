# 🚀 Eventos Django Backend - Complete Setup Guide

## ✅ All Django Code Files Created!

I've created all the necessary Python files for your Django backend with your MySQL credentials configured.

**MySQL Credentials Used:**
- Database: `Eventos`
- User: `Eventos`
- Password: `eventos2026`

---

## 📁 Files Created:

1. **requirements.txt** - Python dependencies
2. **settings_template.py** - Django settings (MySQL configured)
3. **accounts_models.py** - AdminUser model
4. **accounts_serializers.py** - API serializers
5. **accounts_views.py** - Login/Logout/Profile views
6. **accounts_urls.py** - Authentication URLs
7. **accounts_admin.py** - Django admin configuration
8. **project_urls.py** - Main URL configuration
9. **events_models.py** - Event model (basic structure)
10. **START_SERVER.bat** - Easy server startup script
11. **SETUP_INSTRUCTIONS.txt** - Quick reference

---

## 🔧 Setup Steps:

### Step 1: Create Virtual Environment & Install Dependencies

```bash
cd "D:\Personal Projects\EventosApp\eventos_backend"

# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Create Django Project Structure

```bash
# Still in eventos_backend folder with venv activated

# Create Django project
django-admin startproject eventos_project .

# Create apps
django-admin startapp accounts
django-admin startapp events
```

### Step 3: Copy Configuration Files

**Copy the content of these files to their respective locations:**

1. **`settings_template.py`** → `eventos_project/settings.py`
   (Replace the entire content)

2. **`accounts_models.py`** → `accounts/models.py`
   (Replace the entire content)

3. **`accounts_serializers.py`** → `accounts/serializers.py`
   (Create this new file)

4. **`accounts_views.py`** → `accounts/views.py`
   (Replace the entire content)

5. **`accounts_urls.py`** → `accounts/urls.py`
   (Create this new file)

6. **`accounts_admin.py`** → `accounts/admin.py`
   (Replace the entire content)

7. **`project_urls.py`** → `eventos_project/urls.py`
   (Replace the entire content)

8. **`events_models.py`** → `events/models.py`
   (Replace the entire content)

### Step 4: Verify MySQL Database Exists

```bash
mysql -u root -p
```

```sql
-- Check if database exists
SHOW DATABASES LIKE 'Eventos';

-- If not exists, create it
CREATE DATABASE IF NOT EXISTS Eventos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Verify user has permissions
SHOW GRANTS FOR 'Eventos'@'localhost';

-- If needed, grant permissions
GRANT ALL PRIVILEGES ON Eventos.* TO 'Eventos'@'localhost';
FLUSH PRIVILEGES;

EXIT;
```

### Step 5: Run Migrations

```bash
# Make sure venv is activated
cd "D:\Personal Projects\EventosApp\eventos_backend"
venv\Scripts\activate

# Create migration files
python manage.py makemigrations

# Apply migrations to database
python manage.py migrate
```

**Expected Output:**
```
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying accounts.0001_initial... OK
  Applying admin.0001_initial... OK
  ...
```

### Step 6: Create Test Admin Users

```bash
python manage.py shell
```

**Copy and paste this code in the shell:**

```python
from accounts.models import AdminUser

# Create admin user
AdminUser.objects.create_user(
    username='admin',
    password='admin',
    email='admin@eventos.com',
    organization='ADMIN',
    first_name='Admin',
    last_name='User'
)

# Create CSI user
AdminUser.objects.create_user(
    username='CSI',
    password='12345678',
    email='csi@eventos.com',
    organization='CSI'
)

# Create IE user
AdminUser.objects.create_user(
    username='IE',
    password='12345678',
    email='ie@eventos.com',
    organization='IE'
)

# Create GLUGOT user
AdminUser.objects.create_user(
    username='GLUGOT',
    password='12345678',
    email='glugot@eventos.com',
    organization='GLUGOT'
)

# Create IT user
AdminUser.objects.create_user(
    username='IT',
    password='12345678',
    email='it@eventos.com',
    organization='IT'
)

# Create MECH user
AdminUser.objects.create_user(
    username='MECH',
    password='12345678',
    email='mech@eventos.com',
    organization='MECH'
)

# Create SPORTS user
AdminUser.objects.create_user(
    username='SPORTS',
    password='12345678',
    email='sports@eventos.com',
    organization='SPORTS'
)

# Create COLLEGE user
AdminUser.objects.create_user(
    username='COLLEGE',
    password='12345678',
    email='college@eventos.com',
    organization='COLLEGE'
)

print("All users created successfully!")

# Exit the shell
exit()
```

### Step 7: Create Django Superuser (for Admin Panel)

```bash
python manage.py createsuperuser
```

**Enter:**
- Username: `superadmin`
- Email: `superadmin@eventos.com`
- Password: `admin123` (or your choice)

### Step 8: Start Django Server

```bash
python manage.py runserver
```

**OR use the batch file:**
```bash
START_SERVER.bat
```

---

## ✅ Test Your API!

### Option 1: Using Browser

Visit: http://localhost:8000/api/auth/health/

You should see:
```json
{
  "status": "ok",
  "message": "Eventos API is running",
  "version": "1.0.0"
}
```

### Option 2: Using Postman/Thunder Client

**Test Login:**
```
POST http://localhost:8000/api/auth/login/
Content-Type: application/json

{
  "username": "admin",
  "password": "admin"
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@eventos.com",
      "organization": "ADMIN",
      "organization_display": "Admin",
      "first_name": "Admin",
      "last_name": "User",
      "full_name": "Admin User",
      "is_active": true,
      "created_at": "2026-01-17T..."
    },
    "tokens": {
      "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
      "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
    }
  }
}
```

### Option 3: Django Admin Panel

Visit: http://localhost:8000/admin

Login with superuser credentials (superadmin / admin123)

You can view/manage users from the admin panel!

---

## 📊 Database Tables Created:

- `admin_users` - Admin user accounts with organizations
- `events` - Events (basic structure, will implement fully later)
- Plus Django's built-in tables (sessions, auth, etc.)

---

## 🎯 API Endpoints Available:

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | /api/auth/health/ | Health check | No |
| POST | /api/auth/login/ | User login | No |
| POST | /api/auth/logout/ | User logout | Yes |
| GET | /api/auth/profile/ | Get user profile | Yes |
| PUT/PATCH | /api/auth/profile/update/ | Update profile | Yes |

---

## 🐛 Troubleshooting:

### "mysqlclient" installation error on Windows:
```bash
# Install Visual C++ Build Tools first, OR use PyMySQL:
pip uninstall mysqlclient
pip install PyMySQL

# Then add to settings.py at the top:
import pymysql
pymysql.install_as_MySQLdb()
```

### "Access denied for user 'Eventos'@'localhost'":
- Check MySQL user exists: `SELECT User FROM mysql.user;`
- Grant permissions again
- Check password is correct

### "Unknown database 'Eventos'":
- Create database manually in MySQL
- Check database name case-sensitivity

### "No module named 'rest_framework'":
- Activate virtual environment: `venv\Scripts\activate`
- Install requirements: `pip install -r requirements.txt`

---

## 🎉 Next Steps:

Once Django is running successfully:

1. ✅ Test login API works
2. ✅ Connect Flutter app to Django
3. ✅ Implement Events API
4. ✅ Add image upload for event posters
5. ✅ Add event filtering by organization

---

**Your Django backend with MySQL is ready!** 🚀

All code files are created - just follow the setup steps above!
