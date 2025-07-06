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
    is_admin BOOLEAN NOT NULL DEFAULT FALSE, -- Admin flag for special permissions
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

-- 35. ai_agents (New table for AI agents/coaches)
CREATE TABLE ai_agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    agent_type TEXT NOT NULL, -- coach, nutritionist, trainer, therapist, etc.
    capabilities TEXT[], -- array of capabilities like 'messaging', 'goal_tracking', 'workout_planning', etc.
    base_prompt TEXT NOT NULL, -- The base system prompt for the agent
    model TEXT NOT NULL, -- GPT-4, Claude 3, etc.
    avatar_url TEXT,
    voice_id TEXT, -- For voice interactions
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 36. user_ai_agents (New table to link users with their AI agents)
CREATE TABLE user_ai_agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    custom_name TEXT, -- User can rename their agent
    custom_prompt TEXT, -- Additional personalized prompt
    is_primary BOOLEAN NOT NULL DEFAULT FALSE, -- Is this the user's primary agent
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_interaction_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_agent UNIQUE (user_id, agent_id)
);

-- 37. agent_goals (New table to track goals assigned to AI agents)
CREATE TABLE agent_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    goal_id UUID REFERENCES goals(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 1, -- 1 (highest) to 5 (lowest)
    status TEXT NOT NULL DEFAULT 'active', -- active, completed, abandoned
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    target_date DATE,
    completion_date DATE,
    progress NUMERIC DEFAULT 0, -- percentage complete
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_priority_range CHECK (priority >= 1 AND priority <= 5),
    CONSTRAINT check_progress_range CHECK (progress >= 0 AND progress <= 100)
);

-- 38. agent_commands (New table to track commands issued by AI agents)
CREATE TABLE agent_commands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    command_type TEXT NOT NULL, -- message, notification, api_call, workout_plan, etc.
    command_data JSONB NOT NULL, -- Command details
    status TEXT NOT NULL DEFAULT 'pending', -- pending, executed, failed
    result JSONB, -- Result of the command
    error_message TEXT,
    executed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 39. agent_messages (New table for messages sent by AI agents)
CREATE TABLE agent_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    group_id UUID REFERENCES message_groups(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type TEXT NOT NULL DEFAULT 'text', -- text, suggestion, reminder, etc.
    context JSONB, -- Context that triggered this message
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 40. agent_schedules (New table for scheduled agent activities)
CREATE TABLE agent_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    schedule_type TEXT NOT NULL, -- daily_check_in, workout_reminder, meal_planning, etc.
    frequency TEXT NOT NULL, -- daily, weekly, monthly, custom
    custom_schedule JSONB, -- For custom schedules
    next_execution TIMESTAMPTZ NOT NULL,
    last_execution TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 41. agent_feedback (New table for user feedback on agent interactions)
CREATE TABLE agent_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES ai_agents(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    interaction_id UUID, -- Could reference a message, command, etc.
    interaction_type TEXT NOT NULL, -- message, command, suggestion, etc.
    rating INTEGER NOT NULL, -- 1-5 star rating
    feedback TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_rating_range CHECK (rating >= 1 AND rating <= 5)
);

-- 42. notifications (New table for push notifications)
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB, -- Additional data for the notification
    type TEXT NOT NULL, -- workout, meal, goal, message, etc.
    priority TEXT NOT NULL DEFAULT 'normal', -- high, normal, low
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    action_taken BOOLEAN NOT NULL DEFAULT FALSE,
    action_taken_at TIMESTAMPTZ,
    created_by TEXT NOT NULL, -- system, agent, user
    agent_id UUID REFERENCES ai_agents(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 43. notification_devices (New table for user devices to receive notifications)
CREATE TABLE notification_devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    device_token TEXT NOT NULL,
    device_type TEXT NOT NULL, -- ios, android, web
    device_name TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_device_token UNIQUE (device_token)
);

-- 44. emails (New table for email communications)
CREATE TABLE emails (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    html_body TEXT,
    recipient_email TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- pending, sent, delivered, opened, clicked, failed
    type TEXT NOT NULL, -- welcome, password_reset, notification, newsletter, etc.
    sent_at TIMESTAMPTZ,
    opened_at TIMESTAMPTZ,
    clicked_at TIMESTAMPTZ,
    template_id TEXT, -- Reference to email template if used
    template_data JSONB, -- Data used to populate the template
    created_by TEXT NOT NULL, -- system, agent, user
    agent_id UUID REFERENCES ai_agents(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 45. email_templates (New table for email templates)
CREATE TABLE email_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    html_body TEXT,
    type TEXT NOT NULL, -- welcome, password_reset, notification, newsletter, etc.
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_template_name UNIQUE (name)
);

-- 46. api_integrations (New table for external API integrations)
CREATE TABLE api_integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    provider TEXT NOT NULL, -- google, apple, fitbit, strava, etc.
    description TEXT,
    api_key_encrypted TEXT,
    api_secret_encrypted TEXT,
    config JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_integration_name UNIQUE (name)
);

-- 47. user_api_integrations (New table to link users with API integrations)
CREATE TABLE user_api_integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    integration_id UUID NOT NULL REFERENCES api_integrations(id),
    access_token_encrypted TEXT,
    refresh_token_encrypted TEXT,
    token_expires_at TIMESTAMPTZ,
    scopes TEXT[],
    user_identifier TEXT, -- User ID in the external system
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_synced_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_integration UNIQUE (user_id, integration_id)
);

