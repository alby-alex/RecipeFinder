CREATE DATABASE RecipeFinder
GO

USE RecipeFinder
GO

CREATE TABLE Users(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(20) UNIQUE,
    PasswordHash VARCHAR(100) NOT NULL
);

CREATE TABLE Recipe(
    RecipeID INT IDENTITY(1, 1) PRIMARY KEY,
    UserID INT NOT NULL, 
    [Name] VARCHAR(100) NOT NULL,
    TimeToCook INT,
    Instructions VARCHAR(MAX),
    CONSTRAINT fk_recipe_user FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Ingredient(
    IngredientID INT IDENTITY(1, 1) PRIMARY KEY,
    [Name] VARCHAR(100) UNIQUE,
    [Type] VARCHAR(15)
);

CREATE TABLE RecipeIngredients(
    IngredientID INT,
    RecipeID INT,
    Quantity DECIMAL,
    Unit VARCHAR(10),
    CONSTRAINT pk_recipeIngredients PRIMARY KEY (IngredientID, RecipeID),
    CONSTRAINT fk_recipeIngredients_ingredientid FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID),
    CONSTRAINT fk_recipeIngredients_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID)
);

CREATE TABLE Tag(
    TagID INT IDENTITY(1, 1) PRIMARY KEY,
    [Name] VARCHAR(100) UNIQUE
);

CREATE TABLE RecipeTags(
    RecipeID INT,
    TagID INT,
    CONSTRAINT pk_recipeTags PRIMARY KEY (RecipeID, TagID),
    CONSTRAINT fk_recipeTags_tagid FOREIGN KEY (TagID) REFERENCES Tag(TagID),
    CONSTRAINT fk_recipeTags_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID)
);

CREATE TABLE IngredientTag(
    TagID INT,
    IngredientID INT,
    CONSTRAINT pk_ingredientTags PRIMARY KEY (TagID, IngredientID),
    CONSTRAINT fk_ingredientTags_tagid FOREIGN KEY (TagID) REFERENCES Tag(TagID),
    CONSTRAINT fk_ingredientTags_ingredientid FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID)
);

CREATE TABLE Comment(
    RecipeID INT,
    UserID INT,
    [Text] VARCHAR(MAX),
    CONSTRAINT fk_comment_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
    CONSTRAINT fk_comment_userid FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Rating(
    UserID INT,
    RecipeID INT,
    Value DECIMAL,
    CONSTRAINT pk_rating PRIMARY KEY (UserID, RecipeID),
    CONSTRAINT fk_rating_userid FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT fk_rating_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID)
);

CREATE TABLE FavoritedRecipe(
    UserID INT,
    RecipeID INT,
    CONSTRAINT pk_favoritedrecipe PRIMARY KEY (UserID, RecipeID),
    CONSTRAINT fk_favoritedrecipe_userid FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT fk_favoritedrecipe_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID)
);

CREATE TABLE Follows(
    FollowersID INT,
    FollowedsID INT,
    CONSTRAINT pk_follows PRIMARY KEY (FollowersID, FollowedsID),
    CONSTRAINT fk_follows_followersid FOREIGN KEY (FollowersID) REFERENCES Users(UserID),
    CONSTRAINT fk_follows_followedsid FOREIGN KEY (FollowedsID) REFERENCES Users(UserID)
);

CREATE TABLE BlockedUser(
    BlockersID INT,
    BlockedID INT,
    CONSTRAINT pk_blockeduser PRIMARY KEY (BlockersID, BlockedID),
    CONSTRAINT fk_blockeduser_blockersid FOREIGN KEY (BlockersID) REFERENCES Users(UserID),
    CONSTRAINT fk_blockeruser_blockedid FOREIGN KEY (BlockedID) REFERENCES Users(UserID)
);

ALTER TABLE RecipeIngredients ADD CONSTRAINT chk_recipeingredients_unit CHECK (Unit in ('oz', 'ml', 'l', 'fl oz', 'lb', 'cup', 'g', 'unit', 'tbsp', 'tsp'));

ALTER TABLE RecipeIngredients ADD CONSTRAINT chk_recipeingredients_quantity CHECK (Quantity > 0);

ALTER TABLE Rating ADD CONSTRAINT chk_rating_value CHECK (Value in (1.0, 2.0, 3.0, 4.0, 5.0));

