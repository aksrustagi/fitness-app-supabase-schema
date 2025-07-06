-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. fasts_log
CREATE TABLE fasts_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    fast_type TEXT,
    status TEXT NOT NULL DEFAULT 'active',
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. water_consumed
CREATE TABLE water_consumed (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    amount NUMERIC NOT NULL,
    type TEXT NOT NULL DEFAULT 'water',
    goal NUMERIC NOT NULL,
    left NUMERIC,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
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
    meal_type TEXT,
    serving_size TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
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
    source TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. workout_log
CREATE TABLE workout_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    workout_name TEXT NOT NULL,
    workout_type TEXT NOT NULL,
    calories_burned NUMERIC,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    length INTERVAL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    rating INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. exercises
CREATE TABLE exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    calories_burned NUMERIC,
    exercise_type TEXT NOT NULL,
    muscle_group TEXT,
    equipment TEXT,
    difficulty TEXT,
    instructions TEXT,
    video_url TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. exercise_log
CREATE TABLE exercise_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_log_id UUID NOT NULL REFERENCES workout_log(id),
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
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
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
    macros JSONB,
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
    category TEXT,
    image_url TEXT,
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
    category TEXT,
    instructor TEXT,
    audio_url TEXT NOT NULL,
    image_url TEXT,
    difficulty TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 11. challenges
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    challenge_type TEXT NOT NULL,
    difficulty TEXT,
    points INTEGER,
    image_url TEXT,
    created_by UUID REFERENCES auth.users(id),
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 12. challenge_exercise
CREATE TABLE challenge_exercise (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES challenges(id),
    exercise_id UUID NOT NULL REFERENCES exercises(id),
    sets INTEGER,
    reps INTEGER,
    duration INTERVAL,
    distance NUMERIC,
    points INTEGER,
    day_number INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 13. battles
CREATE TABLE battles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    battle_type TEXT NOT NULL,
    creator_id UUID NOT NULL REFERENCES auth.users(id),
    winner_id UUID REFERENCES auth.users(id),
    status TEXT NOT NULL DEFAULT 'pending',
    prize TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 14. battle_participants
CREATE TABLE battle_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    battle_id UUID NOT NULL REFERENCES battles(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    score NUMERIC DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'invited',
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 15. protocols
CREATE TABLE protocols (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL,
    difficulty TEXT,
    duration INTERVAL,
    image_url TEXT,
    created_by UUID REFERENCES auth.users(id),
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 16. protocol_steps
CREATE TABLE protocol_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    protocol_id UUID NOT NULL REFERENCES protocols(id),
    step_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    duration INTERVAL,
    image_url TEXT,
    video_url TEXT,
    exercise_id UUID REFERENCES exercises(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 17. helpers
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
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 18. help_session
CREATE TABLE help_session (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    helper_id UUID NOT NULL REFERENCES helpers(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL,
    status TEXT NOT NULL DEFAULT 'scheduled',
    topic TEXT NOT NULL,
    notes TEXT,
    user_rating INTEGER,
    user_feedback TEXT,
    cost NUMERIC,
    payment_status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 19. orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    total_amount NUMERIC NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    shipping_address JSONB,
    billing_address JSONB,
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending',
    tracking_number TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 20. order_items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id),
    product_id UUID NOT NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC NOT NULL,
    total_price NUMERIC NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 21. prescription_calls
CREATE TABLE prescription_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    doctor_id UUID,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL,
    status TEXT NOT NULL DEFAULT 'scheduled',
    notes TEXT,
    prescription_issued BOOLEAN NOT NULL DEFAULT FALSE,
    prescription_details JSONB,
    follow_up_required BOOLEAN NOT NULL DEFAULT FALSE,
    follow_up_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 22. message_groups
CREATE TABLE message_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    type TEXT NOT NULL,
    created_by UUID NOT NULL REFERENCES auth.users(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 23. message_group_members
CREATE TABLE message_group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES message_groups(id),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    role TEXT NOT NULL DEFAULT 'member',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_read_message_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 24. messages
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES message_groups(id),
    sender_id UUID NOT NULL REFERENCES auth.users(id),
    content TEXT NOT NULL,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    attachment_url TEXT,
    attachment_type TEXT,
    is_edited BOOLEAN NOT NULL DEFAULT FALSE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 25. vapi_calls
CREATE TABLE vapi_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    call_id TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration INTERVAL,
    status TEXT NOT NULL,
    call_type TEXT NOT NULL,
    phone_number TEXT,
    transcript TEXT,
    recording_url TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 26. heygen_sessions
CREATE TABLE heygen_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    session_id TEXT,
    video_url TEXT,
    thumbnail_url TEXT,
    script TEXT,
    avatar_id TEXT,
    duration INTERVAL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 27. ai_calls
CREATE TABLE ai_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    service TEXT NOT NULL,
    model TEXT NOT NULL,
    prompt TEXT NOT NULL,
    response TEXT,
    tokens_used INTEGER,
    cost NUMERIC,
    purpose TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 28. goals
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    goal_type TEXT NOT NULL,
    starting_weight NUMERIC,
    goal_weight NUMERIC,
    goal_physique_type_image_url TEXT,
    height NUMERIC,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    target_date DATE,
    status TEXT NOT NULL DEFAULT 'active',
    progress NUMERIC DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_fasts_log_user_id ON fasts_log(user_id);
CREATE INDEX idx_water_consumed_user_id ON water_consumed(user_id);
CREATE INDEX idx_calories_log_user_id ON calories_log(user_id);
CREATE INDEX idx_steps_log_user_id ON steps_log(user_id);
CREATE INDEX idx_workout_log_user_id ON workout_log(user_id);
CREATE INDEX idx_exercise_log_user_id ON exercise_log(user_id);
CREATE INDEX idx_exercise_log_workout_id ON exercise_log(workout_log_id);
CREATE INDEX idx_food_searches_user_id ON food_searches(user_id);
CREATE INDEX idx_battles_creator_id ON battles(creator_id);
CREATE INDEX idx_battle_participants_battle_id ON battle_participants(battle_id);
CREATE INDEX idx_battle_participants_user_id ON battle_participants(user_id);
CREATE INDEX idx_help_session_user_id ON help_session(user_id);
CREATE INDEX idx_help_session_helper_id ON help_session(helper_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_prescription_calls_user_id ON prescription_calls(user_id);
CREATE INDEX idx_message_groups_created_by ON message_groups(created_by);
CREATE INDEX idx_message_group_members_group_id ON message_group_members(group_id);
CREATE INDEX idx_message_group_members_user_id ON message_group_members(user_id);
CREATE INDEX idx_messages_group_id ON messages(group_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_vapi_calls_user_id ON vapi_calls(user_id);
CREATE INDEX idx_heygen_sessions_user_id ON heygen_sessions(user_id);
CREATE INDEX idx_ai_calls_user_id ON ai_calls(user_id);
CREATE INDEX idx_goals_user_id ON goals(user_id);

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