-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. fasts_log
CREATE TABLE fasts_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    fast_type TEXT, -- 16:8, 18:6, 20:4, etc.
    status TEXT NOT NULL DEFAULT 'active', -- active, completed, broken
    water_consumed DECIMAL(5,2) DEFAULT 0.0, -- Amount in liters
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time)
);

-- 2. water_consumed
CREATE TABLE water_consumed (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    amount NUMERIC NOT NULL,
    type TEXT NOT NULL DEFAULT 'water', -- water, tea, coffee, etc.
    goal NUMERIC NOT NULL,
    left NUMERIC GENERATED ALWAYS AS (goal - amount) STORED,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_amount_positive CHECK (amount >= 0)
);

-- 3. calories_log
CREATE TABLE calories_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    image_url TEXT,
    food_name TEXT NOT NULL,
    calories NUMERIC NOT NULL,
    protein NUMERIC,
    carbs NUMERIC,
    fat NUMERIC,
    meal_type TEXT, -- breakfast, lunch, dinner, snack
    serving_size TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_calories_positive CHECK (calories >= 0)
);

-- 4. steps_log
CREATE TABLE steps_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    steps INTEGER NOT NULL,
    distance NUMERIC,
    goal INTEGER NOT NULL,
    calories_burned NUMERIC,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    source TEXT, -- device, app, manual entry
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_steps_positive CHECK (steps >= 0)
);

-- 5. workout_log
CREATE TABLE workout_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    workout_name TEXT NOT NULL,
    workout_type TEXT NOT NULL, -- strength, cardio, flexibility, etc.
    calories_burned NUMERIC,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    length INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    rating INTEGER, -- User rating (1-5)
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time),
    CONSTRAINT check_rating_range CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5))
);

-- 6. exercises
CREATE TABLE exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    calories_burned NUMERIC, -- Per minute
    exercise_type TEXT NOT NULL, -- strength, cardio, flexibility
    muscle_group TEXT, -- primary muscle group targeted
    equipment TEXT, -- equipment needed
    difficulty TEXT, -- beginner, intermediate, advanced
    instructions TEXT, -- how to perform
    video_url TEXT, -- demonstration video
    image_url TEXT, -- image
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. exercise_log
CREATE TABLE exercise_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_log_id UUID NOT NULL REFERENCES workout_log(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES exercises(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    sets INTEGER,
    reps INTEGER,
    weight NUMERIC,
    duration INTERVAL,
    distance NUMERIC,
    calories_burned NUMERIC,
    notes TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_sets_positive CHECK (sets IS NULL OR sets > 0),
    CONSTRAINT check_reps_positive CHECK (reps IS NULL OR reps > 0),
    CONSTRAINT check_weight_positive CHECK (weight IS NULL OR weight > 0)
);

-- 8. food_searches
CREATE TABLE food_searches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    image_url TEXT,
    query_text TEXT,
    ai_response JSONB,
    food_name TEXT,
    calories NUMERIC,
    macros JSONB, -- protein, carbs, fat
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    saved_to_log BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 9. music (needs to be created before meditations due to foreign key)
CREATE TABLE music (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    artist TEXT,
    duration INTERVAL NOT NULL,
    audio_url TEXT NOT NULL,
    category TEXT, -- meditation, workout, ambient, etc.
    image_url TEXT, -- album art
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 10. meditations
CREATE TABLE meditations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    duration INTERVAL NOT NULL,
    music_id UUID REFERENCES music(id),
    category TEXT, -- sleep, stress, focus, etc.
    instructor TEXT,
    audio_url TEXT NOT NULL,
    image_url TEXT,
    difficulty TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 11. meditation_log (New table to track user meditation sessions)
CREATE TABLE meditation_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    meditation_id UUID REFERENCES meditations(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT,
    rating INTEGER, -- User rating (1-5)
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time),
    CONSTRAINT check_rating_range CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5))
);

-- 12. challenges
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    challenge_type TEXT NOT NULL, -- workout, nutrition, etc.
    difficulty TEXT, -- beginner, intermediate, advanced
    points INTEGER,
    image_url TEXT,
    created_by UUID REFERENCES auth.users(id),
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_date_after_start CHECK (end_date >= start_date)
);

-- 13. challenge_exercise
CREATE TABLE challenge_exercise (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES exercises(id),
    sets INTEGER,
    reps INTEGER,
    duration INTERVAL,
    distance NUMERIC,
    points INTEGER,
    day_number INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_sets_positive CHECK (sets IS NULL OR sets > 0),
    CONSTRAINT check_reps_positive CHECK (reps IS NULL OR reps > 0),
    CONSTRAINT check_day_number_positive CHECK (day_number > 0)
);