-- Values

INSERT INTO Users (Username, PasswordHash) VALUES
('CulinaryQueen', '3abc00605fbb9730ccc983ccd8969ce6f6420e57ad58056d69f792800c05ef1b'),
('SavoryChef', 'c1b5d7a0f3e53a95d74b22ae195427bc0f50356e0cd75a618a8329db8651fa21'),
('BakingGoddess', 'f6bd7757d5990965d42aa1f15d5308517850293fc6f340a5c06c248defc74ec3'),
('FlavorExplorer', 'd9dbea536bd8d0ac05e48f51d48d3e42810152773cac85a5540c51cd5fb7cca3'),
('SpiceWhisperer', '3af856b007912daf5526baa0f820490023300d3d152c8fd185bb888598823b0a'),
('GourmetGuru', 'bd0fc46c5e58ef766880e2e32357e00c5acd937c7313b0175263627bf44d88f9'),
('HealthyEater', '579fc0432290a149e2b0926dc6018fbd88578dc405320e40ad912e1cbaa482e7'),
('SweetTreatsLover', '90752fff65f484ff64d19b6af105d57e56e01441630478f3ce15e688764fb8d9'),
('RecipeNinja', '816b7f54f834f3a1d180bdab198628e426ca798047f0737b5cee2558b23b467a'),
('FoodieAdventurer', '70fe4c2e02b7662812008420bc4225f85e184f84eb5eb230a230d0838536cc59'),
('TastyJourney', '55761826c3009a627253fc3c0b36ff1dbe47a7b84612cf8f499b7639824a0563'),
('ChefAtHeart', '9b6e9ca4903f208472d7b531a8f0ebd76c47439f35b01086760e219eec5a85d0'),
('KitchenMaestro', '8dc61a280f8e5b7bfcf036f5ed118c4ce24339e407e51556b4ce290de4f78366'),
('DishDiva', 'befc54c8532b3842ef4952d417a053f6302f3bce9e2984535c58b47e644dd6f2'),
('EpicureanDreamer', 'd69e9b94b92114e8ff078a0aeec800131a14ae48d2cba48aa92bd1f3619c6bed'),
('RecipeRanger', 'd6ef0f5ef163c1947dab9cf391e6bace7c29e0f47058419c8d53074e783f3442'),
('SizzleAndServe', '42a4ef8b6d73d041c092998b292acac5009dbe425f16daa3455149377e1e80f5'),
('YummyBites', '89af6cc2ccf530af20864d7e92a24d86a9553e83fa79d2933e95b3510b1629f6'),
('FreshFlavors', '22f65f8cf7e51f7f8f4598e510145cc492ced7fb2c48270e25f9fb09ad622bbf'),
('ComfortFoodie', '512b10d32ef01ceaf3e51e3054bd3365a95c5b6f6d810e7889f149df96aeee38'),
('GastronomicExplorer', '1dd86e7faa7128cf67cbdbc8bcd86f8c32abf366239dec1935b2fb1febda393d'),
('FlavorfulVoyager', '1e1d3653f4b3f088369d3863d391395039bc193a0d5c85a7c821afac64d9cd92'),
('HomeCookHero', 'b9fe7ad00589ed3b99e57d00b74c3926f353a808b5e75cf1b787f9e76994ad7f'),
('SavorySavant', '47674fa1ad463b053fc81513fc8adc67a0e9137b773a8cfc8794d37c5b8de0f9'),
('CookingConnoisseur', '7c3263260a7e9123c9b5c10b89ab7e15b5f41ce6bc0f5ed9c8567f2f581a8747'),
('IngredientInnovator', 'e7bfbb0bf322113fe471c67f8df179cd9fe7b924439e8ffb5be9eb43ef7deec9'),
('PalatePleaser', '9d895e0296ee63b04bf9d9efb0ea93360da5ada5e395611687c8dfe1cc51f322'),
('NourishingNibbles', 'b4735fba9129ef0d7dba9649440e3b89da6d34581e4f370bdc2dbcbb44228371'),
('ArtfulBaker', '36eb4df6a835e5c6edf20769523ae510b36cb8271bc832d35cf45b0eefb19005'),
('WhiskAndMix', '5df52fd4f65cf5433c0e7e05ea7ebaf3711dfe1794674bd94f74ab79ba1f49c7'),
('GrillMaster88', '051114a9e760b34db37917b7d7e2fd845e3b3a6cc13230bda86f98f30907b3c6');


