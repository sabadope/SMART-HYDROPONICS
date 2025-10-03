-- =====================================================
-- SUPABASE SETUP FOR EXISTING pump_sensors TABLE
-- =====================================================
-- Your existing table structure:
-- id (uuid)
-- waterlevel_status (bool)
-- pump_status (bool)
-- date_time (timestamptz)

-- Disable Row Level Security for unrestricted access (no authentication required)
ALTER TABLE pump_sensors DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance (if not already exist)
CREATE INDEX IF NOT EXISTS idx_pump_sensors_date_time ON pump_sensors(date_time DESC);
CREATE INDEX IF NOT EXISTS idx_pump_sensors_waterlevel_status ON pump_sensors(waterlevel_status);
CREATE INDEX IF NOT EXISTS idx_pump_sensors_pump_status ON pump_sensors(pump_status);

-- Grant full access to all users (including anonymous for ESP32)
GRANT SELECT, INSERT, UPDATE, DELETE ON pump_sensors TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON pump_sensors TO authenticated;

-- Create a function to get the latest sensor reading
CREATE OR REPLACE FUNCTION get_latest_sensor_reading()
RETURNS TABLE (
    id UUID,
    waterlevel_status BOOLEAN,
    pump_status BOOLEAN,
    date_time TIMESTAMP WITH TIME ZONE
)
LANGUAGE SQL
SECURITY DEFINER
AS $$
    SELECT
        ps.id,
        ps.waterlevel_status,
        ps.pump_status,
        ps.date_time
    FROM pump_sensors ps
    ORDER BY ps.date_time DESC
    LIMIT 1;
$$;

-- Create a function to control pump (insert new record with pump status)
CREATE OR REPLACE FUNCTION control_pump(pump_on BOOLEAN)
RETURNS BOOLEAN
LANGUAGE PLPGSQL
SECURITY DEFINER
AS $$
DECLARE
    latest_water_status BOOLEAN;
BEGIN
    -- Get the latest water level status
    SELECT waterlevel_status INTO latest_water_status
    FROM pump_sensors
    ORDER BY date_time DESC
    LIMIT 1;

    -- If no previous record exists, assume water is available
    IF latest_water_status IS NULL THEN
        latest_water_status := TRUE;
    END IF;

    -- Insert new record with pump control
    INSERT INTO pump_sensors (waterlevel_status, pump_status, date_time)
    VALUES (latest_water_status, pump_on, NOW());

    RETURN TRUE;
END;
$$;

-- Grant execute permissions on functions to all users
GRANT EXECUTE ON FUNCTION get_latest_sensor_reading() TO anon;
GRANT EXECUTE ON FUNCTION get_latest_sensor_reading() TO authenticated;
GRANT EXECUTE ON FUNCTION control_pump(BOOLEAN) TO anon;
GRANT EXECUTE ON FUNCTION control_pump(BOOLEAN) TO authenticated;