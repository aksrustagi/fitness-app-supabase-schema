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

## Table Relationships

The schema includes proper foreign key relationships between tables:

- User references (all tables link to the Supabase auth.users table)
- Workout logs to exercise logs
- Challenges to exercises
- Battles to participants
- Protocols to steps
- Message groups to members and messages
- Orders to order items

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

## Extensions

The schema uses the following PostgreSQL extensions:

- `uuid-ossp`: For UUID generation

## Contributing

Feel free to suggest improvements or additional tables by creating a pull request.

## License

This schema is available under the MIT License.