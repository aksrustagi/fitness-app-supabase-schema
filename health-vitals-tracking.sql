-- Health Vitals and Tracking Tables for Fitness App Database
-- This script adds tables for comprehensive health metrics tracking

-- 51. sleep_log (Track detailed sleep metrics)
CREATE TABLE sleep_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    sleep_start TIMESTAMPTZ NOT NULL,
    sleep_end TIMESTAMPTZ NOT NULL,
    duration INTERVAL GENERATED ALWAYS AS (sleep_end - sleep_start) STORED,
    deep_sleep_duration INTERVAL,
    rem_sleep_duration INTERVAL,
    light_sleep_duration INTERVAL,
    awake_duration INTERVAL,
    sleep_quality_score INTEGER, -- 1-100 score
    sleep_debt_minutes INTEGER, -- Minutes of sleep debt
    sleep_surplus_minutes INTEGER, -- Minutes of sleep surplus
    sleep_goal_minutes INTEGER, -- Target sleep duration
    sleep_efficiency NUMERIC, -- Percentage of time in bed actually sleeping
    sleep_latency INTERVAL, -- Time to fall asleep
    wakeups INTEGER, -- Number of times woken up
    heart_rate_avg INTEGER, -- Average heart rate during sleep
    heart_rate_min INTEGER, -- Minimum heart rate during sleep
    heart_rate_max INTEGER, -- Maximum heart rate during sleep
    respiratory_rate NUMERIC, -- Breaths per minute
    oxygen_saturation NUMERIC, -- Blood oxygen percentage
    snoring_episodes INTEGER, -- Number of snoring episodes
    sleep_notes TEXT,
    sleep_tags TEXT[],
    environment_temperature NUMERIC, -- Room temperature
    environment_humidity NUMERIC, -- Room humidity
    environment_noise_level NUMERIC, -- Ambient noise level
    environment_light_level NUMERIC, -- Ambient light level
    caffeine_consumption BOOLEAN, -- Caffeine consumed before sleep
    alcohol_consumption BOOLEAN, -- Alcohol consumed before sleep
    exercise_before_sleep BOOLEAN, -- Exercise performed before sleep
    screen_time_before_sleep INTERVAL, -- Screen time before sleep
    stress_level_before_sleep INTEGER, -- 1-10 stress level
    data_source TEXT, -- apple_health, fitbit, manual, etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_sleep_end_after_start CHECK (sleep_end > sleep_start),
    CONSTRAINT check_sleep_quality_score_range CHECK (sleep_quality_score IS NULL OR (sleep_quality_score >= 1 AND sleep_quality_score <= 100)),
    CONSTRAINT check_stress_level_range CHECK (stress_level_before_sleep IS NULL OR (stress_level_before_sleep >= 1 AND stress_level_before_sleep <= 10)),
    CONSTRAINT unique_user_sleep_date UNIQUE (user_id, date)
);

-- 52. vital_signs (Track heart rate, blood pressure, etc.)
CREATE TABLE vital_signs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    heart_rate INTEGER, -- BPM
    heart_rate_variability NUMERIC, -- ms
    blood_pressure_systolic INTEGER, -- mmHg
    blood_pressure_diastolic INTEGER, -- mmHg
    respiratory_rate NUMERIC, -- Breaths per minute
    oxygen_saturation NUMERIC, -- SpO2 percentage
    body_temperature NUMERIC, -- Celsius
    blood_glucose NUMERIC, -- mg/dL
    measurement_context TEXT, -- resting, post-exercise, fasting, etc.
    measurement_position TEXT, -- sitting, standing, lying down
    data_source TEXT, -- apple_health, medical_device, manual, etc.
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_heart_rate_positive CHECK (heart_rate IS NULL OR heart_rate > 0),
    CONSTRAINT check_blood_pressure_systolic_positive CHECK (blood_pressure_systolic IS NULL OR blood_pressure_systolic > 0),
    CONSTRAINT check_blood_pressure_diastolic_positive CHECK (blood_pressure_diastolic IS NULL OR blood_pressure_diastolic > 0),
    CONSTRAINT check_oxygen_saturation_range CHECK (oxygen_saturation IS NULL OR (oxygen_saturation >= 0 AND oxygen_saturation <= 100))
);

