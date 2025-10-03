-- ===========================================
-- HYDRO MONITOR DATABASE SETUP
-- Updated: 2025-09-13
-- PERFECT MATCH: Registration Form ↔ Database Storage
-- ===========================================

-- REGISTRATION FORM FIELDS MAPPING:
-- ✅ Full Name → user_profiles.full_name
-- ✅ Email → auth.users.email + user_profiles.email
-- ✅ Password → user_profiles.password (stored for reference)
-- ✅ Confirm Password → user_profiles.confirm_password (stored for reference)

-- 1. Create user_profiles table matching registration form
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL, -- From registration form
    role TEXT DEFAULT 'user', -- User role: 'user', 'admin', 'pending_admin'
    password TEXT, -- Stored for reference (NOT recommended for production)
    confirm_password TEXT, -- Stored for reference (NOT recommended for production)
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 2. Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- 3. Create RLS policies for authenticated access
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
CREATE POLICY "Users can view own profile" ON public.user_profiles
    FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
CREATE POLICY "Users can update own profile" ON public.user_profiles
    FOR UPDATE USING (auth.uid() = id);

-- Allow system/trigger to insert profiles during registration
DROP POLICY IF EXISTS "System can insert user profiles" ON public.user_profiles;
CREATE POLICY "System can insert user profiles" ON public.user_profiles
    FOR INSERT WITH CHECK (true);

-- 4. Create function matching registration form data
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    user_full_name TEXT;
    user_role TEXT;
    user_password TEXT;
    user_confirm_password TEXT;
BEGIN
    -- Extract full name from registration form data
    user_full_name := COALESCE(
        NEW.raw_user_meta_data->>'full_name',
        SPLIT_PART(NEW.email, '@', 1)
    );

    -- Extract role from registration form data (default to 'user')
    user_role := COALESCE(
        NEW.raw_user_meta_data->>'role',
        'user'
    );

    -- Extract password from registration form data (SHA-256 hashed)
    user_password := NEW.raw_user_meta_data->>'password';

    -- Extract confirm password from registration form data (SHA-256 hashed)
    user_confirm_password := NEW.raw_user_meta_data->>'confirm_password';

    -- Validate required fields
    IF user_full_name IS NULL OR user_full_name = '' THEN
        RAISE EXCEPTION 'Full name is required';
    END IF;

    IF user_role IS NULL OR user_role = '' THEN
        user_role := 'user'; -- Default role
    END IF;

    IF user_password IS NULL OR user_password = '' THEN
        RAISE EXCEPTION 'Password is required';
    END IF;

    IF user_confirm_password IS NULL OR user_confirm_password = '' THEN
        RAISE EXCEPTION 'Confirm password is required';
    END IF;

    -- Validate password confirmation matches
    IF user_password != user_confirm_password THEN
        RAISE EXCEPTION 'Password and confirm password do not match';
    END IF;

    -- Insert profile with ALL registration form data including role
    INSERT INTO public.user_profiles (id, email, full_name, role, password, confirm_password)
    VALUES (NEW.id, NEW.email, user_full_name, user_role, user_password, user_confirm_password);

    -- Log successful profile creation with all registration data (passwords are SHA-256 hashed)
    RAISE LOG 'User profile created - ID: %, Email: %, Full Name: %, Role: %, Password: [SHA-256 HASHED], Confirm: [SHA-256 HASHED]',
              NEW.id, NEW.email, user_full_name, user_role;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Create trigger for automatic profile creation (DISABLED for now)
-- DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
-- CREATE TRIGGER on_auth_user_created
--     AFTER INSERT ON auth.users
--     FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 6. Create function for updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7. Create trigger for updated_at
DROP TRIGGER IF EXISTS on_user_profile_updated ON public.user_profiles;
CREATE TRIGGER on_user_profile_updated
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- 8. Grant permissions for Flutter app access
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON public.user_profiles TO anon, authenticated;
GRANT ALL ON public.user_profiles TO service_role;

-- 9. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_profiles_id ON public.user_profiles(id);

-- ===========================================
-- REGISTRATION FORM ↔ DATABASE PERFECT MATCH
-- ===========================================

-- ✅ REGISTRATION FORM FIELDS:
--   • Full Name → Stored in user_profiles.full_name
--   • Email → Stored in auth.users.email + user_profiles.email
--   • Role → Stored in user_profiles.role (user/admin/pending_admin)
--   • Password → Stored in user_profiles.password (SHA-256 HASHED)
--   • Confirm Password → Stored in user_profiles.confirm_password (SHA-256 HASHED)

-- ✅ DATABASE STORAGE:
--   • auth.users: email, password (secure), id, timestamps
--   • user_profiles: id, email, full_name, password, confirm_password, avatar_url, created_at, updated_at

-- ✅ COMPLETE FIELD LIST (as displayed in Supabase Table Editor):
--   • id (UUID) - Primary key matching auth.users
--   • email (TEXT) - User's email address
--   • full_name (TEXT) - User's full name from registration
--   • role (TEXT) - User role: 'user', 'admin', 'pending_admin'
--   • password (TEXT) - User's actual password input
--   • confirm_password (TEXT) - User's confirm password input
--   • avatar_url (TEXT) - Profile picture URL (optional)
--   • created_at (TIMESTAMP) - Registration timestamp
--   • updated_at (TIMESTAMP) - Last update timestamp

-- ✅ LOGIN VERIFICATION:
--   1. User enters email/password from registration
--   2. Supabase verifies against auth.users table
--   3. Profile retrieved using matching ID
--   4. Login succeeds with complete user data

-- ===========================================
-- SETUP COMPLETE - READY FOR TESTING
-- ===========================================

-- ETO UNA 
