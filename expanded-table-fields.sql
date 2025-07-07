-- Expanded Table Fields for Fitness App Database
-- This script adds additional fields to existing tables to provide more comprehensive data collection

-- User-Related Tables

-- user_stats
ALTER TABLE user_stats ADD COLUMN metabolic_rate NUMERIC; -- Basal metabolic rate (BMR) in calories
ALTER TABLE user_stats ADD COLUMN activity_level TEXT; -- Sedentary, lightly active, moderately active, very active, etc.
ALTER TABLE user_stats ADD COLUMN body_composition_history JSONB; -- Store historical body composition data
ALTER TABLE user_stats ADD COLUMN genetic_factors JSONB; -- Store genetic information relevant to fitness (if available)
ALTER TABLE user_stats ADD COLUMN medical_conditions TEXT[]; -- Array of medical conditions to consider
ALTER TABLE user_stats ADD COLUMN allergies TEXT[]; -- Food or environmental allergies
ALTER TABLE user_stats ADD COLUMN injuries JSONB; -- Track current and past injuries
ALTER TABLE user_stats ADD COLUMN sleep_quality INTEGER; -- Sleep quality score (1-10)
ALTER TABLE user_stats ADD COLUMN recovery_score INTEGER; -- Daily recovery score based on various metrics
ALTER TABLE user_stats ADD CONSTRAINT check_sleep_quality_range CHECK (sleep_quality IS NULL OR (sleep_quality >= 1 AND sleep_quality <= 10));
ALTER TABLE user_stats ADD CONSTRAINT check_recovery_score_range CHECK (recovery_score IS NULL OR (recovery_score >= 1 AND recovery_score <= 10));

-- goals
ALTER TABLE goals ADD COLUMN goal_category TEXT; -- Weight loss, muscle gain, endurance, etc.
ALTER TABLE goals ADD COLUMN sub_goals JSONB; -- Array of smaller milestone goals
ALTER TABLE goals ADD COLUMN motivation TEXT; -- User's motivation for this goal
ALTER TABLE goals ADD COLUMN accountability_partner_id UUID REFERENCES auth.users(id); -- Reference to another user for accountability
ALTER TABLE goals ADD COLUMN reward TEXT; -- User's planned reward for achieving the goal
ALTER TABLE goals ADD COLUMN difficulty_rating INTEGER; -- AI-assessed difficulty (1-10)
ALTER TABLE goals ADD COLUMN success_probability NUMERIC; -- AI-calculated probability of success
ALTER TABLE goals ADD COLUMN recommended_protocols UUID[]; -- Array of protocol IDs recommended for this goal
ALTER TABLE goals ADD COLUMN goal_image_url TEXT; -- Visual representation of the goal
ALTER TABLE goals ADD CONSTRAINT check_difficulty_rating_range CHECK (difficulty_rating IS NULL OR (difficulty_rating >= 1 AND difficulty_rating <= 10));
ALTER TABLE goals ADD CONSTRAINT check_success_probability_range CHECK (success_probability IS NULL OR (success_probability >= 0 AND success_probability <= 100));

-- Nutrition Tables