-- 53. hormone_levels (Track hormone levels)
CREATE TABLE hormone_levels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    testosterone NUMERIC, -- ng/dL
    cortisol NUMERIC, -- μg/dL
    estrogen NUMERIC, -- pg/mL
    progesterone NUMERIC, -- ng/mL
    thyroid_tsh NUMERIC, -- mIU/L
    thyroid_t3 NUMERIC, -- ng/dL
    thyroid_t4 NUMERIC, -- μg/dL
    insulin NUMERIC, -- μIU/mL
    growth_hormone NUMERIC, -- ng/mL
    dhea NUMERIC, -- μg/dL
    melatonin NUMERIC, -- pg/mL
    leptin NUMERIC, -- ng/mL
    ghrelin NUMERIC, -- pg/mL
    measurement_method TEXT, -- blood_test, saliva_test, estimated, etc.
    fasting_status BOOLEAN, -- Whether user was fasting during measurement
    measurement_context TEXT, -- morning, evening, post-exercise, etc.
    data_source TEXT, -- lab_results, wearable_device, ai_estimated, etc.
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 54. nutrient_levels (Track vitamins, minerals, etc.)
CREATE TABLE nutrient_levels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    vitamin_a NUMERIC, -- μg/dL
    vitamin_b1 NUMERIC, -- nmol/L
    vitamin_b2 NUMERIC, -- μg/L
    vitamin_b3 NUMERIC, -- μmol/L
    vitamin_b5 NUMERIC, -- mg/L
    vitamin_b6 NUMERIC, -- nmol/L
    vitamin_b7 NUMERIC, -- ng/L
    vitamin_b9 NUMERIC, -- ng/mL
    vitamin_b12 NUMERIC, -- pg/mL
    vitamin_c NUMERIC, -- mg/dL
    vitamin_d NUMERIC, -- ng/mL
    vitamin_e NUMERIC, -- mg/L
    vitamin_k NUMERIC, -- ng/mL
    calcium NUMERIC, -- mg/dL
    iron NUMERIC, -- μg/dL
    magnesium NUMERIC, -- mg/dL
    zinc NUMERIC, -- μg/dL
    potassium NUMERIC, -- mmol/L
    sodium NUMERIC, -- mmol/L
    selenium NUMERIC, -- μg/L
    iodine NUMERIC, -- μg/L
    copper NUMERIC, -- μg/dL
    manganese NUMERIC, -- μg/L
    chromium NUMERIC, -- μg/L
    molybdenum NUMERIC, -- μg/L
    omega_3 NUMERIC, -- %
    omega_6 NUMERIC, -- %
    measurement_method TEXT, -- blood_test, hair_analysis, estimated, etc.
    deficiency_risk JSONB, -- Assessment of deficiency risks
    supplement_recommendations JSONB, -- Recommended supplements
    data_source TEXT, -- lab_results, ai_estimated, etc.
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 55. body_measurements (Track detailed body measurements)
CREATE TABLE body_measurements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    weight NUMERIC, -- kg
    height NUMERIC, -- cm
    bmi NUMERIC GENERATED ALWAYS AS (CASE WHEN height > 0 THEN weight / ((height/100) * (height/100)) ELSE NULL END) STORED,
    body_fat_percentage NUMERIC, -- %
    muscle_mass NUMERIC, -- kg
    bone_mass NUMERIC, -- kg
    water_percentage NUMERIC, -- %
    visceral_fat NUMERIC, -- level
    waist_circumference NUMERIC, -- cm
    hip_circumference NUMERIC, -- cm
    chest_circumference NUMERIC, -- cm
    neck_circumference NUMERIC, -- cm
    bicep_circumference NUMERIC, -- cm
    forearm_circumference NUMERIC, -- cm
    thigh_circumference NUMERIC, -- cm
    calf_circumference NUMERIC, -- cm
    shoulder_width NUMERIC, -- cm
    waist_to_hip_ratio NUMERIC GENERATED ALWAYS AS (CASE WHEN hip_circumference > 0 THEN waist_circumference / hip_circumference ELSE NULL END) STORED,
    body_shape TEXT, -- ectomorph, mesomorph, endomorph
    measurement_method TEXT, -- scale, tape_measure, dexa_scan, etc.
    data_source TEXT, -- smart_scale, manual, etc.
    photos JSONB, -- URLs to progress photos (front, side, back)
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_weight_positive CHECK (weight IS NULL OR weight > 0),
    CONSTRAINT check_height_positive CHECK (height IS NULL OR height > 0),
    CONSTRAINT check_body_fat_percentage_range CHECK (body_fat_percentage IS NULL OR (body_fat_percentage >= 0 AND body_fat_percentage <= 100)),
    CONSTRAINT check_water_percentage_range CHECK (water_percentage IS NULL OR (water_percentage >= 0 AND water_percentage <= 100)),
    CONSTRAINT unique_user_measurement_date UNIQUE (user_id, date)
);

-- 56. activity_metrics (Track daily activity metrics)
CREATE TABLE activity_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    steps INTEGER,
    distance NUMERIC, -- km
    floors_climbed INTEGER,
    active_calories NUMERIC, -- kcal
    total_calories NUMERIC, -- kcal
    active_minutes INTERVAL,
    sedentary_minutes INTERVAL,
    standing_minutes INTERVAL,
    exercise_minutes INTERVAL,
    active_hours JSONB, -- Hourly breakdown of activity
    heart_rate_zones JSONB, -- Time spent in different heart rate zones
    vo2_max NUMERIC, -- mL/(kg·min)
    recovery_score INTEGER, -- 1-100 score
    readiness_score INTEGER, -- 1-100 score
    strain_score INTEGER, -- 1-100 score
    activity_score INTEGER, -- 1-100 score
    data_source TEXT, -- apple_health, fitbit, garmin, etc.
    weather_conditions JSONB, -- Weather data for outdoor activities
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_steps_positive CHECK (steps IS NULL OR steps >= 0),
    CONSTRAINT check_distance_positive CHECK (distance IS NULL OR distance >= 0),
    CONSTRAINT check_recovery_score_range CHECK (recovery_score IS NULL OR (recovery_score >= 1 AND recovery_score <= 100)),
    CONSTRAINT check_readiness_score_range CHECK (readiness_score IS NULL OR (readiness_score >= 1 AND readiness_score <= 100)),
    CONSTRAINT check_strain_score_range CHECK (strain_score IS NULL OR (strain_score >= 1 AND strain_score <= 100)),
    CONSTRAINT check_activity_score_range CHECK (activity_score IS NULL OR (activity_score >= 1 AND activity_score <= 100)),
    CONSTRAINT unique_user_activity_date UNIQUE (user_id, date)
);

