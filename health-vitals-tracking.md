# Health Vitals and Tracking Tables

This document outlines the comprehensive health vitals and tracking tables added to the fitness app database schema. These tables enable detailed tracking of sleep, vital signs, hormones, nutrients, body measurements, and other health metrics.

## Sleep Tracking

### sleep_log
Tracks detailed sleep metrics including duration, quality, and environmental factors.

- **sleep_quality_score**: Overall sleep quality on a scale of 1-100
- **sleep_debt_minutes**: Minutes of sleep debt accumulated
- **sleep_surplus_minutes**: Minutes of sleep surplus accumulated
- **deep_sleep_duration**: Time spent in deep sleep
- **rem_sleep_duration**: Time spent in REM sleep
- **sleep_efficiency**: Percentage of time in bed actually sleeping
- **environmental factors**: Temperature, humidity, noise level, light level
- **behavioral factors**: Caffeine, alcohol, exercise, screen time

## Vital Signs

### vital_signs
Tracks heart rate, blood pressure, respiratory rate, and other vital signs.

- **heart_rate**: Beats per minute (BPM)
- **heart_rate_variability**: Variation in time between heartbeats (ms)
- **blood_pressure**: Systolic and diastolic measurements (mmHg)
- **respiratory_rate**: Breaths per minute
- **oxygen_saturation**: Blood oxygen percentage (SpO2)
- **body_temperature**: Temperature in Celsius
- **blood_glucose**: Blood sugar level (mg/dL)

## Hormone Levels

### hormone_levels
Monitors testosterone, cortisol, and other hormone levels.

- **testosterone**: Testosterone level (ng/dL)
- **cortisol**: Cortisol level (μg/dL)
- **estrogen**: Estrogen level (pg/mL)
- **progesterone**: Progesterone level (ng/mL)
- **thyroid hormones**: TSH, T3, T4 levels
- **insulin**: Insulin level (μIU/mL)
- **growth_hormone**: Growth hormone level (ng/mL)
- **melatonin**: Melatonin level (pg/mL)

## Nutrient Levels

### nutrient_levels
Tracks vitamins, minerals, and other nutrient levels.

- **vitamin_d**: Vitamin D level (ng/mL)
- **iron**: Iron level (μg/dL)
- **b_vitamins**: B1, B2, B3, B5, B6, B7, B9, B12 levels
- **vitamin_c**: Vitamin C level (mg/dL)
- **minerals**: Calcium, magnesium, zinc, potassium, sodium, etc.
- **omega_3**: Omega-3 fatty acid level (%)
- **omega_6**: Omega-6 fatty acid level (%)
- **deficiency_risk**: Assessment of deficiency risks
- **supplement_recommendations**: Recommended supplements

## Body Measurements

### body_measurements
Detailed body measurements beyond basic weight and height.

- **weight**: Weight in kilograms
- **height**: Height in centimeters
- **bmi**: Body Mass Index (calculated)
- **body_fat_percentage**: Body fat percentage
- **muscle_mass**: Muscle mass in kilograms
- **bone_mass**: Bone mass in kilograms
- **water_percentage**: Body water percentage
- **circumference measurements**: Waist, hip, chest, neck, bicep, thigh, calf
- **waist_to_hip_ratio**: Waist-to-hip ratio (calculated)
- **body_shape**: Ectomorph, mesomorph, endomorph

## Activity Metrics

### activity_metrics
Daily activity tracking with recovery and readiness scores.

- **steps**: Daily step count
- **distance**: Distance traveled in kilometers
- **floors_climbed**: Number of floors climbed
- **active_calories**: Calories burned from activity
- **active_minutes**: Minutes of activity
- **sedentary_minutes**: Minutes of sedentary time
- **heart_rate_zones**: Time spent in different heart rate zones
- **vo2_max**: Maximum oxygen consumption (mL/(kg·min))
- **recovery_score**: Recovery score (1-100)
- **readiness_score**: Readiness score (1-100)
- **strain_score**: Strain score (1-100)

## Health Assessments

### health_assessments
Health scores, fitness age, and life expectancy predictions.

- **metabolic_age**: Estimated metabolic age in years
- **fitness_age**: Estimated fitness age in years
- **life_expectancy**: Estimated life expectancy in years
- **health_score**: Overall health score (1-100)
- **fitness_score**: Fitness score (1-100)
- **nutrition_score**: Nutrition score (1-100)
- **sleep_score**: Sleep score (1-100)
- **stress_score**: Stress score (1-100)
- **energy_score**: Energy score (1-100)
- **longevity_factors**: Factors affecting longevity
- **health_risks**: Identified health risks
- **improvement_recommendations**: Recommended improvements

## Mood and Psychological Metrics

### mood_tracking
Track mood, energy, stress, confidence, and attractiveness.