-- calories_log
ALTER TABLE calories_log ADD COLUMN glycemic_index INTEGER; -- GI of the food
ALTER TABLE calories_log ADD COLUMN glycemic_load INTEGER; -- GL of the food
ALTER TABLE calories_log ADD COLUMN water_content NUMERIC; -- Water content in grams
ALTER TABLE calories_log ADD COLUMN fiber NUMERIC; -- Fiber content in grams
ALTER TABLE calories_log ADD COLUMN sugar NUMERIC; -- Sugar content in grams
ALTER TABLE calories_log ADD COLUMN saturated_fat NUMERIC; -- Saturated fat in grams
ALTER TABLE calories_log ADD COLUMN unsaturated_fat NUMERIC; -- Unsaturated fat in grams
ALTER TABLE calories_log ADD COLUMN trans_fat NUMERIC; -- Trans fat in grams
ALTER TABLE calories_log ADD COLUMN cholesterol NUMERIC; -- Cholesterol in mg
ALTER TABLE calories_log ADD COLUMN sodium NUMERIC; -- Sodium in mg
ALTER TABLE calories_log ADD COLUMN potassium NUMERIC; -- Potassium in mg
ALTER TABLE calories_log ADD COLUMN vitamins JSONB; -- Detailed vitamin content
ALTER TABLE calories_log ADD COLUMN minerals JSONB; -- Detailed mineral content
ALTER TABLE calories_log ADD COLUMN food_category TEXT; -- Vegetable, fruit, grain, protein, dairy, etc.
ALTER TABLE calories_log ADD COLUMN processing_level TEXT; -- Whole food, minimally processed, highly processed
ALTER TABLE calories_log ADD COLUMN organic BOOLEAN; -- Whether the food is organic
ALTER TABLE calories_log ADD COLUMN brand TEXT; -- Food brand if applicable
ALTER TABLE calories_log ADD COLUMN barcode TEXT; -- Product barcode if applicable
ALTER TABLE calories_log ADD COLUMN restaurant TEXT; -- Restaurant name if applicable
ALTER TABLE calories_log ADD COLUMN recipe_id UUID; -- Reference to a recipe if homemade
ALTER TABLE calories_log ADD COLUMN hunger_level_before INTEGER; -- Hunger level before eating (1-10)
ALTER TABLE calories_log ADD COLUMN fullness_after INTEGER; -- Fullness after eating (1-10)
ALTER TABLE calories_log ADD COLUMN emotional_state TEXT; -- Emotional state during eating
ALTER TABLE calories_log ADD COLUMN location TEXT; -- Where the meal was consumed
ALTER TABLE calories_log ADD CONSTRAINT check_hunger_level_range CHECK (hunger_level_before IS NULL OR (hunger_level_before >= 1 AND hunger_level_before <= 10));
ALTER TABLE calories_log ADD CONSTRAINT check_fullness_range CHECK (fullness_after IS NULL OR (fullness_after >= 1 AND fullness_after <= 10));

-- food_searches
ALTER TABLE food_searches ADD COLUMN confidence_score NUMERIC; -- AI confidence in food identification
ALTER TABLE food_searches ADD COLUMN alternative_identifications JSONB; -- Other possible food matches
ALTER TABLE food_searches ADD COLUMN nutritional_analysis_method TEXT; -- How nutrition was calculated (database, AI estimation, etc.)
ALTER TABLE food_searches ADD COLUMN image_quality TEXT; -- Quality assessment of the uploaded image
ALTER TABLE food_searches ADD COLUMN processing_time_ms INTEGER; -- Time taken to analyze the image
ALTER TABLE food_searches ADD COLUMN user_feedback TEXT; -- User feedback on the accuracy
ALTER TABLE food_searches ADD COLUMN correction_history JSONB; -- History of corrections made
ALTER TABLE food_searches ADD CONSTRAINT check_confidence_score_range CHECK (confidence_score IS NULL OR (confidence_score >= 0 AND confidence_score <= 100));