-- 57. health_assessments (Track health assessments and predictions)
CREATE TABLE health_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    metabolic_age INTEGER, -- Estimated metabolic age in years
    fitness_age INTEGER, -- Estimated fitness age in years
    life_expectancy NUMERIC, -- Estimated life expectancy in years
    health_score INTEGER, -- 1-100 overall health score
    fitness_score INTEGER, -- 1-100 fitness score
    nutrition_score INTEGER, -- 1-100 nutrition score
    sleep_score INTEGER, -- 1-100 sleep score
    stress_score INTEGER, -- 1-100 stress score (lower is better)
    energy_score INTEGER, -- 1-100 energy score
    immune_system_score INTEGER, -- 1-100 immune system score
    cardiovascular_health_score INTEGER, -- 1-100 cardiovascular health score
    metabolic_health_score INTEGER, -- 1-100 metabolic health score
    longevity_factors JSONB, -- Factors affecting longevity
    health_risks JSONB, -- Identified health risks
    improvement_recommendations JSONB, -- Recommended improvements
    assessment_method TEXT, -- ai_analysis, medical_professional, etc.
    confidence_score NUMERIC, -- Confidence in the assessment (0-100%)
    data_sources TEXT[], -- Sources used for the assessment
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_health_score_range CHECK (health_score IS NULL OR (health_score >= 1 AND health_score <= 100)),
    CONSTRAINT check_fitness_score_range CHECK (fitness_score IS NULL OR (fitness_score >= 1 AND fitness_score <= 100)),
    CONSTRAINT check_nutrition_score_range CHECK (nutrition_score IS NULL OR (nutrition_score >= 1 AND nutrition_score <= 100)),
    CONSTRAINT check_sleep_score_range CHECK (sleep_score IS NULL OR (sleep_score >= 1 AND sleep_score <= 100)),
    CONSTRAINT check_stress_score_range CHECK (stress_score IS NULL OR (stress_score >= 1 AND stress_score <= 100)),
    CONSTRAINT check_energy_score_range CHECK (energy_score IS NULL OR (energy_score >= 1 AND energy_score <= 100)),
    CONSTRAINT check_immune_system_score_range CHECK (immune_system_score IS NULL OR (immune_system_score >= 1 AND immune_system_score <= 100)),
    CONSTRAINT check_cardiovascular_health_score_range CHECK (cardiovascular_health_score IS NULL OR (cardiovascular_health_score >= 1 AND cardiovascular_health_score <= 100)),
    CONSTRAINT check_metabolic_health_score_range CHECK (metabolic_health_score IS NULL OR (metabolic_health_score >= 1 AND metabolic_health_score <= 100)),
    CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 0 AND confidence_score <= 100)),
    CONSTRAINT unique_user_assessment_date UNIQUE (user_id, date)
);

-- 58. mood_tracking (Track mood, energy, stress, etc.)
CREATE TABLE mood_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    mood TEXT NOT NULL, -- happy, sad, anxious, energetic, etc.
    mood_score INTEGER, -- 1-10 score
    energy_level INTEGER, -- 1-10 score
    stress_level INTEGER, -- 1-10 score
    anxiety_level INTEGER, -- 1-10 score
    focus_level INTEGER, -- 1-10 score
    motivation_level INTEGER, -- 1-10 score
    happiness_level INTEGER, -- 1-10 score
    social_connection_level INTEGER, -- 1-10 score
    productivity_level INTEGER, -- 1-10 score
    confidence_level INTEGER, -- 1-10 score
    attractiveness_level INTEGER, -- 1-10 score (self-perceived)
    libido_level INTEGER, -- 1-10 score
    factors JSONB, -- Factors affecting mood (sleep, exercise, nutrition, etc.)
    activities TEXT[], -- Activities performed
    symptoms TEXT[], -- Physical or mental symptoms
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_mood_score_range CHECK (mood_score IS NULL OR (mood_score >= 1 AND mood_score <= 10)),
    CONSTRAINT check_energy_level_range CHECK (energy_level IS NULL OR (energy_level >= 1 AND energy_level <= 10)),
    CONSTRAINT check_stress_level_range CHECK (stress_level IS NULL OR (stress_level >= 1 AND stress_level <= 10)),
    CONSTRAINT check_anxiety_level_range CHECK (anxiety_level IS NULL OR (anxiety_level >= 1 AND anxiety_level <= 10)),
    CONSTRAINT check_focus_level_range CHECK (focus_level IS NULL OR (focus_level >= 1 AND focus_level <= 10)),
    CONSTRAINT check_motivation_level_range CHECK (motivation_level IS NULL OR (motivation_level >= 1 AND motivation_level <= 10)),
    CONSTRAINT check_happiness_level_range CHECK (happiness_level IS NULL OR (happiness_level >= 1 AND happiness_level <= 10)),
    CONSTRAINT check_social_connection_level_range CHECK (social_connection_level IS NULL OR (social_connection_level >= 1 AND social_connection_level <= 10)),
    CONSTRAINT check_productivity_level_range CHECK (productivity_level IS NULL OR (productivity_level >= 1 AND productivity_level <= 10)),
    CONSTRAINT check_confidence_level_range CHECK (confidence_level IS NULL OR (confidence_level >= 1 AND confidence_level <= 10)),
    CONSTRAINT check_attractiveness_level_range CHECK (attractiveness_level IS NULL OR (attractiveness_level >= 1 AND attractiveness_level <= 10)),
    CONSTRAINT check_libido_level_range CHECK (libido_level IS NULL OR (libido_level >= 1 AND libido_level <= 10))
);