-- 48. api_logs (New table to log API calls)
CREATE TABLE api_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    integration_id UUID REFERENCES api_integrations(id),
    user_id UUID REFERENCES auth.users(id),
    agent_id UUID REFERENCES ai_agents(id),
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL, -- GET, POST, PUT, DELETE, etc.
    request_headers JSONB,
    request_body JSONB,
    response_status INTEGER,
    response_headers JSONB,
    response_body JSONB,
    error_message TEXT,
    duration_ms INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 49. webhooks (New table for webhook configurations)
CREATE TABLE webhooks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    events TEXT[] NOT NULL, -- Array of events to trigger this webhook
    secret_key_encrypted TEXT,
    headers JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_webhook_name UNIQUE (name)
);

-- 50. webhook_logs (New table to log webhook calls)
CREATE TABLE webhook_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    webhook_id UUID NOT NULL REFERENCES webhooks(id) ON DELETE CASCADE,
    event TEXT NOT NULL,
    payload JSONB NOT NULL,
    response_status INTEGER,
    response_body TEXT,
    error_message TEXT,
    duration_ms INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create additional indexes for the new tables
CREATE INDEX idx_ai_agents_agent_type ON ai_agents(agent_type);
CREATE INDEX idx_user_ai_agents_user_id ON user_ai_agents(user_id);
CREATE INDEX idx_user_ai_agents_agent_id ON user_ai_agents(agent_id);
CREATE INDEX idx_agent_goals_user_id ON agent_goals(user_id);
CREATE INDEX idx_agent_goals_agent_id ON agent_goals(agent_id);
CREATE INDEX idx_agent_goals_goal_id ON agent_goals(goal_id);
CREATE INDEX idx_agent_commands_user_id ON agent_commands(user_id);
CREATE INDEX idx_agent_commands_agent_id ON agent_commands(agent_id);
CREATE INDEX idx_agent_commands_command_type ON agent_commands(command_type);
CREATE INDEX idx_agent_messages_user_id ON agent_messages(user_id);
CREATE INDEX idx_agent_messages_agent_id ON agent_messages(agent_id);
CREATE INDEX idx_agent_messages_group_id ON agent_messages(group_id);
CREATE INDEX idx_agent_schedules_user_id ON agent_schedules(user_id);
CREATE INDEX idx_agent_schedules_agent_id ON agent_schedules(agent_id);
CREATE INDEX idx_agent_schedules_next_execution ON agent_schedules(next_execution);
CREATE INDEX idx_agent_feedback_user_id ON agent_feedback(user_id);
CREATE INDEX idx_agent_feedback_agent_id ON agent_feedback(agent_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX idx_notification_devices_user_id ON notification_devices(user_id);
CREATE INDEX idx_emails_user_id ON emails(user_id);
CREATE INDEX idx_emails_status ON emails(status);
CREATE INDEX idx_emails_type ON emails(type);
CREATE INDEX idx_emails_sent_at ON emails(sent_at);
CREATE INDEX idx_email_templates_type ON email_templates(type);
CREATE INDEX idx_api_integrations_provider ON api_integrations(provider);
CREATE INDEX idx_user_api_integrations_user_id ON user_api_integrations(user_id);
CREATE INDEX idx_user_api_integrations_integration_id ON user_api_integrations(integration_id);
CREATE INDEX idx_api_logs_user_id ON api_logs(user_id);
CREATE INDEX idx_api_logs_integration_id ON api_logs(integration_id);
CREATE INDEX idx_api_logs_agent_id ON api_logs(agent_id);
CREATE INDEX idx_api_logs_created_at ON api_logs(created_at);
CREATE INDEX idx_webhooks_events ON webhooks USING GIN(events);
CREATE INDEX idx_webhook_logs_webhook_id ON webhook_logs(webhook_id);
CREATE INDEX idx_webhook_logs_created_at ON webhook_logs(created_at);

-- Add RLS policies for the new tables
ALTER TABLE ai_agents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins can manage AI agents" ON ai_agents USING (auth.uid() IN (SELECT user_id FROM user_preferences WHERE is_admin = TRUE));

ALTER TABLE user_ai_agents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own AI agents" ON user_ai_agents FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own AI agents" ON user_ai_agents FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own AI agents" ON user_ai_agents FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own AI agents" ON user_ai_agents FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE agent_goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own agent goals" ON agent_goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own agent goals" ON agent_goals FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own agent goals" ON agent_goals FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own agent goals" ON agent_goals FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE agent_commands ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own agent commands" ON agent_commands FOR SELECT USING (auth.uid() = user_id);

ALTER TABLE agent_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own agent messages" ON agent_messages FOR SELECT USING (auth.uid() = user_id);

ALTER TABLE agent_schedules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own agent schedules" ON agent_schedules FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own agent schedules" ON agent_schedules FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own agent schedules" ON agent_schedules FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own agent schedules" ON agent_schedules FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE agent_feedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own agent feedback" ON agent_feedback FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own agent feedback" ON agent_feedback FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own agent feedback" ON agent_feedback FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own agent feedback" ON agent_feedback FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

ALTER TABLE notification_devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own notification devices" ON notification_devices FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own notification devices" ON notification_devices FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own notification devices" ON notification_devices FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own notification devices" ON notification_devices FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE emails ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own emails" ON emails FOR SELECT USING (auth.uid() = user_id);

ALTER TABLE user_api_integrations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own API integrations" ON user_api_integrations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own API integrations" ON user_api_integrations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own API integrations" ON user_api_integrations FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own API integrations" ON user_api_integrations FOR DELETE USING (auth.uid() = user_id);

-- Create functions for AI agent operations
CREATE OR REPLACE FUNCTION get_agent_context(p_agent_id UUID, p_user_id UUID)
RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    -- Get user profile data
    WITH user_data AS (
        SELECT 
            u.id,
            u.email,
            up.theme,
            up.language,
            up.measurement_system,
            us.weight,
            us.height,
            us.body_fat_percentage,
            us.bmi
        FROM 
            auth.users u
        LEFT JOIN 
            user_preferences up ON u.id = up.user_id
        LEFT JOIN 
            user_stats us ON u.id = us.user_id
        WHERE 
            u.id = p_user_id
        ORDER BY 
            us.date DESC
        LIMIT 1
    ),
    -- Get user goals
    goals_data AS (
        SELECT 
            jsonb_agg(
                jsonb_build_object(
                    'id', g.id,
                    'goal_type', g.goal_type,
                    'description', g.notes,
                    'target_date', g.target_date,
                    'progress', g.progress,
                    'status', g.status
                )
            ) AS goals
        FROM 
            goals g
        WHERE 
            g.user_id = p_user_id AND g.status = 'active'
    ),
    -- Get recent workouts
    workouts_data AS (
        SELECT 
            jsonb_agg(
                jsonb_build_object(
                    'id', w.id,
                    'workout_name', w.workout_name,
                    'workout_type', w.workout_type,
                    'date', w.date,
                    'duration', w.length,
                    'calories_burned', w.calories_burned
                )
            ) AS recent_workouts
        FROM 
            workout_log w
        WHERE 
            w.user_id = p_user_id
        ORDER BY 
            w.date DESC
        LIMIT 5
    ),
    -- Get recent meals
    meals_data AS (
        SELECT 
            jsonb_agg(
                jsonb_build_object(
                    'id', c.id,
                    'food_name', c.food_name,
                    'calories', c.calories,
                    'meal_type', c.meal_type,
                    'date', c.date
                )
            ) AS recent_meals
        FROM 
            calories_log c
        WHERE 
            c.user_id = p_user_id
        ORDER BY 
            c.date DESC, c.time DESC
        LIMIT 10
    ),
    -- Get active fasts
    fasts_data AS (
        SELECT 
            jsonb_agg(
                jsonb_build_object(
                    'id', f.id,
                    'start_time', f.start_time,
                    'duration', f.duration,
                    'fast_type', f.fast_type,
                    'status', f.status
                )
            ) AS active_fasts
        FROM 
            fasts_log f
        WHERE 
            f.user_id = p_user_id AND f.status = 'active'
    ),
    -- Get agent configuration
    agent_data AS (
        SELECT 
            a.id,
            a.name,
            a.agent_type,
            a.capabilities,
            a.base_prompt,
            uaa.custom_name,
            uaa.custom_prompt
        FROM 
            ai_agents a
        JOIN 
            user_ai_agents uaa ON a.id = uaa.agent_id
        WHERE 
            a.id = p_agent_id AND uaa.user_id = p_user_id
    )
    -- Combine all data into a single context object
    SELECT 
        jsonb_build_object(
            'user', jsonb_build_object(
                'id', ud.id,
                'email', ud.email,
                'preferences', jsonb_build_object(
                    'theme', ud.theme,
                    'language', ud.language,
                    'measurement_system', ud.measurement_system
                ),
                'stats', jsonb_build_object(
                    'weight', ud.weight,
                    'height', ud.height,
                    'body_fat_percentage', ud.body_fat_percentage,
                    'bmi', ud.bmi
                )
            ),
            'goals', COALESCE(gd.goals, '[]'::jsonb),
            'recent_workouts', COALESCE(wd.recent_workouts, '[]'::jsonb),
            'recent_meals', COALESCE(md.recent_meals, '[]'::jsonb),
            'active_fasts', COALESCE(fd.active_fasts, '[]'::jsonb),
            'agent', jsonb_build_object(
                'id', ad.id,
                'name', COALESCE(ad.custom_name, ad.name),
                'agent_type', ad.agent_type,
                'capabilities', ad.capabilities,
                'base_prompt', ad.base_prompt,
                'custom_prompt', ad.custom_prompt
            )
        ) INTO result
    FROM 
        user_data ud,
        goals_data gd,
        workouts_data wd,
        meals_data md,
        fasts_data fd,
        agent_data ad;
        
    RETURN result;
END;
$$ LANGUAGE plpgsql;

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