INSERT INTO BlockedUser (BlockersID, BlockedID) VALUES
(10, 5),
(20, 6),
(31, 18),
(6, 7),
(27, 1),
(2, 19),
(5, 4),
(23, 9),
(14, 27),
(20, 15),
(17, 5),
(19, 14),
(31, 9),
(2, 16),
(27, 2),
(22, 14),
(15, 28),
(26, 15),
(25, 4),
(27, 6),
(25, 20),
(4, 30),
(3, 11),
(24, 31),
(19, 22),
(14, 4),
(8, 10),
(30, 5),
(14, 13),
(28, 26),
(28, 4),
(12, 24);

INSERT INTO Follows (FollowersID, FollowedsID) VALUES
(7, 25),
(17, 3),
(24, 26),
(19, 9),
(20, 15),
(6, 26),
(2, 27),
(29, 26),
(11, 6),
(29, 8),
(4, 11),
(4, 10),
(6, 8),
(24, 11),
(29, 31),
(29, 7),
(24, 8),
(23, 12),
(27, 26),
(18, 16),
(12, 14),
(1, 21),
(29, 24),
(3, 28),
(7, 15),
(1, 28),
(15, 3),
(13, 19),
(24, 3),
(30, 14),
(9, 8),
(27, 4);

INSERT INTO Recipe (UserID, Name, TimeToCook, Instructions)
VALUES
(7, 'Spaghetti Carbonara', 25, 'Boil pasta. Mix eggs, cheese, pancetta, and pepper. Combine with pasta.'),
(14, 'Chicken Alfredo', 30, 'Cook chicken. Prepare Alfredo sauce. Combine with pasta.'),
(3, 'Vegetable Stir Fry', 20, 'Stir fry vegetables. Add sauce. Serve with rice.'),
(25, 'Beef Tacos', 15, 'Cook ground beef. Prepare taco shells. Add toppings.'),
(10, 'Margherita Pizza', 45, 'Prepare dough. Add sauce, mozzarella, and basil. Bake.'),
(7, 'Pancakes', 20, 'Mix flour, eggs, and milk. Cook on a griddle. Serve with syrup.'),
(6, 'Caesar Salad', 10, 'Chop lettuce. Add Caesar dressing, croutons, and Parmesan.'),
(13, 'Lasagna', 60, 'Layer pasta, meat sauce, and cheese. Bake for 45 minutes.'),
(18, 'Grilled Cheese Sandwich', 10, 'Butter bread. Add cheese. Grill on both sides.'),
(3, 'Chocolate Chip Cookies', 25, 'Mix dough with chocolate chips. Bake at 350°F for 10 minutes.'),
(14, 'French Onion Soup', 50, 'Caramelize onions. Add broth. Simmer and serve with toasted bread.'),
(4, 'Shrimp Scampi', 20, 'Cook shrimp. Add garlic, butter, and lemon. Serve with pasta.'),
(1, 'Eggplant Parmesan', 45, 'Bread eggplant slices. Fry and layer with sauce and cheese. Bake.'),
(1, 'Fish Tacos', 25, 'Grill fish. Prepare tortillas. Add toppings and serve.'),
(29, 'Quinoa Salad', 15, 'Cook quinoa. Mix with vegetables and dressing.'),
(15, 'Omelette', 10, 'Whisk eggs. Add fillings like cheese, ham, or vegetables. Cook in a pan.'),
(5, 'Chicken Curry', 40, 'Cook chicken. Add curry sauce. Simmer and serve with rice.'),
(26, 'Beef Stroganoff', 35, 'Cook beef strips. Add mushrooms, sour cream sauce. Serve over noodles.'),
(17, 'Mushroom Risotto', 50, 'Cook Arborio rice, gradually adding broth. Stir in mushrooms and Parmesan.'),
(3, 'BBQ Pulled Pork', 300, 'Slow cook pork. Shred and mix with BBQ sauce. Serve with buns.'),
(2, 'Grilled Salmon', 20, 'Season salmon. Grill for 10 minutes. Serve with vegetables.'),
(19, 'Chicken Caesar Wrap', 15, 'Grill chicken. Wrap with lettuce, Caesar dressing, and tortilla.'),
(12, 'Chili', 60, 'Brown ground beef. Add beans, tomatoes, and spices. Simmer for an hour.'),
(8, 'Stuffed Peppers', 45, 'Stuff bell peppers with rice, meat, and cheese. Bake for 30 minutes.'),
(31, 'Spaghetti Bolognese', 30, 'Cook ground beef. Add tomato sauce. Serve over spaghetti.'),
(24, 'Teriyaki Chicken', 25, 'Cook chicken with teriyaki sauce. Serve with rice and vegetables.'),
(11, 'Banana Bread', 60, 'Mix bananas, flour, sugar, and eggs. Bake at 350°F for 50 minutes.'),
(21, 'Beef Burritos', 20, 'Cook beef. Add beans, cheese, and wrap in tortilla.'),
(27, 'Chicken Quesadilla', 15, 'Grill chicken. Add cheese in a tortilla and cook until crispy.'),
(16, 'Pumpkin Pie', 70, 'Prepare pumpkin filling. Pour into crust and bake for 60 minutes.'),
(19, 'Greek Salad', 10, 'Chop tomatoes, cucumbers, onions. Add olives, feta, and dressing.'),
(1, 'Garlic Bread', 15, 'Spread garlic butter on bread. Bake until golden brown.');