-- 59. health_goals_progress (Track progress toward health goals)
CREATE TABLE health_goals_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    goal_id UUID NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    current_value NUMERIC NOT NULL, -- Current value (weight, body fat, etc.)
    target_value NUMERIC NOT NULL, -- Target value
    progress_percentage NUMERIC GENERATED ALWAYS AS (
        CASE 
            WHEN current_value = target_value THEN 100
            WHEN (target_value > current_value AND current_value >= 0) THEN 
                LEAST(100, (current_value / target_value) * 100)
            WHEN (target_value < current_value AND target_value > 0) THEN
                LEAST(100, (2 - (current_value / target_value)) * 100)
            ELSE 0
        END
    ) STORED,
    time_remaining INTERVAL, -- Estimated time to reach goal
    confidence_score INTEGER, -- 1-100 confidence in achieving goal
    blockers TEXT[], -- Factors blocking progress
    enablers TEXT[], -- Factors enabling progress
    adjustment_needed BOOLEAN, -- Whether goal adjustment is needed
    adjustment_recommendation TEXT, -- Recommended adjustment
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 1 AND confidence_score <= 100)),
    CONSTRAINT unique_user_goal_date UNIQUE (user_id, goal_id, date)
);

-- 60. health_insights (AI-generated insights from health data)
CREATE TABLE health_insights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    insight_type TEXT NOT NULL, -- correlation, trend, anomaly, recommendation, etc.
    insight_category TEXT NOT NULL, -- sleep, nutrition, fitness, mood, etc.
    title TEXT NOT NULL, -- Brief title of the insight
    description TEXT NOT NULL, -- Detailed description
    data_points JSONB, -- Data points used for the insight
    confidence_score INTEGER, -- 1-100 confidence in the insight
    actionable_steps JSONB, -- Recommended actions
    impact_score INTEGER, -- 1-100 potential impact if acted upon
    user_feedback TEXT, -- User feedback on the insight
    user_rating INTEGER, -- 1-5 user rating of the insight
    dismissed BOOLEAN NOT NULL DEFAULT FALSE, -- Whether user dismissed the insight
    acted_upon BOOLEAN NOT NULL DEFAULT FALSE, -- Whether user acted on the insight
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 1 AND confidence_score <= 100)),
    CONSTRAINT check_impact_score_range CHECK (impact_score IS NULL OR (impact_score >= 1 AND impact_score <= 100)),
    CONSTRAINT check_user_rating_range CHECK (user_rating IS NULL OR (user_rating >= 1 AND user_rating <= 5))
);

-- 61. health_chat_sessions (Track health assessment chat sessions)
CREATE TABLE health_chat_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    agent_id UUID REFERENCES ai_agents(id),
    session_start TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    session_end TIMESTAMPTZ,
    duration INTERVAL GENERATED ALWAYS AS (session_end - session_start) STORED,
    session_type TEXT NOT NULL, -- daily_check_in, health_assessment, mood_check, etc.
    transcript JSONB, -- Full conversation transcript
    health_score_before INTEGER, -- 1-100 score before session
    health_score_after INTEGER, -- 1-100 score after session
    mood_before TEXT,
    mood_after TEXT,
    energy_before INTEGER, -- 1-10 score
    energy_after INTEGER, -- 1-10 score
    confidence_before INTEGER, -- 1-10 score
    confidence_after INTEGER, -- 1-10 score
    key_topics TEXT[], -- Main topics discussed
    action_items JSONB, -- Action items identified
    follow_up_scheduled BOOLEAN NOT NULL DEFAULT FALSE,
    follow_up_date DATE,
    user_feedback TEXT,
    user_rating INTEGER, -- 1-5 rating
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_health_score_before_range CHECK (health_score_before IS NULL OR (health_score_before >= 1 AND health_score_before <= 100)),
    CONSTRAINT check_health_score_after_range CHECK (health_score_after IS NULL OR (health_score_after >= 1 AND health_score_after <= 100)),
    CONSTRAINT check_energy_before_range CHECK (energy_before IS NULL OR (energy_before >= 1 AND energy_before <= 10)),
    CONSTRAINT check_energy_after_range CHECK (energy_after IS NULL OR (energy_after >= 1 AND energy_after <= 10)),
    CONSTRAINT check_confidence_before_range CHECK (confidence_before IS NULL OR (confidence_before >= 1 AND confidence_before <= 10)),
    CONSTRAINT check_confidence_after_range CHECK (confidence_after IS NULL OR (confidence_after >= 1 AND confidence_after <= 10)),
    CONSTRAINT check_user_rating_range CHECK (user_rating IS NULL OR (user_rating >= 1 AND user_rating <= 5))
);

-- 62. external_health_data (Track data imported from external sources)
CREATE TABLE external_health_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    source TEXT NOT NULL, -- apple_health, google_fit, fitbit, etc.
    data_type TEXT NOT NULL, -- steps, heart_rate, sleep, etc.
    date DATE NOT NULL,
    time TIMESTAMPTZ,
    value_numeric NUMERIC,
    value_text TEXT,
    value_json JSONB,
    unit TEXT,
    device_name TEXT,
    device_model TEXT,
    device_manufacturer TEXT,
    app_name TEXT,
    app_version TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_source_type_date_time UNIQUE (user_id, source, data_type, date, time)
);