-- fasts_log
ALTER TABLE fasts_log ADD COLUMN fast_goal_hours INTEGER; -- Target fasting duration
ALTER TABLE fasts_log ADD COLUMN hunger_levels JSONB; -- Tracked hunger levels during fast
ALTER TABLE fasts_log ADD COLUMN energy_levels JSONB; -- Tracked energy levels during fast
ALTER TABLE fasts_log ADD COLUMN mood_tracking JSONB; -- Mood changes during fast
ALTER TABLE fasts_log ADD COLUMN ketone_levels JSONB; -- Ketone measurements if available
ALTER TABLE fasts_log ADD COLUMN glucose_levels JSONB; -- Glucose measurements if available
ALTER TABLE fasts_log ADD COLUMN symptoms TEXT[]; -- Array of symptoms experienced
ALTER TABLE fasts_log ADD COLUMN break_reason TEXT; -- Reason for breaking the fast
ALTER TABLE fasts_log ADD COLUMN break_food TEXT; -- First food consumed after fast
ALTER TABLE fasts_log ADD COLUMN difficulty_rating INTEGER; -- User-rated difficulty (1-10)
ALTER TABLE fasts_log ADD COLUMN fast_streak INTEGER; -- Current streak of successful fasts
ALTER TABLE fasts_log ADD COLUMN previous_fast_id UUID REFERENCES fasts_log(id); -- Link to previous fast for continuity
ALTER TABLE fasts_log ADD CONSTRAINT check_difficulty_rating_range CHECK (difficulty_rating IS NULL OR (difficulty_rating >= 1 AND difficulty_rating <= 10));
ALTER TABLE fasts_log ADD CONSTRAINT check_fast_goal_hours_positive CHECK (fast_goal_hours IS NULL OR fast_goal_hours > 0);

-- Workout Tables

-- workout_log
ALTER TABLE workout_log ADD COLUMN perceived_exertion INTEGER; -- Rate of perceived exertion (1-10)
ALTER TABLE workout_log ADD COLUMN energy_level INTEGER; -- Energy level during workout (1-10)
ALTER TABLE workout_log ADD COLUMN workout_quality INTEGER; -- Overall quality rating (1-10)
ALTER TABLE workout_log ADD COLUMN heart_rate_zones JSONB; -- Time spent in different heart rate zones
ALTER TABLE workout_log ADD COLUMN average_heart_rate INTEGER; -- Average heart rate during workout
ALTER TABLE workout_log ADD COLUMN max_heart_rate INTEGER; -- Maximum heart rate during workout
ALTER TABLE workout_log ADD COLUMN recovery_time_needed INTERVAL; -- AI-recommended recovery time
ALTER TABLE workout_log ADD COLUMN workout_plan_id UUID; -- Reference to a workout plan if following one
ALTER TABLE workout_log ADD COLUMN weather_conditions JSONB; -- Weather during outdoor workouts
ALTER TABLE workout_log ADD COLUMN music_playlist TEXT; -- Music listened to during workout
ALTER TABLE workout_log ADD COLUMN workout_partners UUID[]; -- Other users who worked out together
ALTER TABLE workout_log ADD COLUMN gym_location TEXT; -- Where the workout took place
ALTER TABLE workout_log ADD COLUMN equipment_used TEXT[]; -- Array of equipment used
ALTER TABLE workout_log ADD COLUMN soreness_rating INTEGER; -- Post-workout soreness (1-10)
ALTER TABLE workout_log ADD COLUMN workout_screenshot_url TEXT; -- Screenshot from fitness tracker
ALTER TABLE workout_log ADD COLUMN video_url TEXT; -- Workout video recording if available
ALTER TABLE workout_log ADD CONSTRAINT check_perceived_exertion_range CHECK (perceived_exertion IS NULL OR (perceived_exertion >= 1 AND perceived_exertion <= 10));
ALTER TABLE workout_log ADD CONSTRAINT check_energy_level_range CHECK (energy_level IS NULL OR (energy_level >= 1 AND energy_level <= 10));
ALTER TABLE workout_log ADD CONSTRAINT check_workout_quality_range CHECK (workout_quality IS NULL OR (workout_quality >= 1 AND workout_quality <= 10));
ALTER TABLE workout_log ADD CONSTRAINT check_soreness_rating_range CHECK (soreness_rating IS NULL OR (soreness_rating >= 1 AND soreness_rating <= 10));

