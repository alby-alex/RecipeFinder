CREATE DATABASE RecipeFinder
GO

USE RecipeFinder
GO

CREATE TABLE Users(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(10) UNIQUE,
    PasswordHash VARCHAR(20) NOT NULL
);

CREATE TABLE Recipe(
    RecipeID INT IDENTITY(1, 1) PRIMARY KEY,
    UserID INT NOT NULL, 
    [Name] VARCHAR(10) NOT NULL,
    TimeToCook INT,
    Instructions VARCHAR(100),
    CONSTRAINT fk_recipe_user FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Ingredient(
    IngredientID INT IDENTITY(1, 1) PRIMARY KEY,
    [Name] VARCHAR(10),
    [Type] VARCHAR(10)
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
    [Name] VARCHAR(10)
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
    [Text] VARCHAR(30),
    CONSTRAINT fk_comment_recipeid FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
    CONSTRAINT fk_comment_userid FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Rating(
    UserID INT,
    RecipeID INT,
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

ALTER TABLE Comment ADD CONSTRAINT chk_comment_text CHECK (LEN([Text]) < 300);

ALTER TABLE RecipeIngredients ADD CONSTRAINT chk_recipeingredients_quantity CHECK (Quantity > 0);