INSERT INTO Ingredient (Name, Type)
VALUES
('Spaghetti', 'solid'),
('Eggs', 'solid'),
('Pancetta', 'solid'),
('Parmesan Cheese', 'solid'),
('Black Pepper', 'solid'),
('Chicken Breast', 'solid'),
('Fettuccine', 'solid'),
('Heavy Cream', 'liquid'),
('Butter', 'solid'),
('Tomato Sauce', 'liquid'),
('Bell Peppers', 'solid'),
('Broccoli', 'solid'),
('Soy Sauce', 'liquid'),
('Olive Oil', 'liquid'),
('Ground Beef', 'solid'),
('Taco Shells', 'solid'),
('Cheese', 'solid'),
('Pizza Dough', 'solid'),
('Mozzarella Cheese', 'solid'),
('Basil Leaves', 'solid'),
('Flour', 'solid'),
('Milk', 'liquid'),
('Maple Syrup', 'liquid'),
('Croutons', 'solid'),
('Romaine Lettuce', 'solid'),
('Lasagna Noodles', 'solid'),
('Tomatoes', 'solid'),
('Chocolate Chips', 'solid'),
('Onions', 'solid'),
('Garlic', 'solid'),
('Shrimp', 'solid'),
('Lemon Juice', 'liquid'),
('Eggplant', 'solid'),
('Breadcrumbs', 'solid'),
('Tortillas', 'solid'),
('Cucumber', 'solid'),
('Rice', 'solid'),
('Sour Cream', 'solid'),
('Bananas', 'solid'),
('Cinnamon', 'solid');