-- exercises
ALTER TABLE exercises ADD COLUMN exercise_variations JSONB; -- Different variations of the exercise
ALTER TABLE exercises ADD COLUMN progression_path TEXT[]; -- Progression/regression options
ALTER TABLE exercises ADD COLUMN common_mistakes TEXT[]; -- Common form mistakes to avoid
ALTER TABLE exercises ADD COLUMN target_heart_rate JSONB; -- Target heart rate ranges
ALTER TABLE exercises ADD COLUMN exercise_history TEXT; -- Historical context of the exercise
ALTER TABLE exercises ADD COLUMN safety_considerations TEXT; -- Safety notes and precautions
ALTER TABLE exercises ADD COLUMN recommended_warmup TEXT; -- Recommended warmup for this exercise
ALTER TABLE exercises ADD COLUMN recommended_cooldown TEXT; -- Recommended cooldown after this exercise
ALTER TABLE exercises ADD COLUMN scientific_studies JSONB; -- References to scientific studies
ALTER TABLE exercises ADD COLUMN alternative_exercises UUID[]; -- Alternative exercises targeting same muscles
ALTER TABLE exercises ADD COLUMN exercise_demo_gif_url TEXT; -- Animated demonstration
ALTER TABLE exercises ADD COLUMN form_cues TEXT[]; -- Verbal cues for proper form

-- exercise_log
ALTER TABLE exercise_log ADD COLUMN form_quality INTEGER; -- Self-rated form quality (1-10)
ALTER TABLE exercise_log ADD COLUMN personal_record BOOLEAN; -- Whether this was a personal record
ALTER TABLE exercise_log ADD COLUMN failure_reached BOOLEAN; -- Whether muscle failure was reached
ALTER TABLE exercise_log ADD COLUMN tempo TEXT; -- Lifting tempo (e.g., "3-1-3" for eccentric-pause-concentric)
ALTER TABLE exercise_log ADD COLUMN rest_between_sets INTERVAL; -- Rest time between sets
ALTER TABLE exercise_log ADD COLUMN perceived_difficulty INTEGER; -- How difficult it felt (1-10)
ALTER TABLE exercise_log ADD COLUMN range_of_motion TEXT; -- Full, partial, or limited
ALTER TABLE exercise_log ADD COLUMN unilateral_balance JSONB; -- Track strength imbalances between sides
ALTER TABLE exercise_log ADD COLUMN exercise_variations TEXT; -- Specific variation used
ALTER TABLE exercise_log ADD COLUMN equipment_settings JSONB; -- Machine settings if applicable
ALTER TABLE exercise_log ADD COLUMN exercise_order INTEGER; -- Order in the workout
ALTER TABLE exercise_log ADD COLUMN superset_group_id UUID; -- For tracking supersets
ALTER TABLE exercise_log ADD COLUMN dropset BOOLEAN; -- Whether this was a dropset
ALTER TABLE exercise_log ADD COLUMN failure_reason TEXT; -- Reason if failed to complete planned sets/reps
ALTER TABLE exercise_log ADD CONSTRAINT check_form_quality_range CHECK (form_quality IS NULL OR (form_quality >= 1 AND form_quality <= 10));
ALTER TABLE exercise_log ADD CONSTRAINT check_perceived_difficulty_range CHECK (perceived_difficulty IS NULL OR (perceived_difficulty >= 1 AND perceived_difficulty <= 10));

-- AI Agent Tables

-- ai_agents
ALTER TABLE ai_agents ADD COLUMN personality_traits TEXT[]; -- Array of personality characteristics
ALTER TABLE ai_agents ADD COLUMN communication_style TEXT; -- Formal, casual, motivational, etc.
ALTER TABLE ai_agents ADD COLUMN expertise_areas TEXT[]; -- Specific areas of expertise
ALTER TABLE ai_agents ADD COLUMN knowledge_base_urls TEXT[]; -- References to knowledge sources
ALTER TABLE ai_agents ADD COLUMN response_templates JSONB; -- Templates for common responses
ALTER TABLE ai_agents ADD COLUMN fallback_behavior TEXT; -- How to handle unknown situations
ALTER TABLE ai_agents ADD COLUMN learning_parameters JSONB; -- How the agent learns from interactions
ALTER TABLE ai_agents ADD COLUMN version TEXT; -- Agent version for tracking updates
ALTER TABLE ai_agents ADD COLUMN creator_id UUID REFERENCES auth.users(id); -- Who created this agent
ALTER TABLE ai_agents ADD COLUMN training_data_sources TEXT[]; -- Sources of training data
ALTER TABLE ai_agents ADD COLUMN ethical_guidelines TEXT[]; -- Ethical constraints
ALTER TABLE ai_agents ADD COLUMN multilingual_support TEXT[]; -- Languages supported
ALTER TABLE ai_agents ADD COLUMN voice_characteristics JSONB; -- Voice parameters for speech