-- 63. health_reports (Track generated health reports)
CREATE TABLE health_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    report_type TEXT NOT NULL, -- weekly_summary, monthly_analysis, health_assessment, etc.
    title TEXT NOT NULL,
    description TEXT,
    date_range_start DATE NOT NULL,
    date_range_end DATE NOT NULL,
    report_data JSONB NOT NULL, -- Full report data
    insights JSONB, -- Key insights
    recommendations JSONB, -- Recommendations
    metrics_summary JSONB, -- Summary of key metrics
    report_url TEXT, -- URL to PDF/HTML report
    shared_with UUID[], -- Users the report was shared with
    shared_with_doctor BOOLEAN NOT NULL DEFAULT FALSE,
    user_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_date_range CHECK (date_range_end >= date_range_start)
);

-- 64. attractiveness_metrics (Track factors affecting attractiveness)
CREATE TABLE attractiveness_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    physical_attractiveness_score INTEGER, -- 1-100 self-assessed score
    confidence_score INTEGER, -- 1-100 confidence level
    posture_score INTEGER, -- 1-100 posture quality
    skin_quality_score INTEGER, -- 1-100 skin quality
    hair_quality_score INTEGER, -- 1-100 hair quality
    dental_health_score INTEGER, -- 1-100 dental health
    body_composition_score INTEGER, -- 1-100 body composition
    symmetry_score INTEGER, -- 1-100 facial/body symmetry
    grooming_score INTEGER, -- 1-100 grooming quality
    style_score INTEGER, -- 1-100 style/fashion sense
    charisma_score INTEGER, -- 1-100 charisma level
    social_skills_score INTEGER, -- 1-100 social skills
    humor_score INTEGER, -- 1-100 sense of humor
    intelligence_score INTEGER, -- 1-100 perceived intelligence
    emotional_intelligence_score INTEGER, -- 1-100 emotional intelligence
    financial_stability_score INTEGER, -- 1-100 financial stability
    ambition_score INTEGER, -- 1-100 ambition level
    kindness_score INTEGER, -- 1-100 kindness level
    factors_affecting JSONB, -- Factors affecting scores
    improvement_areas TEXT[], -- Areas identified for improvement
    improvement_actions JSONB, -- Actions taken to improve
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_physical_attractiveness_score_range CHECK (physical_attractiveness_score IS NULL OR (physical_attractiveness_score >= 1 AND physical_attractiveness_score <= 100)),
    CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 1 AND confidence_score <= 100)),
    CONSTRAINT check_posture_score_range CHECK (posture_score IS NULL OR (posture_score >= 1 AND posture_score <= 100)),
    CONSTRAINT check_skin_quality_score_range CHECK (skin_quality_score IS NULL OR (skin_quality_score >= 1 AND skin_quality_score <= 100)),
    CONSTRAINT check_hair_quality_score_range CHECK (hair_quality_score IS NULL OR (hair_quality_score >= 1 AND hair_quality_score <= 100)),
    CONSTRAINT check_dental_health_score_range CHECK (dental_health_score IS NULL OR (dental_health_score >= 1 AND dental_health_score <= 100)),
    CONSTRAINT check_body_composition_score_range CHECK (body_composition_score IS NULL OR (body_composition_score >= 1 AND body_composition_score <= 100)),
    CONSTRAINT check_symmetry_score_range CHECK (symmetry_score IS NULL OR (symmetry_score >= 1 AND symmetry_score <= 100)),
    CONSTRAINT check_grooming_score_range CHECK (grooming_score IS NULL OR (grooming_score >= 1 AND grooming_score <= 100)),
    CONSTRAINT check_style_score_range CHECK (style_score IS NULL OR (style_score >= 1 AND style_score <= 100)),
    CONSTRAINT check_charisma_score_range CHECK (charisma_score IS NULL OR (charisma_score >= 1 AND charisma_score <= 100)),
    CONSTRAINT check_social_skills_score_range CHECK (social_skills_score IS NULL OR (social_skills_score >= 1 AND social_skills_score <= 100)),
    CONSTRAINT check_humor_score_range CHECK (humor_score IS NULL OR (humor_score >= 1 AND humor_score <= 100)),
    CONSTRAINT check_intelligence_score_range CHECK (intelligence_score IS NULL OR (intelligence_score >= 1 AND intelligence_score <= 100)),
    CONSTRAINT check_emotional_intelligence_score_range CHECK (emotional_intelligence_score IS NULL OR (emotional_intelligence_score >= 1 AND emotional_intelligence_score <= 100)),
    CONSTRAINT check_financial_stability_score_range CHECK (financial_stability_score IS NULL OR (financial_stability_score >= 1 AND financial_stability_score <= 100)),
    CONSTRAINT check_ambition_score_range CHECK (ambition_score IS NULL OR (ambition_score >= 1 AND ambition_score <= 100)),
    CONSTRAINT check_kindness_score_range CHECK (kindness_score IS NULL OR (kindness_score >= 1 AND kindness_score <= 100)),
    CONSTRAINT unique_user_attractiveness_date UNIQUE (user_id, date)
);