INSERT INTO RecipeIngredients (IngredientID, RecipeID, Quantity, Unit)
VALUES
(1, 1, 200.0, 'g'),
(2, 1, 2.0, 'unit'),
(3, 1, 100.0, 'g'),
(4, 1, 50.0, 'g'),
(5, 1, 1.0, 'g'),
(6, 2, 200.0, 'g'),
(7, 2, 250.0, 'g'),
(8, 2, 1.0, 'cup'),
(9, 2, 50.0, 'g'),
(4, 2, 50.0, 'g'),
(10, 3, 1.0, 'unit'),
(11, 3, 100.0, 'g'),
(12, 3, 50.0, 'ml'),
(13, 3, 2.0, 'tbsp'),
(14, 4, 200.0, 'g'),
(15, 4, 4.0, 'unit'),
(16, 4, 50.0, 'g'),
(17, 5, 1.0, 'unit'),
(18, 5, 100.0, 'g'),
(19, 5, 5.0, 'g'),
(10, 5, 50.0, 'g'),
(20, 6, 200.0, 'g'),
(2, 6, 2.0, 'unit'),
(21, 6, 200.0, 'ml'),
(9, 6, 30.0, 'g'),
(22, 6, 50.0, 'ml'),
(23, 7, 200.0, 'g'),
(24, 7, 100.0, 'g'),
(4, 7, 50.0, 'g'),
(25, 8, 200.0, 'g'),
(14, 8, 300.0, 'g'),
(18, 8, 100.0, 'g'),
(26, 8, 200.0, 'g'),
(9, 8, 50.0, 'g'),
(27, 9, 2.0, 'unit'),
(16, 9, 50.0, 'g'),
(9, 9, 20.0, 'g'),
(20, 10, 300.0, 'g'),
(9, 10, 100.0, 'g'),
(28, 10, 200.0, 'g'),
(2, 10, 1.0, 'unit'),
(29, 11, 3.0, 'unit'),
(26, 11, 500.0, 'ml'),
(9, 11, 50.0, 'g'),
(27, 11, 1.0, 'unit'),
(30, 12, 200.0, 'g'),
(29, 12, 3.0, 'unit'),
(9, 12, 50.0, 'g'),
(31, 12, 30.0, 'ml'),
(1, 12, 200.0, 'g'),
(32, 13, 1.0, 'unit'),
(33, 13, 100.0, 'g'),
(18, 13, 100.0, 'g'),
(26, 13, 200.0, 'g'),
(13, 13, 50.0, 'ml'),
(30, 14, 200.0, 'g'),
(34, 14, 2.0, 'unit'),
(35, 14, 50.0, 'g'),
(36, 14, 30.0, 'ml'),
(31, 14, 30.0, 'ml'),
(37, 15, 200.0, 'g'),
(35, 15, 50.0, 'g'),
(13, 15, 30.0, 'ml'),
(31, 15, 30.0, 'ml'),
(1, 16, 200.0, 'g'),
(35, 16, 100.0, 'g'),
(2, 16, 1.0, 'unit'),
(36, 16, 50.0, 'ml'),
(37, 16, 100.0, 'g'),
(3, 17, 250.0, 'g'),
(4, 17, 2.0, 'unit'),
(5, 17, 200.0, 'ml'),
(6, 18, 200.0, 'g'),
(10, 18, 1.0, 'unit'),
(11, 18, 300.0, 'g'),
(12, 19, 300.0, 'g'),
(13, 19, 50.0, 'g'),
(14, 20, 300.0, 'g'),
(15, 20, 100.0, 'g'),
(20, 21, 1.0, 'unit'),
(25, 21, 200.0, 'g'),
(2, 22, 1.0, 'unit'),
(5, 22, 200.0, 'g'),
(3, 23, 100.0, 'g'),
(9, 23, 50.0, 'g'),
(7, 24, 200.0, 'g'),
(19, 24, 100.0, 'g'),
(28, 25, 1.0, 'unit'),
(29, 25, 200.0, 'g'),
(30, 26, 1.0, 'unit'),
(31, 26, 150.0, 'g'),
(32, 27, 1.0, 'unit'),
(33, 27, 200.0, 'g'),
(34, 28, 1.0, 'unit'),
(35, 28, 100.0, 'g'),
(36, 29, 200.0, 'g'),
(37, 29, 30.0, 'ml'),
(1, 30, 100.0, 'g'),
(2, 31, 1.0, 'unit'),
(3, 31, 250.0, 'g'),
(4, 32, 200.0, 'g'),
(5, 32, 100.0, 'g');

INSERT INTO Tag (Name)
VALUES
('Pasta'),
('Italian'),
('Quick'),
('Creamy'),
('Comfort Food'),
('Vegetarian'),
('Stir Fry'),
('Healthy'),
('Mexican'),
('Pizza'),
('Dessert'),
('Sweet'),
('Breakfast'),
('Salad'),
('Baked'),
('Seafood'),
('Light'),
('Fresh'),
('Hearty'),
('Elegant'),
('Baking'),
('Asian'),
('Tacos'),
('Homemade'),
('Noodles'),
('Rice'),
('Soup'),
('Sandwich'),
('Savory'),
('Main Course'),
('Side Dish'),
('Simple'),
('Fried');