-- agent_commands
ALTER TABLE agent_commands ADD COLUMN execution_time_ms INTEGER; -- Time taken to execute command
ALTER TABLE agent_commands ADD COLUMN resource_usage JSONB; -- Computational resources used
ALTER TABLE agent_commands ADD COLUMN command_chain_id UUID; -- For tracking sequences of related commands
ALTER TABLE agent_commands ADD COLUMN parent_command_id UUID REFERENCES agent_commands(id); -- Reference to parent command if part of a sequence
ALTER TABLE agent_commands ADD COLUMN command_priority INTEGER; -- Priority level (1-5)
ALTER TABLE agent_commands ADD COLUMN retry_count INTEGER; -- Number of retry attempts
ALTER TABLE agent_commands ADD COLUMN execution_context JSONB; -- Context at time of execution
ALTER TABLE agent_commands ADD COLUMN user_confirmation BOOLEAN; -- Whether user confirmed the action
ALTER TABLE agent_commands ADD COLUMN rollback_status TEXT; -- Status of any rollback operations
ALTER TABLE agent_commands ADD COLUMN command_category TEXT; -- Category for analytics
ALTER TABLE agent_commands ADD COLUMN security_level TEXT; -- Required security clearance
ALTER TABLE agent_commands ADD COLUMN data_access_scope TEXT[]; -- What data was accessed
ALTER TABLE agent_commands ADD CONSTRAINT check_command_priority_range CHECK (command_priority IS NULL OR (command_priority >= 1 AND command_priority <= 5));

-- agent_messages
ALTER TABLE agent_messages ADD COLUMN sentiment TEXT; -- Emotional tone of the message
ALTER TABLE agent_messages ADD COLUMN intent TEXT; -- Purpose of the message (inform, motivate, remind, etc.)
ALTER TABLE agent_messages ADD COLUMN urgency_level INTEGER; -- How urgent the message is (1-5)
ALTER TABLE agent_messages ADD COLUMN personalization_factors JSONB; -- How the message was personalized
ALTER TABLE agent_messages ADD COLUMN message_template_id UUID; -- Reference to template if used
ALTER TABLE agent_messages ADD COLUMN engagement_score NUMERIC; -- Predicted user engagement
ALTER TABLE agent_messages ADD COLUMN optimal_delivery_time TIMESTAMPTZ; -- Best time to deliver
ALTER TABLE agent_messages ADD COLUMN a_b_test_group TEXT; -- For message effectiveness testing
ALTER TABLE agent_messages ADD COLUMN message_category TEXT; -- Category for analytics
ALTER TABLE agent_messages ADD COLUMN related_entity_id UUID; -- Related workout, meal, etc.
ALTER TABLE agent_messages ADD COLUMN related_entity_type TEXT; -- Type of related entity
ALTER TABLE agent_messages ADD COLUMN expected_response TEXT; -- Expected user response
ALTER TABLE agent_messages ADD COLUMN followup_message_id UUID REFERENCES agent_messages(id); -- Planned follow-up message
ALTER TABLE agent_messages ADD CONSTRAINT check_urgency_level_range CHECK (urgency_level IS NULL OR (urgency_level >= 1 AND urgency_level <= 5));
ALTER TABLE agent_messages ADD CONSTRAINT check_engagement_score_range CHECK (engagement_score IS NULL OR (engagement_score >= 0 AND engagement_score <= 100));

-- Notification & Communication Tables

