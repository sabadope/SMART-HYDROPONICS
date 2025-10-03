# Database Setup Instructions

This folder contains the SQL scripts required to set up the SMART-HYDROPONICS database schema in Supabase.

## Setup Order

Run the SQL scripts in the following order:

### 1. `setup_user_profiles_trigger.sql`
- **Purpose**: Creates the `user_profiles` table and related functions/triggers
- **What it does**:
  - Creates `public.user_profiles` table with fields matching the registration form
  - Sets up Row Level Security (RLS) policies
  - Creates trigger function for automatic profile creation (currently disabled)
  - Grants necessary permissions for Flutter app access
  - Creates performance indexes

### 2. `create_admin_requests_table.sql`
- **Purpose**: Creates the admin approval system tables and policies
- **What it does**:
  - Creates `admin_requests` table for managing admin approval requests
  - Enables Row Level Security with appropriate policies
  - Allows users to view their own requests and admins to manage all requests
  - Creates indexes for performance
  - Includes trigger disabling instructions

## Important Notes

- **Trigger Status**: The user profile creation trigger is currently disabled to prevent registration errors. The app handles profile creation through the AuthService.
- **Admin System**: The admin approval system uses a hybrid approach - database tables for requests with local storage fallback in the Flutter app.
- **Security**: All tables have proper RLS policies to ensure data security.
- **Permissions**: Scripts grant necessary permissions for authenticated users and service roles.

## Running the Scripts

1. Open your Supabase project dashboard
2. Navigate to the SQL Editor
3. Run `setup_user_profiles_trigger.sql` first
4. Run `create_admin_requests_table.sql` second
5. Verify the tables were created successfully in the Table Editor

## Tables Created

- `public.user_profiles`: Extended user information
- `admin_requests`: Admin approval request management

## Troubleshooting

If you encounter issues:
- Ensure you're running the scripts in the correct order
- Check that RLS policies are enabled
- Verify permissions are granted correctly
- Check the Supabase logs for any error messages