-- 14. challenge_participants (New table to track challenge participants)
CREATE TABLE challenge_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    join_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status TEXT NOT NULL DEFAULT 'active', -- active, completed, abandoned
    progress NUMERIC DEFAULT 0, -- percentage complete
    points_earned INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_challenge_user UNIQUE (challenge_id, user_id)
);

-- 15. battles
CREATE TABLE battles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    battle_type TEXT NOT NULL, -- steps, workouts, etc.
    creator_id UUID NOT NULL REFERENCES auth.users(id),
    winner_id UUID REFERENCES auth.users(id),
    status TEXT NOT NULL DEFAULT 'pending', -- pending, active, completed
    prize TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_date_after_start CHECK (end_date >= start_date)
);

-- 16. battle_participants
CREATE TABLE battle_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    battle_id UUID NOT NULL REFERENCES battles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    score NUMERIC DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'invited', -- invited, accepted, declined, completed
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_battle_user UNIQUE (battle_id, user_id)
);

-- 17. protocols
CREATE TABLE protocols (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL, -- fitness, nutrition, wellness
    difficulty TEXT, -- beginner, intermediate, advanced
    duration INTERVAL,
    image_url TEXT,
    created_by UUID REFERENCES auth.users(id),
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 18. protocol_steps
CREATE TABLE protocol_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    protocol_id UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    duration INTERVAL,
    image_url TEXT,
    video_url TEXT,
    exercise_id UUID REFERENCES exercises(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_step_number_positive CHECK (step_number > 0)
);

-- 19. protocol_participants (New table to track protocol participants)
CREATE TABLE protocol_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    protocol_id UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status TEXT NOT NULL DEFAULT 'active', -- active, completed, abandoned
    current_step INTEGER DEFAULT 1,
    progress NUMERIC DEFAULT 0, -- percentage complete
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_protocol_user UNIQUE (protocol_id, user_id),
    CONSTRAINT check_current_step_positive CHECK (current_step > 0)
);

-- 20. helpers
CREATE TABLE helpers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    vendor_id TEXT,
    rate NUMERIC NOT NULL,
    specialty TEXT NOT NULL,
    bio TEXT,
    experience_years INTEGER,
    certifications TEXT[],
    availability JSONB,
    rating NUMERIC DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_rate_positive CHECK (rate >= 0),
    CONSTRAINT check_experience_years_positive CHECK (experience_years IS NULL OR experience_years >= 0)
);

-- 21. help_session
CREATE TABLE help_session (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    helper_id UUID NOT NULL REFERENCES helpers(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    status TEXT NOT NULL DEFAULT 'scheduled', -- scheduled, in-progress, completed, cancelled
    topic TEXT NOT NULL,
    notes TEXT,
    user_rating INTEGER,
    user_feedback TEXT,
    cost NUMERIC,
    payment_status TEXT NOT NULL DEFAULT 'pending', -- pending, paid, refunded
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time),
    CONSTRAINT check_rating_range CHECK (user_rating IS NULL OR (user_rating >= 1 AND user_rating <= 5))
);

-- 22. orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    total_amount NUMERIC NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- pending, processing, shipped, delivered, cancelled
    shipping_address JSONB,
    billing_address JSONB,
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending', -- pending, paid, refunded
    tracking_number TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_total_amount_positive CHECK (total_amount >= 0)
);

-- 23. order_items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC NOT NULL,
    total_price NUMERIC GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_quantity_positive CHECK (quantity > 0),
    CONSTRAINT check_unit_price_positive CHECK (unit_price >= 0)
);

-- 24. products (New table to track available products)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    category TEXT NOT NULL, -- subscription, merchandise, digital, etc.
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_price_positive CHECK (price >= 0)
);

-- 25. prescription_calls
CREATE TABLE prescription_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    doctor_id UUID,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    status TEXT NOT NULL DEFAULT 'scheduled', -- scheduled, completed, cancelled
    notes TEXT,
    prescription_issued BOOLEAN NOT NULL DEFAULT FALSE,
    prescription_details JSONB,
    follow_up_required BOOLEAN NOT NULL DEFAULT FALSE,
    follow_up_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time)
);

-- 26. message_groups
CREATE TABLE message_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    type TEXT NOT NULL, -- direct, group, support
    created_by UUID NOT NULL REFERENCES auth.users(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 27. message_group_members
CREATE TABLE message_group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES message_groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    role TEXT NOT NULL DEFAULT 'member', -- admin, member
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_read_message_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_group_user UNIQUE (group_id, user_id)
);

