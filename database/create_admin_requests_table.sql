-- Create admin_requests table for managing admin approval requests
-- Run this SQL in your Supabase SQL Editor

CREATE TABLE IF NOT EXISTS admin_requests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    approved_by UUID REFERENCES auth.users(id),
    rejected_by UUID REFERENCES auth.users(id),

    -- Ensure one request per user
    UNIQUE(user_id)
);

-- Enable Row Level Security (RLS)
ALTER TABLE admin_requests ENABLE ROW LEVEL SECURITY;

-- Allow system/trigger to insert admin requests during registration
CREATE POLICY "System can insert admin requests" ON admin_requests
    FOR INSERT WITH CHECK (true);

-- Users can view their own admin requests
CREATE POLICY "Users can view own admin requests" ON admin_requests
    FOR SELECT USING (auth.uid() = user_id);

-- Admins can view and update all admin requests
CREATE POLICY "Admins can manage admin requests" ON admin_requests
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Grant necessary permissions
GRANT ALL ON admin_requests TO authenticated;
GRANT ALL ON admin_requests TO service_role;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_admin_requests_status ON admin_requests (status);
CREATE INDEX IF NOT EXISTS idx_admin_requests_requested_at ON admin_requests (requested_at DESC);



-- DISABLE THE PROBLEMATIC TRIGGER
-- Run this in Supabase SQL Editor to fix the registration error

-- Drop the trigger that's causing "Database_error saving new user"
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- The trigger function will remain but won't execute
-- Registration should now work without database errors

-- ETO PANGALAWA