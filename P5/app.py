import pyodbc
from flask import Flask, request, jsonify

app = Flask(__name__)


DB_CONFIG = {
    'server': 'localhost',
    'database': 'RecipeFinder',
    'username': 'sa',
    'password': 'Coollife123',
    'driver': '/opt/homebrew/lib/libmsodbcsql.18.dylib'
}

def get_db_connection():
    """Create and return a database connection"""
    conn_str = (
        f"DRIVER={DB_CONFIG['driver']};"
        f"SERVER={DB_CONFIG['server']},1433;"
        f"DATABASE={DB_CONFIG['database']};"
        f"UID={DB_CONFIG['username']};"
        f"PWD={DB_CONFIG['password']};"
        f"TrustServerCertificate=yes"
    )
    return pyodbc.connect(conn_str)


@app.route('/recipes', methods=['POST'])
def create_recipe():
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
        INSERT INTO Recipe (UserID, Name, TimeToCook, Instructions) 
        OUTPUT INSERTED.RecipeID
        VALUES (?, ?, ?, ?)
        """
        cursor.execute(query, (
            data['UserID'], 
            data['Name'], 
            data['TimeToCook'], 
            data['Instructions']
        ))
        
        recipe_id = cursor.fetchone()[0]
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({'RecipeID': recipe_id, **data}), 201
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/recipes/<int:recipe_id>', methods=['GET'])
def get_recipe(recipe_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "SELECT RecipeID, UserID, Name, TimeToCook, Instructions FROM Recipe WHERE RecipeID = ?"
        cursor.execute(query, (recipe_id,))
        
        recipe = cursor.fetchone()
        if not recipe:
            return jsonify({'error': 'Recipe not found'}), 404
        
        columns = [column[0] for column in cursor.description]
        recipe_dict = dict(zip(columns, recipe))
        
        cursor.close()
        conn.close()
        
        return jsonify(recipe_dict)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/recipes/<int:recipe_id>', methods=['PUT'])
def update_recipe(recipe_id):
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        update_fields = []
        params = []
        
        if 'UserID' in data:
            update_fields.append("UserID = ?")
            params.append(data['UserID'])
        if 'Name' in data:
            update_fields.append("Name = ?")
            params.append(data['Name'])
        if 'TimeToCook' in data:
            update_fields.append("TimeToCook = ?")
            params.append(data['TimeToCook'])
        if 'Instructions' in data:
            update_fields.append("Instructions = ?")
            params.append(data['Instructions'])
        
        params.append(recipe_id)
        
        query = f"UPDATE Recipe SET {', '.join(update_fields)} WHERE RecipeID = ?"
        cursor.execute(query, params)
        conn.commit()
        
        
        cursor.close()
        conn.close()
        
        return jsonify({'RecipeID': recipe_id, **data})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/recipes/<int:recipe_id>', methods=['DELETE'])
def delete_recipe(recipe_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "DELETE FROM Recipe WHERE RecipeID = ?"
        cursor.execute(query, (recipe_id,))
        conn.commit()
        
        
        cursor.close()
        conn.close()
        
        return '', 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

@app.route('/ingredients', methods=['POST'])
def create_ingredient():
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
        INSERT INTO Ingredient (Name, Type) 
        OUTPUT INSERTED.IngredientID
        VALUES (?, ?)
        """
        cursor.execute(query, (
            data['Name'], 
            data.get('Type')
        ))
        
        
        ingredient_id = cursor.fetchone()[0]
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({'IngredientID': ingredient_id, **data}), 201
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400



