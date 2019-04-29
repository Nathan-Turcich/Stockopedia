<?php
    //Connects to Maria DB
    $con=mysqli_connect("sp19-cs411-49.cs.illinois.edu","root","374sucks","Stockopedia");   // Create connection

    //Checks if there was an error connecting to MariaDB
    if (mysqli_connect_errno()) { echo "Failed to connect to MySQL: " . mysqli_connect_error(); }
    
    //All Queries
    //Make the sql query based on the query in the URL
    
    $sql = "";
    if($_GET["query"] === "getLatestDate"){
        $sql = "SELECT date
        FROM Date";
    }
    
    else if($_GET["query"] === "downloadRealTimeData"){
        $sql = "SELECT *
        FROM RealTimeStocks
        GROUP BY abbr";
   }
    
    else if($_GET["query"] === "downloadFavoritesJoinRealTime"){
        $key = $_GET["key"];
        $abbr = $_GET["abbr"];
        
        $sql = "SELECT Favorites.abbr
        FROM Favorites
        INNER JOIN RealTimeStocks
        ON Favorites.abbr = RealTimeStocks.abbr
        WHERE Favorites.ID = '$key'
        AND Favorites.abbr ='$abbr'";
    }
    
    else if($_GET["query"] === "downloadRealTimeClosesForAbbr"){
        $abbr = $_GET["abbr"];

        $sql = "SELECT close
        FROM RealTimeStocks
        WHERE abbr = '$abbr'";
    }
    
    else if($_GET["query"] === "getPrediction"){
        $abbr = $_GET["abbr"];

        $sql = "SELECT *
        FROM Predictions
        WHERE abbr = '$abbr'";
    }
    
   else if($_GET["query"] === "downloadUniqueStockNames"){
       $sql = "CALL getAllUniqueStocks()";
   }
    
   else if($_GET["query"] === "downloadPossibleMonths"){
       $abbr = $_GET["abbr"];
       
       $sql = "SELECT date
       FROM Stocks
       WHERE name = '$abbr'
       AND date LIKE '%-01'";
   }
    
   else if($_GET["query"] === "downloadUniqueStockDataForMonth"){
       $abbr = $_GET["abbr"];
       $month = $_GET["month"];
       $percentage = '%';
       $month = $month.$percentage;
       
       $sql = "SELECT date, close
       FROM Stocks
       WHERE name = '$abbr'
       AND date LIKE '$month'";
   }
    
   else if($_GET["query"] === "downloadUniqueStockDataForYear"){
       $abbr = $_GET["abbr"];
       $year = $_GET["year"];
       $percentage = '%';
       $year = $year.$percentage;
       
       $sql = "SELECT date, close
       FROM Stocks
       WHERE name = '$abbr'
       AND date LIKE '$year'";
   }
    
   else if($_GET["query"] === "downloadUserFavoritedList"){
        $key = $_GET["key"];
       
        $sql = "SELECT abbr, fullname
        FROM Favorites
        WHERE ID = '$key'";
    }
    
   else if($_GET["query"] === "insertNameFavoritedList"){
       $key = $_GET["key"];
       $abbr = $_GET["abbr"];
       $fullName = $_GET["fullname"];
       $fullName = str_replace('_', ' ', $fullName);
       
       $sql = "INSERT INTO Favorites
       VALUES ('$key', '$abbr', '$fullName')";
   }
    
   else if($_GET["query"] === "deleteNameFavoritedList"){
       $key = $_GET["key"];
       $abbr = $_GET["abbr"];
       
       $sql = "DELETE
       FROM Favorites
       WHERE ID = '$key' and abbr = '$abbr'";
   }
    
   else if($_GET["query"] === "getTopicData"){
       $sql = "SELECT *
       FROM Topics";
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
    
    else if($_GET["query"] === "getBuys"){
        $sql = "SELECT abbr FROM Stockopedia.aboveAvgDiff";
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