INSERT INTO RecipeTags (RecipeID, TagID)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(2, 5),
(3, 6),
(3, 7),
(3, 8),
(4, 9),
(4, 5),
(5, 1),
(5, 2),
(6, 12),
(6, 13),
(7, 14),
(7, 8),
(8, 1),
(8, 5),
(9, 15),
(9, 5),
(10, 12),
(10, 13),
(11, 16),
(11, 5),
(12, 17),
(12, 3),
(13, 6),
(13, 5),
(14, 9),
(14, 17),
(15, 6),
(15, 8),
(16, 18),
(16, 12),
(17, 19),
(17, 2),
(18, 1),
(18, 3),
(19, 6),
(19, 8),
(20, 14),
(20, 8),
(21, 12),
(21, 13),
(22, 12),
(22, 13),
(23, 14),
(23, 8),
(24, 9),
(24, 5),
(25, 12),
(25, 13),
(26, 5),
(26, 6),
(27, 15),
(27, 5),
(28, 12),
(28, 13),
(29, 16),
(29, 5),
(30, 17),
(30, 2),
(31, 1),
(31, 3),
(32, 12),
(32, 13);

INSERT INTO IngredientTag (TagID, IngredientID)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 6),
(4, 7),
(3, 8),
(4, 9),
(5, 10),
(6, 10),
(7, 11),
(6, 11),
(5, 12),
(4, 13),
(3, 14),
(9, 14),
(1, 15),
(8, 15),
(4, 16),
(1, 17),
(2, 18),
(4, 18),
(4, 19),
(4, 20),
(2, 21),
(5, 22),
(1, 23),
(8, 24),
(6, 25),
(3, 26),
(4, 27),
(6, 28),
(5, 29),
(4, 30),
(1, 31),
(4, 32),
(4, 33),
(4, 34),
(5, 35),
(3, 36),
(5, 37),
(6, 38),
(7, 39),
(1, 40);

INSERT INTO Rating (UserID, RecipeID, Value) VALUES
(31, 4, 2.0),
(17, 12, 5.0),
(3, 4, 2.0),
(5, 16, 5.0),
(2, 10, 3.0),
(9, 14, 5.0),
(14, 17, 1.0),
(22, 25, 4.0),
(7, 25, 1.0),
(27, 22, 2.0),
(18, 15, 3.0),
(17, 15, 5.0),
(6, 1, 4.0),
(18, 22, 4.0),
(12, 12, 4.0),
(18, 5, 1.0),
(19, 23, 4.0),
(21, 13, 2.0),
(20, 2, 4.0),
(6, 15, 2.0),
(25, 28, 1.0),
(29, 24, 5.0),
(7, 29, 5.0),
(22, 28, 1.0),
(30, 16, 3.0),
(20, 20, 2.0),
(27, 10, 1.0),
(30, 18, 2.0),
(26, 28, 3.0),
(11, 27, 1.0),
(28, 6, 2.0),
(10, 22, 2.0),
(13, 1, 5.0),
(4, 16, 4.0),
(23, 20, 5.0),
(9, 12, 1.0),
(10, 26, 5.0),
(2, 7, 5.0),
(6, 4, 4.0);

INSERT INTO FavoritedRecipe (UserID, RecipeID) VALUES
(30, 2),
(17, 13),
(5, 12),
(13, 10),
(14, 8),
(20, 20),
(4, 2),
(8, 5),
(1, 23),
(14, 13),
(16, 30),
(27, 23),
(5, 1),
(16, 14),
(20, 26),
(28, 14),
(4, 29),
(22, 30),
(4, 13),
(9, 24),
(27, 19),
(30, 29),
(22, 2),
(15, 2),
(8, 31),
(27, 25),
(11, 4),
(22, 3),
(16, 22),
(7, 16),
(3, 10),
(22, 6),
(9, 22),
(6, 16),
(13, 21),
(25, 22),
(30, 5),
(10, 31),
(3, 30),
(21, 30);

