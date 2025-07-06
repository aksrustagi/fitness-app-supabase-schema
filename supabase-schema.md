# Supabase Schema Definitions

This document outlines the complete schema for all tables in the Supabase database for our fitness and health tracking application.

## 1. fasts_log

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the fast log entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who logged the fast | FOREIGN KEY REFERENCES users(id), NOT NULL |
| start_time | timestamp with time zone | When the fast started | NOT NULL |
| end_time | timestamp with time zone | When the fast ended | NULL (can be updated when fast ends) |
| duration | interval | Duration of the fast | NULL (calculated field) |
| date | date | Date of the fast | NOT NULL, DEFAULT CURRENT_DATE |
| fast_type | text | Type of fast (16:8, 18:6, 20:4, etc.) | NULL |
| status | text | Status of the fast (active, completed, broken) | NOT NULL, DEFAULT 'active' |
| notes | text | User notes about the fast | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 2. water_consumed

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the water consumption entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who logged the water consumption | FOREIGN KEY REFERENCES users(id), NOT NULL |
| amount | numeric | Amount of water consumed in ml/oz | NOT NULL |
| type | text | Type of liquid (water, tea, coffee, etc.) | NOT NULL, DEFAULT 'water' |
| goal | numeric | Daily water consumption goal in ml/oz | NOT NULL |
| left | numeric | Amount left to reach the goal | NULL (calculated field) |
| date | date | Date of the water consumption | NOT NULL, DEFAULT CURRENT_DATE |
| time | timestamp with time zone | Time of the water consumption | NOT NULL, DEFAULT NOW() |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 3. calories_log

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the calorie log entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who logged the calories | FOREIGN KEY REFERENCES users(id), NOT NULL |
| image_url | text | URL to the image of the food | NULL |
| food_name | text | Name of the food consumed | NOT NULL |
| calories | numeric | Calories in the food | NOT NULL |
| protein | numeric | Protein content in grams | NULL |
| carbs | numeric | Carbohydrate content in grams | NULL |
| fat | numeric | Fat content in grams | NULL |
| meal_type | text | Type of meal (breakfast, lunch, dinner, snack) | NULL |
| serving_size | text | Size of the serving | NULL |
| date | date | Date of consumption | NOT NULL, DEFAULT CURRENT_DATE |
| time | timestamp with time zone | Time of consumption | NOT NULL, DEFAULT NOW() |
| notes | text | Additional notes about the food | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 4. steps_log

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the steps log entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who logged the steps | FOREIGN KEY REFERENCES users(id), NOT NULL |
| steps | integer | Number of steps taken | NOT NULL |
| distance | numeric | Distance covered in km/miles | NULL |
| goal | integer | Daily step goal | NOT NULL |
| calories_burned | numeric | Estimated calories burned from steps | NULL |
| date | date | Date of the step count | NOT NULL, DEFAULT CURRENT_DATE |
| source | text | Source of step data (device, app, manual entry) | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 5. workout_log

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the workout log entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who logged the workout | FOREIGN KEY REFERENCES users(id), NOT NULL |
| workout_name | text | Name of the workout | NOT NULL |
| workout_type | text | Type of workout (strength, cardio, flexibility, etc.) | NOT NULL |
| calories_burned | numeric | Total calories burned during workout | NULL |
| start_time | timestamp with time zone | When the workout started | NOT NULL |
| end_time | timestamp with time zone | When the workout ended | NULL |
| length | interval | Duration of the workout | NULL (calculated field) |
| date | date | Date of the workout | NOT NULL, DEFAULT CURRENT_DATE |
| notes | text | Notes about the workout | NULL |
| rating | integer | User rating of the workout (1-5) | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 6. exercises

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the exercise | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| name | text | Name of the exercise | NOT NULL |
| calories_burned | numeric | Estimated calories burned per minute | NULL |
| exercise_type | text | Type of exercise (strength, cardio, flexibility, etc.) | NOT NULL |
| muscle_group | text | Primary muscle group targeted | NULL |
| equipment | text | Equipment needed for the exercise | NULL |
| difficulty | text | Difficulty level (beginner, intermediate, advanced) | NULL |
| instructions | text | How to perform the exercise | NULL |
| video_url | text | URL to a demonstration video | NULL |
| image_url | text | URL to an image demonstrating the exercise | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 7. exercise_log

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the exercise log entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| workout_log_id | uuid | Reference to the workout log this exercise is part of | FOREIGN KEY REFERENCES workout_log(id), NOT NULL |
| exercise_id | uuid | Reference to the exercise performed | FOREIGN KEY REFERENCES exercises(id), NOT NULL |
| user_id | uuid | Reference to the user who performed the exercise | FOREIGN KEY REFERENCES users(id), NOT NULL |
| sets | integer | Number of sets performed | NULL |
| reps | integer | Number of repetitions per set | NULL |
| weight | numeric | Weight used (if applicable) | NULL |
| duration | interval | Duration of the exercise (for timed exercises) | NULL |
| distance | numeric | Distance covered (if applicable) | NULL |
| calories_burned | numeric | Estimated calories burned | NULL |
| notes | text | Notes about the exercise performance | NULL |
| date | date | Date of the exercise | NOT NULL, DEFAULT CURRENT_DATE |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 8. food_searches

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the food search | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who performed the search | FOREIGN KEY REFERENCES users(id), NOT NULL |
| image_url | text | URL to the image of the food | NULL |
| query_text | text | Text query used for the search | NULL |
| ai_response | jsonb | Structured response from AI analysis | NULL |
| food_name | text | Identified food name | NULL |
| calories | numeric | Estimated calories | NULL |
| macros | jsonb | Macronutrient breakdown | NULL |
| date | date | Date of the search | NOT NULL, DEFAULT CURRENT_DATE |
| time | timestamp with time zone | Time of the search | NOT NULL, DEFAULT NOW() |
| saved_to_log | boolean | Whether this search was saved to calorie log | NOT NULL, DEFAULT FALSE |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 9. meditations

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the meditation | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| title | text | Title of the meditation | NOT NULL |
| description | text | Description of the meditation | NULL |
| duration | interval | Duration of the meditation | NOT NULL |
| music_id | uuid | Reference to background music | FOREIGN KEY REFERENCES music(id), NULL |
| category | text | Category of meditation (sleep, stress, focus, etc.) | NULL |
| instructor | text | Name of the meditation instructor | NULL |
| audio_url | text | URL to the meditation audio | NOT NULL |
| image_url | text | URL to the meditation image | NULL |
| difficulty | text | Difficulty level | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 10. music

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the music track | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| title | text | Title of the music track | NOT NULL |
| artist | text | Artist of the music track | NULL |
| duration | interval | Duration of the track | NOT NULL |
| audio_url | text | URL to the music audio | NOT NULL |
| category | text | Category of music (meditation, workout, ambient, etc.) | NULL |
| image_url | text | URL to the album art or track image | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 11. challenges

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the challenge | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| title | text | Title of the challenge | NOT NULL |
| description | text | Description of the challenge | NULL |
| start_date | date | Start date of the challenge | NOT NULL |
| end_date | date | End date of the challenge | NOT NULL |
| challenge_type | text | Type of challenge (workout, nutrition, etc.) | NOT NULL |
| difficulty | text | Difficulty level | NULL |
| points | integer | Points awarded for completing the challenge | NULL |
| image_url | text | URL to the challenge image | NULL |
| created_by | uuid | Reference to the user who created the challenge | FOREIGN KEY REFERENCES users(id), NULL |
| is_public | boolean | Whether the challenge is public | NOT NULL, DEFAULT TRUE |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 12. challenge_exercise

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the challenge exercise | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| challenge_id | uuid | Reference to the challenge | FOREIGN KEY REFERENCES challenges(id), NOT NULL |
| exercise_id | uuid | Reference to the exercise | FOREIGN KEY REFERENCES exercises(id), NOT NULL |
| sets | integer | Number of sets required | NULL |
| reps | integer | Number of repetitions required | NULL |
| duration | interval | Duration required (for timed exercises) | NULL |
| distance | numeric | Distance required (if applicable) | NULL |
| points | integer | Points awarded for completing this exercise | NULL |
| day_number | integer | Day of the challenge this exercise is for | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 13. battles

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the battle | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| title | text | Title of the battle | NOT NULL |
| description | text | Description of the battle | NULL |
| start_date | date | Start date of the battle | NOT NULL |
| end_date | date | End date of the battle | NOT NULL |
| battle_type | text | Type of battle (steps, workouts, etc.) | NOT NULL |
| creator_id | uuid | Reference to the user who created the battle | FOREIGN KEY REFERENCES users(id), NOT NULL |
| winner_id | uuid | Reference to the user who won the battle | FOREIGN KEY REFERENCES users(id), NULL |
| status | text | Status of the battle (pending, active, completed) | NOT NULL, DEFAULT 'pending' |
| prize | text | Prize for winning the battle | NULL |
| image_url | text | URL to the battle image | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 14. battle_participants

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the battle participant | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| battle_id | uuid | Reference to the battle | FOREIGN KEY REFERENCES battles(id), NOT NULL |
| user_id | uuid | Reference to the participating user | FOREIGN KEY REFERENCES users(id), NOT NULL |
| score | numeric | User's score in the battle | DEFAULT 0 |
| status | text | Status of participation (invited, accepted, declined, completed) | NOT NULL, DEFAULT 'invited' |
| joined_at | timestamp with time zone | When the user joined the battle | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 15. protocols

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the protocol | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| name | text | Name of the protocol | NOT NULL |
| description | text | Description of the protocol | NULL |
| category | text | Category of the protocol (fitness, nutrition, wellness) | NOT NULL |
| difficulty | text | Difficulty level | NULL |
| duration | interval | Expected duration to complete the protocol | NULL |
| image_url | text | URL to the protocol image | NULL |
| created_by | uuid | Reference to the user who created the protocol | FOREIGN KEY REFERENCES users(id), NULL |
| is_public | boolean | Whether the protocol is public | NOT NULL, DEFAULT TRUE |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 16. protocol_steps

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the protocol step | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| protocol_id | uuid | Reference to the protocol | FOREIGN KEY REFERENCES protocols(id), NOT NULL |
| step_number | integer | Order of the step in the protocol | NOT NULL |
| title | text | Title of the step | NOT NULL |
| description | text | Description of the step | NULL |
| duration | interval | Expected duration of the step | NULL |
| image_url | text | URL to an image for this step | NULL |
| video_url | text | URL to a video for this step | NULL |
| exercise_id | uuid | Reference to an exercise (if applicable) | FOREIGN KEY REFERENCES exercises(id), NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 17. helpers

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the helper | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who is a helper | FOREIGN KEY REFERENCES users(id), NOT NULL |
| vendor_id | text | External vendor ID for the helper | NULL |
| rate | numeric | Hourly rate charged by the helper | NOT NULL |
| specialty | text | Helper's specialty area | NOT NULL |
| bio | text | Helper's biography | NULL |
| experience_years | integer | Years of experience | NULL |
| certifications | text[] | List of certifications | NULL |
| availability | jsonb | Helper's availability schedule | NULL |
| rating | numeric | Average rating from users | DEFAULT 0 |
| is_active | boolean | Whether the helper is currently active | NOT NULL, DEFAULT TRUE |
| image_url | text | URL to the helper's profile image | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 18. help_session

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the help session | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user receiving help | FOREIGN KEY REFERENCES users(id), NOT NULL |
| helper_id | uuid | Reference to the helper providing help | FOREIGN KEY REFERENCES helpers(id), NOT NULL |
| start_time | timestamp with time zone | When the session started | NOT NULL |
| end_time | timestamp with time zone | When the session ended | NULL |
| duration | interval | Duration of the session | NULL (calculated field) |
| status | text | Status of the session (scheduled, in-progress, completed, cancelled) | NOT NULL, DEFAULT 'scheduled' |
| topic | text | Main topic of the session | NOT NULL |
| notes | text | Notes about the session | NULL |
| user_rating | integer | Rating given by the user (1-5) | NULL |
| user_feedback | text | Feedback given by the user | NULL |
| cost | numeric | Cost of the session | NULL |
| payment_status | text | Status of payment (pending, paid, refunded) | NOT NULL, DEFAULT 'pending' |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 19. orders

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the order | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who placed the order | FOREIGN KEY REFERENCES users(id), NOT NULL |
| order_date | timestamp with time zone | When the order was placed | NOT NULL, DEFAULT NOW() |
| total_amount | numeric | Total amount of the order | NOT NULL |
| status | text | Status of the order (pending, processing, shipped, delivered, cancelled) | NOT NULL, DEFAULT 'pending' |
| shipping_address | jsonb | Shipping address details | NULL |
| billing_address | jsonb | Billing address details | NULL |
| payment_method | text | Method of payment | NOT NULL |
| payment_status | text | Status of payment (pending, paid, refunded) | NOT NULL, DEFAULT 'pending' |
| tracking_number | text | Shipping tracking number | NULL |
| notes | text | Additional notes about the order | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 20. order_items

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the order item | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| order_id | uuid | Reference to the order | FOREIGN KEY REFERENCES orders(id), NOT NULL |
| product_id | uuid | Reference to the product | NOT NULL |
| product_name | text | Name of the product | NOT NULL |
| quantity | integer | Quantity ordered | NOT NULL |
| unit_price | numeric | Price per unit | NOT NULL |
| total_price | numeric | Total price for this item | NOT NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 21. prescription_calls

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the prescription call | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who had the call | FOREIGN KEY REFERENCES users(id), NOT NULL |
| doctor_id | uuid | Reference to the doctor who conducted the call | NULL |
| start_time | timestamp with time zone | When the call started | NOT NULL |
| end_time | timestamp with time zone | When the call ended | NULL |
| duration | interval | Duration of the call | NULL (calculated field) |
| status | text | Status of the call (scheduled, completed, cancelled) | NOT NULL, DEFAULT 'scheduled' |
| notes | text | Notes from the call | NULL |
| prescription_issued | boolean | Whether a prescription was issued | NOT NULL, DEFAULT FALSE |
| prescription_details | jsonb | Details of the prescription | NULL |
| follow_up_required | boolean | Whether a follow-up is required | NOT NULL, DEFAULT FALSE |
| follow_up_date | date | Date for the follow-up | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 22. message_groups

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the message group | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| name | text | Name of the message group | NULL |
| type | text | Type of group (direct, group, support) | NOT NULL |
| created_by | uuid | Reference to the user who created the group | FOREIGN KEY REFERENCES users(id), NOT NULL |
| is_active | boolean | Whether the group is active | NOT NULL, DEFAULT TRUE |
| image_url | text | URL to the group image | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 23. message_group_members

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the group member entry | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| group_id | uuid | Reference to the message group | FOREIGN KEY REFERENCES message_groups(id), NOT NULL |
| user_id | uuid | Reference to the user who is a member | FOREIGN KEY REFERENCES users(id), NOT NULL |
| role | text | Role in the group (admin, member) | NOT NULL, DEFAULT 'member' |
| joined_at | timestamp with time zone | When the user joined the group | NOT NULL, DEFAULT NOW() |
| is_active | boolean | Whether the user is active in the group | NOT NULL, DEFAULT TRUE |
| last_read_message_id | uuid | Reference to the last message read by the user | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 24. messages

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the message | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| group_id | uuid | Reference to the message group | FOREIGN KEY REFERENCES message_groups(id), NOT NULL |
| sender_id | uuid | Reference to the user who sent the message | FOREIGN KEY REFERENCES users(id), NOT NULL |
| content | text | Content of the message | NOT NULL |
| time | timestamp with time zone | Time the message was sent | NOT NULL, DEFAULT NOW() |
| is_read | boolean | Whether the message has been read | NOT NULL, DEFAULT FALSE |
| attachment_url | text | URL to an attachment | NULL |
| attachment_type | text | Type of attachment (image, video, file) | NULL |
| is_edited | boolean | Whether the message has been edited | NOT NULL, DEFAULT FALSE |
| is_deleted | boolean | Whether the message has been deleted | NOT NULL, DEFAULT FALSE |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 25. vapi_calls

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the VAPI call | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who made the call | FOREIGN KEY REFERENCES users(id), NOT NULL |
| call_id | text | External call ID from VAPI | NULL |
| start_time | timestamp with time zone | When the call started | NOT NULL |
| end_time | timestamp with time zone | When the call ended | NULL |
| duration | interval | Duration of the call | NULL (calculated field) |
| status | text | Status of the call (initiated, in-progress, completed, failed) | NOT NULL |
| call_type | text | Type of call (inbound, outbound) | NOT NULL |
| phone_number | text | Phone number involved in the call | NULL |
| transcript | text | Transcript of the call | NULL |
| recording_url | text | URL to the call recording | NULL |
| notes | text | Notes about the call | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 26. heygen_sessions

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the HeyGen session | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who created the session | FOREIGN KEY REFERENCES users(id), NOT NULL |
| session_id | text | External session ID from HeyGen | NULL |
| video_url | text | URL to the generated video | NULL |
| thumbnail_url | text | URL to the video thumbnail | NULL |
| script | text | Script used for the video | NULL |
| avatar_id | text | ID of the avatar used | NULL |
| duration | interval | Duration of the video | NULL |
| status | text | Status of the session (processing, completed, failed) | NOT NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 27. ai_calls

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the AI call | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who made the call | FOREIGN KEY REFERENCES users(id), NOT NULL |
| service | text | AI service used (OpenAI, Claude, etc.) | NOT NULL |
| model | text | Model used (GPT-4, Claude 3, etc.) | NOT NULL |
| prompt | text | Prompt sent to the AI | NOT NULL |
| response | text | Response from the AI | NULL |
| tokens_used | integer | Number of tokens used | NULL |
| cost | numeric | Cost of the API call | NULL |
| purpose | text | Purpose of the AI call | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |

## 28. goals

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | uuid | Unique identifier for the goal | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| user_id | uuid | Reference to the user who set the goal | FOREIGN KEY REFERENCES users(id), NOT NULL |
| goal_type | text | Type of goal (weight, fitness, nutrition, etc.) | NOT NULL |
| starting_weight | numeric | Starting weight in kg/lbs | NULL |
| goal_weight | numeric | Target weight in kg/lbs | NULL |
| goal_physique_type_image_url | text | URL to the target physique image | NULL |
| height | numeric | User's height in cm/inches | NULL |
| start_date | date | When the goal was set | NOT NULL, DEFAULT CURRENT_DATE |
| target_date | date | Target date to achieve the goal | NULL |
| status | text | Status of the goal (active, achieved, abandoned) | NOT NULL, DEFAULT 'active' |
| progress | numeric | Current progress percentage | DEFAULT 0 |
| notes | text | Additional notes about the goal | NULL |
| created_at | timestamp with time zone | When the record was created | NOT NULL, DEFAULT NOW() |
| updated_at | timestamp with time zone | When the record was last updated | NOT NULL, DEFAULT NOW() |