# Expanded Table Fields for Fitness App Database

This document outlines recommended field expansions for key tables in the fitness app database schema. These additional fields provide more comprehensive data collection, enhanced analytics capabilities, and support for advanced features.

## User-Related Tables

### user_stats
```sql
ALTER TABLE user_stats ADD COLUMN metabolic_rate NUMERIC; -- Basal metabolic rate (BMR) in calories
ALTER TABLE user_stats ADD COLUMN activity_level TEXT; -- Sedentary, lightly active, moderately active, very active, etc.
ALTER TABLE user_stats ADD COLUMN body_composition_history JSONB; -- Store historical body composition data
ALTER TABLE user_stats ADD COLUMN genetic_factors JSONB; -- Store genetic information relevant to fitness (if available)
ALTER TABLE user_stats ADD COLUMN medical_conditions TEXT[]; -- Array of medical conditions to consider
ALTER TABLE user_stats ADD COLUMN allergies TEXT[]; -- Food or environmental allergies
ALTER TABLE user_stats ADD COLUMN injuries JSONB; -- Track current and past injuries
ALTER TABLE user_stats ADD COLUMN sleep_quality INTEGER; -- Sleep quality score (1-10)
ALTER TABLE user_stats ADD COLUMN recovery_score INTEGER; -- Daily recovery score based on various metrics
```

### goals
```sql
ALTER TABLE goals ADD COLUMN goal_category TEXT; -- Weight loss, muscle gain, endurance, etc.
ALTER TABLE goals ADD COLUMN sub_goals JSONB; -- Array of smaller milestone goals
ALTER TABLE goals ADD COLUMN motivation TEXT; -- User's motivation for this goal
ALTER TABLE goals ADD COLUMN accountability_partner_id UUID REFERENCES auth.users(id); -- Reference to another user for accountability
ALTER TABLE goals ADD COLUMN reward TEXT; -- User's planned reward for achieving the goal
ALTER TABLE goals ADD COLUMN difficulty_rating INTEGER; -- AI-assessed difficulty (1-10)
ALTER TABLE goals ADD COLUMN success_probability NUMERIC; -- AI-calculated probability of success
ALTER TABLE goals ADD COLUMN recommended_protocols UUID[]; -- Array of protocol IDs recommended for this goal
ALTER TABLE goals ADD COLUMN goal_image_url TEXT; -- Visual representation of the goal
```

## Nutrition Tables

### calories_log
```sql
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
```

### food_searches
```sql
ALTER TABLE food_searches ADD COLUMN confidence_score NUMERIC; -- AI confidence in food identification
ALTER TABLE food_searches ADD COLUMN alternative_identifications JSONB; -- Other possible food matches
ALTER TABLE food_searches ADD COLUMN nutritional_analysis_method TEXT; -- How nutrition was calculated (database, AI estimation, etc.)
ALTER TABLE food_searches ADD COLUMN image_quality TEXT; -- Quality assessment of the uploaded image
ALTER TABLE food_searches ADD COLUMN processing_time_ms INTEGER; -- Time taken to analyze the image
ALTER TABLE food_searches ADD COLUMN user_feedback TEXT; -- User feedback on the accuracy
ALTER TABLE food_searches ADD COLUMN correction_history JSONB; -- History of corrections made
```

### fasts_log
```sql
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
```

## Workout Tables

### workout_log
```sql
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
```

### exercises
```sql
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
```

### exercise_log
```sql
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
```

## AI Agent Tables

### ai_agents
```sql
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
```

### agent_commands
```sql
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
```

### agent_messages
```sql
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
```

## Notification & Communication Tables

### notifications
```sql
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
```

### emails
```sql
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
```

## Integration Tables

### api_integrations
```sql
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
```

### user_api_integrations
```sql
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
```

## Implementation Notes

1. These field expansions should be applied after the base schema is created
2. Consider adding appropriate indexes for fields that will be frequently queried
3. Some fields may require additional constraints (e.g., range checks for rating fields)
4. JSONB fields provide flexibility but consider normalization for data that will be frequently queried
5. Array fields (TEXT[]) are useful for simple lists but consider junction tables for more complex relationships
6. Consider adding appropriate triggers for fields that need to be automatically updated

## Benefits

- **Enhanced Analytics**: More detailed data collection enables deeper insights
- **Personalization**: Additional fields support more personalized user experiences
- **AI Capabilities**: Expanded data points improve AI coaching and recommendations
- **Research Value**: Comprehensive data collection supports research and development
- **User Engagement**: Detailed tracking encourages user engagement and retention