-- notifications
ALTER TABLE notifications ADD COLUMN delivery_status TEXT; -- Sent, delivered, failed
ALTER TABLE notifications ADD COLUMN delivery_attempts INTEGER; -- Number of delivery attempts
ALTER TABLE notifications ADD COLUMN click_through_rate NUMERIC; -- If applicable
ALTER TABLE notifications ADD COLUMN conversion_action TEXT; -- What action the notification led to
ALTER TABLE notifications ADD COLUMN notification_group TEXT; -- For grouping related notifications
ALTER TABLE notifications ADD COLUMN expiration_time TIMESTAMPTZ; -- When notification expires
ALTER TABLE notifications ADD COLUMN smart_timing BOOLEAN; -- Whether AI optimized timing
ALTER TABLE notifications ADD COLUMN do_not_disturb_override BOOLEAN; -- Whether it overrides DND
ALTER TABLE notifications ADD COLUMN notification_channel TEXT; -- App, SMS, email, etc.
ALTER TABLE notifications ADD COLUMN notification_sound TEXT; -- Custom sound to use
ALTER TABLE notifications ADD COLUMN vibration_pattern TEXT; -- Custom vibration pattern
ALTER TABLE notifications ADD COLUMN color TEXT; -- Notification color
ALTER TABLE notifications ADD COLUMN icon TEXT; -- Custom icon
ALTER TABLE notifications ADD COLUMN deep_link TEXT; -- App deep link
ALTER TABLE notifications ADD COLUMN web_link TEXT; -- Web URL
ALTER TABLE notifications ADD COLUMN campaign_id UUID; -- Marketing campaign reference
ALTER TABLE notifications ADD CONSTRAINT check_click_through_rate_range CHECK (click_through_rate IS NULL OR (click_through_rate >= 0 AND click_through_rate <= 100));

-- emails
ALTER TABLE emails ADD COLUMN email_size INTEGER; -- Size in bytes
ALTER TABLE emails ADD COLUMN spam_score NUMERIC; -- Likelihood of being marked as spam
ALTER TABLE emails ADD COLUMN delivery_service TEXT; -- Service used to send email
ALTER TABLE emails ADD COLUMN bounce_reason TEXT; -- Reason if bounced
ALTER TABLE emails ADD COLUMN unsubscribe_reason TEXT; -- Reason if user unsubscribed
ALTER TABLE emails ADD COLUMN email_client TEXT; -- Client used to open email
ALTER TABLE emails ADD COLUMN device_type TEXT; -- Device used to open email
ALTER TABLE emails ADD COLUMN location TEXT; -- Geographic location when opened
ALTER TABLE emails ADD COLUMN link_clicks JSONB; -- Tracking of which links were clicked
ALTER TABLE emails ADD COLUMN read_time INTEGER; -- Seconds spent reading email
ALTER TABLE emails ADD COLUMN forwarded BOOLEAN; -- Whether email was forwarded
ALTER TABLE emails ADD COLUMN replied BOOLEAN; -- Whether user replied
ALTER TABLE emails ADD COLUMN a_b_test_variant TEXT; -- For email testing
ALTER TABLE emails ADD CONSTRAINT check_spam_score_range CHECK (spam_score IS NULL OR (spam_score >= 0 AND spam_score <= 10));

-- Integration Tables