@app.route('/ingredients/<int:ingredient_id>', methods=['GET'])
def get_ingredient(ingredient_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "SELECT IngredientID, Name, Type FROM Ingredient WHERE IngredientID = ?"
        cursor.execute(query, (ingredient_id,))
        
        ingredient = cursor.fetchone()
        if not ingredient:
            return jsonify({'error': 'Ingredient not found'}), 404
        
        columns = [column[0] for column in cursor.description]
        ingredient_dict = dict(zip(columns, ingredient))
        
        cursor.close()
        conn.close()
        
        return jsonify(ingredient_dict)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/ingredients/<int:ingredient_id>', methods=['PUT'])
def update_ingredient(ingredient_id):
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        update_fields = []
        params = []
        
        if 'Name' in data:
            update_fields.append("Name = ?")
            params.append(data['Name'])
        if 'Type' in data:
            update_fields.append("Type = ?")
            params.append(data['Type'])
        
        params.append(ingredient_id)
        
        query = f"UPDATE Ingredient SET {', '.join(update_fields)} WHERE IngredientID = ?"
        cursor.execute(query, params)
        conn.commit()

        
        cursor.close()
        conn.close()
        
        return jsonify({'IngredientID': ingredient_id, **data})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/ingredients/<int:ingredient_id>', methods=['DELETE'])
def delete_ingredient(ingredient_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "DELETE FROM Ingredient WHERE IngredientID = ?"
        cursor.execute(query, (ingredient_id,))
        conn.commit()
        
        
        cursor.close()
        conn.close()
        
        return '', 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
@app.route('/tags', methods=['POST'])
def create_tag():
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "INSERT INTO Tag (Name) OUTPUT INSERTED.TagID VALUES (?)"
        cursor.execute(query, (data['Name']))
        
        
        tag_id = cursor.fetchone()[0]

        conn.commit()

        cursor.close()
        conn.close()
        
        return jsonify({'TagID': tag_id, **data}), 201
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/tags/<int:tag_id>', methods=['GET'])
def get_tag(tag_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "SELECT TagID, Name FROM Tag WHERE TagID = ?"
        cursor.execute(query, (tag_id,))
        
        tag = cursor.fetchone()
        if not tag:
            return jsonify({'error': 'Tag not found'}), 404
        
        columns = [column[0] for column in cursor.description]
        tag_dict = dict(zip(columns, tag))
        
        cursor.close()
        conn.close()
        
        return jsonify(tag_dict)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/tags/<int:tag_id>', methods=['PUT'])
def update_tag(tag_id):
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "UPDATE Tag SET Name = ? WHERE TagID = ?"
        cursor.execute(query, (data['Name'], tag_id))
        conn.commit()
        
        
        cursor.close()
        conn.close()
        
        return jsonify({'TagID': tag_id, **data})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/tags/<int:tag_id>', methods=['DELETE'])
def delete_tag(tag_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = "DELETE FROM Tag WHERE TagID = ?"
        cursor.execute(query, (tag_id,))
        conn.commit()
        
        
        cursor.close()
        conn.close()
        
        return '', 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/users', methods=["POST"])
def create_user():
    try:

        data = request.json
        username = data.get('username')
        password_hash = data.get('password_hash')

        conn = get_db_connection()

        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO Users (Username, PasswordHash) 
            OUTPUT INSERTED.UserID
            VALUES (?, ?)
        """, (username, password_hash))
       

        user_id = cursor.fetchone()[0]
        
        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'UserID': user_id, **data}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        conn = get_db_connection()


        cursor = conn.cursor()

        cursor.execute("SELECT UserID, Username FROM Users WHERE UserID = ?", (user_id,))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user:
            return jsonify({
                "user_id": user.UserID, 
                "username": user.Username
            }), 200
        else:
            return jsonify({"error": "User not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    try:
        data = request.json
        username = data.get('username')
        password_hash = data.get('password_hash')


        conn = get_db_connection()

        cursor = conn.cursor()


        update_fields = []
        params = []

        if username:
            update_fields.append("Username = ?")
            params.append(username)

        if password_hash:
            update_fields.append("PasswordHash = ?")
            params.append(password_hash)

        params.append(user_id)

        query = f"UPDATE Users SET {', '.join(update_fields)} WHERE UserID = ?"
        cursor.execute(query, params)
        conn.commit()


        cursor.close()
        conn.close()

        return jsonify({'UserID': user_id, **data})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    try:
        conn = get_db_connection()


        cursor = conn.cursor()

        cursor.execute("DELETE FROM Users WHERE UserID = ?", (user_id,))
        conn.commit()


        cursor.close()
        conn.close()

        return '', 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/ratings', methods=['POST'])
def create_rating():
    try:
        data = request.json
        user_id = data.get('user_id')
        recipe_id = data.get('recipe_id')
        value = data.get('value')


        conn = get_db_connection()

        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO Rating (UserID, RecipeID, Value) 
            VALUES (?, ?, ?)
        """, (user_id, recipe_id, value))
        conn.commit()

        cursor.close()
        conn.close()

        return jsonify({
            "message": "Rating created successfully", 
            "user_id": user_id,
            "recipe_id": recipe_id
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/ratings/<int:user_id>/<int:recipe_id>', methods=['GET'])
def get_rating(user_id, recipe_id):
    try:
        conn = get_db_connection()

        cursor = conn.cursor()

        cursor.execute("""
            SELECT UserID, RecipeID, Value 
            FROM Rating 
            WHERE UserID = ? AND RecipeID = ?
        """, (user_id, recipe_id))
        
        rating = cursor.fetchone()
    
        cursor.close()  
        conn.close()
    
    
        if rating:
            return jsonify({
                "user_id": rating.UserID, 
                "recipe_id": rating.RecipeID, 
                "value": float(rating.Value)
            }), 200
        else:
            return jsonify({"error": "Rating not found"}), 404

          

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/ratings/<int:user_id>/<int:recipe_id>', methods=['PUT'])
def update_rating(user_id, recipe_id):
    try:
        data = request.json
        value = data.get('value')

        conn = get_db_connection()

        cursor = conn.cursor()

        cursor.execute("""
            UPDATE Rating 
            SET Value = ? 
            WHERE UserID = ? AND RecipeID = ?
        """, (value, user_id, recipe_id))
        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({
            "message": "Rating updated successfully",
            "user_id": user_id,
            "recipe_id": recipe_id
        }), 200


            

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/ratings/<int:user_id>/<int:recipe_id>', methods=['DELETE'])
def delete_rating(user_id, recipe_id):
    try:
        conn = get_db_connection()

        cursor = conn.cursor()

        cursor.execute("""
            DELETE FROM Rating 
            WHERE UserID = ? AND RecipeID = ?
        """, (user_id, recipe_id))
        conn.commit()

        cursor.close()
        conn.close()

        return '', 200

            

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
if __name__ == '__main__':
    app.run(debug=True)