-- 65. health_correlations (Track correlations between health metrics)
CREATE TABLE health_correlations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    metric_1 TEXT NOT NULL, -- First metric (e.g., sleep_quality)
    metric_2 TEXT NOT NULL, -- Second metric (e.g., mood)
    correlation_coefficient NUMERIC, -- -1 to 1
    confidence_score INTEGER, -- 1-100 confidence in correlation
    causation_likelihood INTEGER, -- 1-100 likelihood of causation
    correlation_direction TEXT, -- positive, negative
    correlation_strength TEXT, -- strong, moderate, weak
    time_lag INTERVAL, -- Time lag between metrics
    sample_size INTEGER, -- Number of data points
    p_value NUMERIC, -- Statistical significance
    insight TEXT, -- Human-readable insight
    recommendation TEXT, -- Recommendation based on correlation
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT check_correlation_coefficient_range CHECK (correlation_coefficient IS NULL OR (correlation_coefficient >= -1 AND correlation_coefficient <= 1)),
    CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 1 AND confidence_score <= 100)),
    CONSTRAINT check_causation_likelihood_range CHECK (causation_likelihood IS NULL OR (causation_likelihood >= 1 AND causation_likelihood <= 100)),
    CONSTRAINT unique_user_metrics_date UNIQUE (user_id, metric_1, metric_2, date)
);

-- 66. apple_health_sync (Track Apple Health data sync status)
CREATE TABLE apple_health_sync (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    last_sync_at TIMESTAMPTZ,
    sync_status TEXT NOT NULL DEFAULT 'never_synced', -- never_synced, in_progress, completed, failed
    data_types_synced TEXT[], -- Array of data types synced
    records_synced INTEGER,
    sync_start_date DATE,
    sync_end_date DATE,
    error_message TEXT,
    device_info JSONB, -- Information about the device
    app_version TEXT,
    permissions_granted JSONB, -- Permissions granted by user
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_apple_health UNIQUE (user_id)
);

-- Create indexes for the new tables
CREATE INDEX idx_sleep_log_user_id ON sleep_log(user_id);
CREATE INDEX idx_sleep_log_date ON sleep_log(date);
CREATE INDEX idx_sleep_log_sleep_quality_score ON sleep_log(sleep_quality_score);
CREATE INDEX idx_vital_signs_user_id ON vital_signs(user_id);
CREATE INDEX idx_vital_signs_date ON vital_signs(date);
CREATE INDEX idx_vital_signs_heart_rate ON vital_signs(heart_rate);
CREATE INDEX idx_hormone_levels_user_id ON hormone_levels(user_id);
CREATE INDEX idx_hormone_levels_date ON hormone_levels(date);
CREATE INDEX idx_nutrient_levels_user_id ON nutrient_levels(user_id);
CREATE INDEX idx_nutrient_levels_date ON nutrient_levels(date);
CREATE INDEX idx_nutrient_levels_vitamin_d ON nutrient_levels(vitamin_d);
CREATE INDEX idx_body_measurements_user_id ON body_measurements(user_id);
CREATE INDEX idx_body_measurements_date ON body_measurements(date);
CREATE INDEX idx_body_measurements_weight ON body_measurements(weight);
CREATE INDEX idx_activity_metrics_user_id ON activity_metrics(user_id);
CREATE INDEX idx_activity_metrics_date ON activity_metrics(date);
CREATE INDEX idx_activity_metrics_steps ON activity_metrics(steps);
CREATE INDEX idx_health_assessments_user_id ON health_assessments(user_id);
CREATE INDEX idx_health_assessments_date ON health_assessments(date);
CREATE INDEX idx_health_assessments_health_score ON health_assessments(health_score);
CREATE INDEX idx_mood_tracking_user_id ON mood_tracking(user_id);
CREATE INDEX idx_mood_tracking_date ON mood_tracking(date);
CREATE INDEX idx_mood_tracking_mood ON mood_tracking(mood);
CREATE INDEX idx_health_goals_progress_user_id ON health_goals_progress(user_id);
CREATE INDEX idx_health_goals_progress_goal_id ON health_goals_progress(goal_id);
CREATE INDEX idx_health_goals_progress_date ON health_goals_progress(date);
CREATE INDEX idx_health_insights_user_id ON health_insights(user_id);
CREATE INDEX idx_health_insights_date ON health_insights(date);
CREATE INDEX idx_health_insights_insight_type ON health_insights(insight_type);
CREATE INDEX idx_health_insights_insight_category ON health_insights(insight_category);
CREATE INDEX idx_health_chat_sessions_user_id ON health_chat_sessions(user_id);
CREATE INDEX idx_health_chat_sessions_session_start ON health_chat_sessions(session_start);
CREATE INDEX idx_health_chat_sessions_session_type ON health_chat_sessions(session_type);
CREATE INDEX idx_external_health_data_user_id ON external_health_data(user_id);
CREATE INDEX idx_external_health_data_source ON external_health_data(source);
CREATE INDEX idx_external_health_data_data_type ON external_health_data(data_type);
CREATE INDEX idx_external_health_data_date ON external_health_data(date);
CREATE INDEX idx_health_reports_user_id ON health_reports(user_id);
CREATE INDEX idx_health_reports_report_type ON health_reports(report_type);
CREATE INDEX idx_health_reports_date_range_start ON health_reports(date_range_start);
CREATE INDEX idx_health_reports_date_range_end ON health_reports(date_range_end);
CREATE INDEX idx_attractiveness_metrics_user_id ON attractiveness_metrics(user_id);
CREATE INDEX idx_attractiveness_metrics_date ON attractiveness_metrics(date);
CREATE INDEX idx_attractiveness_metrics_confidence_score ON attractiveness_metrics(confidence_score);
CREATE INDEX idx_health_correlations_user_id ON health_correlations(user_id);
CREATE INDEX idx_health_correlations_date ON health_correlations(date);
CREATE INDEX idx_health_correlations_metric_1 ON health_correlations(metric_1);
CREATE INDEX idx_health_correlations_metric_2 ON health_correlations(metric_2);
CREATE INDEX idx_apple_health_sync_user_id ON apple_health_sync(user_id);
CREATE INDEX idx_apple_health_sync_sync_status ON apple_health_sync(sync_status);

