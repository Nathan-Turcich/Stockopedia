<?php
    $con=mysqli_connect("sp19-cs411-49.cs.illinois.edu","root","374sucks","Stockopedia");   // Create connection

    if (mysqli_connect_errno()) { echo "Failed to connect to MySQL: " . mysqli_connect_error(); }
    
    //All Queries
    
    $sql = "";
   if($_GET["query"] === "downloadUniqueStockNames"){
        $sql = "SELECT name, fullname
        FROM Stocks
        GROUP BY name";
    }
    else if($_GET["query"] === "getUserFavoritedList"){
        $key = $_GET["key"];
       
        $sql = "SELECT name
        FROM Favorites
        WHERE ID = '$key'";
    }
   else if($_GET["query"] === "insertNameFavoritedList"){
       $key = $_GET["key"];
       $name = $_GET["name"];
       
       $sql = "INSERT INTO Favorites
       VALUES ('$key', '$name')";
   }
   else if($_GET["query"] === "deleteNameFavoritedList"){
       $key = $_GET["key"];
       $name = $_GET["name"];
       
       $sql = "DELETE
       FROM Favorites
       WHERE ID = '$key' and name = '$name'";
   }
   else if($_GET["query"] === "getTopicData"){
       $sql = "SELECT *
       FROM Topics;
   }
   else if($_GET["query"] === "getUserRecommendations"){
       $key = $_GET["key"];
       
       $sql = "SELECT Recomendation
       FROM Recomendations
       WHERE ID = '$key'";
   }
   else if($_GET["query"] === "initilizeUsersRecomendations"){
       $key = $_GET["key"];
       $value = "Choose_Choose_Choose";

       $sql = "INSERT INTO Recomendations
       VALUES ('$key', '$value')";
   }
   else if($_GET["query"] === "updateUserRecomendations"){
       $key = $_GET["key"];
       $recomendation = $_GET["recomendation"];
       
       $sql = "UPDATE Recomendations
       SET Recomendation = '$recomendation'
       WHERE ID = '$key'";
   }
   else if($_GET["query"] === "createUser"){
        $key = $_GET["key"];
        $username = $_GET["username"];
        $password = $_GET["password"];
       
        $sql = "INSERT INTO Users
        VALUES ('$key', '$username', '$password')";
    }
    else if($_GET["query"] === "getUser"){
        $username = $_GET["username"];
        $password = $_GET["password"];
        
        $sql = "SELECT ID, Username
        FROM Users
        WHERE Username = '$username' AND Password = '$password'";
    }
    else if($_GET["query"] === "updateUserPassword"){
        $key = $_GET["key"];
        $newPassword = $_GET["newPassword"];
        
        $sql = "UPDATE Users
        SET Password = '$newPassword'
        WHERE ID = '$key'";
    }
    else if($_GET["query"] === "updateUsername"){
        $key = $_GET["key"];
        $newUsername = $_GET["newUsername"];
        
        $sql = "UPDATE Users
        SET Username='$newUsername'
        WHERE ID = '$key'";
    }
    
    //Result of queries
    if ($result = mysqli_query($con, $sql)) {     // Check if there are results
        // If so, then create a results array and a temporary one to hold the data
        $resultArray = array();
        $tempArray = array();
        
        while($row = $result->fetch_object()) {     // Loop through each row in the result set
            $tempArray = $row;
            array_push($resultArray, $tempArray);   // Add each row into our results array
        }
        
        echo json_encode($resultArray);     // Encode the array to JSON and output the results
    }
    
    mysqli_close($con); // Close connections
?>