-- 28. messages
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES message_groups(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES auth.users(id),
    content TEXT NOT NULL,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    attachment_url TEXT,
    attachment_type TEXT, -- image, video, file
    is_edited BOOLEAN NOT NULL DEFAULT FALSE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 29. vapi_calls
CREATE TABLE vapi_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    call_id TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    status TEXT NOT NULL, -- initiated, in-progress, completed, failed
    call_type TEXT NOT NULL, -- inbound, outbound
    phone_number TEXT,
    transcript TEXT,
    recording_url TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_end_time_after_start CHECK (end_time IS NULL OR end_time > start_time)
);

-- 30. heygen_sessions
CREATE TABLE heygen_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    session_id TEXT,
    video_url TEXT,
    thumbnail_url TEXT,
    script TEXT,
    avatar_id TEXT,
    duration INTERVAL,
    status TEXT NOT NULL, -- processing, completed, failed
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 31. ai_calls
CREATE TABLE ai_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    service TEXT NOT NULL, -- OpenAI, Claude, etc.
    model TEXT NOT NULL, -- GPT-4, Claude 3, etc.
    prompt TEXT NOT NULL,
    response TEXT,
    tokens_used INTEGER,
    cost NUMERIC,
    purpose TEXT, -- food analysis, workout recommendation, etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_tokens_used_positive CHECK (tokens_used IS NULL OR tokens_used >= 0),
    CONSTRAINT check_cost_positive CHECK (cost IS NULL OR cost >= 0)
);

-- 32. goals
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    goal_type TEXT NOT NULL, -- weight, fitness, nutrition, etc.
    starting_weight NUMERIC,
    goal_weight NUMERIC,
    goal_physique_type_image_url TEXT,
    height NUMERIC,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    target_date DATE,
    status TEXT NOT NULL DEFAULT 'active', -- active, achieved, abandoned
    progress NUMERIC DEFAULT 0, -- percentage complete
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_target_date_after_start CHECK (target_date IS NULL OR target_date >= start_date),
    CONSTRAINT check_progress_range CHECK (progress >= 0 AND progress <= 100)
);

-- 33. user_stats (New table to track user statistics)
CREATE TABLE user_stats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    weight NUMERIC,
    body_fat_percentage NUMERIC,
    muscle_mass NUMERIC,
    bmi NUMERIC,
    waist_circumference NUMERIC,
    hip_circumference NUMERIC,
    chest_circumference NUMERIC,
    arm_circumference NUMERIC,
    thigh_circumference NUMERIC,
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    resting_heart_rate INTEGER,
    sleep_hours NUMERIC,
    stress_level INTEGER, -- 1-10
    mood TEXT, -- happy, sad, energetic, tired, etc.
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_date UNIQUE (user_id, date),
    CONSTRAINT check_weight_positive CHECK (weight IS NULL OR weight > 0),
    CONSTRAINT check_body_fat_percentage_range CHECK (body_fat_percentage IS NULL OR (body_fat_percentage >= 0 AND body_fat_percentage <= 100)),
    CONSTRAINT check_stress_level_range CHECK (stress_level IS NULL OR (stress_level >= 1 AND stress_level <= 10))
);

-- 34. user_preferences (New table to store user preferences)
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    theme TEXT DEFAULT 'light', -- light, dark, system
    notification_preferences JSONB,
    measurement_system TEXT DEFAULT 'metric', -- metric, imperial
    language TEXT DEFAULT 'en', -- en, es, fr, etc.
    privacy_settings JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_preferences UNIQUE (user_id)
);