-- Add RLS policies for the new tables
ALTER TABLE sleep_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own sleep logs" ON sleep_log FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own sleep logs" ON sleep_log FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own sleep logs" ON sleep_log FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own sleep logs" ON sleep_log FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE vital_signs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own vital signs" ON vital_signs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own vital signs" ON vital_signs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own vital signs" ON vital_signs FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own vital signs" ON vital_signs FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE hormone_levels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own hormone levels" ON hormone_levels FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own hormone levels" ON hormone_levels FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own hormone levels" ON hormone_levels FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own hormone levels" ON hormone_levels FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE nutrient_levels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own nutrient levels" ON nutrient_levels FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own nutrient levels" ON nutrient_levels FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own nutrient levels" ON nutrient_levels FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own nutrient levels" ON nutrient_levels FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE body_measurements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own body measurements" ON body_measurements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own body measurements" ON body_measurements FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own body measurements" ON body_measurements FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own body measurements" ON body_measurements FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE activity_metrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own activity metrics" ON activity_metrics FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own activity metrics" ON activity_metrics FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own activity metrics" ON activity_metrics FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own activity metrics" ON activity_metrics FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_assessments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health assessments" ON health_assessments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health assessments" ON health_assessments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health assessments" ON health_assessments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health assessments" ON health_assessments FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE mood_tracking ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own mood tracking" ON mood_tracking FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own mood tracking" ON mood_tracking FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own mood tracking" ON mood_tracking FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own mood tracking" ON mood_tracking FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_goals_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health goals progress" ON health_goals_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health goals progress" ON health_goals_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health goals progress" ON health_goals_progress FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health goals progress" ON health_goals_progress FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_insights ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health insights" ON health_insights FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health insights" ON health_insights FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health insights" ON health_insights FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health insights" ON health_insights FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_chat_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health chat sessions" ON health_chat_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health chat sessions" ON health_chat_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health chat sessions" ON health_chat_sessions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health chat sessions" ON health_chat_sessions FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE external_health_data ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own external health data" ON external_health_data FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own external health data" ON external_health_data FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own external health data" ON external_health_data FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own external health data" ON external_health_data FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health reports" ON health_reports FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health reports" ON health_reports FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health reports" ON health_reports FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health reports" ON health_reports FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE attractiveness_metrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own attractiveness metrics" ON attractiveness_metrics FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own attractiveness metrics" ON attractiveness_metrics FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own attractiveness metrics" ON attractiveness_metrics FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own attractiveness metrics" ON attractiveness_metrics FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE health_correlations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own health correlations" ON health_correlations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own health correlations" ON health_correlations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own health correlations" ON health_correlations FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own health correlations" ON health_correlations FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE apple_health_sync ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own Apple Health sync" ON apple_health_sync FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own Apple Health sync" ON apple_health_sync FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own Apple Health sync" ON apple_health_sync FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own Apple Health sync" ON apple_health_sync FOR DELETE USING (auth.uid() = user_id);

-- Create views for health analytics
CREATE VIEW user_health_summary AS
SELECT 
    u.id AS user_id,
    d.date,
    s.sleep_quality_score,
    s.sleep_duration,
    v.heart_rate,
    v.blood_pressure_systolic,
    v.blood_pressure_diastolic,
    h.testosterone,
    h.cortisol,
    n.vitamin_d,
    n.iron,
    b.weight,
    b.body_fat_percentage,
    a.steps,
    a.active_minutes,
    ha.health_score,
    ha.life_expectancy,
    m.mood,
    m.energy_level,
    m.stress_level,
    m.confidence_level,
    att.confidence_score AS attractiveness_confidence
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
        sleep_quality_score,
        EXTRACT(EPOCH FROM duration)/3600 AS sleep_duration
    FROM sleep_log
) s ON u.id = s.user_id AND d.date = s.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        AVG(heart_rate) AS heart_rate,
        AVG(blood_pressure_systolic) AS blood_pressure_systolic,
        AVG(blood_pressure_diastolic) AS blood_pressure_diastolic
    FROM vital_signs
    GROUP BY user_id, date
) v ON u.id = v.user_id AND d.date = v.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        AVG(testosterone) AS testosterone,
        AVG(cortisol) AS cortisol
    FROM hormone_levels
    GROUP BY user_id, date
) h ON u.id = h.user_id AND d.date = h.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        AVG(vitamin_d) AS vitamin_d,
        AVG(iron) AS iron
    FROM nutrient_levels
    GROUP BY user_id, date
) n ON u.id = n.user_id AND d.date = n.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        weight,
        body_fat_percentage
    FROM body_measurements
) b ON u.id = b.user_id AND d.date = b.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        steps,
        EXTRACT(EPOCH FROM active_minutes)/60 AS active_minutes
    FROM activity_metrics
) a ON u.id = a.user_id AND d.date = a.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        health_score,
        life_expectancy
    FROM health_assessments
) ha ON u.id = ha.user_id AND d.date = ha.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        mode() WITHIN GROUP (ORDER BY mood) AS mood,
        AVG(energy_level) AS energy_level,
        AVG(stress_level) AS stress_level,
        AVG(confidence_level) AS confidence_level
    FROM mood_tracking
    GROUP BY user_id, date
) m ON u.id = m.user_id AND d.date = m.date
LEFT JOIN (
    SELECT 
        user_id, 
        date, 
        confidence_score
    FROM attractiveness_metrics
) att ON u.id = att.user_id AND d.date = att.date;