INSERT INTO Comment (UserID, RecipeID, Text) VALUES
(18, 11, 'I tried this recipe for dinner last night, and my family loved it! Will definitely make it again.'),
(21, 3, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(4, 7, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(28, 32, 'So simple and yet so tasty! I’m adding this to my favorites list.'),
(16, 27, 'So simple and yet so tasty! I’m adding this to my favorites list.'),
(29, 14, 'This was a hit at our potluck! Everyone was asking for the recipe.'),
(1, 16, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(21, 1, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(9, 12, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(3, 29, 'This was a hit at our potluck! Everyone was asking for the recipe.'),
(5, 15, 'The flavors in this dish are incredible! I can’t wait to share it with my friends.'),
(9, 20, 'So simple and yet so tasty! I’m adding this to my favorites list.'),
(23, 4, 'The flavors in this dish are incredible! I can’t wait to share it with my friends.'),
(17, 7, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(10, 22, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(28, 21, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(25, 4, 'So simple and yet so tasty! I’m adding this to my favorites list.'),
(25, 18, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(22, 29, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(14, 20, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(15, 12, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(9, 3, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(19, 31, 'The flavors in this dish are incredible! I can’t wait to share it with my friends.'),
(16, 12, 'Quick and easy to make. Perfect for a weeknight meal!'),
(11, 18, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(22, 3, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(26, 21, 'I tried this recipe for dinner last night, and my family loved it! Will definitely make it again.'),
(3, 11, 'I tried this recipe for dinner last night, and my family loved it! Will definitely make it again.'),
(24, 3, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(30, 16, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(8, 9, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(19, 11, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(3, 4, 'Quick and easy to make. Perfect for a weeknight meal!'),
(21, 11, 'This was delicious! I added some extra garlic, and it turned out fantastic!'),
(25, 28, 'This was a hit at our potluck! Everyone was asking for the recipe.'),
(1, 32, 'I found this recipe a bit bland. I’ll add more spices next time.'),
(6, 20, 'Quick and easy to make. Perfect for a weeknight meal!'),
(6, 27, 'This was a hit at our potluck! Everyone was asking for the recipe.'),
(18, 16, 'My kids devoured this! Thank you for a great family recipe!'),
(25, 22, 'I tried this recipe for dinner last night, and my family loved it! Will definitely make it again.'),
(18, 19, 'My kids devoured this! Thank you for a great family recipe!'),
(21, 6, 'I tried this recipe for dinner last night, and my family loved it! Will definitely make it again.'),
(4, 28, 'I substituted quinoa for the rice, and it was amazing! Great healthy option.'),
(25, 26, 'My kids devoured this! Thank you for a great family recipe!'),
(21, 29, 'My kids devoured this! Thank you for a great family recipe!');
-- Queries
SELECT u.Username, COUNT(RecipeID) AS NumRecipes FROM Users u INNER JOIN Recipe r ON u.UserID = r.UserID GROUP BY u.Username;

SELECT u.Username, AVG(RecipeAvgs.RecipeRating) AS AvgUserRating FROM Users u INNER JOIN Recipe r ON u.UserID = r.UserID INNER JOIN (SELECT ra.RecipeID, AVG(ra.Value) AS RecipeRating FROM Rating ra GROUP BY ra.RecipeID) AS RecipeAvgs ON RecipeAvgs.RecipeID = r.RecipeID GROUP BY u.Username;

SELECT t.Name, COUNT(i.IngredientID) As NumIngredients FROM Tag t LEFT JOIN IngredientTag i ON t.TagID = i.TagID GROUP BY t.Name;

SELECT i.Name, IngredientCount.CountVal AS NumUses FROM Ingredient i INNER JOIN (SELECT ri.IngredientID, COUNT(ri.RecipeID) AS CountVal FROM RecipeIngredients ri GROUP BY ri.IngredientID) AS IngredientCount ON i.IngredientID = IngredientCount.IngredientID;

SELECT r.Name, COUNT(fr.UserID) AS NumFavorites FROM Recipe r LEFT JOIN FavoritedRecipe fr ON r.RecipeID = fr.RecipeID GROUP BY r.Name;

SELECT u.username, COUNT(c.text) AS NumComments FROM Users u LEFT JOIN Comment c ON u.UserID = c.UserID GROUP BY u.username;

SELECT * FROM RECIPE r WHERE r.UserID IN (SELECT f.followedsID FROM Follows f WHERE f.FollowersID = 18);

SELECT t.Name, COUNT(r.RecipeID) AS NumRecipes FROM Tag t LEFT JOIN RecipeTags r ON t.TagID = r.TagID GROUP BY t.Name;

SELECT r.Name, (SELECT COUNT(ri.IngredientID) FROM RecipeIngredients ri WHERE ri.RecipeID = r.recipeID) AS NumIngredients FROM Recipe r;

SELECT u.Username, COUNT(BlockersID) AS NumBlockers FROM Users u LEFT JOIN BlockedUser b ON u.UserID = b.BlockedID GROUP BY u.Username;