- **mood**: Current mood (happy, sad, anxious, energetic, etc.)
- **mood_score**: Mood score (1-10)
- **energy_level**: Energy level (1-10)
- **stress_level**: Stress level (1-10)
- **anxiety_level**: Anxiety level (1-10)
- **focus_level**: Focus level (1-10)
- **motivation_level**: Motivation level (1-10)
- **confidence_level**: Confidence level (1-10)
- **attractiveness_level**: Self-perceived attractiveness (1-10)
- **libido_level**: Libido level (1-10)
- **factors**: Factors affecting mood

## Goal Tracking

### health_goals_progress
Track progress toward health goals with confidence scores.

- **current_value**: Current value (weight, body fat, etc.)
- **target_value**: Target value
- **progress_percentage**: Progress percentage (calculated)
- **time_remaining**: Estimated time to reach goal
- **confidence_score**: Confidence in achieving goal (1-100)
- **blockers**: Factors blocking progress
- **enablers**: Factors enabling progress
- **adjustment_needed**: Whether goal adjustment is needed
- **adjustment_recommendation**: Recommended adjustment

## AI-Generated Insights

### health_insights
AI-generated insights from health data.

- **insight_type**: Correlation, trend, anomaly, recommendation, etc.
- **insight_category**: Sleep, nutrition, fitness, mood, etc.
- **title**: Brief title of the insight
- **description**: Detailed description
- **data_points**: Data points used for the insight
- **confidence_score**: Confidence in the insight (1-100)
- **actionable_steps**: Recommended actions
- **impact_score**: Potential impact if acted upon (1-100)

## Health Chat Sessions

### health_chat_sessions
Track health assessment chat sessions.

- **session_type**: Daily check-in, health assessment, mood check, etc.
- **transcript**: Full conversation transcript
- **health_score_before**: Health score before session (1-100)
- **health_score_after**: Health score after session (1-100)
- **mood_before**: Mood before session
- **mood_after**: Mood after session
- **key_topics**: Main topics discussed
- **action_items**: Action items identified
- **follow_up_scheduled**: Whether follow-up is scheduled

## External Data Integration

### external_health_data
Store data imported from Apple Health and other platforms.

- **source**: Apple Health, Google Fit, Fitbit, etc.
- **data_type**: Steps, heart rate, sleep, etc.
- **value_numeric**: Numeric value
- **value_text**: Text value
- **value_json**: JSON value
- **unit**: Measurement unit
- **device_name**: Device name
- **app_name**: App name

### apple_health_sync
Track Apple Health data synchronization status.

- **last_sync_at**: Last sync timestamp
- **sync_status**: Never synced, in progress, completed, failed
- **data_types_synced**: Array of data types synced
- **records_synced**: Number of records synced
- **permissions_granted**: Permissions granted by user

## Attractiveness and Confidence Metrics

### attractiveness_metrics
Track factors affecting attractiveness and confidence.

- **physical_attractiveness_score**: Self-assessed score (1-100)
- **confidence_score**: Confidence level (1-100)
- **posture_score**: Posture quality (1-100)
- **skin_quality_score**: Skin quality (1-100)
- **hair_quality_score**: Hair quality (1-100)
- **body_composition_score**: Body composition (1-100)
- **grooming_score**: Grooming quality (1-100)
- **style_score**: Style/fashion sense (1-100)
- **charisma_score**: Charisma level (1-100)
- **social_skills_score**: Social skills (1-100)
- **factors_affecting**: Factors affecting scores
- **improvement_areas**: Areas identified for improvement
- **improvement_actions**: Actions taken to improve

## Health Correlations

### health_correlations
Track correlations between different health metrics.

- **metric_1**: First metric (e.g., sleep_quality)
- **metric_2**: Second metric (e.g., mood)
- **correlation_coefficient**: -1 to 1
- **confidence_score**: Confidence in correlation (1-100)
- **causation_likelihood**: Likelihood of causation (1-100)
- **correlation_direction**: Positive, negative
- **correlation_strength**: Strong, moderate, weak
- **insight**: Human-readable insight
- **recommendation**: Recommendation based on correlation

## Health Reports

### health_reports
Generated health reports and analyses.

- **report_type**: Weekly summary, monthly analysis, health assessment, etc.
- **date_range**: Start and end dates for the report
- **report_data**: Full report data
- **insights**: Key insights
- **recommendations**: Recommendations
- **metrics_summary**: Summary of key metrics
- **report_url**: URL to PDF/HTML report

## Implementation Notes

1. **Data Privacy**: These tables contain sensitive health information and should be protected with appropriate security measures.
2. **Data Integration**: The `external_health_data` and `apple_health_sync` tables facilitate integration with external health platforms.
3. **AI Analysis**: The schema supports AI-driven health analysis through the `health_insights`, `health_correlations`, and `health_assessments` tables.
4. **Time Series Data**: Most tables include date/time fields to support time series analysis.
5. **Unique Constraints**: Many tables include unique constraints to prevent duplicate entries for the same user and date.
6. **Generated Columns**: Several tables use PostgreSQL's generated columns for calculated fields.
7. **Row Level Security**: All tables have RLS policies to ensure users can only access their own data.