-- Create indexes for better performance
CREATE INDEX idx_fasts_log_user_id ON fasts_log(user_id);
CREATE INDEX idx_fasts_log_date ON fasts_log(date);
CREATE INDEX idx_water_consumed_user_id ON water_consumed(user_id);
CREATE INDEX idx_water_consumed_date ON water_consumed(date);
CREATE INDEX idx_calories_log_user_id ON calories_log(user_id);
CREATE INDEX idx_calories_log_date ON calories_log(date);
CREATE INDEX idx_steps_log_user_id ON steps_log(user_id);
CREATE INDEX idx_steps_log_date ON steps_log(date);
CREATE INDEX idx_workout_log_user_id ON workout_log(user_id);
CREATE INDEX idx_workout_log_date ON workout_log(date);
CREATE INDEX idx_exercise_log_user_id ON exercise_log(user_id);
CREATE INDEX idx_exercise_log_workout_id ON exercise_log(workout_log_id);
CREATE INDEX idx_exercise_log_exercise_id ON exercise_log(exercise_id);
CREATE INDEX idx_food_searches_user_id ON food_searches(user_id);
CREATE INDEX idx_meditation_log_user_id ON meditation_log(user_id);
CREATE INDEX idx_meditation_log_meditation_id ON meditation_log(meditation_id);
CREATE INDEX idx_challenges_created_by ON challenges(created_by);
CREATE INDEX idx_challenge_exercise_challenge_id ON challenge_exercise(challenge_id);
CREATE INDEX idx_challenge_participants_challenge_id ON challenge_participants(challenge_id);
CREATE INDEX idx_challenge_participants_user_id ON challenge_participants(user_id);
CREATE INDEX idx_battles_creator_id ON battles(creator_id);
CREATE INDEX idx_battle_participants_battle_id ON battle_participants(battle_id);
CREATE INDEX idx_battle_participants_user_id ON battle_participants(user_id);
CREATE INDEX idx_protocols_created_by ON protocols(created_by);
CREATE INDEX idx_protocol_steps_protocol_id ON protocol_steps(protocol_id);
CREATE INDEX idx_protocol_participants_protocol_id ON protocol_participants(protocol_id);
CREATE INDEX idx_protocol_participants_user_id ON protocol_participants(user_id);
CREATE INDEX idx_helpers_user_id ON helpers(user_id);
CREATE INDEX idx_help_session_user_id ON help_session(user_id);
CREATE INDEX idx_help_session_helper_id ON help_session(helper_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_prescription_calls_user_id ON prescription_calls(user_id);
CREATE INDEX idx_message_groups_created_by ON message_groups(created_by);
CREATE INDEX idx_message_group_members_group_id ON message_group_members(group_id);
CREATE INDEX idx_message_group_members_user_id ON message_group_members(user_id);
CREATE INDEX idx_messages_group_id ON messages(group_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_time ON messages(time);
CREATE INDEX idx_vapi_calls_user_id ON vapi_calls(user_id);
CREATE INDEX idx_heygen_sessions_user_id ON heygen_sessions(user_id);
CREATE INDEX idx_ai_calls_user_id ON ai_calls(user_id);
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_user_stats_user_id ON user_stats(user_id);
CREATE INDEX idx_user_stats_date ON user_stats(date);
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);

-- Create triggers to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to all tables
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_timestamp
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION trigger_set_timestamp();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Create RLS policies for each table
-- Example for fasts_log (repeat for all tables)
ALTER TABLE fasts_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own fasts" ON fasts_log FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own fasts" ON fasts_log FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own fasts" ON fasts_log FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own fasts" ON fasts_log FOR DELETE USING (auth.uid() = user_id);

-- Create views for common queries
CREATE VIEW user_daily_summary AS
SELECT 
    u.id AS user_id,
    d.date,
    COALESCE(f.fasting_hours, 0) AS fasting_hours,
    COALESCE(w.water_consumed, 0) AS water_consumed,
    COALESCE(c.total_calories, 0) AS total_calories,
    COALESCE(s.steps, 0) AS steps,
    COALESCE(wo.workout_minutes, 0) AS workout_minutes,
    COALESCE(wo.calories_burned, 0) AS workout_calories_burned
FROM 
    auth.users u
CROSS JOIN (
    SELECT DISTINCT date FROM generate_series(
        CURRENT_DATE - INTERVAL '30 days',
        CURRENT_DATE,
        '1 day'
    ) AS date
) d
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        EXTRACT(EPOCH FROM SUM(duration))/3600 AS fasting_hours
    FROM fasts_log
    GROUP BY user_id, date
) f ON u.id = f.user_id AND d.date = f.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        SUM(amount) AS water_consumed
    FROM water_consumed
    GROUP BY user_id, date
) w ON u.id = w.user_id AND d.date = w.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        SUM(calories) AS total_calories
    FROM calories_log
    GROUP BY user_id, date
) c ON u.id = c.user_id AND d.date = c.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        MAX(steps) AS steps
    FROM steps_log
    GROUP BY user_id, date
) s ON u.id = s.user_id AND d.date = s.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        SUM(EXTRACT(EPOCH FROM length)/60) AS workout_minutes,
        SUM(calories_burned) AS calories_burned
    FROM workout_log
    GROUP BY user_id, date
) wo ON u.id = wo.user_id AND d.date = wo.date;

-- Create functions for common calculations
CREATE OR REPLACE FUNCTION calculate_bmi(weight_kg NUMERIC, height_cm NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF weight_kg IS NULL OR height_cm IS NULL OR height_cm = 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND((weight_kg / ((height_cm / 100) ^ 2))::NUMERIC, 2);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_calories_burned(weight_kg NUMERIC, duration_minutes NUMERIC, met NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF weight_kg IS NULL OR duration_minutes IS NULL OR met IS NULL THEN
        RETURN NULL;
    END IF;
    -- Calories = MET * weight (kg) * duration (hours)
    RETURN ROUND((met * weight_kg * (duration_minutes / 60))::NUMERIC, 0);
END;
$$ LANGUAGE plpgsql;