-- api_integrations
ALTER TABLE api_integrations ADD COLUMN rate_limits JSONB; -- API rate limit information
ALTER TABLE api_integrations ADD COLUMN authentication_method TEXT; -- OAuth, API key, etc.
ALTER TABLE api_integrations ADD COLUMN required_scopes TEXT[]; -- Required permission scopes
ALTER TABLE api_integrations ADD COLUMN webhook_support BOOLEAN; -- Whether the API supports webhooks
ALTER TABLE api_integrations ADD COLUMN data_retention_policy TEXT; -- How long data is kept
ALTER TABLE api_integrations ADD COLUMN data_format TEXT; -- JSON, XML, etc.
ALTER TABLE api_integrations ADD COLUMN api_version TEXT; -- Version of the API
ALTER TABLE api_integrations ADD COLUMN documentation_url TEXT; -- Link to API docs
ALTER TABLE api_integrations ADD COLUMN support_contact TEXT; -- Contact for API support
ALTER TABLE api_integrations ADD COLUMN compliance_certifications TEXT[]; -- HIPAA, GDPR, etc.
ALTER TABLE api_integrations ADD COLUMN fallback_behavior TEXT; -- What to do if API is down
ALTER TABLE api_integrations ADD COLUMN sync_frequency TEXT; -- How often to sync data
ALTER TABLE api_integrations ADD COLUMN last_api_change TIMESTAMPTZ; -- When API last changed
ALTER TABLE api_integrations ADD COLUMN deprecation_date TIMESTAMPTZ; -- When API will be deprecated

-- user_api_integrations
ALTER TABLE user_api_integrations ADD COLUMN connection_status TEXT; -- Connected, disconnected, error
ALTER TABLE user_api_integrations ADD COLUMN error_history JSONB; -- History of connection errors
ALTER TABLE user_api_integrations ADD COLUMN data_sync_settings JSONB; -- User preferences for syncing
ALTER TABLE user_api_integrations ADD COLUMN last_error_message TEXT; -- Most recent error
ALTER TABLE user_api_integrations ADD COLUMN data_imported JSONB; -- Summary of imported data
ALTER TABLE user_api_integrations ADD COLUMN data_exported JSONB; -- Summary of exported data
ALTER TABLE user_api_integrations ADD COLUMN consent_status TEXT; -- User's data sharing consent
ALTER TABLE user_api_integrations ADD COLUMN consent_history JSONB; -- History of consent changes
ALTER TABLE user_api_integrations ADD COLUMN integration_notes TEXT; -- User notes about this integration
ALTER TABLE user_api_integrations ADD COLUMN setup_completed BOOLEAN; -- Whether setup is complete
ALTER TABLE user_api_integrations ADD COLUMN setup_step TEXT; -- Current setup step if incomplete
ALTER TABLE user_api_integrations ADD COLUMN custom_mapping JSONB; -- Custom field mappings

-- Create additional indexes for new fields that will be frequently queried
CREATE INDEX idx_user_stats_activity_level ON user_stats(activity_level);
CREATE INDEX idx_goals_goal_category ON goals(goal_category);
CREATE INDEX idx_calories_log_food_category ON calories_log(food_category);
CREATE INDEX idx_calories_log_brand ON calories_log(brand);
CREATE INDEX idx_calories_log_barcode ON calories_log(barcode);
CREATE INDEX idx_fasts_log_fast_streak ON fasts_log(fast_streak);
CREATE INDEX idx_workout_log_workout_quality ON workout_log(workout_quality);
CREATE INDEX idx_workout_log_gym_location ON workout_log(gym_location);
CREATE INDEX idx_exercise_log_personal_record ON exercise_log(personal_record);
CREATE INDEX idx_ai_agents_communication_style ON ai_agents(communication_style);
CREATE INDEX idx_ai_agents_version ON ai_agents(version);
CREATE INDEX idx_agent_commands_command_category ON agent_commands(command_category);
CREATE INDEX idx_agent_messages_intent ON agent_messages(intent);
CREATE INDEX idx_agent_messages_message_category ON agent_messages(message_category);
CREATE INDEX idx_notifications_delivery_status ON notifications(delivery_status);
CREATE INDEX idx_notifications_notification_channel ON notifications(notification_channel);
CREATE INDEX idx_emails_delivery_service ON emails(delivery_service);
CREATE INDEX idx_api_integrations_authentication_method ON api_integrations(authentication_method);
CREATE INDEX idx_user_api_integrations_connection_status ON user_api_integrations(connection_status);
CREATE INDEX idx_user_api_integrations_consent_status ON user_api_integrations(consent_status);