-- Create functions for health analytics
CREATE OR REPLACE FUNCTION calculate_health_score(
    p_sleep_quality INTEGER,
    p_activity_level INTEGER,
    p_nutrition_quality INTEGER,
    p_stress_level INTEGER,
    p_mood_score INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    sleep_weight NUMERIC := 0.25;
    activity_weight NUMERIC := 0.25;
    nutrition_weight NUMERIC := 0.25;
    stress_weight NUMERIC := 0.15;
    mood_weight NUMERIC := 0.10;
    health_score INTEGER;
BEGIN
    -- Normalize stress level (lower is better, so invert)
    p_stress_level := CASE WHEN p_stress_level IS NOT NULL THEN 11 - p_stress_level ELSE NULL END;
    
    -- Calculate weighted score
    health_score := ROUND(
        (COALESCE(p_sleep_quality, 50) * sleep_weight +
         COALESCE(p_activity_level, 50) * activity_weight +
         COALESCE(p_nutrition_quality, 50) * nutrition_weight +
         COALESCE(p_stress_level, 50) * stress_weight +
         COALESCE(p_mood_score, 50) * mood_weight)::NUMERIC
    );
    
    -- Ensure score is within range
    RETURN GREATEST(1, LEAST(100, health_score));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION estimate_life_expectancy(
    p_age INTEGER,
    p_gender TEXT,
    p_bmi NUMERIC,
    p_activity_level INTEGER,
    p_sleep_quality INTEGER,
    p_nutrition_quality INTEGER,
    p_smoking BOOLEAN,
    p_alcohol_consumption TEXT,
    p_chronic_conditions TEXT[]
)
RETURNS NUMERIC AS $$
DECLARE
    base_expectancy NUMERIC;
    bmi_factor NUMERIC := 0;
    activity_factor NUMERIC := 0;
    sleep_factor NUMERIC := 0;
    nutrition_factor NUMERIC := 0;
    smoking_factor NUMERIC := 0;
    alcohol_factor NUMERIC := 0;
    conditions_factor NUMERIC := 0;
    final_expectancy NUMERIC;
BEGIN
    -- Base life expectancy by gender (simplified)
    IF p_gender = 'male' THEN
        base_expectancy := 76.1;
    ELSIF p_gender = 'female' THEN
        base_expectancy := 81.1;
    ELSE
        base_expectancy := 78.6; -- Average
    END IF;
    
    -- BMI adjustment
    IF p_bmi IS NOT NULL THEN
        IF p_bmi < 18.5 THEN
            bmi_factor := -2.0; -- Underweight
        ELSIF p_bmi >= 18.5 AND p_bmi < 25 THEN
            bmi_factor := 2.0; -- Normal weight
        ELSIF p_bmi >= 25 AND p_bmi < 30 THEN
            bmi_factor := -1.0; -- Overweight
        ELSIF p_bmi >= 30 AND p_bmi < 35 THEN
            bmi_factor := -3.0; -- Obese Class I
        ELSIF p_bmi >= 35 THEN
            bmi_factor := -5.0; -- Obese Class II+
        END IF;
    END IF;
    
    -- Activity level adjustment
    IF p_activity_level IS NOT NULL THEN
        activity_factor := (p_activity_level - 50) / 10.0;
    END IF;
    
    -- Sleep quality adjustment
    IF p_sleep_quality IS NOT NULL THEN
        sleep_factor := (p_sleep_quality - 50) / 20.0;
    END IF;
    
    -- Nutrition quality adjustment
    IF p_nutrition_quality IS NOT NULL THEN
        nutrition_factor := (p_nutrition_quality - 50) / 20.0;
    END IF;
    
    -- Smoking adjustment
    IF p_smoking = TRUE THEN
        smoking_factor := -10.0;
    END IF;
    
    -- Alcohol consumption adjustment
    IF p_alcohol_consumption IS NOT NULL THEN
        IF p_alcohol_consumption = 'none' THEN
            alcohol_factor := 0.0;
        ELSIF p_alcohol_consumption = 'light' THEN
            alcohol_factor := -0.5;
        ELSIF p_alcohol_consumption = 'moderate' THEN
            alcohol_factor := -2.0;
        ELSIF p_alcohol_consumption = 'heavy' THEN
            alcohol_factor := -5.0;
        END IF;
    END IF;
    
    -- Chronic conditions adjustment
    IF p_chronic_conditions IS NOT NULL THEN
        conditions_factor := -2.0 * array_length(p_chronic_conditions, 1);
    END IF;
    
    -- Calculate final life expectancy
    final_expectancy := base_expectancy + bmi_factor + activity_factor + sleep_factor + 
                        nutrition_factor + smoking_factor + alcohol_factor + conditions_factor;
    
    -- Ensure reasonable range
    RETURN GREATEST(p_age + 1, ROUND(final_expectancy::NUMERIC, 1));
END;
$$ LANGUAGE plpgsql;