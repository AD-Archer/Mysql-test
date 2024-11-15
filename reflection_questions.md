# SQL Portfolio Reflection Questions

1. **Why did you choose these specific joins in your queries?**
   - INNER JOIN was used for mandatory relationships (e.g., projects must have an owner)
   - LEFT JOIN was used for optional relationships (e.g., projects may or may not have images)
   - This ensures we don't lose project data when optional elements are missing

2. **How do your table constraints improve data integrity?**
   - NOT NULL constraints ensure essential data is always present
   - UNIQUE constraints prevent duplicate emails/phones
   - CHECK constraints validate price and stock values
   - Foreign key constraints maintain referential integrity
   - ON DELETE CASCADE ensures clean removal of related records

3. **What are the benefits of using GROUP_CONCAT in your queries?**
   - Consolidates related data into a single row
   - Makes output more readable and manageable
   - Reduces the need for multiple queries
   - Allows for custom formatting with ORDER BY and SEPARATOR

4. **How does your database design support scalability?**
   - Proper indexing on frequently queried columns
   - Normalized table structure to minimize redundancy
   - Efficient use of data types and constraints
   - Modular design allowing for easy additions