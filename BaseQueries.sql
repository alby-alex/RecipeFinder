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
    [Name] VARCHAR(100),
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
    [Name] VARCHAR(100)
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

ALTER TABLE RecipeIngredients ADD CONSTRAINT chk_recipeingredients_unit CHECK (Unit in ('oz', 'ml', 'l', 'fl oz', 'lb', 'cup', 'g'));

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



-- Queries
SELECT u.Username, COUNT(RecipeID) AS NumRecipes FROM Users u INNER JOIN Recipe r ON u.UserID = r.UserID GROUP BY u.Username;

SELECT u.Username, AVG(RecipeAvgs.RecipeRating) AS AvgUserRating FROM Users u INNER JOIN Recipe r ON u.UserID = r.UserID INNER JOIN (SELECT ra.RecipeID, AVG(ra.Value) AS RecipeRating FROM Rating ra GROUP BY ra.RecipeID) AS RecipeAvgs ON RecipeAvgs.RecipeID = r.RecipeID GROUP BY u.Username;

SELECT t.Name, COUNT(i.IngredientID) As NumIngredients FROM Tag t LEFT JOIN IngredientTag i ON t.TagID = i.TagID GROUP BY t.Name;

SELECT i.Name, IngredientCount.CountVal AS NumUses FROM Ingredient i INNER JOIN (SELECT ri.IngredientID, COUNT(ri.RecipeID) AS CountVal FROM RecipeIngredients ri GROUP BY ri.IngredientID) AS IngredientCount ON i.IngredientID = IngredientCount.IngredientID;

SELECT r.Name, COUNT(fr.UserID) AS NumFavorites FROM Recipe r LEFT JOIN FavoritedRecipe fr ON r.RecipeID = fr.RecipeID GROUP BY r.Name;

SELECT u.username, COUNT(c.text) AS NumComments FROM Users u LEFT JOIN Comment c ON u.UserID = c.UserID GROUP BY u.username;

SELECT * FROM RECIPE r WHERE r.UserID IN (SELECT f.followedsID FROM Follows f WHERE f.FollowersID = 1 );

SELECT t.Name, COUNT(r.RecipeID) AS NumRecipes FROM Tag t LEFT JOIN RecipeTags r ON t.TagID = r.TagID GROUP BY t.Name;

SELECT r.Name, (SELECT COUNT(ri.IngredientID) FROM RecipeIngredients ri WHERE ri.RecipeID = r.recipeID) AS NumIngredients FROM Recipe r;

SELECT u.Username, COUNT(BlockersID) AS NumBlockers FROM Users u LEFT JOIN BlockedUser b ON u.UserID = b.BlockedID GROUP BY u.Username;
