-- =======================================================
-- CodeQuest: Programming Learning Game
-- Database Setup Script (MySQL)
-- Database Name: codequest_db
-- =======================================================

DROP DATABASE IF EXISTS codequest_db;
CREATE DATABASE codequest_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE codequest_db;

-- -------------------------------------------------------
-- Table 1: users
-- Stores student registration and progress details
-- -------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    total_xp INT DEFAULT 0,
    player_level INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------
-- Table 2: admins
-- Stores administrator login credentials
-- -------------------------------------------------------
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------
-- Table 3: missions
-- Stores programming questions created by the Admin
-- -------------------------------------------------------
CREATE TABLE missions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(30) NOT NULL,       -- Java, SQL, or DSA
    difficulty VARCHAR(20) NOT NULL,     -- Easy, Medium, or Hard
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    xp_reward INT DEFAULT 50,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES admins(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------
-- Table 4: mission_submissions
-- Stores student answers and tracks completed missions
-- Enforces one-attempt-per-mission rule via UNIQUE constraint
-- -------------------------------------------------------
CREATE TABLE mission_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    mission_id INT NOT NULL,
    answer VARCHAR(255) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_mission (user_id, mission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =======================================================
-- INITIAL SEED DATA
-- =======================================================

-- Admin Account: admin / admin123
INSERT INTO admins (id, username, password) VALUES
(1, 'admin', 'admin123');

-- Sample Students
INSERT INTO users (id, username, email, password, total_xp, player_level, created_at) VALUES
(1, 'alex_coder', 'alex@codequest.dev', 'password123', 350, 4, NOW() - INTERVAL 5 DAY),
(2, 'sarah_dev', 'sarah@codequest.dev', 'password123', 220, 3, NOW() - INTERVAL 4 DAY),
(3, 'marcus_algo', 'marcus@codequest.dev', 'password123', 140, 2, NOW() - INTERVAL 2 DAY),
(4, 'elena_db', 'elena@codequest.dev', 'password123', 90, 1, NOW() - INTERVAL 1 DAY);

-- Sample Missions (Java, SQL, DSA across Easy, Medium, Hard)
INSERT INTO missions (id, title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) VALUES
(1, 'Java String Immutability', 
 'In Java, String objects are immutable. Consider the code:\nString s = "Hello";\ns.concat(" World");\nSystem.out.println(s);\nWhat is printed to standard output?', 
 'Java', 'Easy', 
 'Hello World', 'Hello', 'null', 'Compilation Error', 
 'Hello', 30, 1),

(2, 'Method Overriding Access Level', 
 'When overriding a method with protected access in a superclass, what access specifier can the subclass method have?', 
 'Java', 'Medium', 
 'Only protected', 'Only private', 'protected or public', 'default or protected', 
 'protected or public', 60, 1),

(3, 'Volatile Keyword Semantics', 
 'What does the "volatile" keyword in Java guarantee for a shared variable accessed across multiple threads?', 
 'Java', 'Hard', 
 'Mutual exclusion and lock acquisition', 'Memory visibility of updates and prevention of instruction reordering', 'Automatic thread suspension', 'Atomic increments for compound operators like i++', 
 'Memory visibility of updates and prevention of instruction reordering', 100, 1),

(4, 'SQL Filtering with LIKE & Wildcards', 
 'Which SQL WHERE condition matches any customer whose name starts with "A" and contains at least 3 characters?', 
 'SQL', 'Easy', 
 'WHERE name LIKE ''A%''', 'WHERE name LIKE ''A__%''', 'WHERE name LIKE ''A*''', 'WHERE name REGEXP ''^A''', 
 'WHERE name LIKE ''A__%''', 30, 1),

(5, 'Aggregate Functions & Filtering', 
 'Which clause must be used to filter groups based on the result of an aggregate function like AVG() or COUNT()?', 
 'SQL', 'Medium', 
 'WHERE', 'HAVING', 'GROUP FILTER', 'ORDER BY', 
 'HAVING', 60, 1),

(6, 'Handling NULLs in Joins', 
 'Suppose Table A has 3 rows with IDs (1, 2, NULL) and Table B has 2 rows with IDs (1, NULL). How many rows does an INNER JOIN on A.id = B.id produce in standard SQL?', 
 'SQL', 'Hard', 
 '1 row', '2 rows', '3 rows', '0 rows', 
 '1 row', 90, 1),

(7, 'Stack LIFO Operation', 
 'If the operations push(10), push(20), pop(), push(30), and peek() are performed on an empty stack in order, what value does peek() return?', 
 'DSA', 'Easy', 
 '10', '20', '30', 'EmptyStackException', 
 '30', 30, 1),

(8, 'Binary Search Tree In-order Traversal', 
 'What is the characteristic property of performing an in-order traversal on a valid Binary Search Tree (BST)?', 
 'DSA', 'Medium', 
 'Nodes are visited in strictly descending order', 'Nodes are visited in non-decreasing (sorted) order', 'Root is always visited first', 'Leaf nodes are visited before any internal node', 
 'Nodes are visited in non-decreasing (sorted) order', 50, 1),

(9, 'Graph Cycle Detection', 
 'What is the optimal algorithm and time complexity to detect a cycle in a directed graph with V vertices and E edges?', 
 'DSA', 'Hard', 
 'Dijkstra Algorithm in O(E + V log V)', 'DFS with 3-color state tracking in O(V + E)', 'Floyd-Warshall in O(V^3)', 'Prim Algorithm in O(E log V)', 
 'DFS with 3-color state tracking in O(V + E)', 90, 1),

(10, 'Java Interface Default Methods', 
 'Since Java 8, interfaces can provide default method implementations. If a class implements two interfaces that declare an identical default method signature, how must the conflict be resolved?', 
 'Java', 'Medium', 
 'The first listed interface takes precedence automatically', 'The code fails to compile unless the class explicitly overrides the method', 'JVM resolves it at runtime via reflection', 'Both methods are executed in declaration order', 
 'The code fails to compile unless the class explicitly overrides the method', 60, 1),

(11, 'SQL Window Ranking Functions', 
 'What is the difference between RANK() and DENSE_RANK() in SQL when identical values (ties) occur in the ranking sequence?', 
 'SQL', 'Hard', 
 'RANK() skips positions after ties while DENSE_RANK() produces consecutive rankings', 'DENSE_RANK() skips positions while RANK() does not', 'RANK() requires PARTITION BY while DENSE_RANK() cannot use it', 'They are identical aliases for the same function', 
 'RANK() skips positions after ties while DENSE_RANK() produces consecutive rankings', 80, 1),

(12, 'Array Random Access Complexity', 
 'What is the worst-case time complexity of accessing an element by index in a contiguous array in memory?', 
 'DSA', 'Easy', 
 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 
 'O(1)', 20, 1);

-- Initial Submissions for Sample Students
-- alex_coder (id 1): completed mission 1, 2, 4, 5, 7, 8, 12 (7 missions solved, total_xp = 350, level 4)
INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct, completed_at) VALUES
(1, 1, 'Hello', TRUE, NOW() - INTERVAL 4 DAY),
(1, 2, 'protected or public', TRUE, NOW() - INTERVAL 3 DAY),
(1, 4, 'WHERE name LIKE ''A__%''', TRUE, NOW() - INTERVAL 3 DAY),
(1, 5, 'HAVING', TRUE, NOW() - INTERVAL 2 DAY),
(1, 7, '30', TRUE, NOW() - INTERVAL 2 DAY),
(1, 8, 'Nodes are visited in non-decreasing (sorted) order', TRUE, NOW() - INTERVAL 1 DAY),
(1, 12, 'O(1)', TRUE, NOW() - INTERVAL 1 DAY);

-- sarah_dev (id 2): completed mission 1, 4, 7, 10, 12 (5 missions, total_xp = 220, level 3)
INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct, completed_at) VALUES
(2, 1, 'Hello', TRUE, NOW() - INTERVAL 3 DAY),
(2, 4, 'WHERE name LIKE ''A__%''', TRUE, NOW() - INTERVAL 2 DAY),
(2, 7, '30', TRUE, NOW() - INTERVAL 2 DAY),
(2, 10, 'The code fails to compile unless the class explicitly overrides the method', TRUE, NOW() - INTERVAL 1 DAY),
(2, 12, 'O(1)', TRUE, NOW() - INTERVAL 12 HOUR);

-- marcus_algo (id 3): completed mission 1, 7, 8, 12 (4 missions, total_xp = 140, level 2)
INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct, completed_at) VALUES
(3, 1, 'Hello', TRUE, NOW() - INTERVAL 2 DAY),
(3, 7, '30', TRUE, NOW() - INTERVAL 1 DAY),
(3, 8, 'Nodes are visited in non-decreasing (sorted) order', TRUE, NOW() - INTERVAL 18 HOUR),
(3, 12, 'O(1)', TRUE, NOW() - INTERVAL 6 HOUR);

-- elena_db (id 4): completed mission 4, 5 (2 missions, total_xp = 90, level 1)
INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct, completed_at) VALUES
(4, 4, 'WHERE name LIKE ''A__%''', TRUE, NOW() - INTERVAL 18 HOUR),
(4, 5, 'HAVING', TRUE, NOW() - INTERVAL 12 HOUR);
