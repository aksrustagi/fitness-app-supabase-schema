# Supabase Database Schema for Fitness & Health Tracking App

This repository contains the complete database schema for a comprehensive fitness and health tracking application using Supabase.

## Overview

The schema includes tables for tracking various health and fitness metrics:

- Fasting logs
- Water consumption
- Calorie intake
- Step tracking
- Workouts and exercises
- Food analysis with AI
- Meditation and music
- Challenges and battles
- Protocols and steps
- Helper sessions
- Orders and payments
- Messaging
- AI integrations
- Goal tracking
- User statistics and preferences

## Files

- `supabase-schema.md`: Detailed documentation of all tables with column descriptions
- `supabase-schema.sql`: SQL script to create all tables, indexes, and RLS policies in Supabase

## Implementation

### Using the SQL Script

1. Access your Supabase project
2. Go to the SQL Editor
3. Copy and paste the contents of `supabase-schema.sql`
4. Run the script to create all tables

### Manual Implementation

If you prefer to implement tables individually:

1. Refer to `supabase-schema.md` for detailed table specifications
2. Create tables in the correct order to maintain foreign key relationships
3. Add indexes for performance optimization
4. Set up Row Level Security (RLS) policies for each table

## Enhanced Features

### Data Integrity

- CHECK constraints to ensure valid data (e.g., positive values, valid date ranges)
- Generated columns for calculated fields (e.g., duration, total price)
- Unique constraints to prevent duplicate entries

### Performance Optimization

- Indexes on frequently queried columns and foreign keys
- Composite indexes for common query patterns
- Cascading deletes to maintain referential integrity
- Views for common complex queries

### Advanced PostgreSQL Features

- Generated columns for calculated fields
- Array data types for lists (e.g., certifications)
- JSONB data types for flexible schema (e.g., availability, preferences)
- Custom functions for common calculations (e.g., BMI, calories burned)

## Table Relationships

The schema includes proper foreign key relationships between tables:

- User references (all tables link to the Supabase auth.users table)
- Workout logs to exercise logs
- Challenges to exercises and participants
- Battles to participants
- Protocols to steps and participants
- Message groups to members and messages
- Orders to order items and products

## Security

The schema includes Row Level Security (RLS) policies to ensure users can only:

- View their own data
- Insert their own data
- Update their own data
- Delete their own data

## Performance Considerations

- Indexes are created on frequently queried columns
- Timestamp triggers automatically update the `updated_at` field
- UUID primary keys for scalability
- Views for common complex queries
- Functions for common calculations

## Extensions

The schema uses the following PostgreSQL extensions:

- `uuid-ossp`: For UUID generation

## New Tables Added

- `meditation_log`: Track user meditation sessions
- `challenge_participants`: Track users participating in challenges
- `protocol_participants`: Track users following protocols
- `products`: Catalog of available products
- `user_stats`: Track user health metrics over time
- `user_preferences`: Store user application preferences

## Contributing

Feel free to suggest improvements or additional tables by creating a pull request.

## License

This schema is available under the MIT License.